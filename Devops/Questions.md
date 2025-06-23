Why do we have the extra docker-compose.yml file in root of project, when we have to other ones in the remote-files?


What's the reason for this code? What does it do? Why do we need it?

```terraform

  provisioner "file" {
    source      = "remote_files/migrator/docker-compose.yml"
    destination = "/root/migrator/docker-compose.yml" # Compose file for migration service
  }
  provisioner "file" {
    source      = "remote_files/migrator/doMigration.sh"
    destination = "/root/migrator/doMigration.sh"     # Migration execution script
  }

```


How exactly does this work?

```terraform

  # Write environment variables into the root's bash_profile on the droplet
  provisioner "file" {
    content = <<-EOT
      export DOCKER_USERNAME="${var.docker_username}"
      export MINITWIT_DB_USER="${var.minitwit_db_user}"
      export MINITWIT_DB_PASSWORD="${var.minitwit_db_password}"
    EOT
    destination = "/root/.bash_profile"
  }

```



Is there a reason we only update and deploy the client/api? in our workflow
We have terraform, so is this still run or?


What is this in our codeql.yml workflow:
```yml

      # 5. (Manual build hook) If build-mode is manual, instruct user to add build commands
      - if: matrix.build-mode == 'manual'
        shell: bash
        run: |
          echo 'Manual build mode enabled. Add your build commands here.'
          exit 1

```