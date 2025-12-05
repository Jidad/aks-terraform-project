# 🚀 Deploying with GitHub Codespaces

This guide demonstrates how to deploy the AKS Terraform infrastructure using **GitHub Codespaces** for a streamlined, browser-based deployment experience.

---

## 📖 Table of Contents

1. [Why Codespaces?](#why-codespaces)
2. [Prerequisites](#prerequisites)
3. [Quick Start](#quick-start)
4. [Step-by-Step Deployment](#step-by-step-deployment)
5. [Verification](#verification)
6. [Troubleshooting](#troubleshooting)
7. [Best Practices](#best-practices)

---

## Why Codespaces?

GitHub Codespaces provides a pre-configured, cloud-based development environment that eliminates local setup complexity.

### Key Benefits

✅ **Zero Setup Time** - Environment ready in 2-3 minutes  
✅ **Pre-installed Tools** - Terraform, Azure CLI, kubectl, Docker  
✅ **Consistent Environment** - Same configuration for all team members  
✅ **Powerful Resources** - 4-8 CPU cores, ample memory  
✅ **Browser-Based** - Work from any device, anywhere  
✅ **Integrated Git** - Seamless version control workflow  
✅ **Cost-Effective** - Free tier includes 120 core-hours/month

### Comparison: Local vs. Codespaces

| Feature | Local Deployment | GitHub Codespaces |
|---------|------------------|-------------------|
| **Initial Setup** | 30-45 minutes | 2-3 minutes |
| **Tool Installation** | Manual | Pre-installed |
| **Environment Consistency** | Varies | Guaranteed |
| **Compute Resources** | Limited by device | Consistent 4-8 cores |
| **Access** | Single workstation | Any device |

---

## Prerequisites

- ✅ **GitHub account** with Codespaces access
- ✅ **Azure subscription** with appropriate permissions
- ✅ **Forked or cloned** this repository
- ✅ Basic understanding of Terraform and Kubernetes

---

## Quick Start

### 1. Launch Codespace

1. Navigate to your repository on GitHub
2. Click the green **"Code"** button
3. Select the **"Codespaces"** tab
4. Click **"Create codespace on main"**

⏱️ **Wait 2-3 minutes** for environment setup.

### 2. Deploy Infrastructure
```bash
# Authenticate with Azure
az login --use-device-code

# Initialize Terraform
terraform init

# Create development workspace
terraform workspace new dev

# Review deployment plan
./scripts/terraform.sh plan

# Deploy infrastructure
./scripts/terraform.sh apply
```

Type **`yes`** when prompted.

⏱️ **Deployment takes approximately 20-25 minutes**.

---

## Step-by-Step Deployment

### Step 1: Verify Environment (2 minutes)
```bash
# Check pre-installed tools
terraform version
az version
kubectl version --client

# Verify project structure
ls -la
```

### Step 2: Azure Authentication (5 minutes)
```bash
# Login using device code flow
az login --use-device-code

# Verify authentication
az account show
```

### Step 3: Initialize Terraform (5 minutes)
```bash
terraform init
```

### Step 4: Create Workspace (2 minutes)
```bash
terraform workspace new dev
terraform workspace show
```

### Step 5: Make Scripts Executable (1 minute)
```bash
chmod +x scripts/*.sh
ls -la scripts/
```

### Step 6: Review Plan (5 minutes)
```bash
./scripts/terraform.sh plan
```

### Step 7: Deploy Infrastructure (20-25 minutes)
```bash
./scripts/terraform.sh apply
```

---

## Verification

### Verify AKS Cluster (5 minutes)
```bash
# Fetch kubeconfig
./scripts/get-kubeconfig.sh cloudproj-dev-rg cloudproj-dev-aks

# Check nodes
kubectl get nodes

# Verify pods
kubectl get pods -A
```

### Verify ACR (5 minutes)
```bash
# Login to ACR
az acr login --name cloudprojdevacr

# List repositories
az acr repository list --name cloudprojdevacr --output table

# Test image push
docker pull nginx:latest
docker tag nginx:latest cloudprojdevacr.azurecr.io/frontend:dev
docker push cloudprojdevacr.azurecr.io/frontend:dev
```

---

## Troubleshooting

### Issue: Azure CLI login fails
```bash
az login --use-device-code
```

### Issue: Terraform prompts for variables
```bash
# Use wrapper script
./scripts/terraform.sh apply
```

### Issue: kubectl cannot connect
```bash
./scripts/get-kubeconfig.sh cloudproj-dev-rg cloudproj-dev-aks
```

---

## Best Practices

1. **Always verify workspace**: `terraform workspace show`
2. **Review plans**: Always run `plan` before `apply`
3. **Cost optimization**: Run `terraform destroy` when done
4. **Never commit** `.tfstate` files
5. **Use Key Vault** for secrets

---

## Cost Considerations

- **Codespaces**: 120 core-hours/month free
- **Azure Dev Environment**: ~$50-75/month
- **Tip**: Stop Codespace when not in use

---

## Next Steps

- Deploy applications (see [DEVELOPER_GUIDE.md](./DEVELOPER_GUIDE.md))
- Configure CI/CD pipelines
- Monitor resources with Azure Monitor

---

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/)
- [GitHub Codespaces](https://docs.github.com/codespaces)

---

**Successfully deployed and documented by the community** 🎉
