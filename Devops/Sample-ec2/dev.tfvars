ami                    = "ami-0b86aaed8ef90e45f"
instance_type          = "t2.micro"
vpc_security_group_ids = ["sg-05c3c3b1017505216"]
key_name               = "jenkins"
subnet_id              = "subnet-058dabedfa9f36754"
iam_instance_profile   = "admin_role"
name                   = "FQTS-sample-ec2"
project_name           = "DevOps"
env                    = "dev"
user_data              = <<-EOF
  #!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF
bucket                 = "pdhalkar-fqts-backup-dev"
key                    = "envs/dev/terraform.tfstate"
region                 = "us-east-1"
encrypt                = true
use_lockfile           = true