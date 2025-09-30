---
title: Create an Azure Operator Nexus virtual machine by using Azure CLI
description: Learn how to create an Azure Operator Nexus virtual machine (VM) for virtual network function (VNF) workloads
author: dramasamy
ms.author: dramasamy
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 09/30/2025
ms.custom: template-how-to-pattern, devx-track-azurecli
---

# Quickstart: Create an Azure Operator Nexus virtual machine by using Azure CLI

* Deploy an Azure Nexus virtual machine using Azure CLI

This quick-start guide is designed to help you get started with using Nexus virtual machines to host virtual network functions (VNFs).
By following the steps outlined in this guide, you're able to quickly and easily create a customized Nexus virtual machine that meets your specific needs and requirements.
Whether you're a beginner or an expert in Nexus networking, this guide is here to help.
You learn everything you need to know to create and customize Nexus virtual machines for hosting virtual network functions.

## Before you begin

[!INCLUDE [virtual-machine-prereq](./includes/virtual-machine/quickstart-prereq.md)]
* Complete the [prerequisites](./quickstarts-tenant-workload-prerequisites.md) for deploying a Nexus virtual machine.

## Create a Nexus virtual machine

The following example creates a virtual machine named *myNexusVirtualMachine* in resource group *myResourceGroup* in the *eastus* location.

Before you run the commands, you need to set several variables to define the configuration for your virtual machine.
Here are the variables you need to set, along with some default values you can use for certain variables:

| Variable                   | Description                                                                                           |
| -------------------------- | ------------------------------------------------------------------------------------------------------|
| LOCATION                   | The Azure region where you want to create your virtual machine.                                       |
| RESOURCE_GROUP             | The name of the Azure resource group where you want to create the virtual machine.                    |
| SUBSCRIPTION               | The ID of your Azure subscription.                                                                    |
| CUSTOM_LOCATION            | This argument specifies a custom location of the Nexus instance.                                      |
| CSN_ARM_ID                 | The ARM resource ID of the cloud services network that the virtual machine connects to.               |
| L3_NETWORK_ID              | The ARM resource ID of the L3 network that the virtual machine connects to.                           |
| NETWORK_INTERFACE_NAME     | The name of the L3 network interface to be assigned.                                                  |
| ADMIN_USERNAME             | The username for the virtual machine administrator.                                                   |
| SSH_PUBLIC_KEY             | The SSH public key that is used for secure communication with the virtual machine.                    |
| CPU_CORES                  | The number of CPU cores for the virtual machine (even number, max 46 vCPUs)                           |
| MEMORY_SIZE                | The amount of memory (in GiB, max 224 GiB) for the virtual machine.                                   |
| VM_DISK_SIZE               | The size (in GiB) of the virtual machine disk.                                                        |
| VM_IMAGE                   | The URL of the virtual machine image.                                                                 |
| ACR_URL                    | The URL of the Azure Container Registry (ACR).                                                        |
| ACR_USERNAME               | The username for the Azure Container Registry.                                                        |
| ACR_PASSWORD               | The password for the Azure Container Registry.                                                        |
| UAMI_ID                    | The resource ID of the user-assigned managed identity (if using user-assigned managed identity).      |

> [!WARNING]
> User data isn't encrypted, and any process on the VM can query this data. You shouldn't store confidential information in user data.
> For more information, see [Azure data security and encryption best practices](/azure/security/fundamentals/data-encryption-best-practices).

Once the variables are defined, you can create the virtual machine by running the Azure CLI command.
To provide more detailed output for troubleshooting purposes, add the ```--debug``` flag at the end.

Use the following set of commands and replace the example values with your preferred values.
You can also use the default values for some of the variables, as shown in the following example:

```bash
# Azure parameters
RESOURCE_GROUP="myResourceGroup"
SUBSCRIPTION="<Azure subscription ID>"
CUSTOM_LOCATION="/subscriptions/<subscription_id>/resourceGroups/<managed_resource_group>/providers/microsoft.extendedlocation/customlocations/<custom-location-name>"
LOCATION="$(az group show --name $RESOURCE_GROUP --query location --subscription $SUBSCRIPTION -o tsv)"

# VM parameters
VM_NAME="myNexusVirtualMachine"

# VM credentials
ADMIN_USERNAME="azureuser"
SSH_PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub)"

# Network parameters
CSN_ARM_ID="/subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.NetworkCloud/cloudServicesNetworks/<csn-name>"
L3_NETWORK_ID="/subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.NetworkCloud/l3Networks/<l3Network-name>"
NETWORK_INTERFACE_NAME="mgmt0"

# VM Size parameters
CPU_CORES=4
MEMORY_SIZE=12
VM_DISK_SIZE="64"

# Virtual Machine Image parameters
VM_IMAGE="<VM image, example: myacr.azurecr.io/ubuntu:20.04>"
ACR_URL="<Azure Container Registry URL, example: myacr.azurecr.io>"
ACR_USERNAME="<Azure Container Registry username>"
ACR_PASSWORD="<Azure Container Registry password>"
```

> [!IMPORTANT]
> It's essential that you replace the placeholders for CUSTOM_LOCATION, CSN_ARM_ID, L3_NETWORK_ID and ACR parameters with your actual values before running these commands.

After defining these variables, you can create the virtual machine by executing the following Azure CLI command.

Create the virtual machine using a Service Principal with Azure CLI:

```azurecli-interactive
az networkcloud virtualmachine create \
    --name "$VM_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --subscription "$SUBSCRIPTION" \
    --extended-location name="$CUSTOM_LOCATION" type="CustomLocation" \
    --location "$LOCATION" \
    --admin-username "$ADMIN_USERNAME" \
    --csn "attached-network-id=$CSN_ARM_ID" \
    --cpu-cores $CPU_CORES \
    --memory-size $MEMORY_SIZE \
    --network-attachments '[{"attachedNetworkId":"'$L3_NETWORK_ID'","ipAllocationMethod":"Dynamic","defaultGateway":"True","networkAttachmentName":"'$NETWORK_INTERFACE_NAME'"}]'\
    --storage-profile create-option="Ephemeral" delete-option="Delete" disk-size="$VM_DISK_SIZE" \
    --vm-image "$VM_IMAGE" \
    --ssh-key-values "$SSH_PUBLIC_KEY" \
    --vm-image-repository-credentials registry-url="$ACR_URL" username="$ACR_USERNAME" password="$ACR_PASSWORD"
```

### Virtual machines with managed identities

Create the virtual machine with either a system-assigned or a user-assigned managed identity.
To add a managed identity to the VM, the API version must be `2025-07-01-preview` or later.

Make sure the [`networkcloud` extension] is installed with a version that supports the required API version.
You can find supported versions in the [`networkcloud` extension release history] on GitHub.

[`networkcloud` extension]: /cli/azure/networkcloud
[`networkcloud` extension release history]: https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst

> [!IMPORTANT]
> You must assign a managed identity (system-assigned or user-assigned) when creating the VM.
> Managed identities can't be added after the VM is created.

To enable the system-assigned managed identity for the virtual machine, be sure to include the `--mi-system-assigned` flag (or the alias `--system-assigned`).

Create the virtual machine using a System-Assigned Managed Identity (SAMI) with Azure CLI:

```azurecli-interactive
az networkcloud virtualmachine create \
    --name "$VM_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --subscription "$SUBSCRIPTION" \
    --extended-location name="$CUSTOM_LOCATION" type="CustomLocation" \
    --location "$LOCATION" \
    --admin-username "$ADMIN_USERNAME" \
    --csn "attached-network-id=$CSN_ARM_ID" \
    --cpu-cores $CPU_CORES \
    --memory-size $MEMORY_SIZE \
    --network-attachments '[{"attachedNetworkId":"'$L3_NETWORK_ID'","ipAllocationMethod":"Dynamic","defaultGateway":"True","networkAttachmentName":"'$NETWORK_INTERFACE_NAME'"}]'\
    --storage-profile create-option="Ephemeral" delete-option="Delete" disk-size="$VM_DISK_SIZE" \
    --vm-image "$VM_IMAGE" \
    --ssh-key-values "$SSH_PUBLIC_KEY" \
    --vm-image-repository-credentials registry-url="$ACR_URL" username="$ACR_USERNAME" password="$ACR_PASSWORD" \
    --mi-system-assigned
```

To use a user-assigned managed identity, you can specify the user-assigned managed identity ID with the `--mi-user-assigned` flag (or the alias `--user-assigned`).

Be sure to include the `UAMI_ID` variable with the resource ID of the user-assigned managed identity that you want to use.

```azurecli
export UAMI_ID=$(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "id" -o tsv)
```

Create the virtual machine using a User-Assigned Managed Identity (UAMI) with Azure CLI:

```azurecli-interactive
az networkcloud virtualmachine create \
    --name "$VM_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --subscription "$SUBSCRIPTION" \
    --extended-location name="$CUSTOM_LOCATION" type="CustomLocation" \
    --location "$LOCATION" \
    --admin-username "$ADMIN_USERNAME" \
    --csn "attached-network-id=$CSN_ARM_ID" \
    --cpu-cores $CPU_CORES \
    --memory-size $MEMORY_SIZE \
    --network-attachments '[{"attachedNetworkId":"'$L3_NETWORK_ID'","ipAllocationMethod":"Dynamic","defaultGateway":"True","networkAttachmentName":"'$NETWORK_INTERFACE_NAME'"}]'\
    --storage-profile create-option="Ephemeral" delete-option="Delete" disk-size="$VM_DISK_SIZE" \
    --vm-image "$VM_IMAGE" \
    --ssh-key-values "$SSH_PUBLIC_KEY" \
    --vm-image-repository-credentials registry-url="$ACR_URL" username="$ACR_USERNAME" password="$ACR_PASSWORD" \
    --mi-user-assigned "$UAMI_ID"
```

After a few minutes, the command completes and returns information about the virtual machine.
The virtual machine is now ready for use.

## Review deployed resources

[!INCLUDE [quickstart-review-deployment-cli](./includes/virtual-machine/quickstart-review-deployment-cli.md)]

## Clean up resources

[!INCLUDE [quickstart-cleanup](./includes/virtual-machine/quickstart-cleanup-cli.md)]

## Next steps

The Nexus virtual machine is successfully created! You can now use the virtual machine to host virtual network functions (VNFs).
