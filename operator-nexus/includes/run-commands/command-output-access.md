---
author: PerfectChaos
ms.author: chaoschhapi
ms.date: 08/22/2025
ms.topic: include
ms.service: azure-operator-nexus
---

To access the output of a command, users need the appropriate access to the storage blob. They need to have the necessary Azure role assignments and ensure that any networking restrictions are properly configured.

A user must have the following role assignments on the blob container or its storage account:

- A data access role, such as **Storage Blob Data Reader** or **Storage Blob Data Contributor**
- The Azure Resource Manager **Reader** role (at a minimum)

To learn how to assign roles to storage accounts, see [Assign an Azure role for access to blob data](/azure/storage/blobs/assign-azure-role-data-access?tabs=portal).

If the storage account allows public endpoint access via a firewall, you must configure the firewall with a networking rule to allow that user's IP address. If it allows only private endpoint access, a user must be part of a network that has access to the private endpoint.

Learn more about how to allow access through the storage account firewall by using [networking rules](/azure/storage/common/storage-network-security) or [private endpoints](/azure/storage/common/storage-private-endpoints).
