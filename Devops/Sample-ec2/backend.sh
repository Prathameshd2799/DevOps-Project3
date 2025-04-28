#!/bin/bash

# Fetch bucket name from Terraform output
bucket_name=$(terraform output -raw bucket_name)

cat <<EOF > backend-config-dev.tfvars
bucket          = "${bucket_name}"
key             = "envs/dev/terraform.tfstate"
region          = "us-east-1"
encrypt         = true
EOF

echo "✅ backend-config-dev.tfvars generated successfully."
