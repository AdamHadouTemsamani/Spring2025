# credit: https://github.com/itu-devops/itu-minitwit-docker-swarm-teraform

resource "digitalocean_droplet" "seq-droplet" {
  image = "docker-20-04" // ubuntu-22-04-x64
  name = "seq"
  region = var.region
  size = "s-1vcpu-1gb"
  ssh_keys = [
    for key in data.digitalocean_ssh_key.team : key.fingerprint
  ]

  # specify a ssh connection
  connection {
    user = "root"
    host = self.ipv4_address
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "5m"
  }

  # ensure Terraform waits long enough for the droplet to be "created"
  timeouts {
    create = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/minitwit",
    ]
  }

  provisioner "file" {
    source = "remote_files/seq/docker-compose.yml"
    destination = "/root/minitwit/docker-compose.yml"
  }
  
  provisioner "file" {
    source = "remote_files/seq/deploy.sh"
    destination = "/root/minitwit/deploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      # ports for apps
      "ufw allow 80",
      "ufw allow 8080",
      "ufw allow 8888",
      
      # SSH
      "ufw allow 22",

      # strip any CRLF that snuck in on the way
      "apt-get update && apt-get install -y dos2unix",
      "dos2unix /root/minitwit/deploy.sh",

      # deploy seq application
      "cd /root/minitwit",
      "chmod +x deploy.sh",
      "bash -x deploy.sh",
    ]
  }
}

# Assign the reserved IP to the droplet
resource "digitalocean_reserved_ip_assignment" "seq_ip" {
  ip_address = var.seq_reserved_ip
  droplet_id = digitalocean_droplet.seq-droplet.id
}

output "minitwit-seq-ip-address" {
  value = digitalocean_droplet.seq-droplet.ipv4_address
}