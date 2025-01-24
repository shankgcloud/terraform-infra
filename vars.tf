variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "AMI" {
  type    = string
  default = "ami-00bb6a80f01f03502"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "az" {
  type    = string
  default = "ap-south-1a"
}