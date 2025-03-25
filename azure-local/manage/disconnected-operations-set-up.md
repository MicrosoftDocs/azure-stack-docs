---
title: Set up disconnected operations for Azure Local (preview)
description: Learn how to set up disconnected operations for Azure Local by creating a disconnected operations resource in the Portal (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 03/19/2025
---

# Set up disconnected operations for Azure Local (preview)

[!INCLUDE [applies-to:](../includes/release-2411-1-later.md)]

This article describes how to set up disconnected operations for Azure Local. It explains how to create a virtual appliance resource in the Azure portal, download the necessary installation files, and get support from Microsoft.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Prerequisites

- Have an active Azure subscription.  
- Have approval for disconnected operations for Azure Local.
- Have an Azure account with role-based access control rights to create a disconnected operations instance.

After you complete the steps outlined in this document, you should have:  

- A disconnected operations instance in Azure that represents your on-premises, virtual appliance.  
- The files required to deploy Azure Local disconnected operations.

> [!NOTE]
> In this preview, Azure CLI isn't supported. You can use the REST API, if you need automation capabilities. For more information, see [Azure Local REST API](/cli/azure/use-azure-cli-rest-command?tabs=bash).

## Create virtual appliance and download installation files

To create a virtual appliance and download the required files for your on-premises installation, follow these steps:

1. Sign into [the portal](../index.yml) and navigate to **Azure Local**. You should see the **Disconnected operations** tab if you're approved for disconnected operations.

2. Select the **Disconnected operations** tab and then select the **Create** button.

    :::image type="content" source="media/disconnected-operations/set-up/azure-local-page.png" alt-text="Screenshot of Azure Local for Disconnected operations page." lightbox="media/disconnected-operations/set-up/azure-local-page.png":::

3. On the **Basics** tab, complete these required fields:  

    | Field               | Description                                                              |  
    |---------------------|--------------------------------------------------------------------------|  
    | **Subscription**    | The subscription where you want to place the resource.                   |  
    | **Resource group**  | The resource group where you want to place the resource.                 |  
    | **Virtual appliance name** | The name to identify your disconnected operations appliance. For example, *no-site-1*. |  
    | **Region**          | The Azure region where you want to place the metadata. There's no metadata from the on-premises installation itself. This is used for billing and support purposes. |  
    | **Outbound connectivity** | Select how you intend to deploy your disconnected operations appliance: <br></br> **Option 1: Limited connectivity** </br> Use this option if you want the appliance to be connected to Azure. This option: <br></br> - Simplifies management and supportability, should you require it. <br></br> - Only requires that the appliance is able to connect. <br></br> - Allows Azure Local instances to use the local control plane provided by the appliance. <br></br> **Option 2: Air-gapped** </br></br> Use this option if you have no way of connecting to Azure. This option: <br></br> - Works air-gapped. <br></br> - Allows you to transfer necessary files in and out of the environment so you can get updates and send logs, if necessary. |

    :::image type="content" source="media/disconnected-operations/set-up/basics-page.png" alt-text="Screenshot of the Basics page and required fields to create a virtual appliance." lightbox="media/disconnected-operations/set-up/basics-page.png":::

4. Select **Review + create**, verify that the validation succeeds, then select the **Create** button.  

    :::image type="content" source="media/disconnected-operations/set-up/create-validation.png" alt-text="Screenshot of the validation page to create your virtual appliance resource." lightbox="media/disconnected-operations/set-up/create-validation.png":::

5. After the completion, navigate to your new resource. You should see the resource details on the appliance page.

6. Look for the **download manifest** and **download appliance** files. These files are needed for your on-premises installation.

    | File | Description | Estimated size |  
    |------|-------------|----------------|  
    | Manifest file | Identified as `AzureLocal.DisconnectedOperations.Appliance.manifest`. This file is needed for deployment and to activate the appliance. It contains the required licensing information and more. | < 1 KB |  
    | Virtual appliance | Identified as `AzureLocal.DisconnectedOperations.zip`. This is a zip file that contains the virtual hard disks and operations module required to deploy and configure the virtual appliance. | 70 GB+ |  

7. Select the download button for each file.

   :::image type="content" source="media/disconnected-operations/set-up/new-appliance.png" alt-text="Screenshot of the resource page for the virtual appliance you created." lightbox="media/disconnected-operations/set-up/new-appliance.png":::

8. When the downloads are complete, put these files in a share or onto a portable media. You need these files during the deployment process.

## Related content

- [Deploy disconnected operations for Azure Local](disconnected-operations-deploy.md).