---
title: How to enroll Azure Operator Nexus virtual machines with Azure Arc using managed identities
description: Learn how to enroll Azure Operator Nexus virtual machines with Azure Arc using system-assigned and user-assigned managed identities.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: how-to
ms.date: 09/08/2025
ms.author: omarrivera
author: g0r1v3r4
---

# How to enroll Azure Operator Nexus virtual machines with Azure Arc using managed identities

This article shows how to enroll Azure Operator Nexus virtual machines with Azure Arc using managed identities.
Azure Arc enrollment allows you to manage your virtual machines as Azure resources, providing unified management and monitoring capabilities.

> [!IMPORTANT]
> This guide assumes you have a working Nexus cluster and the necessary permissions to create and manage virtual machines and managed identities in your Azure subscription.

> [!NOTE]
> Ensure that your Nexus cluster is running Azure Local Nexus 2510.1 Management Bundle and 4.7.0 Minor Runtime or later.
> The supported API version for this feature is `2025-07-01-preview` or later.

## Before you begin

[!INCLUDE [virtual-machine-prereq](./includes/virtual-machine/quickstart-prereq.md)]

- Complete the [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md) for deploying a Nexus virtual machine.
- Review how to create virtual machines using one of the following deployment methods:
  - [Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
  - [Azure PowerShell](./quickstarts-virtual-machine-deployment-ps.md)
  - [ARM template](./quickstarts-virtual-machine-deployment-arm.md)
  - [Bicep](./quickstarts-virtual-machine-deployment-bicep.md)
- Ensure you have permissions to create and manage managed identities in your Azure subscription.
- Ensure you have permissions to enroll virtual machines with Azure Arc.

## Environment variables

Before proceeding with the deployment, set the following environment variables to define the configuration for your virtual machine and Arc enrollment:

| Variable                 | Description                                                                                  |
|--------------------------|----------------------------------------------------------------------------------------------|
| `ADMIN_USERNAME`         | Administrator username for the VM                                                            |
| `CLUSTER_CUSTOM_LOCATION`| Custom location of the Nexus instance                                                        |
| `CLUSTER_NAME`           | The name of your Nexus cluster                                                               |
| `CPU_CORES`              | Number of CPU cores for the VM                                                               |
| `CSN_ARM_ID`             | ARM resource ID of the cloud services network                                                |
| `VM_DISK_SIZE`           | OS disk size in GiB                                                                          |
| `L3_NETWORK_ARM_ID`      | ARM resource ID of the L3 network to create                                                  |
| `LOCATION`               | Azure region for the resources                                                               |
| `MEMORY_SIZE`            | Memory size in GiB for the VM                                                                |
| `RESOURCE_GROUP`         | The name of the Azure resource group                                                         |
| `SSH_PUBLIC_KEY`         | SSH public key for VM access                                                                 |
| `SUBSCRIPTION_ID`        | Your Azure subscription ID                                                                   |
| `TENANT_ID`              | Your Azure tenant ID                                                                         |
| `UAMI_NAME`              | Name of the user-assigned managed identity                                                   |
| `VM_IMAGE`               | Container image for the VM                                                                   |
| `VM_NAME`                | Name of the virtual machine                                                                  |
| `NETWORK_INTERFACE_NAME` | Name of the network interface                                                                |
| `ACR_URL`                | Azure Container Registry URL                                                                 |
| `ACR_USERNAME`           | Azure Container Registry username                                                            |
| `ACR_PASSWORD`           | Azure Container Registry password                                                            |
| `UAMI_ID`                | The user-assigned managed identity (UAMI) ID to be used for the virtual machine              |
| `UAMI_CLIENT_ID`         | The client ID of the user-assigned managed identity (UAMI) to be used for the virtual machine|

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

# Virtual Machine Image parameters
VM_IMAGE="<VM image, example: myacr.azurecr.io/ubuntu:20.04>"
ACR_URL="<Azure Container Registry URL, example: myacr.azurecr.io>"
ACR_USERNAME="<Azure Container Registry username>"
ACR_PASSWORD="<Azure Container Registry password>"

# Optional variables (will use defaults if not set), values here are examples you can modify as needed
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

## Create prerequisite networking resources

Before creating the virtual machine, you need to create the required networking resources.
Follow the **[Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md)** guide to set up:

1. **L3 isolation domain** - For network isolation and routing
2. **L3 network** - For VM connectivity
3. **Cloud services network** - For external connectivity and proxy services

This guide assumes that the networking resource must be created before creating the virtual machine.

## Create user-assigned managed identity

If you plan to use a user-assigned managed identity, create it before creating the virtual machine:

```bash
az identity create \
    --name "$UAMI_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION"
```

You must also assign the necessary roles to the managed identity to allow it to enroll the VM with Azure Arc.

Assign the roles `HybridCompute Machine ListAccessDetails Action` and `Azure Connected Machine Resource Manager` to the managed identity.
Role assignments can be done at the subscription, resource group, or resource level depending on your requirements.
The details on how to assign roles can be found in the [Assign Azure roles using the Azure portal](role-assignments-portal) documentation.

Get the identity resource ID for later use.
Example ARM resource ID: `/subscriptions/<subscription_id>/resourceGroups/<subscription_id>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<uami-name>`

For more information about creating and managing managed identities, see:

- [Create a user-assigned managed identity](s-azure-resources/how-manage-user-assigned-managed-identities)
- [Configure managed identities for Azure resources on a VM](s-azure-resources/qs-configure-cli-windows-vm)

## Prepare cloud-init script for Arc enrollment

Create a cloud-init script that will automatically enroll the VM with Azure Arc using managed identities.
This script handles both system-assigned and user-assigned managed identity scenarios.

> [!IMPORTANT]
> The `azcmagent` package installation must happen **after** the access token is retrieved.
> If the `azcmagent` installation happens before the access token is retrieved, the enrollment process will fail.
> An alternative approach will be necesssary to obtain the access token using `az rest`.

Create a file named `arc-enrollment-cloud-init.yaml`:

```yaml
#cloud-config
users:
  - name: ${ADMIN_USERNAME}
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    ssh-authorized-keys:
      - ${SSH_PUBLIC_KEY}

package_update: true
packages:
  - curl
  - apt-transport-https
  - ca-certificates
  - lsb-release
  - gnupg

runcmd:
  - |
    set -ex
    TMP_DIR=$(mktemp -d)

    # Install Azure CLI if not present
    if ! command -v az &> /dev/null; then
      curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    fi

    # Login with managed identity and get access token
    if [ -z "${UAMI_CLIENT_ID:-}" ]; then
      echo "Using system-assigned managed identity for Arc enrollment"
      if ! az login --identity --allow-no-subscriptions; then
        echo "ERROR: Failed to login with system-assigned managed identity"
        exit 1
      fi
    else
      echo "Using user-assigned managed identity: ${UAMI_CLIENT_ID}"
      if ! az login --identity -u "${UAMI_CLIENT_ID}" --allow-no-subscriptions; then
        echo "ERROR: Failed to login with user-assigned managed identity"
        exit 1
      fi
    fi

    # Get access token from IMDS endpoint
    if ! ACCESS_TOKEN=$(az account get-access-token --resource https://management.azure.com/ --query accessToken -o tsv); then
      echo "ERROR: Failed to retrieve access token"
      exit 1
    fi

    # Install Azure Connected Machine agent (azcmagent)
    # It is important that the azcmagent install happens after the access token is retrieved
    if ! command -v azcmagent &> /dev/null; then
      echo "Installing Azure Connected Machine agent..."
      wget https://aka.ms/azcmagent -O "$TMP_DIR/install_linux_azcmagent.sh"
      bash "$TMP_DIR/install_linux_azcmagent.sh"
      azcmagent version
    fi

    # Connect to Azure Arc
    echo "Connecting virtual machine to Azure Arc..."
    if ! sudo azcmagent connect \
        --resource-group "${RESOURCE_GROUP}" \
        --tenant-id "${TENANT_ID}" \
        --location "${LOCATION}" \
        --subscription-id "${SUBSCRIPTION_ID}" \
        --access-token "$ACCESS_TOKEN" \
        --verbose; then
      echo "ERROR: Failed to connect to Azure Arc"
      exit 1
    fi

    echo "SUCCESS: Virtual machine successfully enrolled with Azure Arc"

    # Cleanup
    rm -rf "$TMP_DIR"
    unset ACCESS_TOKEN  # Clear sensitive data
```

## Create virtual machine with system-assigned managed identity

To create a virtual machine with a system-assigned managed identity:

```bash
# Ensure to export the necessary environment variables for the cloud-init script
UAMI_ID=$(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "id" -o tsv)
UAMI_CLIENT_ID=$(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "clientId" -o tsv)

# Substitute variables in cloud-init script
envsubst < arc-enrollment-cloud-init.yaml > cloud-init-substituted.yaml

# Base64 encode the cloud-init script
ENCODED_USER_DATA=$(base64 -w 0 < cloud-init-substituted.yaml)

# Get network resource IDs
CSN_ARM_ID=$(az networkcloud cloudservicesnetwork show --name "$CSN_NAME" --resource-group "$RESOURCE_GROUP" --query "id" -o tsv)
L3_NETWORK_ARM_ID=$(az networkcloud l3network show --name "$L3NETWORK_NAME" --resource-group "$RESOURCE_GROUP" --query "id" -o tsv)
```

Create VM with system-assigned managed identity:

```azurecli-interactive
az networkcloud virtualmachine create \
    --name "${VM_NAME}-sami" \
    --resource-group "$RESOURCE_GROUP" \
    --subscription "$SUBSCRIPTION_ID" \
    --extended-location name="$CLUSTER_CUSTOM_LOCATION" type="CustomLocation" \
    --location "$LOCATION" \
    --admin-username "$ADMIN_USERNAME" \
    --csn attached-network-id="$CSN_ARM_ID" \
    --cpu-cores "$CPU_CORES" \
    --memory-size "$MEMORY_SIZE" \
    --storage-profile create-option="Ephemeral" delete-option="Delete" disk-size="$DISK_SIZE" \
    --vm-image "$VM_IMAGE" \
    --user-data "$ENCODED_USER_DATA" \
    --mi-system-assigned --system-assigned \
    --network-attachments "[{\"attachedNetworkId\":\"${L3_NETWORK_ARM_ID}\",\"defaultGateway\":\"True\",\"ipAllocationMethod\":\"Dynamic\",\"networkAttachmentName\":\"${L3NETWORK_NAME}\"}]"
```

## Create virtual machine with user-assigned managed identity

To create a virtual machine with a user-assigned managed identity:

```bash
# Ensure to export the necessary environment variables for the cloud-init script
UAMI_ID=$(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "id" -o tsv)
UAMI_CLIENT_ID=$(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "clientId" -o tsv)

# Substitute variables in cloud-init script including UAMI_CLIENT_ID
envsubst < arc-enrollment-cloud-init.yaml > cloud-init-substituted.yaml

# Base64 encode the cloud-init script
ENCODED_USER_DATA=$(base64 -w 0 < cloud-init-substituted.yaml)
```

```azurecli-interactive
# Create VM with user-assigned managed identity
az networkcloud virtualmachine create \
    --name "${VM_NAME}-uami" \
    --resource-group "$RESOURCE_GROUP" \
    --subscription "$SUBSCRIPTION_ID" \
    --extended-location name="$CLUSTER_CUSTOM_LOCATION" type="CustomLocation" \
    --location "$LOCATION" \
    --admin-username "$ADMIN_USERNAME" \
    --csn attached-network-id="$CSN_ARM_ID" \
    --cpu-cores "$CPU_CORES" \
    --memory-size "$MEMORY_SIZE" \
    --storage-profile create-option="Ephemeral" delete-option="Delete" disk-size="$DISK_SIZE" \
    --vm-image "$VM_IMAGE" \
    --user-data "$ENCODED_USER_DATA" \
    --mi-user-assigned --user-assigned "$UAMI_ID" \
    --network-attachments "[{\"attachedNetworkId\":\"${L3_NETWORK_ARM_ID}\",\"defaultGateway\":\"True\",\"ipAllocationMethod\":\"Dynamic\",\"networkAttachmentName\":\"${L3NETWORK_NAME}\"}]"
```

## Understanding the Arc enrollment process

The sample cloud-init script performs the following steps during VM boot up:

1. **Install Azure CLI** - Downloads and installs the latest Azure CLI
2. **Authenticate with managed identity** - Uses either system-assigned or user-assigned managed identity to login
3. **Retrieve access token** - Gets an access token for Azure Resource Manager API
4. **Install the `azcmagent` CLI tool** - Downloads and installs the Azure Connected Machine agent
5. **Connect to Arc** - Uses the access token to register the VM with Azure Arc

For more information about the `azcmagent connect` command and access tokens, see [Azure Connected Machine agent connect reference].

For details about token retrieval with managed identities, see [How to use managed identities to get an access token].

[Azure Connected Machine agent connect reference]: t-connect#access-token
[How to use managed identities to get an access token]: s-azure-resources/how-to-use-vm-token#get-a-token-using-go

## Verify Arc enrollment

After the VM is created and boots, verify that Arc enrollment was successful:

### Check VM status

```azurecli-interactive
# Check VM detailed status
az networkcloud virtualmachine show \
    --name "$VM_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "detailedStatus"
```

### Check Arc-enabled server

```azurecli-interactive
# List Arc-enabled servers in the resource group
az connectedmachine list \
    --resource-group "$RESOURCE_GROUP" \
    --query "[].{Name:name,Status:status,LastStatusChange:lastStatusChange}"
```

```azurecli-interactive
# Get detailed information about a specific Arc-enabled server
az connectedmachine show \
    --name "$VM_NAME" \
    --resource-group "$RESOURCE_GROUP"
```

### Check the VM cloud-init logs

After the VM is created and boots, you can check the cloud-init logs to verify that the Arc enrollment process completed successfully.

To access the VM through console, you will need to follow the steps in [Azure Operator Nexus: VM Console Service](howto-use-vm-console-service.md).

If you need to troubleshoot the enrollment process, you can check the cloud-init logs:

```bash
# SSH to the VM and check cloud-init logs
sudo tail -f /var/log/cloud-init-output.log

# Check for any errors
sudo grep -i error /var/log/cloud-init-output.log
```

## Next steps

- Learn about [managing Arc-enabled servers]()
- Explore [Azure Arc security and monitoring capabilities](-overview)
- Review [troubleshooting guidance](./troubleshoot-virtual-machine-arc-enrollment-managed-identity.md) for common issues

## Related articles

- [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md)
- [Create a virtual machine using Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
- [Create a virtual machine using PowerShell](./quickstarts-virtual-machine-deployment-ps.md)
- [Troubleshoot VM Arc enrollment issues](./troubleshoot-virtual-machine-arc-enrollment-managed-identity.md)