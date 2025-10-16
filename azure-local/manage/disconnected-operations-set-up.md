---
title: Set Up Disconnected Operations for Azure Local (preview)
description: Learn how to set up disconnected operations for Azure Local by creating a disconnected operations resource in the Azure portal (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 10/16/2025
ai-usage: ai-assisted
---

# Set up disconnected operations for Azure Local (preview)

::: moniker range=">=azloc-2506"

This article explains how to set up disconnected operations for Azure Local. Learn how to create a virtual appliance resource in the Azure portal, download installation files, and get support from Microsoft for your deployment.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Prerequisites

- An active Azure subscription.  
- An approval for disconnected operations for Azure Local.
- An Azure account with role-based access control rights to create a disconnected operations instance.

When you finish these steps, you get:

- A disconnected operations instance in Azure that represents your on-premises virtual appliance.
- The files you need to deploy Azure Local disconnected operations.

> [!NOTE]
> In this preview, Azure CLI isn't supported. Use the REST API if you need automation capabilities. For more information, see [Azure Local REST API](/cli/azure/use-azure-cli-rest-command?tabs=bash).

## Create virtual appliance and download installation files

To create a virtual appliance and download the required files for your on-premises installation, follow these steps:

1. Sign in to [the portal](https://portal.azure.com) and navigate to **Azure Local**. 
1. From the same browser session, click this [link](https://aka.ms/azurelocaldisconnectedoperationspreview)

    > [!NOTE]
    > If your subscription isn't approved for **Disconnected operations** any action (such as create) fails.

1. From the **Disconnected operations** tab, select the **Create** button.

    :::image type="content" source="media/disconnected-operations/set-up/azure-local-page.png" alt-text="Screenshot of Azure Local for Disconnected operations page." lightbox="media/disconnected-operations/set-up/azure-local-page.png":::

1. On the **Basics** tab, complete these required fields:  

    | Field               | Description                                                              |  
    |---------------------|--------------------------------------------------------------------------|  
    | **Subscription**    | The subscription where you want to place the resource.                   |  
    | **Resource group**  | The resource group where you want to place the resource.                 |  
    | **Virtual appliance name** | The name to identify your disconnected operations appliance. For example, *no-site-1*. |  
    | **Region**          | The Azure region where you want to place the metadata. There's no metadata from the on-premises installation itself. This is used for billing and support purposes. |  
    | **Outbound connectivity** | Select how you intend to deploy your disconnected operations appliance: <br></br> **Option 1: Limited connectivity** </br> Use this option if you want the appliance to be connected to Azure. This option: <br></br> - Simplifies management and supportability, should you require it. <br></br> - Only requires that the appliance is able to connect. <br></br> - Allows Azure Local instances to use the local control plane provided by the appliance. <br></br> **Option 2: Air-gapped** </br></br> Use this option if you have no way of connecting to Azure. This option: <br></br> - Works air-gapped. <br></br> - Allows you to transfer necessary files in and out of the environment so you can get updates and send logs, if necessary. |

    :::image type="content" source="media/disconnected-operations/set-up/basics-page.png" alt-text="Screenshot of the Basics page and required fields to create a virtual appliance." lightbox="media/disconnected-operations/set-up/basics-page.png":::

1. Select **Review + create**, check that the validation succeeds, then select the **Create** button.  

    :::image type="content" source="media/disconnected-operations/set-up/create-validation.png" alt-text="Screenshot of the validation page to create your virtual appliance resource." lightbox="media/disconnected-operations/set-up/create-validation.png":::

1. After the deployment finishes, go to your new resource. You see the resource details on the appliance page.

    > [!NOTE]
    > For the next two steps, see the supplemental documentation for getting the appliance. During the first preview, special instructions are required for downloading the appliance. Steps 6 and 7 are subject to change during preview.

1. Look for the **download manifest** and **get virtual appliance** actions. You need these files for your on-premises installation.

    | Action | Description | Estimated download size |  
    |------|-------------|----------------|  
    | Manifest file | Identified as `AzureLocal.DisconnectedOperations.Appliance.manifest`. This file is needed for deployment and to activate the appliance. It contains the required licensing information and more. | < 1 KB |  
    | Appliance | Shows a set of files you can download, identified as  `AzureLocal.disconnectedoperations.zip`, `ArcA_LocalData_A.vhdx`,`ArcA_SharedData_A.vhdx`, and`OSAndDocker_A.vhdx`. These files contain the virtual hard disks and virtual machine together with the operations module required to deploy and configure the virtual appliance as a whole. You can download each file individually or run the script provided on the page to automate the download. | 70 GB+ |  

1. Select **download manifest**.

    :::image type="content" source="media/disconnected-operations/set-up/new-appliance.png" alt-text="Screenshot of the resource page for the virtual appliance you created." lightbox="media/disconnected-operations/set-up/new-appliance.png":::

1. Select **get virtual appliance** and download each file in the list. This can take several hours. When completed, move these files to a single folder. Unzip the `AzureLocal.disconnectedoperations.zip` file in that folder. After you extract the zip file, delete it. You should have the following files required for installation in the folder after this step:

    - manifest.xml
    - OperationsModule
    - IRVM.zip
    - ArcA_LocalData_A.vhdx
    - ArcA_SharedData_A.vhdx
    - OSAndDocker_A.vhdx
    - Storage.json

    > [!NOTE]
    > To download files faster, select and run the script from the portal instead of downloading each file individually.

1. When the steps are complete, put all the files in a share or on portable media. You need these files during deployment.

### Download Azure Local ISO

1. Sign in to [the Portal](https://portal.azure.com) and navigate to **Azure Local**. 
1. Hit **download software**.
1. Download Local HCI OS.
1. Select a subscription where you've registered the `Microsoft.AzureStackHCI` resource provider.
1. Select the software version that's compatible with the preview version you're using.
1. Read the privacy notice and click **download**.

Make sure you have the ISO available to install on your Azure Local nodes.

### Review Azure local disconnected operations compatible versions

When you deploy a new system, use an Azure Local build that's compatible with your Azure Local disconnected operations build.

| Disconnected operations milestone | Disconnected operations build | Azure Local Build |  
|------|-------------|----------------|  
| M1 | 6.1064663200.16860 | AzureLocal24H2.26100.1742.LCM.10.2411.2.3003 |
| M2 | 7.1064837202.19761 | AzureLocal24H2.26100.1742.LCM.12.2506.0.3136 |
| 2508 | 8.1064855627.20050 | AzureLocal24H2.26100.1742.LCM.12.2506.0.3136 |
| 2509 | 9.1064929344.21347 | AzureLocal24H2.26100.1742.LCM.12.2508.0.3201 |
## Related content

- [Deploy disconnected operations for Azure Local](disconnected-operations-deploy.md)

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end

