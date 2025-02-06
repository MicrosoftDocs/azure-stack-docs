---
title: Connect to an Arc VM on Azure Local using SSH
description: Learn how to use SSH to connect to an Arc VM on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 02/06/2025
---

# Connect to an Arc VM on Azure Local using SSH

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article uses an example to connect to an Azure Arc VM on Azure Local using Secure Shell (SSH). The example enables the OpenSSH Server via Arc Extension, using Azure CLI. This can also be done in Azure portal.

## More about the SSH Server Extension

You can open a Remote Desktop (RDP) connection to every Windows Server from the Azure CLI without a VPN or another open port through your firewall. For more information, see [SSH access to Azure Arc-enabled servers](/azure/azure-arc/servers/ssh-arc-overview?tabs=azure-cli).

The latest versions of Windows Server can also act as an SSH Server if you enable the OpenSSH Server Extension. For more information, see [OpenSSH for Windows overview](/windows-server/administration/OpenSSH/openssh-overview).

## Prerequisites

Before you begin, ensure that you:

1. Have access to Azure Local that is running the latest version of software.

1. Install the OpenSSH Server Extension:

   :::image type="content" source="./media/connect-arc-vm-using-ssh/install-open-ssh-server-1.png" alt-text="Screenshot of the Azure Arc Extensions page." lightbox="./media/connect-arc-vm-using-ssh/install-open-ssh-server-1.png":::

1. Open a Windows PowerShell session as an administrator.

1. Run the following cmdlets to ensure that the required Azure CLI Extensions are installed:

   ```powershell
   az extension add --upgrade --name connectedmachine
   az extension add --upgrade --name ssh
   ```

1. Sign in to Azure:

   ```powershell
   az login --use-device-code
   ```

1. Set appropriate parameters:

   ```powershell
   $resourceGroup="<your resource group>"
   $serverName = "<your server name>"
   $localUser = "Administrator" # Use a local admin account for testing        
   ```

1. Install the `OpenSSH` Arc Extension:

   ```powershell
   az connectedmachine extension create --name WindowsOpenSSH --location westeurope --type WindowsOpenSSH --publisher Microsoft.Azure.OpenSSH --type-handler-version 3.0.1.0 --machine-name $serverName --resource-group $resourceGroup
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

1. You can see `WindowsOpenSSH` Extension in the Azure portal Extensions list view.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png" alt-text="Screenshot of Azure portal Extensions list view." lightbox="./media/connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png":::

## Use SSH to connect to Azure Local

> [!NOTE]
> You may be asked to allow Arc SSH to set up port 22 for SSH.

Use the following steps to connect to Azure Local.

1. Run the following command to launch Arc SSH and sign in to the server:

   ```powershell
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser
   ```

   You're now connected to Azure Local over SSH:

   ```powershell
   Microsoft Windows [Version 10.0.20348.2655]
   (c) Microsoft Corporation. All rights reserved.

   administrator@VMName C:\Users\Administrator>
   ```

    You're now connected to Server Manager.

    :::image type="content" source="./media/connect-arc-vm-using-ssh/server-manager-dashboard-7.png" alt-text="Screenshot of the Server Manager Dashboard for Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/server-manager-dashboard-7.png":::

## Use RDP to connect to Azure Local

1. To sign into Azure Local using RDP, run the following command with the RDP parameter:

   ```powershell
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser --rdp
   ```

1. Sign in to the local server for SSH.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png" alt-text="Screenshot of server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png":::

1. Sign in to authenticate for RDP.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/rdp-login-dialog-for-ssh-arc-connection-6.png" alt-text="Screenshot of the RDP server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/rdp-login-dialog-for-ssh-arc-connection-6.png":::

1. You're now connected to Server Manager.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/server-manager-dashboard-7.png" alt-text="Screenshot of the Server Manager Dashboard for a Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/server-manager-dashboard-7.png":::

You have set up an RDP tunnel over SSH into your Azure Local using Azure CLI without any VPN or open ports at your firewall.

## Next steps

- [What is Azure Arc VM management?](azure-arc-vm-management-overview.md)
