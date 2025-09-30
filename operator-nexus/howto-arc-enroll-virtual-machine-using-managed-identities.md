---
title: How to Azure Arc enroll Azure Operator Nexus virtual machines using managed identities
description: Learn how to Azure Arc enroll Azure Operator Nexus virtual machines using system-assigned and user-assigned managed identities.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: how-to
ms.date: 09/30/2025
ms.author: omarrivera
author: g0r1v3r4
---

# How to Azure Arc enroll Azure Operator Nexus virtual machines using managed identities

This article shows how to enroll Azure Operator Nexus virtual machines (VM) with Azure Arc using managed identities (MI).
Azure Arc enrollment allows you to manage your virtual machines as Azure resources, providing unified management and monitoring capabilities.

> [!IMPORTANT]
> This guide assumes you have a working Nexus Cluster and the necessary permissions to create and manage virtual machines and managed identities in your Azure subscription.

## Before you begin

### Prerequisites on Azure Operator Nexus management bundle, runtime, and API versions

- Ensure that your Nexus Cluster is running Azure Local Nexus `2510.1` Management Bundle and `4.7.0` Minor Runtime or later.
- The feature support is available in API version `2025-07-01-preview` or later.
- Make sure the [`networkcloud` extension] is installed with a version that supports the required API version.
  You can find supported versions in the [`networkcloud` extension release history] on GitHub.

[`networkcloud` extension]: /cli/azure/networkcloud
[`networkcloud` extension release history]: https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst

### Getting started with Azure Operator Nexus virtual machines

[!INCLUDE [virtual-machine-prereq](./includes/virtual-machine/quickstart-prereq.md)]

- Complete the [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md) for deploying a Nexus virtual machine.
- Review how to create virtual machines using one of the following deployment methods:
  - [Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
  - [Azure PowerShell](./quickstarts-virtual-machine-deployment-ps.md)
  - [ARM template](./quickstarts-virtual-machine-deployment-arm.md)
  - [Bicep](./quickstarts-virtual-machine-deployment-bicep.md)
- Ensure you have permissions to create and managed identities in your Azure subscription.
- Ensure you have permissions to enroll virtual machines with Azure Arc.
- Ensure to create the VM with either a system-assigned or user-assigned managed identity.
  You can't update the VM to add a managed identity after creation.

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

This guide assumes that the networking resources are created before creating the virtual machine.

## Choose a managed identity option

You can use either a system-assigned or a user-assigned managed identity to Azure Arc enroll the VM.
Both options are supported in this guide.
Choose the option that best fits your requirements.

In this guide, doesn't cover the details on how to create and manage managed identities and role assignments.
For more information about creating and managing managed identities and role assignments, see the relevant documentation:

- [Manage user-assigned managed identities using the Azure portal](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities)
- [Configure managed identities for Azure resources on a VM](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities?pivots=qs-configure-cli-windows-vm)

### Using a system-assigned managed identity

The system-assigned managed identity is created automatically when the VM is created.
The lifecycle of the system-assigned managed identity is tied to the VM.
This option is simpler to manage as you don't need to create and manage the identity separately.
However, it's necessary to assign roles to the system-assigned managed identity after the VM is created.

If you're Azure Arc enrolling manually, you can assign the roles after the VM is created and booted.
Then you can use the Azure CLI within the VM to authenticate and enroll the VM with Azure Arc.

If you automate Azure Arc enrollment using a cloud-init user data script, make sure to assign the required roles first.
It's possible to assign the roles using the Azure CLI as part of the cloud-init script.
If the roles aren't assigned, the enrollment fails.

### Using a user-assigned managed identity

If you plan to use a user-assigned managed identity, create it before creating the virtual machine.
Since the user-assigned managed identity is independent of the VM, you can reuse it across multiple VMs.
Also, you can assign the necessary roles to the user-assigned managed identity ahead of time.

Assigning the roles ahead of time simplifies the enrollment process as the VM can use the identity directly without needing to assign roles during the user data cloud-init script execution.

### Assign roles to the managed identity

You must also assign the necessary roles to the managed identity to allow it to enroll the VM with Azure Arc.
Both the system-assigned and user-assigned managed identities require the same roles.
Role assignments can be done at the subscription, resource group, or resource level depending on your requirements.

The required roles to allow the managed identity to Azure Arc enroll the VM are:

- `HybridCompute Machine ListAccessDetails Action`
- `Azure Connected Machine Resource Manager`

For more information about role assignments, see:

- [Assign Azure roles using Azure CLI](/azure/role-based-access-control/role-assignments-cli)
- [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal)
- [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity)

## Use cloud-init user data script or manual execution for Azure Arc enrollment

It's possible to pass in a cloud-init script to the VM during creation using the `--user-data-content` parameter (or the alias `--udc`).
The cloud-init script must be base64 encoded before passing it to the `--user-data-content` parameter.

> [!NOTE]
> The `--user-data` parameter is deprecated and will be removed in a future release.
> Verify in the [`networkcloud` extension release history] for the latest updates.

> [!NOTE]
> The cloud-init script runs only during the first boot of the VM.
> You can also authenticate with managed identities manually from inside the VM after creation and boot.

> [!IMPORTANT]
> Create the VM with either a system-assigned or user-assigned managed identity.
> It isn't possible to add a managed identity to the VM after creation.

The cloud-init script runs during the VM's first boot and can be used to:

- [Install Azure CLI](https://aka.ms/azcli) (or ensure that the Azure CLI is already installed)
- Authenticate using the managed identity with the `az login --identity` command,
  explained in [Authentication using Azure CLI and managed identities](#authentication-using-azure-cli-and-managed-identities)
- [Install the `azcmagent` package](https://aka.ms/azcmagent) and enroll the VM with Azure Arc

The cloud-init script must handle the required scenario for your VM:

- If you're using a System-Assigned Managed Identity (SAMI), you don't need to pass any other parameters to the cloud-init script.
- If you're using a User-Assigned Managed Identity (UAMI), you need to pass the resource ID of the UAMI to the cloud-init script.
  (You can also pass the client ID if you prefer to use that instead.)

> [!TIP]
> After the VM is created and boots, you can check the cloud-init logs to verify that the Arc enrollment process completed successfully.
> If you need to troubleshoot the enrollment process, you can check the cloud-init logs file `/var/log/cloud-init-output.log` for any errors or issues.

Ensure you complete the necessary setup for your chosen managed identity option before creating the VM.

## Required proxy and network settings to enable outbound connectivity

The VM must have outbound connectivity to Azure Resource Manager endpoints to complete the Azure Arc enrollment process.
If your environment requires using a proxy server for outbound connectivity, you must configure the proxy settings in the cloud-init script or manually within the VM.

The `TENANT_PROXY_IP` and `TENANT_PROXY_PORT` environment variables must be set with the appropriate values from the tenant proxy configuration.
The tenant proxy is configured in the Network Fabric Controller (NFC) and is used by the VM for egress traffic.

```bash
export HTTPS_PROXY=http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
export https_proxy=http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
export HTTPS_PROXY=http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
export https_proxy=http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
```

Similarly, you must also configure the `NO_PROXY` environment variable to exclude the IP address `169.254.169.254`.
The Instance Metadata Service (IMDS) endpoint `169.254.169.254` is used by the VM to communicate with the platform's token service for managed identity token retrieval.

```bash
export NO_PROXY=169.254.169.254
export no_proxy=169.254.169.254
```

The Cloud Services Network (CSN) should already have the necessary egress routes to allow the VM to reach required Azure endpoints.
However, if you're encountering connectivity issues, ensure that the CSN has the necessary routes to allow outbound connectivity.

| Endpoint                         | Reason                                                          |
|----------------------------------|-----------------------------------------------------------------|
| management.azure.com             | Required for `az login` and Azure Resource Manager API access   |
| login.microsoftonline.com        | Required for authentication during `az login`                   |
| his.arc.azure.com                | Required for Azure Arc enrollment via `azcmagent connect`       |

## Authentication using Azure CLI and managed identities

No matter the preferred approach of using a cloud-init script or manual execution, the authentication process using managed identities is similar.
The main difference is that when using a user-assigned managed identity, it's necessary to specify the resource ID of the identity.

### Sign in with a System-Assigned Managed Identity

```azurecli-interactive
az login --identity --allow-no-subscriptions
```

### Sign in with a User-Assigned Managed Identity

Ensure to export the necessary environment variables for the cloud-init script

```azurecli-interactive
export UAMI_ID=$(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "id" -o tsv)
```

For Azure CLI `2.71.0` and earlier, use the `--username` flag:

```azurecli-interactive
az login --identity --username "${UAMI_ID}" --allow-no-subscriptions
```

Otherwise, for Azure CLI `2.72.0` and later, use the `--msi-resource-id` flag:

```azurecli-interactive
az login --identity --msi-resource-id "${UAMI_ID}" --allow-no-subscriptions
```

### Retrieve access token after authentication

```azurecli-interactive
ACCESS_TOKEN=$(az account get-access-token --resource https://management.azure.com/ --query accessToken -o tsv)
```

### Alternative access token retrieval methods

If you prefer not to use the Azure CLI for authentication, you can retrieve an access token directly using `az rest` or `curl`.
This approach can be useful in environments where the Azure CLI isn't available or if you encounter issues with the CLI.
The `az login` command is the preferred and recommended method for authentication.

- [Alternative approach using `az rest` or `curl`](#alternative-approach-using-az-rest-or-curl)

## Enroll the VM using managed identities

Once you authenticate using the managed identity and retrieve the access token, you proceed to enroll the VM with Azure Arc using the `azcmagent connect` command.
The `azcmagent connect` command requires the access token to authenticate and authorize the enrollment process.

Ensure to install the `azcmagent` CLI tool within the VM.
This step can be done as part of the cloud-init script or manually after the VM is created and boots.

- [Install the `azcmagent` CLI tool](/azure/azure-arc/servers/azcmagent)

For more information about the `azcmagent connect` command and access tokens, see:

- [Azure Connected Machine agent connect reference]: /azure/azure-arc/servers/azcmagent-connect#access-token
- [How to use managed identities to get an access token]: /entra/identity/managed-identities-azure-resources/how-to-use-vm-token#get-a-token-using-go

The overall process involves the following steps:

1. **Install Azure CLI** - Downloads and installs the latest Azure CLI
2. **Configure proxy settings** - Sets the necessary proxy environment variables if necessary
3. **Authenticate with managed identity** - Uses either system-assigned or user-assigned managed identity to sign in to Azure
4. **Retrieve access token** - Gets an access token for Azure Resource Manager API
5. **Install the `azcmagent` CLI tool** - Downloads and installs the Azure Connected Machine agent
6. **Connect to Arc** - Uses the access token to register the VM with Azure Arc via the `azcmagent connect` command

### Azure Arc enrollment commands

```bash
azcmagent config set proxy.url "http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>"
```

Output from setting the proxy configuration successfully:

```
Config property proxy.url set to value http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
INFO    Updating service configuration: Azure Arc Proxy
```

Verify the proxy settings are correctly applied:

```bash
azcmagent config list
```

Output should show the proxy settings:

```
Local Configuration Settings
  incomingconnections.enabled (preview)                 : true
  incomingconnections.ports (preview)                   : []
  connection.type (preview)                             : default
  proxy.url                                             : http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
  proxy.bypass                                          : []
  extensions.allowlist                                  : []
  extensions.blocklist                                  : []
  guestconfiguration.enabled                            : true
  extensions.enabled                                    : true
  config.mode                                           : full
  guestconfiguration.agent.cpulimit                     : 5
  extensions.agent.cpulimit                             : 5
```

Execute the command to enroll the VM using the access token retrieved from the managed identity.
The `ACCESS_TOKEN` variable represents the output of the `az account get-access-token` command from section [Retrieve access token after authentication](#retrieve-access-token-after-authentication).

> [!TIP]
> If the managed identity roles or permissions are changed, the token must be refreshed to reflect the changes.

To see detailed output, add the `--verbose` flag.

```bash
azcmagent connect \
  --resource-group "${RESOURCE_GROUP}" \
  --tenant-id "${TENANT_ID}" \
  --location "${LOCATION}" \
  --subscription-id "${SUBSCRIPTION_ID}" \
  --access-token "${ACCESS_TOKEN}"
```

After the command completes, the VM should be successfully enrolled with Azure Arc.

### Verify Azure Arc enrollment

After the VM is created and boots, verify that Azure Arc enrollment was successful.
You can check through Azure portal that the VM has an Azure Arc machine resource created.

Install the [`connectedmachine` CLI extension](/cli/azure/connectedmachine?view=azure-cli-latest) to run the command.

```azurecli-interactive
az connectedmachine list --resource-group "$RESOURCE_GROUP" \
  --query "[].{Name:name,Location:location,Status:status,LastChange:lastStatusChange}" -o table
```

### Check VM health status

Check VM detailed status to make sure the VM is successfully provisioned.

```azurecli-interactive
az networkcloud virtualmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP" --query "detailedStatus"
```

### Check Azure Arc-enabled VM

List Azure Arc-enabled VM in the resource group.

```azurecli-interactive
az connectedmachine list --resource-group "$RESOURCE_GROUP" --query "[].{Name:name,Status:status,LastStatusChange:lastStatusChange}"
```

Get detailed information about a specific Azure Arc enabled VM.

```azurecli-interactive
az connectedmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP"
```

## Next steps

It might be useful to review the [troubleshooting guide](./troubleshoot-virtual-machine-arc-enrollment-managed-identity.md) for common issues and pitfalls.

## Related articles

- [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md)
- [Create a virtual machine using Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
- [Create a virtual machine using PowerShell](./quickstarts-virtual-machine-deployment-ps.md)
- [Troubleshoot VM Arc enrollment issues](./troubleshoot-virtual-machine-arc-enrollment-managed-identity.md)
- [Connect hybrid machines to Azure using a deployment script](/azure/azure-arc/servers/onboard-portal#install-and-validate-the-agent-on-linux)
- [Quickstart: Connect a Linux machine with Azure Arc-enabled servers (package-based installation)](/azure/azure-arc/servers/quick-onboard-linux)
- [Quickstart: Connect a machine to Arc-enabled servers (Windows or Linux install script)](/azure/azure-arc/servers/quick-enable-hybrid-vm)