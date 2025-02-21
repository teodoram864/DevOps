#!/bin/bash

# Update package index and install prerequisites
echo "Updating package list and installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Add the Microsoft GPG key
echo "Adding Microsoft GPG key..."
curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /
