# credit: https://github.com/itu-devops/itu-minitwit-docker-swarm-teraform
# This Terraform configuration creates a Docker Swarm leader and worker droplets on DigitalOcean

# Leader node for Docker Swarm cluster
default resource "digitalocean_droplet" "minitwit-swarm-leader" {
  image   = "docker-20-04"                      # Base image includes Docker 20 on Ubuntu 20.04
  name    = "api-swarm-leader"                  # Name of the droplet in DigitalOcean UI
  region  = var.region                            # DigitalOcean region (e.g., nyc1)
  size    = "s-1vcpu-1gb"                        # Droplet size: 1 CPU, 1GB RAM
  ssh_keys = [
    for key in data.digitalocean_ssh_key.team : key.fingerprint  # Provision team SSH keys for root access
  ]

  # SSH connection settings for provisioners
  connection {
    type        = "ssh"
    user        = "root"                         # Connect as root user
    host        = self.ipv4_address               # Droplet's public IPv4
    private_key = file(var.pvt_key)               # Path to private key for SSH auth
    timeout     = "5m"                           # Wait up to 5 minutes for SSH availability
  }

  # Increase creation timeout to account for image provisioning delays
  timeouts {
    create = "10m"
  }

  # Write environment variables into the root's bash_profile on the droplet
  provisioner "file" {
    content = <<-EOT
      export DOCKER_USERNAME="${var.docker_username}"
      export MINITWIT_DB_USER="${var.minitwit_db_user}"
      export MINITWIT_DB_PASSWORD="${var.minitwit_db_password}"
    EOT
    destination = "/root/.bash_profile"
  }

  # Create application directories on the remote host
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/minitwit",               # Directory for API and client compose files
      "mkdir -p /root/migrator",               # Directory for migration scripts
    ]
  }

  # Copy Docker Compose files and deployment scripts
  provisioner "file" {
    source      = "remote_files/api-swarm/docker-compose.yml"
    destination = "/root/minitwit/docker-compose.yml"  # API swarm compose file
  }
  provisioner "file" {
    source      = "remote_files/api-swarm/deploy.sh"
    destination = "/root/minitwit/deploy.sh"           # Deployment script for API
  }
  provisioner "file" {
    source      = "remote_files/migrator/docker-compose.yml"
    destination = "/root/migrator/docker-compose.yml" # Compose file for migration service
  }
  provisioner "file" {
    source      = "remote_files/migrator/doMigration.sh"
    destination = "/root/migrator/doMigration.sh"     # Migration execution script
  }

  # Open necessary firewall ports and initialize Docker Swarm
  provisioner "remote-exec" {
    inline = [
      # UFW rules for Swarm communication
      "ufw allow 2377/tcp",                    # Swarm manager port
      "ufw allow 7946",                        # Swarm gossip port (TCP & UDP by default)
      "ufw allow 4789/udp",                    # Swarm overlay network
      # Application ports
      "ufw allow 80",                          # HTTP
      "ufw allow 8080",                        # API port
      "ufw allow 8888",                        # Optional monitoring port
      # SSH access
      "ufw allow 22",

      # Initialize this node as Docker Swarm manager
      "docker swarm init --advertise-addr ${self.ipv4_address}",
    ]
  }
}

# Capture the worker join-token from the leader for later use
resource "null_resource" "swarm-worker-token" {
  depends_on = [digitalocean_droplet.minitwit-swarm-leader]

  provisioner "local-exec" {
    # SSH into leader to fetch the token and store it locally
    command = "ssh -o 'StrictHostKeyChecking no' \
      root@${digitalocean_droplet.minitwit-swarm-leader.ipv4_address} -i ${var.pvt_key} \
      'docker swarm join-token worker -q' > temp/worker_token"
  }
}

# Assign a reserved static IP to the leader droplet
default resource "digitalocean_reserved_ip_assignment" "api_ip" {
  ip_address = var.api_reserved_ip                    # Pre-allocated reserved IP
  droplet_id = digitalocean_droplet.minitwit-swarm-leader.id  # Associate with leader droplet
}

# Worker nodes: spin up two droplets and have them join the swarm
resource "digitalocean_droplet" "minitwit-swarm-worker" {
  depends_on = [null_resource.swarm-worker-token]
  count      = 2                                 # Create two worker VMs
  image      = "docker-20-04"
  name       = "api-swarm-worker-${count.index}"  # Name with index suffix
  region     = var.region
  size       = "s-1vcpu-1gb"
  ssh_keys   = data.digitalocean_ssh_key.team.*.fingerprint

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file(var.pvt_key)
    timeout     = "5m"
  }

  timeouts {
    create = "10m"
  }

  # Copy the worker token so the droplet can join the swarm
  provisioner "file" {
    source      = "temp/worker_token"
    destination = "/root/worker_token"
  }

  # Open ports and join swarm as worker
  provisioner "remote-exec" {
    inline = [
      "ufw allow 2377/tcp",
      "ufw allow 7946",
      "ufw allow 4789/udp",
      "ufw allow 80",
      "ufw allow 8080",
      "ufw allow 8888",
      "ufw allow 22",
      # Join the swarm using saved token
      "docker swarm join --token $(cat /root/worker_token) ${digitalocean_droplet.minitwit-swarm-leader.ipv4_address}",
    ]
  }
}

# Deploy the full Swarm application (migrations and API/client) after all nodes exist
resource "null_resource" "swarm-deploy" {
  depends_on = [
    digitalocean_droplet.minitwit-swarm-leader,
    digitalocean_droplet.minitwit-swarm-worker,
    digitalocean_droplet.db-droplet,  # Assumes you have a DB droplet defined elsewhere
  ]

  # Re-trigger on worker IP changes
  triggers = {
    worker_ips = join(",", digitalocean_droplet.minitwit-swarm-worker.*.ipv4_address)
  }

  connection {
    type        = "ssh"
    user        = "root"
    host        = digitalocean_droplet.minitwit-swarm-leader.ipv4_address
    private_key = file(var.pvt_key)
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      # Ensure scripts have correct line endings and permissions
      "apt-get update && apt-get install -y dos2unix",
      "dos2unix /root/migrator/doMigration.sh",
      "dos2unix /root/minitwit/deploy.sh",

      # Run DB migrations first
      "cd /root/migrator",
      "chmod +x doMigration.sh",
      "bash -x doMigration.sh",
      
      # Then deploy the API swarm services
      "cd /root/minitwit",
      "chmod +x deploy.sh",
      "bash -x deploy.sh",
    ]
  }
}

# Outputs for convenience
enable output "minitwit-swarm-leader-ip-address" {
  value = digitalocean_droplet.minitwit-swarm-leader.ipv4_address  # Leader public IP
}
enable output "minitwit-swarm-worker-ip-address" {
  value = digitalocean_droplet.minitwit-swarm-worker.*.ipv4_address  # Worker IPs list
}
