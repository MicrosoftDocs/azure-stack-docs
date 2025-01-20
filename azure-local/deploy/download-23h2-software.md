---
title: Download Azure Stack HCI Operating System, version 23H2 software for Azure Local deployment
description: Learn how to download Azure Local, version 23H2 software from the Azure portal to deploy an Azure Local instance.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/06/2024
---

# Download version 23H2 operating system for Azure Local deployment

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to download the operating system (OS) software from the Azure portal to deploy an Azure Local instance.

The first step in deploying Azure Local, version 23H2 is to download the OS from the Azure portal. The software download includes a free 60-day trial. However, if you've purchased Integrated System solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS should be preinstalled. In that case, you can skip this step and move on to [Register your machines and assign permissions for Azure Local deployment](./deployment-arc-register-server-permissions.md).

## Prerequisites

Before you begin the download of the software from Azure portal, ensure that you have the following prerequisites:

- An Azure account. If you don’t already have an Azure account, first [create an account](https://azure.microsoft.com/free/).
- An Azure subscription. You can use an existing subscription of any type:

   - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
   - [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
   - Subscription obtained through an Enterprise Agreement (EA).
   - Subscription obtained through the Cloud Solution Provider (CSP) program.

## Download the software from the Azure portal

> [!IMPORTANT]
> English is the only supported language for the deployment.

Follow these steps to download the software:

1. If not already signed in, sign in to the [Azure portal](https://portal.azure.com/) with your Azure account credentials.
1. In the Azure portal search bar at the top, enter **Azure Local**. As you type, the portal starts suggesting related resources and services based on your input. Select **Azure Local** under the **Services** category.

    :::image type="content" source="media/download-23h2-software/search-software.png" alt-text="Screenshot that shows how to search for Azure Local." lightbox="media/download-23h2-software/search-software.png":::

    After you select **Azure Local**, you're directed to the Azure Local **Get started** page, with the **Get started** tab selected by default.

1. On the **Get started** tab, under the **Prepare machines** tile, select **Download software**. Skip this step if your Azure Local instance came installed with the OS.

    :::image type="content" source="media/download-23h2-software/get-started-page-with-download-button.png" alt-text="Screenshot of the Get started page with the option to download the Azure Stack HCI OS." lightbox="media/download-23h2-software/get-started-page-with-download-button.png":::
    
1. On the **Download Azure Local software** page on the right, do the following:

    :::image type="content" source="media/download-23h2-software/download-23h2-software-2.png" alt-text="Screenshot of the Download Azure Stack HCI OS version 23H2 page with the various ISO options." lightbox="media/download-23h2-software/download-23h2-software-2.png":::

    1. Choose software version. By default, the latest generally available version is selected.
    1. Select **English** to download the English version of the ISO. To download the VHDX, select **English VHDX** from the dropdown list.
        > [!NOTE]
        > - Currently, English is the only language that is supported.
        > - Download an **English VHDX** if you are performing [Virtual deployments](./deployment-virtual.md) for educational and demonstration purposes only.
        > - Download **English Preview** only if you are participating in the Azure Local preview program. The**English** and **English VHDX** options are not available for preview versions.

    1. Select the **Azure Stack HCI OS, version 23H2** option.
        > [!NOTE]
        > The ISO that you download is OS version 25398.469. This ISO is then patched to the latest OS version during the installation process.
    1. Review service terms and privacy notice.
    1. Select the license terms and privacy notice checkbox.
    1. Select **Download software**. This action begins the download. Use the downloaded ISO file to install the software on each machine that you want to cluster.

        :::image type="content" source="media/download-23h2-software/download-23h2-software-1.png" alt-text="Screenshot of the Download Azure Stack HCI version 23H2 page." lightbox="media/download-23h2-software/download-23h2-software-1.png":::

## Next steps

- [Install the Azure Stack HCI operating system, version 23H2 ](./deployment-install-os.md).
