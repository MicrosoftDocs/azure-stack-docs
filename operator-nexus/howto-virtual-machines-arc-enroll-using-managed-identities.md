---
title: How to Azure Arc enroll virtual machines using managed identities through the public relay
description: Learn how to Azure Arc enroll Azure Operator Nexus virtual machines using managed identities through the public relay.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: how-to
ms.date: 10/23/2025
ms.author: omarrivera
author: g0r1v3r4
---

# How to Azure Arc enroll virtual machines using managed identities through the public relay

This guide explains how to create Azure Arc enroll an Azure Operator Nexus virtual machines (VM) with associated managed identities.

> [!IMPORTANT]
> In this guide, the Azure Arc enrollment is done with the VM network traffic routed through the public relay.
> The steps to use the private relay will be provided in a separate guide in a future release.

[!INCLUDE [virtual-machine-managed-identity-version-prereq](./includes/virtual-machine/howto-virtual-machines-managed-identities-version-prerequisites.md)]

## Create a VM with a managed identity

For a comprehensive walkthrough, see [How to create virtual machines with managed identities and authenticate with a managed identity](./howto-virtual-machines-authenticate-using-managed-identities.md).
Review the entire document before starting the steps in this guide.

[!INCLUDE [virtual-machine-howto-virtual-machines-environment-variables](./includes/virtual-machine/howto-virtual-machines-environment-variables.md)]

### Required roles for managed identities when Azure Arc enrolling VMs

You can use either a system-assigned or a user-assigned managed identity to Azure Arc enroll the VM.
However, you must assign the necessary roles to the managed identity to allow it to Azure Arc enroll the VM.
Both the system-assigned and user-assigned managed identities require the same roles.

For system-assigned managed identities, if you're Azure Arc enrolling manually, you can assign the roles after the VM is created and booted.
If you automate the Azure Arc enrollment using a cloud-init user data script, then you can use the Azure CLI within the VM to assign the required roles first.

The required roles to allow the managed identity to Azure Arc enroll the VM are:

- `HybridCompute Machine ListAccessDetails Action`
- `Azure Connected Machine Resource Manager`

## Automate using cloud-init user data script

It's possible to pass in a cloud-init script to the VM during creation using the `--user-data-content` parameter (or the alias `--udc`).
The cloud-init script must be base64 encoded before passing it to the `--user-data-content "$ENCODED_USER_DATA"` parameter of the `az networkcloud virtualmachine create` command.
The cloud-init script runs during the VM's first boot and can be used to perform various setup tasks.

Steps for the cloud-init script can include:

- Ensure to [Install Azure CLI](https://aka.ms/azcli) at the latest versions.
  Including any required extensions such as the `networkcloud` extension.
- Complete the necessary setup for your chosen managed identity option before creating the VM.
  - If you're using a System-Assigned Managed Identity (SAMI), the cloud-init script must handle role assignments.
  - If you're using a User-Assigned Managed Identity (UAMI), the role assignments can be done ahead of time.
- Authenticate using the managed identity with the `az login --identity` command and obtain an access token as needed.
- [Install the `azcmagent` package](https://aka.ms/azcmagent) and enroll the VM with Azure Arc.

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

[!INCLUDE [virtual-machine-howto-virtual-machines-proxy-settings](./includes/virtual-machine/howto-virtual-machines-proxy-settings.md)]

[!INCLUDE [virtual-machine-howto-virtual-machines-authenticate-with-managed-identity](./includes/virtual-machine/howto-virtual-machines-authenticate-with-managed-identity.md)]

## Enroll the VM using managed identities

Once you authenticate using the managed identity and retrieve the access token, use the `azcmagent connect` command to Azure Arc enroll the VM.
The `azcmagent connect` command requires the access token to authenticate and authorize the enrollment process.

[!INCLUDE [virtual-machine-howto-virtual-machines-warning-azcmagent-blocks-access-token](./includes/virtual-machine/howto-virtual-machines-warning-azcmagent-blocks-access-token.md)]

### Install the `azcmagent` CLI tool

Follow the steps to [install the `azcmagent` CLI tool](/azure/azure-arc/servers/azcmagent) within the VM.
This step can be done as part of the cloud-init script or manually after the VM is created and boots.

Validate the `azcmagent` installation was successful by checking the version.

```bash
azcmagent version
azcmagent show
```

For more information about the `azcmagent connect` command and access tokens, see:

- [Azure Connected Machine agent connect reference](/azure/azure-arc/servers/azcmagent-connect#access-token)
- [How to use managed identities to get an access token](/entra/identity/managed-identities-azure-resources/how-to-use-vm-token)

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

```bash
sudo azcmagent connect \
    --resource-group "${RESOURCE_GROUP}" \
    --tenant-id "${TENANT_ID}" \
    --location "${LOCATION}" \
    --subscription-id "${SUBSCRIPTION_ID}" \
    --access-token "${ACCESS_TOKEN}"
```

After the command completes, the VM should be successfully enrolled with Azure Arc.
You can verify the enrollment status by running:

```bash
azcmagent show
```

### Verify Arc enabled VM using Azure CLI

You can verify that your VM is enrolled with Azure Arc by checking its status in the Azure portal or by using the Azure CLI.
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