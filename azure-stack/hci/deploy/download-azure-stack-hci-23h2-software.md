---
title: Download Azure Stack HCI, version 23H2 software (preview)
description: Learn how to download Azure Stack HCI, version 23h2 software from the Azure portal  (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/13/2023
---

# Download Azure Stack HCI, version 23H2 software (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to download the Azure Stack HCI, version 23H2 software from the Azure portal.

The first step in deploying Azure Stack HCI, version 23H2 is to download Azure Stack HCI software from the Azure portal. The software download includes a free 60-day trial. However, if you've purchased Azure Stack HCI Integrated System solution hardware from the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the Azure Stack HCI software should be pre-installed. In that case, you can skip this step and move on to [Register your servers and assign permissions for Azure Stack HCI deployment](./deployment-arc-register-server-permissions.md).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin the download of Azure Stack HCI, version 23H2 software, ensure that you have the following prerequisites:

- An Azure account. If you don’t already have an Azure account, first [create an account](https://azure.microsoft.com/free/).
- An Azure subscription. You can use an existing subscription of any type:

   - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
   - [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
   - Subscription obtained through an Enterprise Agreement (EA).
   - Subscription obtained through the Cloud Solution Provider (CSP) program.

## Download the Azure Stack HCI software from the Azure portal

Follow these steps to download the Azure Stack HCI software:

1. If not already signed in, sign in to the [Azure portal](https://portal.azure.com/) with your Azure account credentials.
1. In the Azure portal search bar at the top, enter **Azure Stack HCI**. As you type, the portal starts suggesting related resources and services based on your input. Select **Azure Stack HCI** under the **Services** category.

    :::image type="content" source="media/download-azure-stack-hci-23h2-software/search-azure-stack-hci.png" alt-text="Screenshot that shows how to search for Azure Stack HCI." lightbox="media/download-azure-stack-hci-23h2-software/search-azure-stack-hci.png":::

    After you select **Azure Stack HCI**, you're directed to the Azure Stack HCI **Get started** page, with the **Get started** tab selected by default.

1. On the **Get started** tab, under the **Download software** tile, select **Download Azure Stack HCI**.

    :::image type="content" source="media/download-azure-stack-hci-23h2-software/get-started-page-with-download-button.png" alt-text="Screenshot of the Get started page with the option to download the Azure Stack HCI OS." lightbox="media/download-azure-stack-hci-23h2-software/get-started-page-with-download-button.png":::
    
1. On the **Download Azure Stack HCI** page on the right, do the following:
    1. Choose software version. By default, the latest generally available version of Azure Stack HCI is selected.
    1. Choose language from the dropdown list. Select **English** to download the English version of the software. 
    
        We recommend that you use the ISO for the language you wish to install in. You should download a VHDX only if you are performing virtual deployments. To download the VHDX in English, select **English VHDX** from the dropdown list.
    1. Select the **Azure Stack HCI, version 23H2 (Preview)** option.
    1. Review service terms and privacy notice. <!--link to privacy statement-->
    1. Select the license terms and privacy notice checkbox.
    1. Select the **Download Azure Stack HCI** button. This action begins the download. Use the downloaded ISO file to install the software on each server that you want to cluster.

        :::image type="content" source="media/download-azure-stack-hci-23h2-software/download-azure-stack-hci-23h2-software.png" alt-text="Screenshot of the Download Azure Stack HCI version 23H2 page." lightbox="media/download-azure-stack-hci-23h2-software/download-azure-stack-hci-23h2-software.png":::

## Next steps

- [Install the Azure Stack HCI, version 23H2 operating system](./deployment-install-os.md).
