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