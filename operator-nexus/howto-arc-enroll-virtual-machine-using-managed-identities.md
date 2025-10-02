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
Once enrolled, you can manage the VM as an Azure resource using Azure Arc capabilities and use extensions to enhance its functionality.
Azure Arc enrollment allows you to manage your virtual machines as Azure resources, providing unified management and monitoring capabilities.

The guide covers each individual step required to complete the process, including prerequisites, environment setup, and the actual enrollment process.
You may be able to automate the entire process using a cloud-init user data script passed during VM creation or execute after the VM is created and boots.
We leave this choice to you based on your requirements and preferences.

The overall process involves the following steps:

1. **Create Nexus VM** - Create a Nexus VM with an associated managed identity
1. **Assign roles to the managed identity** - Assign the necessary roles to the managed identity to allow Azure Arc enrollment
1. **Install Azure CLI** - Downloads and installs the latest Azure CLI
1. **Configure proxy settings** - Sets the necessary proxy environment variables if necessary
1. **Authenticate with managed identity** - Uses either system-assigned or user-assigned managed identity to sign in to Azure
1. **Create Arc machine resource** - Creates the Azure Arc machine resource in the specified resource group
1. **Assign VM traffic to Private Relay** - Assigns the VM's traffic to use Private Relay for secure outbound connectivity
1. **Retrieve access token** - Gets an access token for Azure Resource Manager API
1. **Install the `azcmagent` CLI tool** - Downloads and installs the Azure Connected machine agent
1. **Connect to Arc** - Uses the access token to register the VM with Azure Arc via the `azcmagent connect` command

The end result is a Nexus VM that is successfully enrolled with Azure Arc using managed identities for authentication.
Its traffic is routed through Private Relay for secure outbound connectivity.
And you can manage the VM as an Azure resource using Azure Arc capabilities.

## Before you begin

### Prerequisites on Azure Operator Nexus management bundle, runtime, and API versions

- Ensure that your Nexus Cluster is running Azure Local Nexus `2510.1` Management Bundle and `4.7.0` Minor Runtime or later.
- The feature support is available in API version `2025-07-01-preview` or later.
- Make sure the [`networkcloud` extension] is installed with a version that supports the required API version.
  You can find supported versions in the [`networkcloud` extension release history] on GitHub.

> [!IMPORTANT]
> This guide assumes you have a working Nexus Cluster and the necessary permissions to create and manage virtual machines and managed identities in your Azure subscription.

[`networkcloud` extension]: /cli/azure/networkcloud
[`networkcloud` extension release history]: https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst

### Nexus VM with associated managed identities at creation time

When creating a Nexus VM for Azure Arc enrollment with managed identities, you must assign either a system-assigned or user-assigned managed identity during VM creation.
This enables managed identity authentication for the VM.
If you omit a managed identity at creation, you cannot add one later—managed identity support cannot be enabled by updating the VM after it is provisioned.
To use managed identities, always specify them when you create the VM.

> [!NOTE]
> The managed identity requirement applies to Azure Arc enrollment using the Managed Identity authentication method through the Private Relay feature.
> If you plan to use other authentication methods, such as using a service principal, you can create the VM without a managed identity.

### Choose a managed identity option

You can use either a system-assigned or a user-assigned managed identity to Azure Arc enroll the VM.
Choose the option that best fits your requirements.

For more information about creating and managing managed identities and role assignments, see the relevant documentation:

- [Manage user-assigned managed identities using the Azure portal](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities)
- [Configure managed identities for Azure resources on a VM](/entra/identity/managed-identities-azure-resources/how-to-configure-managed-identities)

#### Using a system-assigned managed identity

The system-assigned managed identity is created automatically when the VM is created.
The lifecycle of the system-assigned managed identity is tied to the VM.
This option is simpler to manage as you don't need to create and manage the identity separately.
However, it's necessary to assign roles to the system-assigned managed identity after the VM is created.

If you're Azure Arc enrolling manually, you can assign the roles after the VM is created and booted.
Then you can use the Azure CLI within the VM to authenticate and enroll the VM with Azure Arc.

If you automate Azure Arc enrollment using a cloud-init user data script, make sure to assign the required roles first.
It's possible to assign the roles using the Azure CLI as part of the cloud-init script.
If the roles aren't assigned, the enrollment fails.

#### Using a user-assigned managed identity

If you plan to use a user-assigned managed identity, create it before creating the virtual machine.
Since the user-assigned managed identity is independent of the VM, you can assign the necessary roles ahead of time.

Assigning the roles ahead of time simplifies the enrollment process as the VM can use the identity directly without needing to assign roles during the user data cloud-init script execution.

#### Assign roles to the managed identity

You must assign the necessary roles to the managed identity to allow it to enroll the VM with Azure Arc.
Both the system-assigned and user-assigned managed identities require the same roles.
Role assignments can be done at the subscription or resource group level depending on your requirements.

The required roles to allow the managed identity to Azure Arc enroll the VM are:

- `HybridCompute Machine ListAccessDetails Action`
- `Azure Connected Machine Resource Manager`

For more information about role assignments, see:

- [Required Permissions for Connected Machines](/azure/azure-arc/servers/prerequisites#required-permissions)
- [Assign Azure roles using Azure CLI](/azure/role-based-access-control/role-assignments-cli)
- [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal)
- [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity)

## Create a Nexus virtual machine with the managed identity

[!INCLUDE [virtual-machine-prereq](./includes/virtual-machine/quickstart-prereq.md)]

- Complete the [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md) for deploying a Nexus virtual machine.
  - Before creating the virtual machine, you need to create the required networking resources.
    - **L3 isolation domain** - For network isolation and routing
    - **L3 network** - For VM connectivity
    - **Cloud Services Network (CSN)** - For external connectivity and proxy services
- Review how to create virtual machines using one of the following deployment methods:
  - [Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
  - [Azure PowerShell](./quickstarts-virtual-machine-deployment-ps.md)
  - [ARM template](./quickstarts-virtual-machine-deployment-arm.md)
  - [Bicep](./quickstarts-virtual-machine-deployment-bicep.md)
- Ensure you have permissions to create and managed identities in your Azure subscription.
- Ensure you have permissions to enroll virtual machines with Azure Arc.
- Ensure to create the VM with either a system-assigned or user-assigned managed identity. You can't update the VM to add a managed identity after creation.

### CSN egress routes and required Azure endpoints

The Cloud Services Network (CSN) should already have the necessary default egress routes to allow the VM to reach required Azure endpoints.
The CSN must be created with the `--enable-default-egress-endpoints "True"` flag to automatically include the necessary endpoints.
If this was skipped during creation, you will need to manually add the required endpoints.

You can use the `networkcloud` extension to verify the setting value:

```azurecli-interactive
az networkcloud cloudservicesnetwork show --name "$CSN_NAME" --resource-group "$RESOURCE_GROUP" --query "enableDefaultEgressEndpoints" -o tsv
```

The easiest way is to see the egress endpoints configured for the CSN is through Azure portal, although you can also use the Azure CLI.
If you're encountering connectivity issues, ensure that the CSN has the necessary routes to allow outbound connectivity.

| Endpoint                         | Reason                                                          |
|----------------------------------|-----------------------------------------------------------------|
| management.azure.com             | Required for `az login` and Azure Resource Manager API access   |
| login.microsoftonline.com        | Required for authentication during `az login`                   |
| his.arc.azure.com                | Required for Azure Arc enrollment via `azcmagent connect`       |

### Environment variables

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

# VM Image parameters
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

## Use cloud-init user data script or manual execution for Azure Arc enrollment

It's possible to pass in a cloud-init script to the VM during creation using the `--user-data-content` parameter (or the alias `--udc`).
The cloud-init script must be base64 encoded before passing it to the `--user-data-content "$ENCODED_USER_DATA"` parameter of the `az networkcloud virtualmachine create` command.

> [!NOTE]
> The `--user-data` parameter is deprecated and will be removed in a future release.
> Verify in the [`networkcloud` extension release history] for the latest updates.

> [!TIP]
> The cloud-init script runs only during the first boot of the VM.
> You can also authenticate with managed identities manually from inside the VM after creation and boot.

The cloud-init script runs during the VM's first boot and can be used to:

- [Install Azure CLI](https://aka.ms/azcli) (or ensure that the Azure CLI is already installed)
- Authenticate using the managed identity with the `az login --identity` command,
  explained in [Authentication using Azure CLI and managed identities](#authentication-using-azure-cli-and-managed-identities)
- [Install the `azcmagent` package](https://aka.ms/azcmagent) and enroll the VM with Azure Arc

The cloud-init script must handle the required scenario for your VM:

- If you're using a System-Assigned Managed Identity (SAMI), you don't need to pass any other parameters to the cloud-init script.
- If you're using a User-Assigned Managed Identity (UAMI), you need to pass the resource ID of the UAMI to the cloud-init script.
  (You can also pass the client ID if you prefer to use that instead.)

After the VM is created and boots, you can check the cloud-init logs to verify that the Arc enrollment process completed successfully.
If you need to troubleshoot the enrollment process, you can check the cloud-init logs file `/var/log/cloud-init-output.log` for any errors or issues.
It is necessary to SSH into the VM to access the logs.

Ensure you complete the necessary setup for your chosen managed identity option before creating the VM.

## Required proxy and network settings to enable outbound connectivity

The VM must have outbound connectivity to Azure Resource Manager endpoints to complete the Azure Arc enrollment process.
If your environment requires using a proxy server for outbound connectivity, you must configure the proxy settings in the cloud-init script or manually within the VM.

The CSN proxy is used by the VM for outbound traffic, which should always be `http://169.254.0.11:3128`.

```bash
export HTTPS_PROXY=http://169.254.0.11:3128
export https_proxy=http://169.254.0.11:3128
export HTTPS_PROXY=http://169.254.0.11:3128
export https_proxy=http://169.254.0.11:3128
```

Similarly, you must also configure the `NO_PROXY` environment variable to exclude the IP address `169.254.169.254`.
The Instance Metadata Service (IMDS) endpoint `169.254.169.254` is used by the VM to communicate with the platform's token service for managed identity token retrieval.
The `NO_PROXY` variable can have multiple comma-separated values, but at a minimum, it must include the IMDS IP address.

```bash
export NO_PROXY=169.254.169.254
export no_proxy=169.254.169.254
```

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

### Alternative access token retrieval methods

If you prefer not to use the Azure CLI for authentication, you can retrieve an access token directly using `az rest` or `curl`.
This approach can be useful in environments where the Azure CLI isn't available or if you encounter issues with the CLI.
The `az login` command is the preferred and recommended method for authentication.
See [Alternative access token retrieval methods](./troubleshoot-virtual-machine-arc-enroll-with-managed-identity.md#alternative-access-token-retrieval-methods) for more information.

## Create the Azure Arc machine resource

In order to enroll the VM with Azure Arc without having the traffic go through the public relay, you must create the Azure Arc machine resource before connecting the Arc machine.

| Variable             | Description                                                                                  |
|----------------------|----------------------------------------------------------------------------------------------|
| ARC_MACHINE_NAME     | The name of the Azure Arc machine resource to be created.                                    |
| ARC_MACHINE_VMID     | The unique identifier (UUID) for the Azure Arc machine resource.                             |
| ARC_MACHINE_ID | The resource ID of the Azure Arc machine to be created.                                      |
| PRIVATE_B64          | The base64-encoded private key used for connecting the VM Arc machine resource.    |
| PUBLIC_B64           | The base64-encoded public key used for connecting the VM with the Arc machine resource.  |

Generate a new key pair to use during the creation of the Arc machine resource.
This key pair is required for secure authentication between your Nexus VM and Azure Arc during the connection phase.
The private key will be needed later when you run the `azcmagent connect existing` command to complete the enrollment.

The key pair is for one-time use only and should be kept secure until the VM is successfully connected to Azure Arc.
Do not share the key pair publicly. Once the Azure Arc machine resource is created and the connection is established, the key pair is no longer required.

```bash
TEMP_DIR=$(mktemp -d)
openssl genrsa 2048 > "$TEMP_DIR/key.pem"

PRIVATE_B64=$(openssl rsa -in "$TEMP_DIR/key.pem" -outform DER | base64 | tr -d '\n')

PUBLIC_B64=$(openssl rsa -in "$TEMP_DIR/key.pem" -RSAPublicKey_out -outform DER | base64 | tr -d '\n')
```

Define the `ARC_MACHINE_ID` variable with the resource ID for the Azure Arc machine resource that you will create in your `SUBSCRIPTION` and `RESOURCE_GROUP`.
Set the `ARC_MACHINE_NAME` variable to match the VM name for easy identification.
You must specify these values manually, as the resource does not exist until you create it.

```bash
ARC_MACHINE_NAME="${VM_NAME}"
ARC_MACHINE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.HybridCompute/machines/${VM_NAME}"
ARC_MACHINE_VMID=$(uuidgen)
API_URL="https://management.azure.com$ARC_MACHINE_ID?api-version=2025-02-19-preview"

REQUEST_BODY=$(cat <<EOF
{
  "location": "${LOCATION}",
  "identity": {
    "type": "SystemAssigned"
  },
  "properties": {
    "osName": "linux",
    "clientPublicKey": "${PUBLIC_B64}",
    "vmId": "${ARC_MACHINE_VMID}"
  }
}
EOF
)
```

>[!IMPORTANT]
> The `identity.type` property in the request body is set to `SystemAssigned` regardless of the managed identity type used for the VM.
> This property is for the Arc machine resource which does create an system-assigned identity for itself.

Submit the request to create the Arc machine resource using `az rest`.
You can add `--debug`, `--verbose` flags to see detailed output for troubleshooting if necessary.

```azurecli-interactive
az rest --method PUT \
  --uri "$API_URL" \
  --body "$REQUEST_BODY" \
  --headers "Content-Type=application/json"
```

Validate the Arc machine resource was created successfully.
The resource does not receive `Connected` status until the VM is enrolled using the `azcmagent connect existing` command.

```azurecli-interactive
az connectedmachine show \
  --name "$ARC_MACHINE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "{Name:name,Status:status,LastHeartbeat:lastStatusChange,OS:osName,Version:agentVersion}" \
  -o table
```

## Assign VM traffic to Private Relay

To ensure secure outbound connectivity for the VM, you must assign its traffic to use Private Relay.

Get the VM details to retrieve the resource ID for the

```azurecli-interactive
az networkcloud virtualmachine assign-relay -g "$RESOURCE_GROUP" -n "$VM_NAME" --machine-id "$ARC_MACHINE_ID"
```

Validate the Private Relay assignment was successful by retrieving the `HybridConnectivity` endpoint details.

```azurecli-interactive
ENDPOINTS_URL="https://management.azure.com${ARC_MACHINE_ID}/providers/Microsoft.HybridConnectivity/endpoints/default?api-version=2023-03-15"

az rest --method get --uri "$ENDPOINTS_URL"
```

Example output:

```json
{
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.HybridCompute/machines/myNexusVirtualMachine/providers/Microsoft.HybridConnectivity/endpoints/default",
  "name": "default",
  "type": "Microsoft.HybridCompute/machines/providers/Microsoft.HybridConnectivity/endpoints",
  "properties": {
    "provisioningState": "Succeeded",
    "endpointType": "PrivateRelay",
    "status": "Connected",
    "lastStatusChange": "2024-01-01T12:00:00Z",
    "privateLinkScopeId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.HybridConnectivity/privateLinkScopes/myPrivateLinkScope"
  }
}
```

## Enroll the VM using managed identities

Once you authenticate using the managed identity and retrieve the access token, you proceed to enroll the VM with Azure Arc using the `azcmagent connect` command.
The `azcmagent connect` command requires the access token to authenticate and authorize the enrollment process.

Ensure to install the `azcmagent` CLI tool within the VM.
This step can be done as part of the cloud-init script or manually after the VM is created and boots.

- [Install the `azcmagent` CLI tool](/azure/azure-arc/servers/azcmagent)

Validate the `azcmagent` installation was successful by checking the version.

```bash
azcmagent version
```

For more information about the `azcmagent connect` command and access tokens, see:

- [Azure Connected Machine agent connect reference]: /azure/azure-arc/servers/azcmagent-connect#access-token
- [How to use managed identities to get an access token]: /entra/identity/managed-identities-azure-resources/how-to-use-vm-token#get-a-token-using-go

### Azure Arc enrollment commands

```bash
azcmagent config set proxy.url "http://169.254.0.11:3128"
```

Output from setting the proxy configuration successfully:

```
Config property proxy.url set to value http://169.254.0.11:3128
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
  proxy.url                                             : http://169.254.0.11:3128
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
Make sure the [Retrieve access token after authentication](#retrieve-access-token-after-authentication).

> [!TIP]
> If the managed identity roles or permissions are changed, the token must be refreshed to reflect the changes.

```azurecli-interactive
ACCESS_TOKEN=$(az account get-access-token --resource https://management.azure.com/ --query accessToken -o tsv)
```

Execute the `azcmagent connect existing` command to connect the Azure Arc machine resource associated with the VM.
To see detailed output, add the `--verbose` flag.

The `--vmid` parameter should be set to the value of `ARC_MACHINE_VMID` defined in [Create the Azure Arc machine resource](#create-the-azure-arc-machine-resource) section.
The `--private-key` parameter should use the base64-encoded private key (`PRIVATE_B64`) generated [Create the Azure Arc machine resource](#create-the-azure-arc-machine-resource) section.

```bash
azcmagent connect existing \
    --location "${LOCATION}" \
    --private-key "${PRIVATE_B64}" \
    --resource-group "${RESOURCE_GROUP}" \
    --resource-name "${VM_NAME}" \
    --subscription-id "${SUBSCRIPTION_ID}" \
    --tenant-id "${TENANT_ID}" \
    --vmid "${ARC_MACHINE_VMID}" \
    --verbose
```

After the command completes, the VM should be successfully enrolled with Azure Arc.

#### Verify Arc enabled VM using Azure CLI

You can verify that your VM is enrolled with Azure Arc by checking its status in the Azure portal or by using the Azure CLI.
First, confirm that the VM is provisioned by reviewing its detailed status.
Then, view the details of the Azure Arc enabled VM to ensure it is connected and reporting correctly.

```azurecli-interactive
az networkcloud virtualmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP" --query "detailedStatus"
```

Install the [`connectedmachine` CLI extension](/cli/azure/connectedmachine) to run the command.

```azurecli-interactive
az connectedmachine show \
  --name "$ARC_MACHINE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "{Name:name,Status:status,LastHeartbeat:lastStatusChange,OS:osName,Version:agentVersion}" \
  -o table
```

## Next steps

It might be useful to review the [troubleshooting guide][Troubleshoot Nexus virtual machines using managed identities] for common issues and pitfalls.

If you are wanting to setup [SSH access to Azure Arc-enabled servers](/azure/azure-arc/servers/ssh-arc-overview) using [az ssh arc](/cli/azure/ssh?view=azure-cli-latest#az-ssh-arc)

## Related articles

- [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md)
- [Create a virtual machine using Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
- [Troubleshoot Nexus virtual machines using managed identities](./troubleshoot-virtual-machine-arc-enroll-with-managed-identity.md)
- [Connect hybrid machines to Azure using a deployment script](/azure/azure-arc/servers/onboard-portal#install-and-validate-the-agent-on-linux)
- [Quickstart: Connect a Linux machine with Azure Arc-enabled servers (package-based installation)](/azure/azure-arc/servers/quick-onboard-linux)
- [Quickstart: Connect a machine to Arc-enabled servers (Windows or Linux install script)](/azure/azure-arc/servers/quick-enable-hybrid-vm)
