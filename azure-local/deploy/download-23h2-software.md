---
title: Download Azure Stack HCI Operating System, version 23H2 software for Azure Local deployment
description: Learn how to download Azure Local, version 23H2 software from the Azure portal to deploy an Azure Local instance.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 09/24/2025
---

# Download operating system for Azure Local deployment

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to download the operating system (OS) software from the Azure portal to deploy an Azure Local instance.

The first step in deploying Azure Local is to download the OS from the Azure portal. The software download includes a free 60-day trial. However, if you've purchased Integrated System solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS should be preinstalled. In that case, you can skip this step and move on to [Register your machines and assign permissions for Azure Local deployment](./deployment-arc-register-server-permissions.md).

## Prerequisites

Before you begin the download of the software from Azure portal, ensure that you have the following prerequisites:

- An Azure account. If you don’t already have an Azure account, first [create an account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- An Azure subscription. You can use an existing subscription of any type:

   - Free account with Azure credits [for students](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
   - [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
   - Subscription obtained through an Enterprise Agreement (EA).
   - Subscription obtained through the Cloud Solution Provider (CSP) program.
   - At a minimum, you'll need **Reader** access at the subscription level.

- Register the Microsoft Azure Stack HCI resource provider to access the Azure Local OS image download. For instructions on registering via PowerShell or the Azure portal, see [Register required resource providers](deployment-arc-register-server-permissions.md#azure-prerequisites) in the Azure prerequisites section, or refer to [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).

## Download the software from the Azure portal

> [!IMPORTANT]
> English is the only supported language for the deployment.

Follow these steps to download the software:

1. If not already signed in, sign in to [Azure portal](https://ms.portal.azure.com/) with your Azure account credentials.
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

## Next steps

- [Install the Azure Stack HCI operating system](./deployment-install-os.md).
