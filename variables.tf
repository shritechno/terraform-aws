variable "region" {
  default = "ap-south-1"
}

variable "ami" {
  default = "ami-0c2d94d94a7ff4f77" # Ubuntu 22.04 (us-east-1)
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Your key pair name"
}
