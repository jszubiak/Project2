variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "region to which deploy infrastructure to"
}
variable "ami" {
  type        = string
  default     = "ami-0ec23856b3bad62d3"
  description = "AMI with Amazon Linux, based on RHEL v8"
}
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "free tier machine"
}
variable "availability_zone" {
  type        = string
  default     = "eu-west-1a"
  description = "availability zone within EU-WEST-1 zone"
}
variable "key" {
  type        = string
  default     = "ssh-keyGFT"
  description = "ssh pu key to use"
}
variable "user_data" {
  type    = string
  default = <<-EOF
    #!/bin/bash
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo bash -c "echo your very first web server > /var/www/html/index.html"
    EOF
}

variable "project_tags" {
  type = object({
    Name    = string
    version = number
  })
  default = {
    Name    = "prod"
    version = 1
  }
  description = "tags used in this project"
}

variable "lista_nazw" {
  type        = list(string)
  default     = ["abc", "xyz"]
  description = "list nazw ..."
}

variable "lista_numerow" {
  type        = list(number)
  default     = [1, 2, 3]
  description = "lista numwerów porządkowych ..."
}