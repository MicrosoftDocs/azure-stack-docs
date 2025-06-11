---
title: Set up disconnected operations for Azure Local (preview)
description: Learn how to set up disconnected operations for Azure Local by creating a disconnected operations resource in the Portal (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 04/22/2025
---

# Set up disconnected operations for Azure Local (preview)

::: moniker range=">=azloc-24112"

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

1. Sign into [the portal](https://portal.azure.com) and navigate to **Azure Local**. You should see the **Disconnected operations** tab if you're approved for disconnected operations.

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

    > [!NOTE]
    > For the next 2 steps, please see Supplemental doc for getting the appliance - as during the first preview, special instructions are required for downloading the appliance. Step 6 and 7 are subject to change during preview.

6. Look for the **download manifest** and **download appliance** actions. These files are needed for your on-premises installation.

    | Action | Description | Estimated download size |  
    |------|-------------|----------------|  
    | Manifest file | Identified as `AzureLocal.DisconnectedOperations.Appliance.manifest`. This file is needed for deployment and to activate the appliance. It contains the required licensing information and more. | < 1 KB |  
    | Appliance | Downloads a set of files, identified as  `AzureLocal.disconnectedoperations.zip`, `ArcA_LocalData_A.vhdx`,`ArcA_SharedData_A.vhdx`,`OSAndDocker_A.vhdx`. These files will contain the virtual hard disks and virtual machine together with the operations module required to deploy and configure the virtual appliance as a wole. | 70 GB+ |  

7. Select **download manifest**

:::image type="content" source="media/disconnected-operations/set-up/new-appliance.png" alt-text="Screenshot of the resource page for the virtual appliance you created." lightbox="media/disconnected-operations/set-up/new-appliance.png":::

8. Select download appliance and download each respective file. Move these files in a single folder. Unzip the AzureLocal.disconnectedoperations.zip in that directory. Once the zip is extracted, you can delete the zip file. You should have the following files required for installation in the directory after this step:

    - manifest.xml
    - OperationsModule
    - IRVM.zip
    - ArcA_LocalData_A.vhdx
    - ArcA_SharedData_A.vhdx
    - OSAndDocker_A.vhdx

9. When the steps are complete, put all the files in a share or onto a portable media. You need these files during the deployment process.

## Related content

- [Deploy disconnected operations for Azure Local](disconnected-operations-deploy.md).

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local 2411.2.

::: moniker-end
