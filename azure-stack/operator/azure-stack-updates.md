---
title: Manage updates 
description: Learn how to manage updates in Azure Stack Hub
author: IngridAtMicrosoft

ms.topic: how-to
ms.date: 03/04/2020
ms.author: inhenkel
ms.lastreviewed: 09/10/2019
ms.reviewer: ppacent

# Intent: As an Azure Stack Hub operator, I want to manage updates so I can keep everything up to date.
# Keyword: manage updates azure stack hub

---


# Manage updates in Azure Stack Hub

Full and express updates, hotfixes, as well as driver and firmware updates from the original equipment manufacturer (OEM) all help keep Azure Stack Hub up to date. This article explains the different types of updates, when to expect their release, and where to find more about the current release.

> [!Note]  
> You can't apply Azure Stack Hub update packages to the Azure Stack Development Kit (ASDK). The update packages are designed for integrated systems. For information, see [Redeploy the ASDK](https://docs.microsoft.com/azure-stack/asdk/asdk-redeploy).

## Update package types

There are three types of update packages for integrated systems:

- **Azure Stack Hub software updates**. Microsoft is responsible for the end-to-end servicing lifecycle for the Microsoft software update packages. These packages can include the latest Windows Server security updates, non-security updates, and Azure Stack Hub feature updates. You download theses update packages directly from Microsoft.

    Each update package has a corresponding type: **Full** or **Express**.

    **Full** update packages update the physical host operating systems in the scale unit and require a larger maintenance window.

    **Express** update packages are scoped and don't update the underlying physical host operating systems.

- **Azure Stack Hub hotfixes**. Microsoft provides hotfixes for Azure Stack Hub that address a specific issue that's often preventive or time-sensitive. Each hotfix is released with a corresponding Microsoft Knowledge Base article that details the issue, cause, and resolution. You download and install hotfixes just like the regular full update packages for Azure Stack Hub. Hotfixes are cumulative and can install in minutes.

- **OEM hardware-vendor-provided updates**. Azure Stack Hub hardware partners are responsible for the end-to-end servicing lifecycle (including guidance) for the hardware-related firmware and driver update packages. In addition, Azure Stack Hub hardware partners own and maintain guidance for all software and hardware on the hardware lifecycle host. The OEM hardware vendor hosts these update packages on their own download site.

## When to update

The three types of updates are released with the following cadence:

- **Azure Stack Hub software updates**. Microsoft typically releases software update packages each month.

- **Azure Stack Hub hotfixes**. Hotfixes are time-sensitive releases that can be released at any time.

- **OEM hardware vendor-provided updates**. OEM hardware vendors release their updates on an as-needed basis.

To continue to receive support, you must keep your Azure Stack Hub environment on a supported Azure Stack Hub software version. For more information, see [Azure Stack Hub Servicing Policy](azure-stack-update-servicing-policy.md).

## Where to get notice of an update

Notice of updates varies on a couple of factors, such as your connection to the internet and the type of update.

- **Microsoft software updates and hotfixes**

    An update alert for Microsoft software updates and hotfixes will appear in the **Update** blade for Azure Stack Hub instances that are connected to the internet. If the **Update** blade isn't displayed, restart the infrastructure management controller VM.

    If your instance isn't connected and you would like to be notified about each hotfix release, subscribe to the [RSS](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/rss) or [ATOM](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/atom) feed.

- **OEM hardware vendor-provided updates**

    OEM updates will depend on your manufacturer. You'll need to establish a communication channel with your OEM so that you can be aware of updates from your OEM that need to be applied. For more information about the OEMs and the OEM update process, see [Apply Azure Stack Hub original equipment manufacturer (OEM) updates](azure-stack-update-oem.md).

## Update processes

Once you know you have an update, apply it by using the following steps.

![Azure Stack Hub update process](./media/azure-stack-updates/azure-stack-update-process.png)

1. **Plan for the update**.

    Prepare your Azure Stack Hub to make the update process go as smoothly as possible so that there's minimal impact on your users. Notify your users of any possible service outage and then follow the steps to prepare your instance for the update. Be sure to follow **ALL** steps in [Azure Stack Hub pre-update checklist](release-notes-checklist.md) to ensure that you've completed the required presteps for applying an update. Also make sure to schedule an appropriate maintenance window for the update type being applied.

2. **Upload and prepare the update package**.

    For internet-connected Azure Stack Hub environments, Azure Stack Hub software updates and hotfixes are automatically imported into the system and prepared for update.

    For internet-disconnected Azure Stack Hub environments and environments with weak or intermittent internet connectivity, update packages are imported into Azure Stack Hub storage via the Azure Stack Hub administrator portal. For more steps to upload and prepare the update package, see [Upload and prepare an Azure Stack Hub update package](azure-stack-update-prepare-package.md).

    All OEM update packages are manually imported into your environment, regardless of your Azure Stack Hub system's internet connectivity. For more steps to import and prepare the update package, see [Upload and prepare an Azure Stack Hub update package](azure-stack-update-prepare-package.md).

3. **Apply the update**.

    Apply the update using the **Update** blade in Azure Stack Hub. During the update, monitor and troubleshoot the update progress. For more information, see [Apply an Azure Stack Hub update](azure-stack-apply-updates.md).

## The update resource provider

Azure Stack Hub includes an update resource provider that handles the application of Microsoft software updates. This provider checks that updates are applied across all physical hosts, Service Fabric apps and runtimes, and all infrastructure virtual machines and their associated services.

As updates install, you can view high-level status as the update process targets the various subsystems in Azure Stack Hub (for example, physical hosts and infrastructure virtual machines).

## Next steps

- To begin the update process, follow the steps in see [Azure Stack Hub update activity checklist](release-notes-checklist.md).
- To learn what versions of Azure Stack Hub are in support, see [Azure Stack Hub Servicing Policy](azure-stack-servicing-policy.md).  
- To learn more about the current and recent updates, see the [Azure Stack Hub release notes](release-notes.md).
