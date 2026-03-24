variable "instance_ec2" {
  description = "Type de l'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Nom de l'instance EC2"
  type        = string
  default     = "nginx-server"
}

variable "bucket_name" {
  description = "Nom du bucket S3"
  type        = string
  default     = "demo-bucket-tf"
}

variable "security_group_port" {
  description = "Port ouvert par défaut pour le security group"
  type        = number
  default     = 80
}