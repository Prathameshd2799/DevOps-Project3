variable "instance_type" {
  type        = string
  default     = "m5.large"
  description = "AWS instance type"
}
 
# Env is partially figured out by the context of the environment it's being run in - this should still be specified between Staging::STG and Production::PRD in Pub-PRD though
variable "Env" {
  type        = string
  default     = null
}
variable "tags" {
  type        = map
 
}
# Private key used for SSH. This value shouldn't be changed.
variable "key_name" {
  type = string
  default = null
}
 
# Uses our hierarchy of Service > Logical_Component > Service_Component to label where in the service tree the instance lives.
variable "service" {
  type = string
}
 
variable "logical_component" {
  type = string
}
 
variable "service_component" {
  type = string
}
 
variable "security_groups" {
  type = list(string)
  default = ["sg-068d41711e55161f5"]
}
 
### Disk parameters ###
variable "ebs_volume_type" {
  type     = string
  default  = "gp3"
  nullable = false
}
 
# Sets sizes of default disks, #1
variable "root_size" {
  type     = number
  default  = 20
  nullable = false
}
# Sets sizes of default disks, #2
variable "ebs_size" {
  type = number
  default = 48
}
 
# If this var is changed, it will attach an additional EBS volume to the instance.
variable "ebs_size_extra" {
  type = number
  default = 0
}
 
variable "ebs_volume_extra_iops" {
  type = number
  default = 3000
}
 
variable "ebs_volume_extra_throughput" {
  type = number
  default = 125
}
 
# Does not need to be specified in NPE, but does in Pub-PRD.
variable "subnet_id" {
  type    = string
  default = null
}
 
# Also known as IAM role, necessary for the instance to bind to VASD. This generally should not be set from an instance declaration.
variable "iam_instance_profile" {
  type     = string
  default  = null
}
 
# Should not be set in instance declaration
variable "ami" {
  type    = string
  default = null
}
 
# For silo labeling
variable "silo" {
  type    = string
  default = null
}
 
# Can be used to brand a service owner to instances. Optional.
variable "service_owner" {
  type    = string
  default = null
}
 
# Points to a file (script) to be placed into userdata and read on instance launch.
variable "user_data" {
  type    = string
  default = null
}
 
variable "iqt_node" {
  type    = string
  default = null
}
 
variable "iqt_client_1" {
  type    = string
  default = null
}
variable "iqt_client_2" {
  type    = string
  default = null
}
variable "iqt_client_3" {
  type    = string
  default = null
}
variable "iqt_client_4" {
  type    = string
  default = null
}
variable "iqt_client_5" {
  type    = string
  default = null
}
variable "enable_delete_protection" {
  description = "Enable delete protection for the EC2 instance"
  type        = bool
#  default     = false
}
variable "instance_identifier" {
  type        = list(string)
  default     = [""]
  description = "AWS instance_identifier"
}
variable "Application_identifier" {
  type        = string
  description = "Application_identifier"
}