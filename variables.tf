variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "number_of_instance" {
  type    = number
  default = 3
}

variable "ami" {
  type    = string
  default = "ami-065deacbcaac64cf2"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "key_pair_name" {
  type    = string
  default = "etcd-key-pair"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "private_ips_file" {
  type    = string
  default = "private_ips.txt"
}

variable "etcd_version" {
  type    = string
  default = "3.5.4"
}