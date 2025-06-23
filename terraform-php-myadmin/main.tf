provider "aws" {
  region                  = var.region
  shared_credentials_files = ["C:/Users/Shrikant Singh/.aws/credentials"]
}


resource "aws_security_group" "php_sg" {
  name        = "phpmyadmin-sg"
  description = "Allow SSH, HTTP, MySQL"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "phpmyadmin" {
  ami           = var.ami # Ubuntu Server 22.04 LTS in ap-south-1
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.php_sg.name]

  user_data = file("install.sh")

  tags = {
    Name = "phpmyadmin-ubuntu"
  }


  provisioner "file" {
    source      = "db_dump.sql"
    destination = "/home/ubuntu/db_dump.sql"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:/Users/Shrikant Singh/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}





