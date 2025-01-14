---
title: Create Kubernetes clusters using Terraform (preview)
description: Learn how to create Kubernetes clusters using Terraform.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 11/15/2024

---

# Create Kubernetes clusters using Terraform (preview)

This article describes how to create Kubernetes clusters in Azure Local using Terraform and the Azure Verified Module. The workflow is as follows:

- Create an SSH key pair.
- Create a Kubernetes cluster in Azure Local 23H2 using Terraform. By default, the cluster is Azure Arc-connected.
- Validate the deployment and connect to the cluster.

> [!IMPORTANT]
> These preview features are available on a self-service, opt-in basis. Previews are provided "as is" and "as available," and they're excluded from the service-level agreements and limited warranty. Azure Kubernetes Service, enabled by Azure Arc previews are partially covered by customer support on a best-effort basis.

## Before you begin

Before you begin, make sure you have the following prerequisites:

1. Get the following details from your on-premises infrastructure administrator:
   - Azure subscription ID: the Azure subscription ID that uses Azure Local for deployment and registration.
   - Custom location name or ID: the Azure Resource Manager ID of the custom location. The custom location is configured during the Azure Local cluster deployment. Your infrastructure admin should give you the Resource Manager ID of the custom location. This parameter is required to create Kubernetes clusters. You can also get the Resource Manager ID using `az customlocation show --name "<custom location name>" --resource-group <azure resource group> --query "id" -o tsv`, if the infrastructure admin provides a custom location name and resource group name.
   - Logical network name or ID: the Azure Resource Manager ID of the Azure Local logical network that was created following these steps. Your admin should give you the ID of the logical network. This parameter is required in order to create Kubernetes clusters. You can also get the Azure Resource Manager ID using `az stack-hci-vm network lnet show --name "<lnet name>" --resource-group <azure resource group> --query "id" -o tsv` if you know the resource group in which the logical network was created.
1. Make sure you have GitHub, [the latest version of Azure CLI](/cli/azure/install-azure-cli), and [the Terraform client](/azure/developer/terraform/quickstart-configure) installed on your development machine.  
1. [Download and install kubectl](https://kubernetes.io/docs/tasks/tools/) on your development machine.

## Create an SSH key pair

To create an SSH key pair (same as Azure AKS), use the following procedure:

1. [Open a Cloud Shell session](https://shell.azure.com/) in your browser.
1. Create an SSH key pair using the [az sshkey create](/cli/azure/sshkey#az-sshkey-create) command, [from the portal](/azure/virtual-machines/ssh-keys-portal), or the `ssh-keygen` command:  

   ```azurecli
   az sshkey create --name "mySSHKey" --resource-group "myResourceGroup"
   ```

   or

   ```azurecli
   ssh-keygen -t rsa -b 4096 
   ```

1. Retrieve the value of your public key from Azure or from your local machine under **/.ssh/id_rsa.pub**.

## Sign in to Azure

Terraform only supports authenticating to Azure with the Azure CLI. Authenticating using Azure PowerShell isn't supported. Therefore, while you can use the Azure PowerShell module when doing your Terraform work, you must first [authenticate to Azure](/azure/developer/terraform/authenticate-to-azure).

## Implement the Terraform code

1. Create a directory you can use to test the sample Terraform code, and make it your current directory.
1. In the same directory, create a file named **providers.tf** and paste the following code:

   ```terraform
   terraform { 
    required_version = "~> 1.5" 
    required_providers { 
      azapi = { 
        source  = "azure/azapi" 
        version = "~> 1.13" 
      } 
      azurerm = { 
       source  = "hashicorp/azurerm" 
       version = "~> 3.74" 
      } 
     }
    }
  
    provider "azurerm" { 
    features { 
     resource_group { 
      prevent_deletion_if_contains_resources = false 
     } 
    } 
   }
   ```

1. Create another file named **main.tf** that points to the latest AKS Arc AVM module, and insert the following code. You can read the description and input of the module and add optional parameters as needed. To find the admin group object ID, see [Enable Microsoft Entra authentication for Kubernetes clusters](enable-authentication-microsoft-entra-id.md). You can [follow this guidance](https://github.com/Azure/Edge-infrastructure-quickstart-template/blob/main/doc/AKS-Arc-Admin-Groups.md) to find it in your Azure environment.

   ```terraform
   module "aks_arc" { 
   # Make sure to use the latest AVM module version
   source = "Azure/avm-res-hybridcontainerservice-provisionedclusterinstance/azurerm" 
   version = "~>0.6"

   # Make sure to provide all required parameters  
   resource_group_id = "<Resource_Group>" 
   location = "<Region>" 
   name = "<Cluster_Name>" 
   logical_network_id = "<LNet_ID>" 
   custom_location_id = "<CustomLocation_ID>" 
   agent_pool_profiles = [{count=1}] 
   ssh_public_key =  "Your_SSH_Key"

   # Optional parameters, please update them as needed
   enable_workload_identity = false 
   enable_oidc_issuer = false 
   rbac_admin_group_object_ids = ["<Admin_Group_Object_ID>"]
   }
   ```

## Initialize Terraform

Run [`terraform init`](https://www.terraform.io/docs/commands/init.html) to initialize the Terraform deployment. Make sure to use the `-upgrade` flag to upgrade the necessary provider plugins to the latest version:

```terraform
terraform init -upgrade
```

## Create a Terraform execution plan and apply the plan

Run [terraform plan](https://www.terraform.io/docs/commands/plan.html) to create an execution plan, then run [terraform apply](https://www.terraform.io/docs/commands/apply.html) to apply the output file to your cloud infrastructure:

```terraform
terraform plan -out main.tfplan 
terraform apply main.tfplan 
```

The command executes, then returns success after the resource is successfully provisioned.

## Validate the deployment and connect to the cluster

You can now connect to your Kubernetes cluster by running `az connectedk8s proxy` from your development machine. You can also use **kubectl** to see the node and pod status. Follow the same steps as described in [Connect to the Kubernetes cluster](aks-create-clusters-cli.md#connect-to-the-kubernetes-cluster).

## Next steps

[Connect to the Kubernetes cluster](aks-create-clusters-cli.md#connect-to-the-kubernetes-cluster)
