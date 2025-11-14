---
title: Connect to an Azure Local virtual machine (VM) via SSH for multi-rack deployments (Preview)
description: Learn how to use SSH to connect to an Azure Local VM for multi-rack deployments (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/12/2025
---

# Connect to an Azure Local VM via SSH for multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to connect to an Azure Local virtual machine (VM) using Secure Shell (SSH) and Remote Desktop (RDP) over SSH for multi-rack deployments. The example shown demonstrates enabling the OpenSSH Server via the Azure Arc extension using Azure portal and Azure CLI.

## About SSH Server extension

You can open an RDP connection to every Windows Server from the Azure CLI without a VPN or another open port through your firewall. For more information, see [SSH access to Azure Arc-enabled servers](/azure/azure-arc/servers/ssh-arc-overview?tabs=azure-cli).

## Prerequisites

Before you begin, ensure that you:

- Have access to the Azure Local VM that you want to connect to.

- Install the OpenSSH Server Extension.

   You can install the OpenSSH Server Extension via Azure portal or using PowerShell. Installing the extension via Azure portal is the recommended method.

   ### Install the OpenSSH Server Extension via Azure portal

   To install the extension via Azure portal, navigate to **Extensions** and select the **OpenSSH for Windows - Azure Arc** option.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/install-open-ssh-server-1.png" alt-text="Screenshot of the Azure Arc Extensions page." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/install-open-ssh-server-1.png":::

   ### Install the OpenSSH Server Extension via PowerShell

   Use the following steps to install the OpenSSH Server Extension via PowerShell:

   1. Open a Windows PowerShell session as an administrator.

   1. Run the following cmdlets to ensure that the required Azure CLI Extensions are installed:

   ```powershell
   az extension add --upgrade --name connectedmachine
   az extension add --upgrade --name ssh
   ```

   c. Sign in to Azure:

   ```powershell
   az login --use-device-code
   ```

   d. Set appropriate parameters:

   ```powershell
   $resourceGroup="<your resource group>"
   $serverName = "<your server name>"
   $location = "<your location>"
   $localUser = "<your username>" # Use a local admin account for testing        
   ```

   e. Install the `OpenSSH` Arc Extension:

   ```powershell
   az connectedmachine extension create --name WindowsOpenSSH 
   --type WindowsOpenSSH --publisher Microsoft.Azure.OpenSSH --type-handler-version 3.0.1.0 --machine-name $serverName --resource-group $resourceGroup
   ```

   Here's a sample output:

   ```powershell
   PS C:\Users\labadmin> az connectedmachine extension create --name WindowsOpenSSH --location westeurope --type WindowsOpenSSH --publisher Microsoft.Azure.OpenSSH --type-handler-version 3.0.1.0 --machine-name $serverName --resource-group $resourceGroup
   {
     "id": "/subscriptions/<SubscriptionName>/resourceGroups/<ResourceGroupName>/providers/<ProviderName>/machines/<MachineName>/extensions/WindowsOpenSSH",
     "location": "westeurope",
     "name": "WindowsOpenSSH",
     "properties": {
       "autoUpgradeMinorVersion": false,
       "enableAutomaticUpgrade": true,
       "instanceView": {
         "name": "WindowsOpenSSH",
         "status": {
           "code": "0",
           "level": "Information",
           "message": "Extension Message: OpenSSH Successfully enabled"
         },
         "type": "WindowsOpenSSH",
         "typeHandlerVersion": "3.0.1.0"
       },
        "provisioningState": "Succeeded",
        "publisher": "Microsoft.Azure.OpenSSH",
        "type": "WindowsOpenSSH",
        "typeHandlerVersion": "3.0.1.0",
     },
     "resourceGroup": "<ResourceGroupName>",
     "type": "Microsoft.HybridCompute/machines/extensions"
   }
   PS C:\Users\labadmin>
   ```

   f. You can see the **WindowsOpenSSH** extension in the Azure portal Extensions list view.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png" alt-text="Screenshot of Azure portal Extensions list view." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png":::

## Use SSH to connect to an Azure Local VM

> [!NOTE]
> You may be asked to allow Azure Arc SSH to set up port 22 for SSH.

Use the following steps to connect to Azure Local.

1. Run the following command to launch Arc SSH and sign in to the server:

   ```powershell
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser
   ```

   You're now connected to Azure Local over SSH:

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/server-connection-6.png" alt-text="Screenshot of server connection over SSH." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/server-connection-6.png":::

## Use RDP over SSH to connect an Azure Local VM

1. To sign into Azure Local using RDP over SSH, run the following command with the RDP parameter:

   ```powershell
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser --rdp
   ```

1. Sign in to the local server for RDP over SSH.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png" alt-text="Screenshot of server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png":::

1. Sign in to authenticate for RDP.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/remote-desktop-login-dialog-for-ssh-arc-connection-6.png" alt-text="Screenshot of the remote desktop server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/remote-desktop-login-dialog-for-ssh-arc-connection-6.png":::

1. You can see the desktop for the remote desktop connection.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/remote-desktop-for-ssh-arc-connection-9.png" alt-text="Screenshot of the remote desktop to connect to Windows Server over SSH." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/remote-desktop-for-ssh-arc-connection-9.png":::

   You set up an RDP tunnel over SSH into your Azure Local using Azure CLI without any VPN or open ports at your firewall.

## Next steps

- [What is Azure Local VM management?](../manage/azure-arc-vm-management-overview.md)
