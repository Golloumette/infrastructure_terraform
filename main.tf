terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "docker" { host = "tcp://localhost:2375" }

#reseau docker 

resource "docker_network" "private_network" {
  name = "mon_reseau_docker"
} 
#conteneur 1
resource "docker_image" "nginx" {
  name         = var.image_docker
  keep_locally = true
}

#imade du conteneur 1
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
#accrocher le conteneur au reseau prive
networks_advanced {
  name = docker_network.private_network.name
}

}


#conteneur 2
resource "docker_image" "client" {
  name = "appropriate/curl"
}

resource "docker_container" "client" {
  name  = "conteneur_client"
  image = docker_image.client.image_id

  command = ["sh", "-c" ,"curl -s http://nginx:80 && sleep 60"]

  networks_advanced {
  name = docker_network.private_network.name
 }
}


output "nginx_container_id" {
  value = docker_container.nginx.id
}
