---
title: Apply an original equipment manufacturer (OEM) update to Azure Stack | Microsoft Docs
description: Learn to apply an original equipment manufacturer (OEM) update to Azure Stack.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/15/2019
ms.author: mabrigg
ms.lastreviewed: 08/15/2019
ms.reviewer: ppacent 

---

# Prepare an Azure Stack update package

*Applies to: Azure Stack integrated systems*

As an Azure Stack operator, you can prepare an Azure Stack package to be updated through the update blade in Azure Stack so that you can validate the health of your system during the update process. This article looks at downloading an Azure Stack update package or OEM update package and importing the package to storage so that it can be accessed by the Azure Stack update provider.

## Download the update package

The update package for Azure Stack updates and hotfixes is available through the update blade for connected systems. You will need to download the package and move the package to a location that is accessible to your Azure Stack instance if you are updating an OEM package, or if you are supporting a disconnected system. You may also need to download and then upload the package to an accessible location if your are running a system with an intermittent connection.

Review the package contents. An update package typically consists of the following files:

-   A self-extracting &lt;PackageName&gt;.zip file. This file contains the payload for the update, for example, the latest cumulative update for Windows Server.

-   Corresponding &lt;PackageName&gt;.bin files. These files provide compression for the payload that's associated with the *PackageName*.zip file.

-   A Metadata.xml file. This file contains essential information about the update, for example, the publisher, name, prerequisite, size, and support path URL.

If you are using an integrated system before 1808, then you will need to download the package using these instructions.

> [!Important]  
> After the Azure Stack 1901 update package is applied, the packaging format for Azure Stack update packages will move from .zip, .bin(s), and .xml format to a .zip(s) and .xml format. Azure Stack operators that have connected stamps won't be impacted. Azure Stack operators that are disconnected will simply import the .xml and .zip file(s) by using the same process described below.

## Download update packages for integrated systems

Microsoft releases both full monthly update packages as well as hotfix packages to address specific issues.

### Microsoft software updates

Microsoft update packages for Azure Stack integrated systems typically release each month. Ask your original equipment manufacturer (OEM) about their specific notification process to ensure update notifications reach your organization. You can also check in this documentation library under **Overview** &gt; **Release notes** for information about releases that are in active support.

Each release of Microsoft software updates is bundled as a single update package. As an Azure Stack operator you can import, install, and monitor the installation progress of update packages from the Azure Stack administration portal.

Monthly update packages are hosted in a secure Azure endpoint. You can download them manually using the [*Azure Stack Updates downloader tool*](https://aka.ms/azurestackupdatedownload). If your instance is connected, the update appears automatically in the Administration portal as **Update available**.

Full, monthly update packages are well documented at each release. For more information about each release, you can click any release from the [*Update package release cadence*](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-servicing-policy#update-package-release-cadence) section of this article.

### Microsoft hotfixes. 

Hotfix update packages are hosted in the same secure Azure endpoint. You can download them using the embedded links in each of the respective hotfix KB articles; for example, [Azure Stack hotfix 1.1906.11.52](https://support.microsoft.com/help/4515650). Similar to the full, monthly update packages, Azure Stack operators can download the .xml, .bin and .exe files and import them using the procedure in [*Apply updates in Azure Stack*](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-apply-updates). Azure Stack operators with connected instances will see the hotfixes automatically appear in the Administration portal with the message **Update available**.

### OEM hardware vendor-provided updates

Your OEM vendor will also release updates, such as driver and firmware updates. While these updates are delivered as separate packages by vendor, some are imported, installed, and managed the same way as update packages from Microsoft. You can find a list of vendor contact links at "[Apply Azure Stack original equipment manufacturer (OEM) updates](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-update-oem#oem-contact-information)".

To keep your system under support, you must keep Azure Stack updated to a specific version level. Make sure that you review the [*Azure Stack servicing policy*](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-servicing-policy).

## Import and install updates

The following procedure shows how to import and install update packages in the administration portal.

> [!Important]  
> We strongly recommend that you notify users of any maintenance operations, and that you schedule normal maintenance windows during non-business hours as much as possible. Maintenance operations may affect both user workloads and portal operations.

1.  In the administration portal, select **All services**. Then, under the **DATA + STORAGE** category, select **Storage accounts**. (Or, in the filter box, start typing **storage accounts**, and select it.)

> ![](media\azure-stack-update-prepare-package/media/image1.png)

1.  In the filter box, type **update**, and select the **updateadminaccount** storage account.

2.  In the storage account details, under **Services**, select **Blobs**.

> ![](media\azure-stack-update-prepare-package/media/image2.png)

1.  Under **Blob service**, select **+ Container** to create a container. Enter a name (for exampl *update-1811*) and then select **OK**.

> ![](media\azure-stack-update-prepare-package/media/image3.png)

1.  After the container is created, click the container name, and then click **Upload** to upload the package files to the container.

> ![](media\azure-stack-update-prepare-package/media/image4.png)

1.  Under **Upload blob**, click the folder icon, browse to the update package's .zip file and then click **Open** in the file explorer window.

2.  Under **Upload blob**, click **Upload**.

> ![](media\azure-stack-update-prepare-package/media/image5.png)

1.  Repeat steps 6 and 7 for the *PackageName*.bin and Metadata.xml files. Do not import the Supplemental Notice.txt file if included. Note the files will be .zip starting at 1901 as opposed to .bin and .zip - continue to import the .xml as usual.

2.  When done, you can review the notifications (bell icon in the top-right corner of the portal). The notifications should indicate that the upload has completed.

3.  Navigate back to the Update blade on the dashboard. The blade should indicate that an update is available. Click the blade to review the newly added update package.

4.  To install the update, select the package that's marked as **Ready** and either right-click the package and select **Update now**, or click the **Update now** action near the top.

5.  When you click the installing update package, you can view the status in the **Update run details** area. From here, you can also click **Download summary** to download the log files. Logs from update runs are available for 6 months after the attempt ended.

6.  When the update completes, the Update blade shows the updated Azure Stack version.

You can manually delete updates from the storage account after they have been installed on Azure Stack. Azure Stack periodically checks for older update packages and removes them from storage. It may take Azure Stack two weeks to remove the old packages.

## Next steps

Apply the update
