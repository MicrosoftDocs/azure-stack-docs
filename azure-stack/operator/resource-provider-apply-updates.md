---
title: Apply updates to an Azure Stack Hub resource provider
description: Learn how to apply a service update to a resource provider on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 04/02/2021
ms.reviewer: jfggdl
ms.lastreviewed: 04/02/2021
zone_pivot_groups: state-connected-disconnected
---

# How to update an Azure Stack Hub resource provider

> [!IMPORTANT]
> Before continuing, be sure to review the resource provider's latest release notes to learn about new functionality, fixes, and any known issues that could affect your deployment. The release notes may also specify the minimum Azure Stack Hub version required for the resource provider. If you've never installed the resource provider previously, refer to the resource provider's prerequisites and initial install instructions instead.

Resource providers that are installed from Marketplace will require regular servicing. Servicing is done by applying service updates, provided by Microsoft on a regular basis. Updates can include both new features and fixes.  

## Check for updates

Resource providers are updated using the same update feature that is used to apply Azure Stack Hub updates.

1. Sign in to the Azure Stack Hub administrator portal.
2. Select the **All services** link on the left, then under the **Administration** section select **Updates**.
   [![All services page](media/resource-provider-apply-updates/1-all-services.png)](media/resource-provider-apply-updates/1-all-services.png#lightbox)

3. On the **Updates** page, you find updates for the resource providers under the **Resource provider** section, with **State** showing "Available".

   [![Screenshot that shows the Resource Provider section.](media/resource-provider-apply-updates/3-update-available.png)](media/resource-provider-apply-updates/3-update-available.png#lightbox)

## Download package

[!INCLUDE [prereqs](../includes/resource-provider-va-package-download-common.md)]

::: zone pivot="state-connected"
For a connected scenario, you download the update directly from Azure Marketplace:

1. From the **Resource provider** section of the **Updates** page, select the row of the resource provider you want to update. Notice the **Download** link at the top of the page becomes enabled.
   [![Update available page](media/resource-provider-apply-updates/4-download.png)](media/resource-provider-apply-updates/3-update-available.png#lightbox)

2. Click the **Download** link to begin the download of the resource provider install package. Notice the **State** column for the resource provider row change from "Available" to "Downloading".
3. When the **State** changes to "Ready to install", the download is complete. 
::: zone-end

::: zone pivot="state-disconnected" 
[!INCLUDE [prereqs](../includes/resource-provider-va-package-download-disconnected.md)]
::: zone-end

## Apply an update

Once the resource provider package has been downloaded, return to the **Resource provider** section of the **Updates** page:

1. Select the row of the resource provider you want to update. The **State** will now show "Ready to install", and the **Install now** link at the top of the page becomes enabled.
2. Select the **Install now** link and you're taken to the **Install** page for the resource provider. 
3. Select the **Install** button to begin the installation.
4. An "Installation in progress" notification will be shown in the upper right, and you return to the **Updates** page. The resource provider row **Status** column also changes to "Installing".
5. When installation is complete, another notification will indicate success or failure. A successful installation will also update the **Version** on the **Marketplace management - Resource providers** page.

## Next steps

Learn more about the [administrator dashboard updates feature](azure-stack-apply-updates.md).
