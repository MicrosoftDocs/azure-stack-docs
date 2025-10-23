---
title: How to create virtual machines with managed identities and authenticate with a managed identity
description: Learn how to use system-assigned and user-assigned managed identities associated with Azure Operator Nexus virtual machines.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: how-to
ms.date: 10/23/2025
ms.author: omarrivera
author: g0r1v3r4
---

# How to create virtual machines with managed identities and authenticate with a managed identity

This guide explains how to create Azure Operator Nexus virtual machines (VM) with managed identities and how to authenticate using those identities.
The authentication using managed identities enables the ability to obtain Azure AD tokens without the need to manage credentials explicitly.

## Before you begin

[!INCLUDE [virtual-machine-managed-identity-version-prereq](./includes/virtual-machine/howto-virtual-machines-managed-identities-version-prerequisites.md)]

[!INCLUDE [virtual-machine-managed-identity-options-explained](./includes/virtual-machine/howto-virtual-machines-managed-identity-options-explained.md)]

## Create a VM with the managed identity

[!INCLUDE [virtual-machine-prereq](./includes/virtual-machine/quickstart-prereq.md)]

- Ensure you have permissions to create managed identities and manage the role assignments in your Azure subscription.
- Ensure to create the VM with either a system-assigned or user-assigned managed identity.

Complete the [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md) for deploying a Nexus virtual machine.

  - Before creating the virtual machine, you need to create the required networking resources.
    - **L3 isolation domain** - For network isolation and routing
    - **L3 network** - For VM connectivity
    - **Cloud Services Network (CSN)** - For external connectivity and proxy services

Review how to create virtual machines using one of the following deployment methods:

  - [Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
  - [Azure PowerShell](./quickstarts-virtual-machine-deployment-ps.md)
  - [ARM template](./quickstarts-virtual-machine-deployment-arm.md)
  - [Bicep](./quickstarts-virtual-machine-deployment-bicep.md)

### Associate managed identities at VM creation time

When creating an Operator Nexus VM with managed identities, you must assign either a system-assigned or user-assigned managed identity during VM creation.
Creating the VM with an associated managed identity enables the capabilities for the authentication method.
Although the VM resource can be updated to add or change the managed identity after creation, the VM must be recreated to enable managed identity support.
If you plan to use other authentication methods, such as using a service principal, you can create the VM without a managed identity.

> [!IMPORTANT]
> If you don't specify a managed identity when creating the VM, you can't enable managed identity support by updating the VM after provisioning.

### Environment variables

Before proceeding with the deployment, set the following environment variables to define the configuration for your virtual machine:

| Variable                  | Description                                                                                                                 |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| `ACR_PASSWORD`            | Azure Container Registry password.                                                                                          |
| `ACR_URL`                 | Azure Container Registry URL.                                                                                               |
| `ACR_USERNAME`            | Azure Container Registry username.                                                                                          |
| `ADMIN_USERNAME`          | Administrator username for the VM.                                                                                          |
| `CLUSTER_CUSTOM_LOCATION` | Custom location of the Nexus instance.                                                                                      |
| `CLUSTER_NAME`            | The name of your Nexus cluster.                                                                                             |
| `CPU_CORES`               | (Optional) Number of CPU cores for the VM.                                                                                  |
| `CSN_ARM_ID`              | ARM resource ID of the cloud services network.                                                                              |
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

## Automate using cloud-init user data script

It's possible to pass in a cloud-init script to the VM during creation using the `--user-data-content` parameter (or the alias `--udc`).
The cloud-init script must be base64 encoded before passing it to the `--user-data-content "$ENCODED_USER_DATA"` parameter of the `az networkcloud virtualmachine create` command.
The cloud-init script runs during the VM's first boot and can be used to perform various setup tasks.

Ensure you complete the necessary setup for your chosen managed identity option before creating the VM such as assigning roles or permissions.
After the VM is created and boots, you can check the cloud-init logs to verify that the script completed successfully.
The cloud-init logs file is found at `/var/log/cloud-init-output.log`.
It's necessary to SSH into the VM to access the logs.

> [!NOTE]
> The previous `--user-data` parameter is deprecated and will be removed in a future release.
> Verify in the [`networkcloud` extension release history] for the latest updates.

> [!TIP]
> The cloud-init script runs only during the first boot of the VM.
> You can also authenticate with managed identities manually from inside the VM after creation and boot.

## Required proxy settings to enable outbound connectivity

The VM must have outbound connectivity to Azure Resource Manager endpoints to complete the Azure Arc enrollment process.
You must configure the proxy settings in the cloud-init script or manually within the VM.
The CSN proxy is used by the VM for outbound traffic, which should always be `http://169.254.0.11:3128`.

```bash
export HTTPS_PROXY=http://169.254.0.11:3128
export https_proxy=http://169.254.0.11:3128
export HTTP_PROXY=http://169.254.0.11:3128
export http_proxy=http://169.254.0.11:3128
```

Similarly, you must also configure the `NO_PROXY` environment variable to exclude the IP address `169.254.169.254`.
The Instance Metadata Service (IMDS) endpoint `169.254.169.254` is used by the VM to communicate with the platform's token service for managed identity token retrieval.
The `NO_PROXY` variable can have multiple comma-separated values, but at a minimum, it must include the IMDS IP address.
Add other addresses that you don't want to be proxied through the CSN proxy to the `NO_PROXY` variable as needed for your environment.

```bash
export NO_PROXY=localhost,127.0.0.1,::1,169.254.169.254
export no_proxy=localhost,127.0.0.1,::1,169.254.169.254
```

## Authentication using Azure CLI and managed identities

No matter the preferred approach of using a cloud-init script or manual execution, the authentication process using managed identities is similar.
The main difference is that when using a user-assigned managed identity, it's necessary to specify the resource ID of the identity.

### Authenticate with a System-Assigned Managed Identity

```azurecli-interactive
az login --identity --allow-no-subscriptions
```

### Authenticate with a User-Assigned Managed Identity

```azurecli-interactive
export UAMI_ID=$(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "id" -o tsv)
```

```azurecli-interactive
az login --identity --allow-no-subscriptions --msi-resource-id "${UAMI_ID}"
```

### Get an access token using the managed identity

After successfully authenticating using the managed identity, you can retrieve an access token for a specific Azure resource.
This token can be used to access Azure services securely.

```azurecli-interactive
TOKEN=$(az account get-access-token --resource https://management.azure.com/ --query accessToken -o tsv)
```

## Related articles

It might be useful to review the [troubleshooting guide](./troubleshoot-virtual-machine-arc-enroll-with-managed-identity.md) for common issues and pitfalls.

[!INCLUDE [contact-support](./includes/contact-support.md)]