---
title: Use Azure Backup to back up Windows Servers
description: This article provides guidance on how to use Azure Backup through Windows Admin Center to back up Windows Servers.
author: thomasmaurer
ms.author: thmaure
ms.topic: how-to
ms.date: 07/09/2020
---

# Use Azure Backup to back up Windows Servers

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

Windows Admin Center streamlines backing up Windows Servers to Microsoft Azure, as well as protecting you from accidental or malicious deletions, corruption, and even ransomware. To automate setup, you connect Windows Admin Center to Azure to use the Azure Backup service.

This article shows you how to configure Azure Backup, and create a Backup policy for server volumes and Windows System State from Windows Admin Center. The guidance is intended for backing up workloads running on the Azure Stack HCI operating system to Azure.

To learn more about Azure integration with Windows Admin Center, see [Connecting Windows Server to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/).

## How Azure Backup works with Windows Admin Center
**Azure Backup** is a service that you can use to back up, protect, and restore your data in Azure. Azure Backup replaces either existing on-premises or off-premises backup solutions with a cloud-based solution that is reliable, secure, and cost-competitive.

To learn more, see [What is the Azure Backup service?](https://docs.microsoft.com/azure/backup/backup-overview)

Azure Backup offers multiple components that you download and deploy on the appropriate computer, server, or in the cloud. The component, or agent, that you deploy depends on what you want to protect. All Azure Backup components can back up data to a Recovery Services vault in Azure, no matter whether you're protecting data on-premises or in Azure.

Azure Backup integration with Windows Admin Center is ideal for backing up volumes and the Windows System State for either on-premises Windows Servers or virtual servers. The comprehensive process backs up file servers, domain controllers, and IIS web servers.

You access Azure Backup in Windows Admin Center via the **Backup** tool. The **Backup** tool setup, management, and monitoring capabilities let you quickly start backing up servers, perform backup and restore operations, and monitor the overall backup health of the Windows Servers that you manage.

## Prerequisites
The following prerequisites are required to use Azure Backup:
- An Azure Account with at least one active subscription
- Internet access to Azure for the target Windows Servers
- A connection from the Windows Admin Center gateway to Azure

    To learn more, see [Configuring Azure integration](/windows-server/manage/windows-admin-center/azure/azure-integration)

## Getting started with Azure Backup
When you first select the **Backup** tool in Windows Admin Center to establish a server connection to Azure, the **Welcome to Azure Backup** page displays. Select **Set up Azure Backup** to start the Azure Backup setup wizard. The following sections detail the steps in the wizard.

If Azure Backup is already configured for a server connection, selecting the **Backup** tool opens the **Backup Dashboard**. See the ([Management and monitoring](#management-and-monitoring)) section for information about operations and tasks that you can perform from the dashboard.

### Step 1: Log on to the Microsoft Azure portal
Sign in to your Azure account.

> [!NOTE]
> If you've already connected the Windows Admin Center gateway to Azure, you should automatically log on to the portal. Select **sign out** to then sign in as a different user.

### Step 2: Set up Azure Backup
Select the following settings for Azure Backup:
- **Subscription Id:** The Azure subscription that you want to use for backing up Windows Server to Azure. All Azure assets like the Azure Resource Group and the Recovery Services Vault will be created and associated with the selected subscription.
- **Vault:** The Recovery Services Vault is the location where your servers' backups will be stored. You can use either an existing vault or Windows Admin Center will create a new one.  
- **Resource Group:** The Azure Resource Group is a container for a collection of resources. The Recovery Services vault is either created or contained in the specified Resource Group. You can use either an existing Resource Group or Windows Admin Center will create a new one.
- **Location:** The Azure region where the Recovery Services Vault will be created. We recommend to select the Azure region that is closest to the Windows Server that you are backing up.

### Step 3: Select backup items and schedule
- Select the items that you want to back up from your server. Windows Admin Center lets you choose a combination of volumes and Windows System State, and provides an estimated size of the data that you've selected to back up.

    > [!NOTE]
    > The first backup is a full backup of all the selected data. Subsequent backups are incremental and transfer only changes to the data that have occurred since the previous backup.

- Select from multiple preset **Backup Schedules** for your Windows System State and volumes.

### Step 4: Enter an encryption passphrase
- Enter an **Encryption Passphrase** that has a minimum of 16 characters. Azure Backup secures your backup data with an encryption passphrase that you create and manage. The encryption passphrase is required to recover data from Azure Backup.

    > [!NOTE]
    > Store the passphrase in a secure offsite location, such as another server or the [Azure Key Vault](https://docs.microsoft.com/azure/key-vault/quick-create-portal). Microsoft does not store the passphrase and cannot retrieve or reset the passphrase if it is lost or forgotten.

- Review all of the settings on the wizard page and select **Apply**.

Windows Admin Center then performs the following operations:
1. Creates an Azure Resource Group if one does not already exist.
1. Creates an Azure Recovery Services Vault as specified.
1. Installs and registers the Microsoft Azure Recovery Services Agent in the Vault.
1. Creates the Backup and Retention schedule according to the selected options associated with the Windows Server.

## Management and monitoring
After successfully setting up Azure Backup, you'll see the **Backup Dashboard** when you open the **Backup** tool for an existing server connection. You can perform the following tasks from the dashboard:
- **Access the vault in Azure:** On the **Overview** tab, select  **Recovery Services Vault** to access the vault where you can perform many management operations. To learn more, see [Monitor and manage Recovery Services vaults](https://docs.microsoft.com/azure/backup/backup-azure-manage-windows-server).
- **Perform an ad hoc backup:** Select **Backup Now** to make an ad hoc backup. 
- **Monitor jobs and configure alert notifications:** Navigate to the **Jobs** tab to monitor ongoing or past jobs, and [configure alert notifications](https://docs.microsoft.com/azure/backup/backup-azure-manage-windows-server#configuring-notifications-for-alerts) to receive email on failed jobs and other backup alerts.
- **View recovery points and recover data:** Select the **Recovery Points** tab to view recovery points, and select **Recover Data** for steps on how to recover your data from Azure.

## Next steps
For more information, see also:
- [Protect Azure Stack HCI VMs using Azure Site Recovery](https://docs.microsoft.com/azure-stack/hci/manage/azure-site-recovery)
