---
title: Download the Azure Stack HCI operating system
description: Learn how to download the Azure Stack HCI OS from the Azure portal.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/20/2023
---

# Download the Azure Stack HCI operating system

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to download the Azure Stack HCI operating system (OS) from the Azure portal.

The first step in deploying Azure Stack HCI is to download Azure Stack HCI OS from the Azure portal. The software download includes a free 60-day trial.

> [!NOTE]
> If you've purchased Azure Stack HCI Integrated System solution hardware from the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the Azure Stack HCI OS should be pre-installed. In that case, you can skip this step and move on to [Create an Azure Stack HCI cluster](create-cluster.md).

## Download the Azure Stack HCI OS from the Azure portal

Follow these steps to download the Azure Stack HCI OS:

1. Sign in to the [Azure portal](https://portal.azure.com/) with your Azure account credentials.
1. From the **Home** page, go to **Azure Arc** > **Azure Stack HCI**.
1. On the **Get started** page, select **Download Azure Stack HCI**.

    :::image type="content" source="media/download-operating-system/get-started-page-with-download-button.png" alt-text="Screenshot of the Get started page with the option to download the Azure Stack HCI OS." lightbox="media/download-operating-system/get-started-page-with-download-button.png":::
    
1. On the **Download Azure Stack HCI** context page displays on the right:
 do the following:
    1. Choose software version. By default, the latest generally available version of Aure Stack HCI is selected.
    1. Choose language from the dropdown list.
    1. Review the privacy statement.
    1. Select the license terms and privacy notice checkbox.
    1. Select the **Download Azure Stack HCI** button. This action downloads an ISO file. Use this ISO file to install the operating system on each server that you want to cluster.

    :::image type="content" source="media/download-operating-system/download-azure-stack-hci-page.png" alt-text="Screenshot of the Download Azure Stack HCI page." lightbox="media/download-operating-system/download-azure-stack-hci-page.png":::

## Next steps

To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Deploy the Azure Stack HCI OS](operating-system.md)
