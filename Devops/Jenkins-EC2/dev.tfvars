ami                    = "ami-0b86aaed8ef90e45f"
instance_type          = "t2.micro"
vpc_security_group_ids = ["sg-05c3c3b1017505216"]
key_name               = "jenkins"
subnet_id              = "subnet-058dabedfa9f36754"
iam_instance_profile   = "admin_role"
name                   = "jenkins-ec2"
project_name           = "DevOps"
env                    = "dev"
user_data              = <<-EOF
  #!/bin/bash
  sudo yum update -y

  # Install Java 17 (Amazon Corretto)
  sudo amazon-linux-extras enable corretto17
  sudo yum install -y java-17-amazon-corretto

  # Install Jenkins
  wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  sudo yum install -y jenkins

  # Enable and start Jenkins
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
EOF
