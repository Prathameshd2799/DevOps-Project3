module "ec2-detailing" {
  source                 = "../module/ec2"
  enable_delete_protection = true
  service_component      = "api"
  service                = "user-service"
  Application_identifier = "nodejs-app"
  logical_component      = "frontend"
  silo                   = "dev"
  service_owner          = "dev-team"

  tags = {
    Environment = "dev"
    Owner       = "DevOps"
    Project     = "MyProject"
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "jenkins"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = data.aws_subnet_ids.default.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    curl -sL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs git

    mkdir -p /home/ec2-user/app
    cd /home/ec2-user/app

    cat > index.js <<APP
    const http = require('http');
    const PORT = 3000;
    const server = http.createServer((req, res) => {
      res.statusCode = 200;
      res.setHeader('Content-Type', 'text/plain');
      res.end('Hello from Terraform Node.js App!');
    });
    server.listen(PORT, () => {
      console.log(\`Server running on port \${PORT}\`);
    });
    APP

    npm init -y
    npm install
    npm install -g pm2
    pm2 start index.js
    pm2 startup
    pm2 save
  EOF

  tags = {
    Name        = "NodeAppServer"
    Environment = "dev"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}
