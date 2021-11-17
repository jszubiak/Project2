
variable "ami" {
  type = string
  default = "ami-0ec23856b3bad62d3"  
}

variable "instance_type" {
  type = string
  default = "t2.micro"  
}

variable "availability_zone" {
  type = string
  default = "eu-west-1a"  
}

variable "key" {
  type = string
  default = "ssh-keyGFT"  
}

variable "user_data" {
    type = string
    default = <<-EOF
    #!/bin/bash
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo bash -c "echo your very first web server > /var/www/html/index.html"
    EOF
}
