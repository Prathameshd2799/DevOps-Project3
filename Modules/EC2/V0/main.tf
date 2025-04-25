locals {
  Env     = var.env
  vpcname = local.Env == "Production::PRD" ? "prod" : "npe"
  envtag  = local.vpcname == "prod" ? "prd" : "dev"

  key_name             = coalesce(var.key_name, local.vpcname == "prod" ? "VPC_TMOPUB_WEST" : "VPC_NPE_WEST")
  iam_instance_profile = coalesce(var.iam_instance_profile, local.vpcname == "prod" ? "prd-llk-ec2" : "ec2-llk-npe")

  hostname_prefix = "${local.envtag}-${var.project_name}"
}

resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = local.key_name
  subnet_id                   = var.subnet_id
  iam_instance_profile        = local.iam_instance_profile
  associate_public_ip_address = true
  user_data                   = var.user_data

  root_block_device {
    volume_size           = var.root_size
    volume_type           = var.ebs_volume_type
    iops                  = 3000
    throughput            = var.ebs_volume_type == "gp3" ? 125 : null
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = var.ebs_size
    volume_type           = var.ebs_volume_type
    iops                  = 3000
    throughput            = var.ebs_volume_type == "gp3" ? 125 : null
    delete_on_termination = true
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_size_extra > 0 ? [1] : []
    content {
      device_name           = "/dev/sdc"
      volume_size           = var.ebs_size_extra
      volume_type           = var.ebs_volume_type
      iops                  = 3000
      throughput            = var.ebs_volume_type == "gp3" ? 125 : null
      delete_on_termination = true
    }
  }

  tags = merge(var.tags, {
    Name        = "${local.hostname_prefix}-${var.name}"
    Environment = var.env
    Application = "Linelink"
    cmdb_app_id = "APM0223601"
  })
}
