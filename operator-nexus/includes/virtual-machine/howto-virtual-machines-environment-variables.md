---
ms.date: 10/23/2025
ms.author: omarrivera
author: g0r1v3r4
ms.topic: include
ms.service: azure-operator-nexus
---

## Environment variables

Before proceeding with the deployment, set the following environment variables to define the configuration for your virtual machine (VM).

| Variable                  | Description                                                                                                                 |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| `ACR_PASSWORD`            | Azure Container Registry password.                                                                                          |
| `ACR_URL`                 | Azure Container Registry URL.                                                                                               |
| `ACR_USERNAME`            | Azure Container Registry username.                                                                                          |
| `ADMIN_USERNAME`          | Administrator username for the VM.                                                                                          |
| `CLUSTER_CUSTOM_LOCATION` | Custom location of the Nexus instance.                                                                                      |
| `CLUSTER_NAME`            | The name of your Nexus cluster.                                                                                             |
| `CPU_CORES`               | (Optional) Number of CPU cores for the VM.                                                                                  |
| `CSN_ARM_ID`              | ARM resource ID of the Cloud Services Network (CSN).                                                                        |
| `L3_NETWORK_ARM_ID`       | ARM resource ID of the L3 network to create.                                                                                |
| `LOCATION`                | Azure region for the resources.                                                                                             |
| `MEMORY_SIZE`             | (Optional) Memory size in GiB for the VM.                                                                                   |
| `NETWORK_INTERFACE_NAME`  | Name of the network interface.                                                                                              |
| `RESOURCE_GROUP`          | The name of the Azure resource group.                                                                                       |
| `SSH_PUBLIC_KEY`          | SSH public key for VM access.                                                                                               |
| `SUBSCRIPTION_ID`         | Your Azure subscription ID.                                                                                                 |
| `TENANT_ID`               | Your Azure tenant ID.                                                                                                       |
| `UAMI_ID`                 | (Optional) The user-assigned managed identity (UAMI) resource ID. Not required when using system-assigned managed identity. |
| `UAMI_NAME`               | (Optional) Name of the user-assigned managed identity. Not required when using system-assigned managed identity.            |
| `VM_DISK_SIZE`            | (Optional) OS disk size in GiB.                                                                                             |
| `VM_IMAGE`                | Container image for the VM.                                                                                                 |
| `VM_NAME`                 | Name of the virtual machine.                                                                                                |

To set these variables, use the following commands and replace the example values with your actual values:

```bash
# Required variables
RESOURCE_GROUP="my-resource-group"
CLUSTER_NAME="my-cluster-name"
TENANT_ID="00000000-0000-0000-0000-000000000000"
SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
LOCATION="$(az group show --name $RESOURCE_GROUP --query location --subscription $SUBSCRIPTION -o tsv)"
CLUSTER_CUSTOM_LOCATION=$(az networkcloud cluster show -g "$RESOURCE_GROUP" -n "$CLUSTER_NAME" --query "clusterExtendedLocation.name" -o tsv)

# VM specific variables (replace with your preferred values)
VM_NAME="myNexusVirtualMachine"

# (Optional) User-Assigned Managed Identity (UAMI) parameters
UAMI_NAME="myUamiName"
UAMI_ID="</subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<uami-name>"

# VM Image parameters
VM_IMAGE="<VM image, example: myacr.azurecr.io/ubuntu:20.04>"
ACR_URL="<Azure Container Registry URL, example: myacr.azurecr.io>"
ACR_USERNAME="<Azure Container Registry username>"
ACR_PASSWORD="<Azure Container Registry password>"

# (Optional) variables (will use defaults if not set), values here are examples you can modify as needed
CPU_CORES="4"
MEMORY_SIZE="8"
VM_DISK_SIZE="64"

# VM credentials
ADMIN_USERNAME="azureuser"
SSH_PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub)"

# Network parameters
CSN_ARM_ID="/subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.NetworkCloud/cloudServicesNetworks/<csn-name>"
L3_NETWORK_ARM_ID="/subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.NetworkCloud/l3Networks/<l3Network-name>"
NETWORK_INTERFACE_NAME="mgmt0"
```
