#!/bin/bash

# Define the Terraform version you want to install
TERRAFORM_VERSION="1.5.0"  # Change to the desired version if necessary

# Update package index and install required dependencies
echo "Updating package index and installing dependencies..."
sudo apt update -y
sudo apt install -y wget unzip

# Download the Terraform zip file for Linux
echo "Downloading Terraform version $TERRAFORM_VERSION..."
wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_linux_amd64.zip

# Unzip the downloaded file
echo "Unzipping Terraform..."
unzip terraform_$TERRAFORM_VERSION_linux_amd64.zip

# Move the Terraform binary to a directory in the PATH
echo "Moving Terraform binary to /usr/local/bin..."
sudo mv terraform /usr/local/bin/

# Clean up by removing the downloaded zip file
rm terraform_$TERRAFORM_VERSION_linux_amd64.zip

# Verify the installation
echo "Verifying Terraform installation..."
terraform -v

echo "Terraform installation complete."
