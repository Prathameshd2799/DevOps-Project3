ami                    = "ami-0b86aaed8ef90e45f"
instance_type          = "t2.large"
vpc_security_group_ids = ["sg-05c3c3b1017505216"]
key_name               = "jenkins"
subnet_id              = "subnet-058dabedfa9f36754"
iam_instance_profile   = "admin_role"
name                   = "terraform-ec2"
project_name           = "DevOps"
env                    = "dev"
user_data              = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y wget unzip
    wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
    unzip terraform_1.6.6_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    terraform -version
  EOF
