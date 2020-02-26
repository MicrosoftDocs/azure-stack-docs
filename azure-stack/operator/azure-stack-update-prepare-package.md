---
title: Prepare an Azure Stack Hub update package 
description: Learn to prepare an Azure Stack Hub update package.
author: IngridAtMicrosoft

ms.topic: article
ms.date: 1/22/2020
ms.author: inhenkel
ms.lastreviewed: 09/10/2019
ms.reviewer: ppace

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Prepare an Azure Stack Hub update package

This article provides an overview of preparing Azure Stack Hub update packages so that they can be used to update your Azure Stack Hub  environment. This process consists of:

- [Downloading the update package](#download-the-update-package)
- [Importing the update package into your Azure Stack Hub environment via the Azure Stack Hub Administrator Portal](#import-and-install-updates)

On systems that can connect to the automatic update endpoints, Azure Stack Hub software updates and hotfixes are automatically downloaded and prepared. On systems without connectivity and for any update from the OEM, the update package must be prepared as explained in this topic.  

The following table shows when update packages require manual preparation and when they are prepared automatically.

| Update Type | Connectivity | Action Required |
| --- | --- | --- |
| Azure Stack Hub Software Updates | Connected | Update is automatically downloaded and prepared when the update is applied. |
| Azure Stack Hub Hotfixes | Connected | Update is automatically downloaded and prepared when the update is applied. |
| OEM Package Updates | Connected | The update package must be prepared. Follow the steps in this article. |
| Azure Stack Hub Software Updates | Disconnected or Weak Connection | The update package must be prepared. Follow the steps in this article. |
| Azure Stack Hub Hotfixes | Disconnected or Weak Connection | The update package must be prepared. Follow the steps in this article. |
| OEM Package Updates | Disconnected or Weak Connection | The update package must be prepared. Follow the steps in this article. |

## Download the update package
The update package for Azure Stack Hub updates and hotfixes is available through the update blade for connected systems. You will need to download the package and move the package to a location that is accessible to your Azure Stack Hub instance if you are updating an OEM package, or if you are supporting a disconnected system. You may also need to download and then upload the package to an accessible location if your are running a system with an intermittent connection.

Review the package contents. An update package typically consists of the following files:

-   **A self-extracting \<PackageName>.zip file**. This file contains the payload for the update.
- **A Metadata.xml file**. This file contains essential information about the update, for example, the publisher, name, prerequisite, size, and support path URL.

### Automatic download and preparation for update packages
Azure Stack Hub software updates and hotfixes are prepared automatically for systems with connectivity to the **Azure Stack Hub automatic update endpoints**: https://*.azureedge.net and https://aka.ms/azurestackautomaticupdate. For more information about setting up connectivity to the **Azure Stack Hub automatic update endpoints**, see the **Patch and Update** endpoints outlined in [Azure Stack Hub Firewall Integration](https://docs.microsoft.com/azure-stack/operator/azure-stack-integrate-endpoints#ports-and-urls-outbound)

### Where to download Azure Stack Hub update packages

Azure Stack Hub updates for [full and express updates](https://docs.microsoft.com/azure-stack/operator/azure-stack-updates#update-package-types) are hosted at a secure Azure endpoint. Azure Stack Hub operators with connected instances will see the [Azure Stack Hub updates automatically appear in the Administration portal](https://docs.microsoft.com/azure-stack/operator/azure-stack-update-prepare-package#automatic-download-and-preparation-for-update-packages). For internet disconnected systems or systems with weak internet connectivity, update packages can be downloaded using the [Azure Stack Hub Updates downloader tool](https://aka.ms/azurestackupdatedownload). Azure Stack Hub software update packages may contain updates to Azure Stack Hub services as well as updates to the operating system of your Azure Stack Hub’s scale units.

>[!NOTE]
>The update package itself and its contents (such as binaries, PowerShell scripts, and so on) are signed with Microsoft-owned certificates. Tampering with the package will make the signature invalid.​


### Where to download Azure Stack Hub hotfix packages

Package for [Azure Stack Hub hotfixes](https://docs.microsoft.com/azure-stack/operator/azure-stack-updates#update-package-types) are hosted in the same secure Azure endpoint as for Azure Stack Hub updates. Azure Stack Hub operators with connected instances will see the [Azure Stack Hub updates automatically appear in the Administration portal](https://docs.microsoft.com/azure-stack/operator/azure-stack-update-prepare-package#automatic-download-and-preparation-for-update-packages). You can download them using the embedded links in each of the respective hotfix KB articles, such as [Azure Stack Hub hotfix 1.1906.11.52](https://support.microsoft.com/help/4515650). You can find hotfixes in the release notes corresponding to your Azure Stack Hub version.

### Where to download OEM update packages
Your OEM vendor will also release updates, such as driver and firmware updates. While these updates are delivered as separate [OEM package updates](https://docs.microsoft.com/azure-stack/operator/azure-stack-updates#update-package-types) by your hardware vendor, they are still imported, installed, and managed the same way as update packages from Microsoft. You can find a list of vendor contact links at [Apply Azure Stack Hub original equipment manufacturer (OEM) updates](https://docs.microsoft.com/azure-stack/operator/azure-stack-update-oem#oem-contact-information).

## Import and install updates

The following procedure shows how to import and install update packages in the administration portal.

> [!Important]  
> Notify users of any maintenance operations, and that you schedule normal maintenance windows during non-business hours as much as possible. Maintenance operations may affect both user workloads and portal operations.

1.  In the administration portal, select **All services**. Then, under the **DATA + STORAGE** category, select **Storage accounts**. (Or, in the filter box, start typing **storage accounts**, and select it.)

    ![Azure Stack Hub update](./media/azure-stack-update-prepare-package/image1.png) 

1.  In the filter box, type **update**, and select the **updateadminaccount** storage account.

2.  In the storage account details, under **Services**, select **Blobs**.

    ![Azure Stack Hub update - blob](./media/azure-stack-update-prepare-package/image2.png)

1.  Under **Blob service**, select **+ Container** to create a container. Enter a name (for example *update-1811*) and then select **OK**.

    ![Azure Stack Hub update - container](./media/azure-stack-update-prepare-package/image3.png)

1.  After the container is created, click the container name, and then click **Upload** to upload the package files to the container.

    ![Azure Stack Hub update - upload](./media/azure-stack-update-prepare-package/image4.png)

1.  Under **Upload blob**, click the folder icon, browse to the update package's .zip file and then click **Open** in the file explorer window.

2.  Under **Upload blob**, click **Upload**.

    ![Azure Stack Hub update - upload blob](./media/azure-stack-update-prepare-package/image5.png)

1.  Repeat steps 6 and 7 for the Metadata.xml file and any additional .zip files in the update package. Do not import the Supplemental Notice.txt file if included.

2.  When done, you can review the notifications (bell icon in the top-right corner of the portal). The notifications should indicate that the upload has completed.

3.  Navigate back to the Update blade on the dashboard. The blade should indicate that an update is available. This indicates that the update has been prepared successfully. Click the blade to review the newly added update package.

4.  To install the update, select the package that's marked as **Ready** and either right-click the package and select **Update now**, or click the **Update now** action near the top.

5.  When you click the installing update package, you can view the status in the **Update run details** area. From here, you can also click **Download summary** to download the log files. Logs from update runs are available for 6 months after the attempt ended.

6.  When the update completes, the Update blade shows the updated Azure Stack Hub version.

You can manually delete updates from the storage account after they have been installed on Azure Stack Hub. Azure Stack Hub periodically checks for older update packages and removes them from storage. It may take Azure Stack Hub two weeks to remove the old packages.

## Next steps

[Apply the update](azure-stack-apply-updates.md)
