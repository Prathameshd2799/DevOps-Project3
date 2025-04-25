module "jenkins_instance" {
  source                 = "../../Modules/EC2/V0"
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile
  name                   = var.name
  project_name           = var.project_name
  env                    = var.env
  user_data              = var.user_data
}
