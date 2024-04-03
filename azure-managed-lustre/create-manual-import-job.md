---
title: Create a manual import job from Blob Storage to Azure Managed Lustre
description: Learn how to create a manual import job to import data from an Azure Blob Storage container into an Azure Managed Lustre file system.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.date: 04/03/2024
ms.reviewer: brianl
---

# Create a manual import job from Blob Storage to a file system

Azure Managed Lustre integrates with Azure Blob Storage to simplify the process of importing data from a blob container to a file system. You can configure this integration during [cluster creation](create-file-system-portal.md#blob-integration), or you can manually create an import job any time after the cluster is created.

In this article, you learn how to use the Azure portal to create a manual import job to import data from a blob container into an existing Azure Managed Lustre file system.

## Prerequisites

- Existing Azure Managed Lustre file system - create one using the [Azure portal](create-file-system-portal.md), [Azure Resource Manager](create-file-system-resource-manager.md), or [Terraform](create-aml-file-system-terraform.md). To learn more about blob integration, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites-optional).

## Create a manual import job

Manually importing data from a blob container into an Azure Managed Lustre file system begins with creating an import job. In this section, you learn how to create, configure, and start an import job in the Azure portal.

### Configure import options and start the job

To configure the import options and start the job, follow these steps:

1. In the Azure portal, open your Azure Managed Lustre file system and navigate to the **Blob integration** pane.
1. TODO: Add steps for configuring the import job. Pull screenshots from the portal.

## Monitor the import job

After the import job is created, you can monitor its progress to make sure it completes successfully. In this section, you learn how to monitor the import job in the Azure portal.

TODO: Add note about viewing errors/conflicts in the logging container after the import is complete.

## Next steps

For more information about using Azure Blob Storage with Azure Managed Lustre, see [Use Azure Blob storage with an Azure Managed Lustre file system](blob-integration.md).
