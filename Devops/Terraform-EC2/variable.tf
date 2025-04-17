variable "Env" {
  description = "The environment name (e.g., Production::PRD, Non-production::Pre Prod)"
  type        = string
}

variable "key_name" {
  description = "SSH key name for EC2 instance"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile name (optional)"
  type        = string
  default     = null
}

variable "ami" {
  description = "AMI ID for EC2"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_identifier" {
  description = "List of instance name identifiers"
  type        = list(string)
}

variable "enable_delete_protection" {
  description = "If true, prevents the instance from being terminated via API"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Startup script to configure EC2"
  type        = string
  default     = ""
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "root_size" {
  description = "Size of the root EBS volume (in GB)"
  type        = number
}

variable "ebs_size" {
  description = "Size of the additional EBS volume (in GB)"
  type        = number
}

variable "ebs_size_extra" {
  description = "Size of the optional third EBS volume (in GB)"
  type        = number
  default     = 0
}

variable "ebs_volume_type" {
  description = "EBS volume type (e.g., gp3, gp2)"
  type        = string
  default     = "gp3"
}

variable "Application_identifier" {
  description = "Short name to identify the application (used in hostnames)"
  type        = string
}

variable "logical_component" {
  type = string
}

variable "service_component" {
  type = string
}

variable "service" {
  type = string
}

variable "silo" {
  type = string
}

variable "service_owner" {
  type = string
}

variable "iqt_client_1" {
  type = string
}

variable "iqt_client_2" {
  type = string
}

variable "iqt_client_3" {
  type = string
}

variable "iqt_client_4" {
  type = string
}

variable "iqt_client_5" {
  type = string
}

variable "iqt_node" {
  type = string
}

variable "tags" {
  description = "Additional tags to apply to EC2 instance"
  type        = map(string)
  default     = {}
}
