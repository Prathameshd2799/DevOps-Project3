locals {
  # This determines whether the VPC is prod (Pub-PRD) or NPE, and changes parameters to fit the environment.
  Env     = var.Env
  vpc_id  = local.Env == "Production::PRD" ? "vpc-5161a435" : "vpc-1e22027b"
  vpcname = local.Env == "Production::PRD" ? "prod" : "npe"
  key_name = coalesce(var.key_name, local.vpcname == "prod" ? "VPC_TMOPUB_WEST" : "VPC_NPE_WEST")
  subnet_ids = var.Env == "Production::PRD" ? ["subnet-d1d45ab5","subnet-4d498529","subnet-091887f8c61d7f98a"] : ["subnet-3ea98b5a", "subnet-3ccab04a"]
  ip_counts = { for subnet_id, details in data.aws_subnet.subnet :
    subnet_id => details.available_ip_address_count
  }
  # Filter subnets where available IP count is greater than 8
  filtered_subnets = { for subnet_id, count in local.ip_counts :
    subnet_id => count if count > 8
  }
  subnet_id = element(keys(local.filtered_subnets), 0)
  envtag = (var.Env == "Production::PRD" ? "prd" : (var.Env == "Non-production::Pre Prod" ? "stg" : "dev" ))
   hostname_prefix      = "${local.envtag}-${var.Application_identifier}"
  # Changes Instance IAM role to fit the environment
  iam_instance_profile = coalesce(var.iam_instance_profile,local.vpcname == "prod" ? "prd-llk-ec2" : "ec2-llk-npe")
 
 
 
}
# The base config used to create EC2 instances. The ami section should be updated whenever CCoE releases a new image at: https://ccoe.docs.t-mobile.com/aws/reference/base_ami/
resource "aws_instance" "host" {
  ami           = coalesce(var.ami, data.aws_ami.ec2_ami.id)
  instance_type = var.instance_type
  count                 = length(var.instance_identifier)
  iam_instance_profile = local.iam_instance_profile
  key_name             = local.key_name
  disable_api_termination = var.enable_delete_protection
  user_data           = var.user_data
 
  vpc_security_group_ids = var.security_groups
  subnet_id              = local.subnet_id
  metadata_options {
    http_tokens = "required"
  }
  # Handles the first disk that comes with the instance by default. Defaults to 20GiB.
  root_block_device {
    delete_on_termination = true
    iops                  = 3000
    kms_key_id            = null
 
    throughput  = var.ebs_volume_type == "gp3" ? 125 : null
    volume_size = var.root_size
    volume_type = var.ebs_volume_type
  }
  # Handles the second disk that comes with the instance by default. Defaults to 48GiB.
  ebs_block_device {
    device_name           = "/dev/sdb"
    delete_on_termination = true
    iops                  = 3000
    kms_key_id            = null
 
    throughput  = var.ebs_volume_type == "gp3" ? 125 : null
    volume_size = var.ebs_size
    volume_type = var.ebs_volume_type
  }
 
    # This block adds an additional disk, if the variable ebs_size_extra is specified.
    dynamic "ebs_block_device" {
        for_each = var.ebs_size_extra > 0 ? [1] : []
        content {
            device_name = "/dev/sdc"
            delete_on_termination = true
            iops                  = 3000
            kms_key_id            = null
 
            throughput  = var.ebs_volume_type == "gp3" ? 125 : null
            volume_size = var.ebs_size_extra
            volume_type = var.ebs_volume_type
        }
    }
 
  # Plants default volume tags required for instances to function  
  volume_tags = {
    Application = "Linelink"
    Environment = local.Env
  }
 
  lifecycle {
    # QSConfigName is related to SSM Agent. Role/stack are deprecated but still exist.
    ignore_changes  = [user_data, ami, ebs_block_device, root_block_device, volume_tags, iam_instance_profile, tags["QSConfigName-ay6d4"], tags["Role"], tags["Stack"], tags["cmdb_app_id"]]
   
  }
  tags = merge(var.tags,{
    Name              = "${local.hostname_prefix}-${var.instance_identifier[count.index]}"
    Application       = "Linelink"
    Environment       = var.Env
    Logical_Component = var.logical_component
    Service_Component = var.service_component
    Service           = var.service
    Silo              = var.silo
    Service_Owner     = var.service_owner
    cmdb_app_id       = "APM0223601"
    IQT_Client_1      = var.iqt_client_1
    IQT_Client_2      = var.iqt_client_2
    IQT_Client_3      = var.iqt_client_3
    IQT_Client_4      = var.iqt_client_4
    IQT_Client_5      = var.iqt_client_5
    IQT_Node          = var.iqt_node
  })
}
 
 