---
title: Use Azure Backup to back up Windows Servers
description: This article provides guidance on how to use Azure Backup through Windows Admin Center to back up Windows Servers.
author: thomasmaurer
ms.author: thmaure
ms.topic: how-to
ms.date: 07/08/2020
---

# Use Azure Backup to back up Windows Servers

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

Windows Admin Center streamlines the process of backing up your Windows Servers to Azure and protecting you from accidental or malicious deletions, corruption and even ransomware. To automate setup, you can connect the Windows Admin Center gateway to Azure.

Use the following information to configure Backup for you Windows Server and create a Backup policy to backup your server's Volumes and the Windows System State from the Windows Admin Center.

<!---Qualify intro with messaging from Thomas.--->

To learn more about Azure integration with Windows Admin Center, see [Connecting Windows Server to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/).

## How does Azure Backup work with Windows Admin Center?
**Azure Backup** is the Azure-based service you can use to back up (or protect) and restore your data in the Microsoft cloud. Azure Backup replaces your existing on-premises or off-site backup solution with a cloud-based solution that is reliable, secure, and cost-competitive.
[Learn more about Azure Backup](https://docs.microsoft.com/azure/backup/backup-overview).

Azure Backup offers multiple components that you download and deploy on the appropriate computer, server, or in the cloud. The component, or agent, that you deploy depends on what you want to protect. All Azure Backup components (no matter whether you're protecting data on-premises or in Azure) can be used to back up data to a Recovery Services vault in Azure.

The integration of Azure Backup in the Windows Admin Center is ideal for backing up volumes and the Windows System state on-premises Windows physical or virtual servers. This makes for a comprehensive mechanism to backup File Servers, Domain Controllers and IIS Web Servers.

Windows Admin Center exposes the Azure Backup integration via the native **Backup** tool. The **Backup** tool provides setup, management and monitoring experiences to quickly start backing up your servers, perform common backup and restore operations and to monitor overall backup health of your Windows Servers.

## Prerequisites
The following is required to use Azure Backup:
- An Azure Account with at least one active subscription
- The target Windows Servers that you want to back up must have Internet access to Azure
- A connection from the Windows Admin Center gateway to Azure

    To learn more, see [Configuring Azure integration](/windows-server/manage/windows-admin-center/azure/azure-integration)

## Set up Azure Backup
<!---Restate heading so it doesn't repeat Step 2 below.--->

When you click on the **Backup** tool for a server connection on which Azure Backup is not yet enabled, you would see the **Welcome to Azure Backup** screen. Click the **Set up Azure Backup** button. This would open the Azure Backup setup wizard. Follow the steps as listed below in the wizard to back up your server.

If Azure Backup is already configured, clicking on the **Backup** tool will open the **Backup Dashboard**. Refer to the ([Management and Monitoring](#management-and-monitoring)) section to discover operations and tasks that can be performed from the dashboard.

To start the workflow to back up a Windows Server, open a server connection, select the **Backup** tool, and then and use the steps in the following sections.

### Step 1: Log on to Microsoft Azure
Sign into you Azure Account. 

> [!NOTE]
> If you have connected your Windows Admin Center gateway to Azure, you should be automatically logged in to Azure. You can click **sign-out** to further sign-in as a different user.

### Step 2: Set up Azure Backup
Select the appropriate settings for Azure Backup as described below:

- **Subscription Id:** The Azure subscription you want to use backing up your Windows Server to Azure. All Azure assets like the Azure Resource Group, the Recovery Services Vault will be created in the selected Subscription.
- **Vault:** The Recovery Services Vault where your servers' backups will be stored. You can select from existing vaults or Windows Admin Center will create a new Vault.  
- **Resource Group:** The Azure Resource Group is a container for a collection of resources. The Recovery Services vault is created or contained in the specified Resource Group. You can select from existing Resource Groups or Windows Admin Center will create a new one.
- **Location:** The Azure region where the Recovery Services Vault will be created. It is recommended to select the Azure region closest to the Windows Server.

### Step 3: Select Backup items and schedule
- Select what you want to back up from your server. Windows Admin Center allows you to pick from a combination of **Volumes** and the **Windows System State** while  giving you the estimated size of data that is selected for backup.

    > [!NOTE]
    > The first backup is a full-backup of all the selected data. However, subsequent backups are incremental in nature and transfer only the changes to the data since the previous backup.

- Select from multiple preset **Backup Schedules** for you System State and/or Volumes.

### Step 4: Enter an encryption passphrase
- Enter an **Encryption Passphrase** of your choice (minimum 16 characters).  **Azure Backup** secures your backup data with a user-configured and user-managed encryption passphrase. The encryption passphrase is required to recover data from Azure Backup.

    > [!NOTE]
    > The passphrase must be stored in a secure offsite location such as another server or the [Azure Key Vault](https://docs.microsoft.com/azure/key-vault/quick-create-portal). Microsoft does not store the passphrase and cannot retrieve or reset the passphrase if it is lost or forgotten.

- Review all the settings and click **Apply**

Windows Admin Center will then perform the following operations

1. Create an Azure Resource Group if it does not exist already
1. Create an Azure Recovery Services Vault as specified
1. Install and register the Microsoft Azure Recovery Services Agent to the Vault
1. Create the Backup and Retention schedule as per the selected options and associate them with the Windows Server.

## Management and monitoring
Once you have successfully setup Azure Backup, you would see the **Backup Dashboard** when you open the Backup tool for an existing server connection. You can perform the following tasks from the **Backup Dashboard**

- **Access the Vault in Azure:** You can click on the **Recovery Services Vault** link in the **Overview** tab of the **Backup Dashboard** to be taken to the Vault in Azure to perform a [rich set of management operations](https://docs.microsoft.com/azure/backup/backup-azure-manage-windows-server)
- **Perform an ad hoc backup:** Click on **Backup Now** to take an ad hoc backup. 
- **Monitor Jobs and Configure alert notifications:** Navigate to the **Jobs** tab of the dashboard to monitor on-going or past jobs and [configure alert notifications](https://docs.microsoft.com/azure/backup/backup-azure-manage-windows-server#configuring-notifications-for-alerts) to receive emails for any failed jobs or other backup related alerts.
- **View Recovery Points and Recover Data:** Click on the **Recovery Points** tab of the dashboard to view the Recovery Points and click on **Recover Data** for steps to recover you data from Azure.

## Next steps
For more information, see also:
- [Protect Azure Stack HCI VMs using Azure Site Recovery](https://docs.microsoft.com/azure-stack/hci/manage/azure-site-recovery)


<!---Example figure format--->
<!---:::image type="content" source="media/attach-gpu-to-linux-vm/vlc-player.png" alt-text="VLC Player Screenshot":::--->
