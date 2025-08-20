---
title: Prerequisites for Azure Managed Lustre file systems
description: Learn about network and storage prerequisites to complete before you create an Azure Managed Lustre file system.
ms.topic: overview
ms.date: 07/31/2025
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: mayabishop

# Intent: As an IT Pro, I need to understand network and storage requirements for using an Azure Managed Lustre file system, and I need to configure resource settings.
# Keyword: 

---

# Azure Managed Lustre file system prerequisites

This article explains prerequisites that you must configure before creating an Azure Managed Lustre file system.

- [Network prerequisites](#network-prerequisites)
- [Blob integration prerequisites](#blob-integration-prerequisites-optional) (optional)

## Network prerequisites

You supply the virtual network and subnet for Azure Managed Lustre networking. This gives you full control of which network security measures you wish to apply, including which compute and other services can access Azure Managed Lustre. Ensure you follow the networking and security guidelines provided for Azure Managed Lustre. Include allowing required connections for essential services such as the Lustre protocol, engineering and diagnostic support, Azure Blob storage, and security monitoring. If your network settings disable one of the essential services, it leads to a degraded product experience or it reduces Microsoft’s support abilities.

You can't move a file system from one network or subnet to another after you create the file system.

Azure Managed Lustre accepts only IPv4 addresses. IPv6 isn't supported.

### Network size requirements

The size of subnet that you need depends on the size of the file system you create. The following table gives a rough estimate of the minimum subnet size for Azure Managed Lustre file systems of different sizes.

| Storage capacity     | Recommended CIDR prefix value |
|----------------------|-------------------------------|
| 4 TiB to 16 TiB      | /27 or larger                 |
| 20 TiB to 40 TiB     | /26 or larger                 |
| 44 TiB to 92 TiB     | /25 or larger                 |
| 96 TiB to 196 TiB    | /24 or larger                 |
| 200 TiB to 400 TiB   | /23 or larger                 |

#### Other network size considerations

When you plan your virtual network and subnet, take into account the requirements for any other services you want to locate within the Azure Managed Lustre subnet or virtual network.

If you're using an Azure Kubernetes Service (AKS) cluster with your Azure Managed Lustre file system, you can locate the AKS cluster in the same subnet as the file system. In this case, you must provide enough IP addresses for the AKS nodes and pods in addition to the address space for the Lustre file system. If you use more than one AKS cluster within the virtual network, make sure the virtual network has enough capacity for all resources in all of the clusters. To learn more about network strategies for Azure Managed Lustre and AKS, see [AKS subnet access](use-csi-driver-kubernetes.md#determine-the-network-type-to-use-with-aks).

If you plan to use another resource to host your compute VMs in the same virtual network, check the requirements for that process before creating the virtual network and subnet for your Azure Managed Lustre system. When planning multiple clusters within the same subnet, it's necessary to use an address space large enough to accommodate the total requirements for all clusters.

### Subnet access and permissions

By default, no specific changes need to be made to enable Azure Managed Lustre. If your environment includes restricted network or security policies, the following guidance should be considered:

| Access type | Required network settings |
|-------------|---------------------------|
| DNS access  | Use the default Azure-based DNS server. |
| Access between hosts on the Azure Managed Lustre subnet | Allow inbound and outbound access between hosts within the Azure Managed Lustre subnet. As an example, access to TCP port 22 (SSH) is necessary for cluster deployment. |
| Azure cloud service access | Configure your network security group to permit the Azure Managed Lustre file system to access Azure cloud services from within the Azure Managed Lustre subnet.<br><br>Add an outbound security rule with the following properties:<br>- **Port**: Any<br>- **Protocol**: Any<br>- **Source**: Virtual Network<br>- **Destination**: "AzureCloud" service tag<br>- **Action**: Allow<br><br>Note: Configuring the Azure cloud service also enables the necessary configuration of the Azure Queue service.<br><br>For more information, see [Virtual network service tags](/azure/virtual-network/service-tags-overview). |
| Lustre access<br>(TCP ports 988, 1019-1023) | Your network security group must allow inbound and outbound traffic for TCP port 988 and TCP port range 1019-1023. These rules need to be allowed between hosts on the Azure Managed Lustre subnet, and between any client subnets and the Azure Managed Lustre subnet. No other services can reserve or use these ports on your Lustre clients. The default rules `65000 AllowVnetInBound` and `65000 AllowVnetOutBound` meet this requirement. |

For detailed guidance about configuring a network security group for Azure Managed Lustre file systems, see [Create and configure a network security group](configure-network-security-group.md#create-and-configure-a-network-security-group).

#### Known limitations

The following known limitations apply to virtual network settings for Azure Managed Lustre file systems:

- Azure Managed Lustre and Azure NetApp Files resources can't share a subnet. If you use the Azure NetApp Files service, you must create your Azure Managed Lustre file system in a separate subnet. The deployment fails if you try to create an Azure Managed Lustre file system in a subnet that contains, or has contained, Azure NetApp Files resources.
- If you use the `ypbind` daemon on your clients to maintain Network Information Services (NIS) binding information, you must ensure that `ypbind` doesn't reserve port 988. You can either manually adjust the ports that `ypbind` reserves, or ensure that your system startup infrastructure starts your Lustre client mount before starting `ypbind`.

> [!NOTE]
> After you create your Azure Managed Lustre file system, several new network interfaces appear in the file system's resource group. Their names start with **amlfs-** and end with **-snic**. Don't change any settings on these interfaces. Specifically, leave the default value, **enabled**, for the **Accelerated networking** setting. Disabling accelerated networking on these network interfaces degrades your file system's performance.

## Blob integration prerequisites (optional)

If you plan to integrate your Azure Managed Lustre file system with Azure Blob Storage, complete the following prerequisites before you create your file system.

To learn more about blob integration, see [Use Azure Blob storage with an Azure Managed Lustre file system](blob-integration.md).

Azure Managed Lustre works with storage accounts that have hierarchical namespace enabled and storage accounts with a nonhierarchical, or flat, namespace. The following minor differences apply:

- For a storage account with hierarchical namespace enabled, Azure Managed Lustre reads POSIX attributes from the blob header.
- For a storage account that *does not* have hierarchical namespace enabled, Azure Managed Lustre reads POSIX attributes from the blob metadata. A separate, empty file with the same name as your blob container contents is created to hold the metadata. This file is a sibling to the actual data directory in the Azure Managed Lustre file system.

To integrate Azure Blob Storage with your Azure Managed Lustre file system, you must create or configure the following resources before you create the file system:

- [Storage account](#storage-account)
- [Blob containers](#blob-containers)

### Storage account

You must create a storage account or use an existing one. The storage account must have the following settings:

- **Account type** - A compatible storage account type. To learn more, see [Supported storage account types](#supported-storage-account-types).
- **Access roles** - Role assignments that permit the Azure Managed Lustre system to modify data. To learn more, see [Required access roles](#access-roles-for-blob-integration).
- **Access keys** - The storage account must have the storage account key access setting set to **Enabled**.
- **Subnet access** - The storage account must be accessible from the Azure Managed Lustre subnet. To learn more, see [Enable subnet access](#enable-subnet-access).

#### Supported storage account types

The following storage account types can be used with Azure Managed Lustre file systems:

| Storage account type  | Redundancy                          |
|-----------------------|-------------------------------------|
| Standard              | Locally redundant storage (LRS), geo-redundant storage (GRS)<br><br>Zone-redundant storage (ZRS), read-access-geo-redundant storage (RAGRS), geo-zone-redundant storage (GZRS), read-access-geo-zone-redundant storage (RA-GZRS) |
| Premium - Block blobs | LRS, ZRS |

For more information about storage account types, see [Types of storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts).

#### Access roles for blob integration

Azure Managed Lustre needs authorization to access your storage account. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/) to give the file system access to your blob storage.

A storage account owner must add these roles before creating the file system:

- [Storage Account Contributor](/azure/role-based-access-control/built-in-roles#storage-account-contributor)
- [Storage Blob Data Contributor](/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor)

> [!IMPORTANT]
> You must add these roles before you create your Azure Managed Lustre file system. If the file system can't access your blob container, file system creation fails. Validation performed before the file system is created can't detect container access permission problems. It can take up to five minutes for the role settings to propagate through the Azure environment.

To add the roles for the service principal **HPC Cache Resource Provider**, follow these steps:

1. Navigate your storage account, and select **Access control (IAM)** in the left navigation pane.
1. Select **Add** > **Add role assignment** to open the **Add role assignment** page.
1. Assign the role.
1. Add **HPC Cache Resource Provider** to that role.
   > [!TIP]
   > If you can't find the HPC Cache Resource Provider, search for **storagecache** instead. **storagecache Resource Provider** was the service principal name before general availability of the product.
1. Repeat steps 3 and 4 to add each role.

For detailed steps, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

#### Enable subnet access

Configure network access of the storage account to enable public access from all networks or from the subnet configured with the Azure Managed Lustre system.  If you choose to disable public access to the storage account (private endpoints), see [Private endpoints](#private-endpoints-optional).

To enable storage account access from the Azure Managed Lustre subnet, follow these steps:

1. Navigate your storage account, and expand **Security + Networking** in the left navigation pane.
1. Select **Networking**.
1. Under Public network access, click the radio button for either **Enable public access from selected virtual networks and IP Addresses** (recommended) or **Enable public access from all networks**. If you choose **Enable public access from selected virtual networks and IP Addresses**, then continue with the steps below. If you choose **Enable public access from all networks**, then jump to the last step below to **Save**.
![Screenshot showing Enable public access from selected virtual networks and IP Addresses in the Network access section.](./media/prerequisites/storage-account-subnet-access.png)
1. Under Virtual networks, click **Add existing virtual network**.
1. On the right, select the Virtual networks and Subnets used by Azure Managed Lustre.
1. Click **Enable**.
1. In the upper left, click **Save**.

### Blob containers

You must have two separate blob containers in the same storage account, which are used for the following purposes:

- **Data container**: A blob container in the storage account that contains the files you want to use in the Azure Managed Lustre file system.
- **Logging container**: A second container for import/export logs in the storage account. You must store the logs in a different container from the data container.

> [!NOTE]
> You can add files to the file system later from clients. However, files added to the original blob container after you create the file system aren't imported to the Azure Managed Lustre file system unless you [create an import job](create-import-job.md).

### Private endpoints (optional)

If you're using a private endpoint with your blob setup, in order to ensure Azure Managed Lustre can resolve the SA name, you must enable the private endpoint setting **Integrate with private DNS Zone** during the creation of a new endpoint.

- **Integrate with Private DNS zone**: Must be set to **Yes**.

![Screenshot showing the DNS tab of the Endpoint setup process.](./media/prerequisites/blob-endpoints-dns-settings.png)

## Next steps

- [Create an Azure Managed Lustre file system in the Azure portal](create-file-system-portal.md)
