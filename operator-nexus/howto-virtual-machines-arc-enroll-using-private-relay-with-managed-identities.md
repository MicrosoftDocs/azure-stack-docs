---
title: How to Azure Arc enroll Azure Operator Nexus virtual machines using managed identities and assign network traffic to Private Relay
description: |
  This article explains how to enroll Azure Operator Nexus virtual machines with Azure Arc using managed identities for authentication.
  The article also shows how to route virtual machine network traffic through Private Relay to ensure secure outbound connectivity.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: how-to
ms.date: 02/09/2026
ms.author: omarrivera
author: g0r1v3r4
---

# How to Azure Arc enroll Azure Operator Nexus virtual machines using managed identities and assign network traffic to Private Relay

This article shows how to enroll Azure Operator Nexus virtual machines (VM) with Azure Arc using managed identities (MI).
Azure Arc enrollment enables you to manage virtual machines as Azure resources, providing unified management, monitoring, and extension capabilities.

This guide covers the steps required to complete the enrollment process using managed identities and making sure the VM's network traffic is assigned to Private Relay for secure outbound connectivity.
The process can be automated through a cloud-init user data script passed during VM creation or executed after the VM is created and boots.
However, we leave this choice to you based on your requirements and preferences.

The overall process involves the following steps:

1. **Create a managed identity**: Create a user-assigned managed identity to be associated with the VM. Alternatively, you can use a system-assigned managed identity that is created along with the VM.
2. **Assign roles and permissions to the managed identity**: Assign the necessary roles and permissions to the managed identity to allow Azure Arc enrollment and to assign VM traffic to Private Relay.
3. **Create Nexus VM**: Create a Nexus VM with an associated managed identity. If using system-assigned managed identities, the identity is created along with the VM.
4. **Install Azure CLI**: Install the latest Azure CLI.
5. **Configure proxy settings**: Configure the necessary proxy environment variables.
6. **Authenticate with managed identity**: Authenticate using either a system-assigned or user-assigned managed identity to sign in to Azure.
7. **Create Arc machine resource**: Create the Azure Arc machine resource in the specified resource group without connecting it to the VM.
8. **Assign VM traffic to Private Relay**: Assign the VM's traffic to use Private Relay for secure outbound connectivity.
9. **Install the `azcmagent` CLI tool**: Install the Azure Connected machine agent (`azcmagent`) CLI tool.
10. **Connect to existing Arc machine**: Connect the VM to the existing Azure Arc machine using the `azcmagent connect existing` command.

All the listed steps are explained in detail in the following sections and can be automated using a cloud-init user data script or executed manually.
The end result is a Nexus VM that is successfully enrolled with Azure Arc using managed identities for authentication.
The VM's network traffic is routed through Private Relay for secure outbound connectivity.
And you can manage the VM as an Azure resource using Azure Arc capabilities.

[!INCLUDE [virtual-machine-managed-identity-version-prereq](./includes/virtual-machine/howto-virtual-machines-managed-identities-version-prerequisites.md)]

[!INCLUDE [virtual-machine-managed-identity-options-explained](./includes/virtual-machine/howto-virtual-machines-managed-identity-options-explained.md)]

### Required roles or permissions for managed identities when Azure Arc enrolling VMs and assigning traffic to Private Relay

You can use either a system-assigned or a user-assigned managed identity to Azure Arc enroll the VM.
In both options, you must assign the necessary roles to the managed identity to allow it to Azure Arc enroll the VM and the required permissions to assign the VM traffic to Private Relay.

For _system-assigned managed identities_, you must assign the roles to the identity created with the VM.
It might not be possible to achieve role assignment from within the cloud-init script since the user likely doesn't yet have the permissions needed to grant itself further roles.
An option to automate the Azure Arc enrollment using system-assigned identity is to use Az CLI, ARM, or bicep to assign the necessary roles independent of the VM provisioning.

#### Assign roles to allow Azure Arc enrollment

The required roles to allow the managed identity to Azure Arc enroll the VM are:

- `HybridCompute Machine ListAccessDetails Action`
- `Azure Connected Machine Resource Manager`

#### Assign permission to assign VM traffic to Private Relay

You need the `Microsoft.NetworkCloud/virtualMachines/assignRelay/action` permission assigned to the managed identity, in order to make the assign relay action succeed.
The permission can be assigned through a custom role, or by assigning the `Contributor` built-in role to the managed identity.
For steps on how to create a custom role, see [Create or update Azure custom roles using an ARM template].

[Create or update Azure custom roles using an ARM template]: /azure/role-based-access-control/custom-roles-template

## Create a VM with the managed identity

[!INCLUDE [virtual-machine-prereq](./includes/virtual-machine/quickstart-prereq.md)]

- Ensure you have permissions to create managed identities and manage the role assignments in your Azure subscription.
- Ensure to create the VM with either an associated system-assigned or user-assigned managed identity.
- Ensure to assign roles or permissions for the managed identities to enroll virtual machines with Azure Arc.
- Ensure to assign roles or permissions to assign virtual machine traffic to the Private Relay.

Complete the [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md) for deploying a Nexus virtual machine.

- Before creating the virtual machine, you need to create the required networking resources.
  - **L3 network andL3 isolation domain**: virtual machine's network connectivity, isolation, and routing
  - **Cloud Services Network (CSN)**: virtual machine's outbound and inbound connectivity and proxy services

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

The Operator Nexus VM must be created with a managed identity in order to use managed identity authentication for Azure Arc enrollment with the Private Relay feature.

> [!IMPORTANT]
> If you don't specify a managed identity when creating the VM, you can't enable managed identity support by updating the VM after provisioning.

### CSN egress routes and required Azure endpoints

The Cloud Services Network (CSN) should already have the necessary default egress routes to allow the VM to reach required Azure endpoints.
The CSN must be created with the `--enable-default-egress-endpoints "True"` flag to automatically include the necessary endpoints.
If this flag setting was skipped during creation, you need to manually add the required endpoints.

You can use the `networkcloud` extension to verify the setting value:

```azurecli-interactive
az networkcloud cloudservicesnetwork show --name <CSN_NAME> --resource-group <RESOURCE_GROUP> --query "enableDefaultEgressEndpoints" -o tsv
```

The easiest way is to see the egress endpoints configured for the CSN is through Azure portal, although you can also use the Azure CLI.
If you're encountering connectivity issues, ensure that the CSN has the necessary routes to allow outbound connectivity.

| Endpoint                         | Reason                                                          |
|----------------------------------|-----------------------------------------------------------------|
| management.azure.com             | Required for `az login` and Azure Resource Manager API access   |
| login.microsoftonline.com        | Required for authentication during `az login`                   |
| his.arc.azure.com                | Required for Azure Arc enrollment via `azcmagent connect`       |

[!INCLUDE [virtual-machine-howto-virtual-machines-environment-variables](./includes/virtual-machine/howto-virtual-machines-environment-variables.md)]

## Use cloud-init user data script or manual execution for Azure Arc enrollment

You can pass in a cloud-init script to the VM during creation using the `--user-data-content` parameter (or the alias `--udc`).
The cloud-init script must be base64 encoded before passing it to the `--user-data-content "$ENCODED_USER_DATA"` parameter of the `az networkcloud virtualmachine create` command.
The cloud-init script runs during the VM's first boot and can be used to perform various setup tasks.

Steps for the cloud-init script can include:

- Ensure to [Install Azure CLI](https://aka.ms/azcli) at the latest versions.
  Including any required extensions such as the [`networkcloud` extension](https://github.com/Azure/azure-cli-extensions/tree/main/src/networkcloud).
- Complete the necessary setup for your chosen managed identity option before creating the VM.
  - If you're using a User-Assigned Managed Identity (UAMI), the role assignments can be done ahead of time.
  - If you're using a System-Assigned Managed Identity (SAMI), the cloud-init script might not be able to handle role assignments since the identity created during provisioning doesn't have the permissions to grant itself roles.
    One option is to use the same user that's calling the Az CLI, ARM, or bicep deployment to assign the necessary roles to the SAMI.
    Role assignment should be done after the VM is provisioned but before the cloud-init script attempts to authenticate using the SAMI.
- Authenticate using the managed identity with the `az login --identity` command and obtain an access token as needed.
- [Install the `azcmagent` package](https://aka.ms/azcmagent) and enroll the VM with Azure Arc.

After the VM is created and boots, you can check the cloud-init logs to verify that the script completed successfully.
The cloud-init logs file is found at `/var/log/cloud-init-output.log`.
It's necessary to SSH into the VM to access the logs.

> [!NOTE]
> The previous `--user-data` parameter is deprecated and will be removed in a future release.
> Verify in the [`networkcloud` extension release history](https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst) for the latest updates.

> [!TIP]
> The cloud-init script runs only during the first boot of the VM.
> This means that if you need to make changes or rerun the cloud-init script, the VM must be recreated.
> You can also authenticate with managed identities manually from inside the VM after creation and boot.

[!INCLUDE [virtual-machine-howto-virtual-machines-proxy-settings](./includes/virtual-machine/howto-virtual-machines-proxy-settings.md)]

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

> [!NOTE]
> The `az login` command is the preferred method to authenticate using managed identities.
> However, this method can be blocked due to the `azcmagent` binary installation affecting the routing for the authentication calls inside the VM.
> To enable a workaround, you can use [Alternative access token retrieval methods](./troubleshoot-virtual-machines-arc-enroll-with-managed-identities.md#alternative-access-token-retrieval-methods).

## Create the Azure Arc machine resource

In order to enroll the VM with Azure Arc without having the traffic go through the public relay, you must create the Azure Arc machine resource before connecting the Arc machine.

| Variable             | Description                                                                                  |
|----------------------|----------------------------------------------------------------------------------------------|
| ARC_MACHINE_NAME     | The name of the Azure Arc machine resource to be created.                                    |
| ARC_MACHINE_VMID     | The unique identifier (UUID) for the Azure Arc machine resource.                             |
| ARC_MACHINE_ID       | The resource ID of the Azure Arc machine to be created.                                      |
| PRIVATE_B64          | The base64-encoded private key used for connecting the VM Arc machine resource.              |
| PUBLIC_B64           | The base64-encoded public key used for connecting the VM with the Arc machine resource.      |

Generate a new key pair to use during the creation of the Arc machine resource.
This key pair is required for secure authentication between your Nexus VM and Azure Arc during the connection phase.
The private key is needed later when you run the `azcmagent connect existing` command to complete the enrollment.

The key pair is for one-time use only and should be kept secure until the VM is successfully connected to Azure Arc.
_Don't share the key pair publicly._ Once the Azure Arc machine resource is created and the connection is established, the key pair is no longer required.

The script generates the key pair and outputs the base64-encoded private and public keys as environment variable export commands.
Depending on your OS and available tools, you might need to adjust the script accordingly.

```bash
#!/bin/bash
# Generate RSA 2048-bit PKCS#1 keys for Azure Arc agent enrollment.
# Output: base64(PKCS#1 DER)
#
# Target Platforms:
#   - Azure Linux 3 (OpenSSL 3.x)
#   - Ubuntu 24.04 LTS+ (OpenSSL 3.x)
#
# Why use the -traditional flag?
#   OpenSSL 3.x defaults to PKCS#8 format for private key output.
#   The key pairs must be in PKCS#1 DER format to properly Arc enroll.
#   Without -traditional, you get "asn1: structure error" when the agent attempts to parse the key.
#
# Why use openssl base64 instead of coreutils base64?
#   GNU coreutils base64 requires -w0 to disable line wrapping, but this flag
#   is not portable.
#   Using openssl base64 -A provides consistent single-line output across all platforms.
#
# Security Notes:
#   - umask 077 ensures the private key PEM file is not group/world readable.
#   - Keys exist only in a mktemp-created directory, removed on exit.
set -euo pipefail
umask 077

tmpdir="$(mktemp -d -t azcmkeys.XXXXXX)"
private_pem="${tmpdir}/private.pem"

# Cleanup temp directory on exit (normal or error)
# Comment out this line to keep files for debugging purposes.
trap 'rm -rf "${tmpdir}"' EXIT

# Generate RSA 2048-bit key (OpenSSL 3.x writes PKCS#8 PEM by default)
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "${private_pem}" 2>/dev/null

# Private key: PKCS#1 DER → base64 (matches x509.ParsePKCS1PrivateKey)
PRIVATE_B64="$(openssl pkey -in "${private_pem}" -traditional -outform DER | openssl base64 -A)"

# Public key: PKCS#1 RSAPublicKey DER → base64 (matches x509.MarshalPKCS1PublicKey)
# Note: -RSAPublicKey_out outputs PKCS#1 format, not SubjectPublicKeyInfo (SPKI)
PUBLIC_B64="$(openssl rsa -in "${private_pem}" -RSAPublicKey_out -outform DER 2>/dev/null | openssl base64 -A)"

# Output export commands
echo "Export these environment variables to your session:"
printf 'export PRIVATE_B64="%s"\n' "$PRIVATE_B64"
printf 'export PUBLIC_B64="%s"\n' "$PUBLIC_B64"
```

Define the `ARC_MACHINE_ID` variable with the resource ID for the Azure Arc machine resource that you create in your `SUBSCRIPTION` and `RESOURCE_GROUP`.
Set the `ARC_MACHINE_NAME` variable to match the VM name for easy identification.
You specify these values manually, as the resource doesn't exist until you create it.

```bash
# Varibles to set for your environment - update these values accordingly
TENANT_ID="00000000-0000-0000-0000-000000000000"
SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
RESOURCE_GROUP="my-nexus-vm-rg"
LOCATION="$(az group show --name $RESOURCE_GROUP --query location --subscription $SUBSCRIPTION_ID -o tsv)"
VM_NAME="my-nexus-vm-name"

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

> [!IMPORTANT]
> The `identity.type` property in the request body is always set to `SystemAssigned` regardless of the managed identity type used for the VM.
> This property is for the Arc machine resource, which creates a system-assigned identity for itself.

Submit the request to create the Arc machine resource using `az rest`.
You can add `--debug`, `--verbose` flags to see detailed output for troubleshooting if necessary.

```azurecli-interactive
az rest --method PUT \
  --uri "$API_URL" \
  --body "$REQUEST_BODY" \
  --headers "Content-Type=application/json"
```

Validate the Arc machine resource was created successfully.
The resource doesn't receive `Connected` status until the VM is enrolled using the `azcmagent connect existing` command.

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

[!INCLUDE [virtual-machine-howto-virtual-machines-important-blocked-access-token-retrieval](./includes/virtual-machine/howto-virtual-machines-important-blocked-access-token-retrieval.md)]

### Install the `azcmagent` CLI tool

Follow the steps to [install the `azcmagent` CLI tool](/azure/azure-arc/servers/azcmagent) within the VM.
This step can be done as part of the cloud-init script or manually after the VM is created and boots.

> [!IMPORTANT]
>

Validate the `azcmagent` installation was successful by checking the version.

```bash
azcmagent version
```

For more information about the `azcmagent connect` command and access tokens, see:

- [Azure Connected Machine agent connect reference](/azure/azure-arc/servers/azcmagent-connect#access-token)
- [How to use managed identities to get an access token](/entra/identity/managed-identities-azure-resources/how-to-use-vm-token#get-a-token-using-go)

> [!IMPORTANT]
> The `azcmagent` installation blocks the default access token retrieval method used by the Azure CLI.
> For this reason, `azcmagent` can't be installed any earlier than at this point.
> For example, it can't be preinstalled on the VM disk image.
> Once `azcmagent` is installed and the `himdsd` binary exists on the VM, any previously assigned Nexus VM identities can't be accessed via `az login`.
> As long as the `azcmagent` is installed, the `az login --identity` and `az account get-access-token` command fails to retrieve an access token using the managed identity.
> To obtain access tokens, use [Alternative access token retrieval methods](./troubleshoot-virtual-machines-arc-enroll-with-managed-identities.md#alternative-access-token-retrieval-methods).
> If your virtual machine image bundles the `azcmagent` by default, you need to use these alternative methods to retrieve access tokens.

### Configure the `azcmagent` proxy settings

Set the proxy settings for the `azcmagent` to use the same proxy for outbound connectivity.

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
You can verify the enrollment status by running:

```bash
azcmagent show
```


### Verify Arc enabled VM using Azure CLI

You can verify that your VM is enrolled with Azure Arc by checking its status in the Azure portal or by using the Azure CLI.

> [!TIP]
> You can't run the verification commands from within the VM (for example, via cloud-init).
> The newly created system-assigned managed identity (SAMI) for the Arc-enabled machine requires role assignment to list Arc Connected Machine resources.
> If you run the command as the same Azure user or service principal that performed the Az CLI/ARM/bicep template deployment, it should work as expected.

First, confirm that the VM is provisioned by reviewing its detailed status.

```azurecli-interactive
az networkcloud virtualmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP" --query "detailedStatus"
```

Next, view the details of the Azure Arc enabled VM to confirm connectivity and statuses are reported correctly.
Install the [`connectedmachine` CLI extension](/cli/azure/connectedmachine) to run the command.

```azurecli-interactive
az connectedmachine show \
  --name "$ARC_MACHINE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "{Name:name,Status:status,LastHeartbeat:lastStatusChange,OS:osName,Version:agentVersion}" \
  -o table
```

## Next steps

It might be useful to review the [troubleshooting guide](./troubleshoot-virtual-machine-arc-enroll-with-managed-identity.md) for common issues and pitfalls.

If you're wanting to set up [SSH access to Azure Arc-enabled servers](/azure/azure-arc/servers/ssh-arc-overview) using [az ssh arc](/cli/azure/ssh#az-ssh-arc).

[!INCLUDE [contact-support](./includes/contact-support.md)]

## Related articles

- [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md)
- [Create a virtual machine using Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
- [Connect hybrid machines to Azure using a deployment script](/azure/azure-arc/servers/onboard-portal#install-and-validate-the-agent-on-linux)
- [Quickstart: Connect a Linux machine with Azure Arc-enabled servers (package-based installation)](/azure/azure-arc/servers/quick-onboard-linux)
- [Quickstart: Connect a machine to Arc-enabled servers (Windows or Linux install script)](/azure/azure-arc/servers/quick-enable-hybrid-vm)