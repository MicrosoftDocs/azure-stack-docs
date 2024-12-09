---
title: Troubleshoot Azure Managed Lustre cluster deployment issues
description: Learn how to troubleshoot common cluster deployment issues in Azure Managed Lustre
author: pauljewellmsft
ms.author: pauljewell
ms.service: azure-managed-lustre
ms.topic: troubleshooting-general
ms.date: 11/01/2024

---

# Troubleshoot Azure Managed Lustre deployment issues

In this article, you learn how to troubleshoot common issues that you might encounter when deploying an Azure Managed Lustre file system.

## Cluster deployment fails due to incorrect network configuration

In this section, we cover the following causes:

- [Cause 1: Network ports are blocked](#cause-1-network-ports-are-blocked)
- [Cause 2: Resources within the subnet are incompatible](#cause-2-resources-within-the-subnet-are-incompatible)
- [Cause 3: Network security group rules aren't configured correctly](#cause-3-network-security-group-rules-arent-configured-correctly)

### Cause 1: Network ports are blocked

Port 988 and port 22 must be open within the subnet for the cluster to communicate with the Azure Managed Lustre service. If either port is blocked, the deployment fails.

### Solution: Verify the network configuration

Allow inbound and outbound access between hosts within the Azure Managed Lustre subnet. For example, access to TCP port 22 (SSH) is necessary for cluster deployment.

Your network security group (NSG) must allow inbound and outbound access on port 988 and ports 1019-1023. No other services can reserve or use these ports on your Lustre clients. If you use the `ypbind` daemon on your clients to maintain Network Information Services (NIS) binding information, you must ensure that `ypbind` doesn't reserve port 988.

Make sure that the virtual network, subnet, and NSG meet the requirements for Azure Managed Lustre. To learn more, see [Network prerequisites](amlfs-prerequisites.md#network-prerequisites).

### Cause 2: Resources within the subnet are incompatible

Azure Managed Lustre and Azure NetApp Files resources can't share a subnet. The deployment fails if you try to create an Azure Managed Lustre file system in a subnet that currently contains, or has previously contained, Azure NetApp Files resources.

### Solution: Verify the subnet configuration

If you use the Azure NetApp Files service, you must create your Azure Managed Lustre file system in a separate subnet. To learn more, see [Network prerequisites](amlfs-prerequisites.md#network-prerequisites).

### Cause 3: Network security group rules aren't configured correctly

If you're using a network security group to filter network traffic between Azure resources in an Azure virtual network, the security rules that allow or deny inbound and outbound network traffic must be properly configured. If the network security group rules aren't correctly configured for Azure Managed Lustre file system support, the deployment fails.

### Solution: Verify the network security group configuration

For detailed guidance about configuring inbound and outbound security rules to support Azure Managed Lustre file systems, see [Configure network security group rules](configure-network-security-group.md#configure-network-security-group-rules).

## Cluster deployment fails due to incorrect blob container configuration

In this section, we cover the following causes:

- [Cause 1: Blob container allows public access](#cause-1-blob-container-allows-public-access)
- [Cause 2: Blob container can't be accessed by the file system](#cause-2-blob-container-cant-be-accessed-by-the-file-system)

### Cause 1: Blob container allows public access

To comply with security requirements, the blob container anonymous access level must be set to private. If the blob container is set to public, the deployment fails.

### Solution: Set the blob container access level to private

Configure the blob container to allow private access only. You can disallow public access at the storage account level, or you can configure access at the container level. To learn more, see [About anonymous read access](/azure/storage/blobs/anonymous-read-access-configure#about-anonymous-read-access).

### Cause 2: Blob container can't be accessed by the file system

If the file system can't access the blob container, the deployment fails. You must add role assignments at the storage account scope or higher to allow the file system to access the container.

### Solution: Authorize access to the storage account

To authorize access to the storage account, add the following role assignments to the service principal **HPC Cache Resource Provider**:

- [Storage Account Contributor](/azure/role-based-access-control/built-in-roles#storage-account-contributor)
- [Storage Blob Data Contributor](/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor)

To learn more, see [Access role for blob integration](amlfs-prerequisites.md#access-roles-for-blob-integration).
