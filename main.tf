terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "docker" { host = "tcp://localhost:2375" }

resource "docker_image" "nginx" {
  name         = var.image_docker
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = var.nom_container
  image = docker_image.nginx.image_id
  ports {
    internal = var.int_port
    external = var.ext_port
  }

  provisioner "local-exec" {
    command = "curl -s http://localhost:${var.ext_port} | grep 'Welcome'"
  }
}

output "nginx_container_id" {
  value = docker_image.nginx.image_id
}

  

