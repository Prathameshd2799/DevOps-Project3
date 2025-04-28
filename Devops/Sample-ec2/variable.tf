variable "ami" {
    type = string
}
variable "instance_type" {
    type = string
}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "key_name" {
    type = string
}
variable "subnet_id" {
    type = string
}
variable "iam_instance_profile" {
    type = string
}
variable "name" {

    type = string
}
variable "project_name" {
    type = string
}
variable "env" {
    type = string
}
variable "user_data" {
    type = string
}

