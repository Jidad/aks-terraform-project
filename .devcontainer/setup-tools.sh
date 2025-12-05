#!/usr/bin/env bash
set -e

echo "🔧 Setting up tools for Azure Terraform Project..."

# Update base packages
sudo apt-get update -y

#######################################
# Azure CLI
#######################################
if ! command -v az >/dev/null 2>&1; then
  echo "➡ Installing Azure CLI..."
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
  echo "✅ Azure CLI already installed"
fi

#######################################
# Terraform
#######################################
if ! command -v terraform >/dev/null 2>&1; then
  echo "➡ Installing Terraform..."
  sudo apt-get install -y gnupg software-properties-common wget

  wget -O- https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/hashicorp.list

  sudo apt-get update -y
  sudo apt-get install -y terraform
else
  echo "✅ Terraform already installed"
fi

#######################################
# kubectl (fallback install if missing)
#######################################
if ! command -v kubectl >/dev/null 2>&1; then
  echo "➡ Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -m 0755 kubectl /usr/local/bin/kubectl
  rm kubectl
else
  echo "✅ kubectl already installed"
fi

echo "✅ Tool setup completed."
