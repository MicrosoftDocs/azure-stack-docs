---
title: Download Azure Stack HCI Operating System software for Azure Local deployment
description: Learn how to download Azure Stack HCI operating system from the Azure portal to deploy an Azure Local instance.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.date: 05/04/2026
ms.subservice: hyperconverged
---

# Download operating system for Azure Local deployment

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to download the operating system (OS) software from the Azure portal to deploy an Azure Local instance.

The first step in deploying Azure Local is to download the OS from the Azure portal. The software download includes a free 60-day trial.

If you purchase Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through a Microsoft hardware partner or original equipment manufacturer (OEM), the Azure Stack HCI OS is typically preinstalled. In this case, use the preinstalled OS or the latest OEM golden image instead of downloading an image from the Azure portal. You can then skip this step and continue to [Register your machines and assign permissions for Azure Local deployment](./deployment-arc-register-server-permissions.md).

## Prerequisites

Before you download the software from the Azure portal, ensure you meet the following prerequisites if your OEM doesn't provide an image or if you're deploying in a lab environment:

| Prerequisite | Instructions |
|--------------|------------------|
| Azure tenant | If you don’t already have an Azure tenant, create one. <br>  Before creating a new tenant, confirm that your organization doesn’t already have one to avoid unmanaged (shadow) tenants and potential governance or licensing issues. <br><br> You can create an Azure tenant by signing in with your Microsoft personal, work, or school account and obtaining a free [PowerBI license](https://app.powerbi.com/home). The user who creates the tenant is assigned the Global Administrator role. <br><br> If your organization already has an Azure tenant, consult your IT department to determine whether Azure Local should be deployed in the existing tenant or in a new tenant to meet governance and licensing requirements. To create a new tenant, see [Create a new tenant](/entra/fundamentals/create-new-tenant?tabs=workforce). |
| Azure account |  If you don’t already have an Azure account, first [create an account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn). |
| Azure subscription | You can use a new or existing subscription of any type: <br> - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/?cid=msft_learn) <br> - [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/) or <br> - Pay-as-you-go subscription with credit card or <br> - Azure Subscription obtained through an Enterprise Agreement (EA) or <br> - Azure Subscription obtained through the Cloud Solution Provider (CSP) program or <br> - Other eligible Azure Subscription types containing Azure (Extended) Credits. |
| RBAC permissions | At a minimum, you need Reader access at the subscription level. Additional RBAC requirements are specified throughout the resource provider registration and deployment guidance. |
| Resource provider registration | Before downloading, register the Azure Stack HCI resource provider (`Microsoft.AzureStackHCI`) to access the OS image download. <br><br> For instructions on registering via Azure PowerShell in the Azure portal, see **Register required resource providers** in the [Azure prerequisites](./deployment-arc-register-server-permissions.md#azure-prerequisites) section. <br><br>For general information about Azure resource provider registration, see [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider). |

## Key considerations

- English is the only supported deployment language.
- Ensure that you have the required permissions and that the necessary resource providers are registered. Otherwise, the option to download the Azure Stack HCI OS might not be available.
- OEM providers for Integrated and Premier solutions typically provide custom images. When deploying or redeploying, use the latest OEM image provided by your hardware vendor to ensure that the required drivers and configurations are included for supportability and best practices. For more information, see [Obtain OEM golden images](#obtain-oem-golden-images).

## Download the software from the Azure portal

Follow these steps to download the software:

1. If not already signed in, sign in to [Azure portal](https://portal.azure.com/) with your Azure account credentials.
1. In the Azure portal search bar at the top, enter **Azure Local**. As you type, the portal starts suggesting related resources and services based on your input. Select **Azure Local** under the **Services** category.

    :::image type="content" source="media/download-23h2-software/search-software.png" alt-text="Screenshot that shows how to search for Azure Local." lightbox="media/download-23h2-software/search-software.png":::

    After you select **Azure Local**, you're directed to the Azure Local **Get started** page, with the **Get started** tab selected by default.

1. On the **Get started** tab, under the **Download software** tile, select **Download**. Skip this step if your Azure Local instance came installed with the OS.

    :::image type="content" source="media/download-23h2-software/get-started-page-with-download-button.png" alt-text="Screenshot of the Get started page with the option to download the Azure Stack HCI OS." lightbox="media/download-23h2-software/get-started-page-with-download-button.png":::
    
1. On the **Download Azure Stack HCI** page, do the following:

    1. Select the subscription in which you intend to deploy Azure Local. Ensure that the selected subscription has the Microsoft Azure Stack HCI resource provider registered and which you have **Reader** access at a minimum.

    :::image type="content" source="media/download-23h2-software/download-azure-stack-hci.png" alt-text="Screenshot of the Download Azure Stack HCI OS version 23H2 page showing step 1." lightbox="media/download-23h2-software/download-azure-stack-hci.png":::

    2. Select your desired version. Only the recommended version is eligible for deployment using Azure portal. To deploy a previous version, use an [Azure Resource Manager template](deployment-azure-resource-manager-template.md).
    
    3. Select **I agree with Azure Local license terms and privacy notice** and then select **Download**.
    
    :::image type="content" source="media/download-23h2-software/download-azure-stack-hci-step-2.png" alt-text="Screenshot of the Download Azure Stack HCI OS version 23H2 page showing step 2." lightbox="media/download-23h2-software/download-azure-stack-hci-step-2.png":::

    > [!NOTE]
    > This action begins the download. Use the downloaded ISO file to install the software on each machine that you want to cluster.

## Obtain OEM golden images

| OEM | Download location |
|--------------|------------------|
| DELL EMC | [Download location](https://dell.github.io/azurestack-docs/docs/hci/supportmatrix/2509/goldenimages/). |
| HPE | Contact your HPE support channel or OEM representative. |
| Lenovo | Contact your Lenovo support channel or OEM representative. |

## Next steps

- [Install the Azure Stack HCI operating system](./deployment-install-os.md).