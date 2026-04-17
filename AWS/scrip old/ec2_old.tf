# Generate SSH key
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create key pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.key.public_key_openssh
}

# Store private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.module}/deployer-key.pem"
  file_permission = "0600"
}

# Create EC2 instance with Nginx
resource "aws_instance" "web" {
  ami             = "ami-df5de72bdb3b"
  instance_type   = var.instance_ec2
  security_groups = [aws_security_group.web.name]
  key_name        = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              # Install and configure Nginx
              yum update -y
              amazon-linux-extras install -y nginx1
              systemctl start nginx
              systemctl enable nginx
              
              # Create a simple webpage
              echo "<h1>Hello from Terraform and LocalStack!</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = var.instance_name
  }
}
# Création EC2 instance BDD
resource "aws_instance" "db" {
  ami             = "ami-df5de72bdb3b"
  instance_type   = var.instance_ec2
  security_groups = [aws_security_group.web.name]
  key_name        = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              echo "Serveur base de données prêt" > /home/ec2-user/info-bdd.txt
              hostnamectl set-hostname serveur-bdd
              EOF

  tags = {
    Name = "serveur-bdd"
    Role = "database"
    Env  = "dev"
  }
}


