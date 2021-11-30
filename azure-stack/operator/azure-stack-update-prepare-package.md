---
title: Prepare update package in Azure Stack Hub
description: Learn to prepare an update package in Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 11/24/2021
ms.author: sethm
ms.lastreviewed: 03/10/2021
ms.reviewer: sranthar

# Intent: As an Azure Stack Hub operator, I want to prepare an update package so I can use it to update my Azure Stack Hub environment.
# Keyword: prepare update package azure stack hub

---

# Prepare an Azure Stack Hub update package

This article provides an overview of preparing Azure Stack Hub update packages so they can be used to update your Azure Stack Hub environment. This process consists of the following steps:

- [Download the update package](#download-the-update-package).
- [Import the update package into your Azure Stack Hub environment using the Azure Stack Hub administrator portal](#import-and-install-updates).

On systems that can connect to the automatic update endpoints, Azure Stack Hub software updates and hotfixes are automatically downloaded and prepared. On systems without connectivity, and for any update from the original equipment manufacturer (OEM), the update package must be prepared as explained in this article.  

The following table shows when update packages require manual preparation and when they're prepared automatically.

| Update Type | Connectivity | Action Required |
| --- | --- | --- |
| Azure Stack Hub software updates | Connected | Update is automatically downloaded and prepared when the update is applied. |
| Azure Stack Hub hotfixes | Connected | Update is automatically downloaded and prepared when the update is applied. |
| OEM package updates | Connected | The update package must be prepared. Follow the steps in this article. |
| Azure Stack Hub software updates | Disconnected or weak connection | The update package must be prepared. Follow the steps in this article. |
| Azure Stack Hub hotfixes | Disconnected or weak connection | The update package must be prepared. Follow the steps in this article. |
| OEM package updates | Disconnected or weak connection | The update package must be prepared. Follow the steps in this article. |

## Download the update package

The update package for Azure Stack Hub updates and hotfixes is available for connected systems through the update blade in the portal. Download the package and move the package to a location that's accessible to your Azure Stack Hub instance if you're updating an OEM package or if you're supporting a disconnected system. You also might need to download and then upload the package to an accessible location if you're running a system with an intermittent connection.

Review the package contents. An update package typically consists of the following files:

- One or more **.zip** files named **\<PackageName\>.zip**. These files contain the payload for the update.
- A **metadata.xml** file. This file contains essential information about the update; for example, the publisher, name, prerequisite, size, and support path URL.

SHA256 hashes are computed for the .zip file(s) with update package content and inserted into the metadata.xml associated with the package. The **metadata.xml** file itself is signed with an embedded signature using a certificate trusted by the Azure Stack Hub system.

### Automatic download and preparation for update packages

Azure Stack Hub software updates and hotfixes are prepared automatically for systems with connectivity to the **Azure Stack Hub automatic update endpoints**: `https://*.azureedge.net` and `https://aka.ms/azurestackautomaticupdate`. For more information about setting up connectivity to the **Azure Stack Hub automatic update endpoints**, see the **Patch and Update** endpoints described in [Azure Stack Hub firewall integration](./azure-stack-integrate-endpoints.md#ports-and-urls-outbound).

### Where to download Azure Stack Hub update packages

Azure Stack Hub updates for [full and express updates](./azure-stack-updates.md#update-package-types) are hosted at a secure Azure endpoint. When updates become available, Azure Stack Hub operators with connected instances will see the [Azure Stack Hub updates automatically appear in the administrator portal](#automatic-download-and-preparation-for-update-packages).

For disconnected systems or systems with weak internet connectivity, *full* update packages can be downloaded using the [Azure Stack Hub updates downloader tool](https://aka.ms/azurestackupdatedownload). Hotfix packages can be downloaded from the hotfix KB link listed in [Azure Stack Hub release notes](release-notes.md). Azure Stack Hub software update packages may contain updates to Azure Stack Hub services and updates to the operating system of your Azure Stack Hub's scale units.

>[!NOTE]
>The update package itself and its contents (such as binaries, PowerShell scripts, and so on) are signed with Microsoft-owned certificates. Tampering with the package will make the signature invalid.

### Where to download Azure Stack Hub hotfix packages

Packages for [Azure Stack Hub hotfixes](./azure-stack-updates.md#update-package-types) are hosted in the same secure Azure endpoint as Azure Stack Hub updates. Azure Stack Hub operators with connected instances will see the [Azure Stack Hub updates automatically appear in the administrator portal](#automatic-download-and-preparation-for-update-packages) when they become available. You can download them using the embedded links in each of the respective hotfix KB articles. You can also find links to hotfix KB articles in the release notes corresponding to your Azure Stack Hub version.

### Where to download OEM update packages

Your OEM vendor might also release updates, such as driver and firmware updates. While these updates are delivered as separate [OEM package updates](./azure-stack-updates.md#update-package-types) by your hardware vendor, they're still imported, installed, and managed the same way as update packages from Microsoft. You can find a list of vendor contact links in the article [Apply Azure Stack Hub OEM updates](./azure-stack-update-oem.md#oem-contact-information).

## Import and install updates

The following procedure shows how to import and install update packages in the administrator portal.

> [!IMPORTANT]  
> Notify users of any maintenance operations, and ensure you schedule normal maintenance windows during non-business hours as much as possible. Maintenance operations can affect both user workloads and portal operations.

1. In the administrator portal, select **All services**. Then, under the **STORAGE** category, select **Storage accounts**. Or, in the filter box, start typing **storage accounts**, and then select it.

    [![Azure Stack Hub update](./media/azure-stack-update-prepare-package/select-storage-small.png)](./media/azure-stack-update-prepare-package/select-storage.png#lightbox)

2. In the filter box, type **update**, and select the **updateadminaccount** storage account.

3. In **All services**, under **Essentials** or **Blob service**, select **Containers**.

    [![Azure Stack Hub update - blob](./media/azure-stack-update-prepare-package/select-containers-small.png)](./media/azure-stack-update-prepare-package/select-containers.png#lightbox)

4. In **Containers**, select **+ Container** to create a container. Enter a name (for example, **update-2102**), and then select **Create**.

    [![Azure Stack Hub update - container](./media/azure-stack-update-prepare-package/new-container-small.png)](./media/azure-stack-update-prepare-package/new-container.png#lightbox)

5. After the container is created, select the container name, and then select **Upload** to upload the package files to the container.

    [![Azure Stack Hub update - upload](./media/azure-stack-update-prepare-package/upload-package-small.png)](./media/azure-stack-update-prepare-package/upload-package.png#lightbox)

6. Under **Upload blob**, select the folder icon, browse to the update package .zip file, and then select **Open** in the file explorer window.

7. Under **Upload blob**, select **Upload**.

    ![Azure Stack Hub update - upload blob](./media/azure-stack-update-prepare-package/upload-blob.png)

8. Repeat steps 6 and 7 for the **Metadata.xml** file and any additional .zip files in the update package. Don't import the **Supplemental Notice.txt** file if included.

9. When done, you can review the notifications (select the bell icon in the top-right corner of the portal). A notification should indicate that the upload has finished.

10. Go back to the **Update** blade on the dashboard. The blade should show that an update is available. This indicates that the update has been prepared successfully. Select the blade to review the newly-added update package.

11. Verify no updates are running. If an update is installing, an alert banner displays *The exclusive operation is in progress. Additional update operations are disabled while the operation is running*. Wait for the update to finish before starting another update.

    ![Update dashboard showing an update installing and an alert that update operations are disabled](./media/azure-stack-update-prepare-package/update-alert.png)

12. To install the update, select the package that's marked as **Ready**, and then select **Update now**.

13. When you select the installing update package, you can view the status in the **Update run details** area. From here, you can also select **Download summary** to download the log files. Logs from update runs are available for six months after the attempt ended.

14. When the update finishes, the **Update** blade shows the updated Azure Stack Hub version.

You can manually delete updates from the storage account after they've been installed on Azure Stack Hub. Azure Stack Hub periodically checks for older update packages and removes them from storage. It may take Azure Stack Hub up to two weeks to remove the old packages.

## Next steps

[Apply the update](azure-stack-apply-updates.md)
