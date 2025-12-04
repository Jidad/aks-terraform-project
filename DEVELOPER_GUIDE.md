# 💻 Azure Kubernetes Service (AKS) Terraform Project – Developer Guide

This guide outlines the essential steps for setting up the your local environment and understanding the core tools required to work with the **Dev** AKS cluster and its resources.

---

### 1. Environment Setup

To ensure successful deployment and interaction with the Azure resources, confirm all prerequisites are met:

#### Prerequisites

* **Azure subscription** and necessary permissions to deploy resources.
* **Installed Tools:**
    * **Terraform ($\geq 1.6$):** [https://www.terraform.io/downloads](https://www.terraform.io/downloads)
    * **Azure CLI:** [https://docs.microsoft.com/en-us/cli/azure/install-azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    * **kubectl:** [https://kubernetes.io/docs/tasks/tools/](https://kubernetes.io/docs/tasks/tools/)
* Access to the project repository (`aks-terraform-project/`).
* **Authentication:** Ensure you are logged into Azure CLI (`az login`).

---

### 2. Terraform Workspaces

The project uses Terraform Workspaces to enforce strict isolation between environments. You must select the appropriate workspace before running any deployment commands (`plan`, `apply`, `destroy`).

| Workspace | Environment | Purpose |
| :--- | :--- | :--- |
| `dev` | Development | Primary environment for developers to test features and configuration. |
| `stage` | Staging | Environment for integration testing and pre-production validation. |
| `prod` | Production | Live production environment (highly restricted access). |

* **State Isolation:** Workspaces ensure that the Terraform state is completely separate for each environment, preventing accidental cross-environment changes.
* **Automated Variables:** Use the **workspace-aware wrapper script** (`terraform.sh` or `terraform.ps1`) to automatically load environment-specific variables from the correct `.tfvars` file, avoiding manual input.

#### Selecting a Workspace

```bash
# Select the 'dev' workspace. If it doesn't exist, create it.
terraform workspace select dev || terraform workspace new dev
```

### 3. Deploying Infrastructure (Dev)

This section details the commands for initializing and deploying the **Dev** environment infrastructure.

1.  **Select Dev Workspace:** Ensure you are operating within the dedicated Development workspace.

    ```bash
    terraform workspace select dev || terraform workspace new dev
    ```

2.  **Run Terraform Plan:** Review the plan output to see what resources will be created.

    ```bash
    ./scripts/terraform.sh plan
    ```

3.  **Apply Deployment:** Execute the deployment.

    ```bash
    ./scripts/terraform.sh apply
    ```

> ⚙️ **The wrapper script automatically picks the correct variable file (`envs/dev/terraform.tfvars`), so no variable prompts are required.**

---

### 4. Accessing AKS Cluster

Once the infrastructure is deployed, use the following steps to establish connectivity to the cluster API.

1.  **Fetch Kubeconfig:** Run the utility script to securely retrieve the cluster configuration required for `kubectl`.

    ```bash
    bash scripts/get-kubeconfig.sh cloudproj-dev-rg cloudproj-dev-aks
    ```

2.  **Verify Cluster Connectivity:** Use `kubectl` to confirm that the nodes are ready and system pods are running.

    ```bash
    kubectl get nodes
    kubectl get pods -A
    ```

3.  **Deployment:** Developers can now deploy applications to the **Dev AKS cluster** using standard `kubectl` commands or integrated CI/CD pipelines.

---

### 5. Accessing ACR

To manage container images, developers need to authenticate with the Azure Container Registry (ACR) and use standard Docker commands.

1.  **Login to ACR:** Use the Azure CLI to authenticate your Docker client using the registry name.

    ```bash
    az acr login --name cloudprojdevacr
    ```

2.  **Pull Images:** Once logged in, you can pull images for local testing or reference.

    ```bash
    # Pull the frontend image
    docker pull cloudprojdevacr.azurecr.io/frontend:dev

    # Pull the backend image
    docker pull cloudprojdevacr.azurecr.io/backend:dev
    ```

> 🔒 **Push permissions (for deploying new images) are strictly controlled via Azure AD Role-Based Access Control (RBAC).**

### 6. Database Access (Dev) 🔒

Access to the Azure MySQL Flexible Server is highly restricted, leveraging a secure, private network configuration.

* **Network Security:** The MySQL server resides in a **private subnet** and is accessed via a **private endpoint (PE)**. This architecture ensures that traffic never leaves the Azure backbone.
* **Access Control:** Developers can only connect from **whitelisted IPs**. In the Dev environment, this often means your workstation's IP or a designated jump host IP must be explicitly allowed in the NSG rules for the `database subnet`.
* **Security:** Database credentials (`username`, `password`) are stored securely in **Azure Key Vault** and should be read dynamically for connection (e.g., using a small script or retrieving them manually for client setup).

#### Example Connection:

```bash
# Connect using the FQDN retrieved from deployment outputs
mysql -h <mysql_fqdn> -u <username> -p
```

### 7. Stage / Production Workflow 🚀

The **Stage** and **Production** environments are exclusively managed by automation to enforce security and consistency.

* **Access Restriction:** **Stage** and **Prod** deployments are handled via **CI/CD pipelines**. Developers **do not get direct `kubectl` access** to these clusters. Access is restricted to service principals used by the pipeline.
* **Deployment Method:** Deployment remains consistent using **Terraform workspaces**.

#### Deploy Stage

```bash
terraform workspace select stage || terraform workspace new stage
./scripts/terraform.sh plan
./scripts/terraform.sh apply
```

#### Deploy Production

```bash
terraform workspace select prod || terraform workspace new prod
./scripts/terraform.sh plan
./scripts/terraform.sh apply
```

⚙️ The wrapper scripts automatically use the correct variable files (envs/stage/terraform.tfvars or envs/prod/terraform.tfvars), ensuring consistency and safety across production environments.


### 8. Switching Between Workspaces 🔄

To ensure all Terraform commands target the correct environment, you must explicitly switch your active workspace.

* **List Workspaces:**
    ```bash
    terraform workspace list
    ```

* **Select Target Workspace:**
    ```bash
    terraform workspace select <workspace_name>
    ```

> ⚙️ This command is crucial. It ensures all subsequent Terraform commands automatically use the correct environment state and variables for the selected environment (`dev`, `stage`, or `prod`).

---

### 9. Best Practices for Developers 🛡️

Adhere to these best practices for safe, secure, and efficient operations:

1.  **Never hardcode credentials;** always use **Azure Key Vault** for secret storage.
2.  Always verify **`terraform plan`** before running **`terraform apply`** to confirm expected changes.
3.  Use the wrapper scripts (`terraform.sh`/`.ps1`) to ensure the **correct `.tfvars` file** is automatically applied.
4.  Avoid modifying **Stage/Prod clusters directly**; all changes should flow through **CI/CD pipelines**.
5.  Follow **naming and tagging conventions** strictly to maintain resource organization and cost management.

---

### 10. Troubleshooting Tips 💡

| Issue | Potential Cause / Action |
| :--- | :--- |
| **Terraform prompts for variables** | Make sure you are using the wrapper script (`terraform.sh`/`.ps1`) or explicitly supplying the correct `tfvars` file via the `-var-file` flag. |
| **Kubeconfig not updating** | Run **`scripts/get-kubeconfig.sh`** after deployment to fetch the latest cluster credentials. |
| **ACR login fails (`az acr login`)** | Ensure your user account or service principal has the proper **Azure AD RBAC permissions** (e.g., `AcrPull`, `AcrPush`) for the registry. |

This guide ensures developers can safely and efficiently work with all environments without manual input prompts, leveraging workspace-aware automation.