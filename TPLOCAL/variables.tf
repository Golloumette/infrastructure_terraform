variable "image_docker" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  default     = "nginx:latest"
}
variable "nom_container" {
  type        = string
  description = "Nom du conteneur"
  default     = "nginx-terraform"
}
variable "ext_port" {
  type        = number
  description = "Port expose"
  default     = 8080
}
variable "int_port" {
  type        = number
  description = "Port interne"
  default     = 80
}
variable "nbr_conteneur_client" {
  type    = number
  default = 3
}
variable "serveur-nom" {
  type    = list(string)
  default = ["zeus", "poseidon", "hades"]
}
variable "machines" {
    type  = list(object({
        name = string
        vCpu = number
        disk_size = number
        region = string
    }
    ))
    default = [
    {
      name      = "zeus"
      vCpu      = 2
      disk_size = 20
      region    = "eu-west-1"
    }
  ]
  #vérifier les conditions
   validation {
    condition = (
        # alltrue ou 
        #list d'objet donc on boucle
        #on fait un ternaire
      alltrue([for v in var.machines[*].vCpu      : v >= 2 && v <= 64]) &&
      alltrue([for d in var.machines[*].disk_size : d >= 20]) &&
      alltrue([for r in var.machines[*].region    : contains(["eu-west-1", "us-east-1", "ap-southeast-1"], r)])
    )
    error_message = "Chaque machine doit avoir entre 2 et 64 vCPU, un disque >= 20 Go, et une région valide."
  }
}




