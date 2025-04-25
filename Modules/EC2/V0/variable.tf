variable "ami" {}
variable "instance_type" {}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "key_name" {
  default = null
}
variable "subnet_id" {}
variable "iam_instance_profile" {
  default = null
}
variable "name" {}
variable "project_name" {}
variable "env" {}
variable "user_data" {}
variable "tags" {
  type    = map(string)
  default = {}
}

# Storage related
variable "root_size" {
  default = 20
}
variable "ebs_size" {
  default = 48
}
variable "ebs_size_extra" {
  default = 0
}
variable "ebs_volume_type" {
  default = "gp3"
}
