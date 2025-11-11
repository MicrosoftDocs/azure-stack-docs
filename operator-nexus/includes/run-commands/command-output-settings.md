---
author: PerfectChaos
ms.author: chaoschhapi
ms.date: 07/09/2025
ms.topic: include
ms.service: azure-operator-nexus
---

## <a name = "send-command-output-to-a-user-specified-storage-account"></a> Send the command output to a user-specified storage account

To send the command output to a specified storage account and container, see [Azure Operator Nexus cluster support for managed identities and user-provided resources](../../howto-cluster-managed-identity-user-provided-resources.md).

[!INCLUDE [command-output-access](./command-output-access.md)]

## Verify you can access the specified storage account

Before you run commands, you might want to verify that you can access the specified storage account:

1. From the Azure portal, navigate to **Storage Account**.
1. In **Storage Account details**, select **Storage browser** from the left menu.
1. In **Storage browser details**, select **Blob containers**.
1. Select the container to which you want to send the command output.
1. If you encounter errors while accessing the storage account or container, you might need a role assignment for the storage account or container. Alternatively, you might need to update the storage account's firewall settings to include your IP address.
