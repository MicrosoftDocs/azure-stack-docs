---
title: Update Microsoft Defender Antivirus
titleSuffix: Azure Stack Hub
description: Learn how to update Microsoft Defender Antivirus on Azure Stack Hub
author: sethmanheim
ms.topic: how-to
ms.date: 01/17/2025
ms.author: sethm
ms.lastreviewed: 12/04/2019

# Intent: As an Azure Stack operator, I want to update Microsoft Defender Antivurus on my Azure Stack so my security is up-to-date.
# Keyword: update windows defender antivirus azure stack

---

# Update Microsoft Defender Antivirus on Azure Stack Hub

[Microsoft Defender Antivirus](/windows/security/threat-protection/windows-defender-antivirus/windows-defender-antivirus-in-windows-10) is an antimalware solution that provides security and virus protection. Every Azure Stack Hub infrastructure component (Hyper-V hosts and virtual machines) is protected with Microsoft Defender Antivirus. For up-to-date protection, you need periodic updates to Microsoft Defender Antivirus definitions, engine, and platform. How updates are applied depends on your configuration.

## Connected scenario

The Azure Stack Hub [update resource provider](azure-stack-updates.md#the-update-resource-provider) downloads antimalware definitions and engine updates multiple times per day. Each Azure Stack Hub infrastructure component gets the update from the update resource provider and applies the update automatically.

For those Azure Stack Hub deployments that are connected to the public Internet, apply the [monthly Azure Stack Hub update](azure-stack-apply-updates.md). The monthly Azure Stack Hub update includes Microsoft Defender Antivirus platform updates for the month.

## Disconnected scenario

For those Azure Stack Hub deployments that are not connected to the public Internet (such as air-gapped datacenters) customers have the ability to apply the antimalware definitions and engine updates as they are published.

To apply the updates to your Azure Stack Hub solution, you first have to download them from the Microsoft site (links below) and subsequently, import them into a storage blob container under your *updateadminaccount*. A scheduled task scans the blob container every 30 minutes and, if new Defender definitions and engine updates are found, it applies them to the Azure Stack Hub infrastructure.

For those disconnected deployments that don't have the ability to download Defender definitions and engine updates on a daily basis, the monthly Azure Stack Hub update includes Microsoft Defender Antivirus definitions, engine, and platform updates for the month.

### Set up Microsoft Defender for manual updates

You can use two new cmdlets in the privileged endpoint to configure Microsoft Defender Antivirus manual update in Azure Stack Hub.

```powershell
### cmdlet to configure the storage blob container for the Defender updates 
Set-AzsDefenderManualUpdate [-Container <string>] [-Remove]  
### cmdlet to retrieve the configuration of the Microsoft Defender Antivirus manual update settings 
Get-AzsDefenderManualUpdate  
```

The following procedure shows how to setup Microsoft Defender Antivirus manual update.

1. Connect to the privileged endpoint and run the following cmdlet to specify the name of the storage blob container where the Defender updates will be uploaded.

   > [!NOTE]
   > The manual update process described below only works in disconnected environments where access to "go.microsoft.com" is not allowed. If you try to run the `Set-AzsDefenderManualUpdate` cmdlet in connected environments, it results in an error.

   ```powershell
   ### Configure the storage blob container for the Defender updates 
   Set-AzsDefenderManualUpdate -Container <yourContainerName>
   ```

1. Download the two Microsoft Defender Antivirus update packages and save them on a location that is reachable from your Azure Stack Hub administration portal.

   - mpam-fe.exe from [https://go.microsoft.com/fwlink/?LinkId=121721&arch=x64](https://go.microsoft.com/fwlink/?LinkId=121721&arch=x64)
   - nis_full.exe from [https://go.microsoft.com/fwlink/?LinkId=197094](https://go.microsoft.com/fwlink/?LinkId=197094)

   > [!NOTE]
   > You must download these two files every time you want to update the Defender signatures.

1. In the administration portal, select **All services**. Then, under the **DATA + STORAGE** category, select **Storage accounts**. Or, in the filter box, start typing **storage accounts**, and select it.

   ![Azure Stack Hub Defender - all services](./media/azure-stack-security-av/image1.png)  

1. In the filter box, type **update**, and select the **updateadminaccount** storage account.

1. In the storage account details, under **Services**, select **Blobs**.

   ![Azure Stack Hub Defender - blob](./media/azure-stack-security-av/image2.png)

1. Under **Blob service**, select **+ Container** to create a container. Enter the name that was specified with the `Set-AzsDefenderManualUpdate` command (in this example **defenderupdates**), and then select **OK**.

   ![Azure Stack Hub Defender - container](./media/azure-stack-security-av/image3.png)

1. After the container is created, select the container name, and then click **Upload** to upload the package files to the container.

   ![Azure Stack Hub Defender - upload](./media/azure-stack-security-av/image4.png)

1. Under **Upload blob**, click the folder icon, browse to the Microsoft Defender Antivirus update *mpam-fe.exe* files and then click **Open** in the file explorer window.

1. Under **Upload blob**, click **Upload**.

   ![Azure Stack Hub Defender - upload blob1](./media/azure-stack-security-av/image5.png)

1. Repeat steps 8 and 9 for the *nis_full.exe* file.

   ![Azure Stack Hub Defender - upload blob2](./media/azure-stack-security-av/image6.png)

A scheduled task scans the blob container every 30 minutes and applies any new Microsoft Defender Antivirus package.  

## Next steps

[Learn more about Azure Stack Hub security](azure-stack-security-foundations.md)
