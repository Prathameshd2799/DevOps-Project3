variable "ami" {}
variable "instance_type" {}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "key_name" {}
variable "subnet_id" {}
variable "iam_instance_profile" {}
variable "name" {}
variable "project_name" {}
variable "env" {}
variable "user_data" {}
