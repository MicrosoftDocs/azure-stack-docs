---
title: Connect to an Azure Local VM using SSH or RDP over SSH for multi-rack deployments (preview)
description: Learn how to use SSH or RDP over SSH to connect to an Azure Local VM for multi-rack deployments (preview).
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.date: 02/18/2026
ms.subservice: multi-rack
---

# Connect to an Azure Local VM using SSH or RDP over SSH for multi-rack deployments (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to connect to an Azure Local virtual machine (VM) using Secure Shell (SSH) and Remote Desktop Protocol (RDP) over SSH for multi-rack deployments.

- **SSH** is supported for both Windows and Linux VMs.
- **RDP over SSH** is supported for Windows VMs only.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About SSH and RDP over SSH

Azure Arc uses the SSH service (sshd) running inside the VM, but you establish connections through Azure Arc rather than directly over the network. You don't need to open any public IP address or inbound SSH ports on the VM for connectivity. For more information, see [SSH access to Azure Arc-enabled servers](/azure/azure-arc/servers/ssh-arc-overview?tabs=azure-cli).

The SSH server extension provides access to both Windows and Linux Azure Local VMs.

## Prerequisites

Before you begin, make sure that you:

1. Have access to the Azure Local VM that you want to connect to.

1. For **Windows VMs**, install the OpenSSH Server Extension. Linux VMs typically have SSH enabled by default and don't require this extension.

   You can install the OpenSSH Server Extension via Azure portal or using Azure CLI. Installing the extension via Azure portal is the recommended method.

   > [!NOTE]
   > Starting with Windows Server 2025, OpenSSH is installed by default.

### Install the OpenSSH Server Extension via Azure portal

To install the extension via Azure portal, navigate to **Extensions** and select the **OpenSSH for Windows - Azure Arc** option.

:::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/install-open-ssh-server-1.png" alt-text="Screenshot of the Azure Arc Extensions page." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/install-open-ssh-server-1.png":::

### Install the OpenSSH Server Extension via Azure CLI

Use the following steps to install the OpenSSH Server Extension via Azure CLI:

1. Run the following commands to ensure that the required Azure CLI Extensions are installed:

   ```azurecli
   az extension add --upgrade --name connectedmachine
   az extension add --upgrade --name ssh
   ```

1. Sign in to Azure:

   ```azurecli
   az login --use-device-code
   ```

1. Set appropriate parameters:

   ```azurecli
   $resourceGroup="<your resource group>"
   $serverName = "<your server name>"
   $location = "<your location>"
   $localUser = "<your username>" # Use a local admin account for testing        
   ```

1. Install the `OpenSSH` Arc Extension:

   ```azurecli
   az connectedmachine extension create --name WindowsOpenSSH \
     --type WindowsOpenSSH --publisher Microsoft.Azure.OpenSSH \
     --type-handler-version 3.0.1.0 --machine-name $serverName \
     --resource-group $resourceGroup
   ```

1. You can see the **WindowsOpenSSH** extension in the Azure portal Extensions list view.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png" alt-text="Screenshot of Azure portal Extensions list view." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png":::

## Use SSH to connect to an Azure Local VM

> [!NOTE]
> You might be prompted to allow Azure Arc to use port 22 as the local SSH endpoint inside the VM.

Use the following steps to connect to an Azure Local VM. This procedure works for both Windows and Linux VMs.

1. Run the following command to launch Arc SSH and sign in to the VM:

   ```azurecli
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser
   ```

   You're now connected to the Azure Local VM over SSH.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/server-connection-6.png" alt-text="Screenshot of server connection over SSH." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/server-connection-6.png":::

## Use RDP over SSH to connect to an Azure Local VM

For Windows VMs only, you can use RDP over SSH to connect to an Azure Local VM. Linux VMs don't support RDP over SSH.

1. Run the following command with the RDP parameter:

   ```azurecli
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser --rdp
   ```

1. Sign in to the local server for RDP over SSH.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png" alt-text="Screenshot of server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png":::

1. Sign in to authenticate for RDP.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/remote-desktop-login-dialog-for-ssh-arc-connection-6.png" alt-text="Screenshot of the remote desktop server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/remote-desktop-login-dialog-for-ssh-arc-connection-6.png":::

1. You can see the desktop for the remote desktop connection.

   :::image type="content" source="./media/multi-rack-connect-arc-vm-using-ssh/remote-desktop-for-ssh-arc-connection-9.png" alt-text="Screenshot of the remote desktop to connect to Windows Server over SSH." lightbox="./media/multi-rack-connect-arc-vm-using-ssh/remote-desktop-for-ssh-arc-connection-9.png":::

   You set up an RDP tunnel over SSH into your Azure Local VM using Azure CLI without any VPN or open ports at your firewall.

## Next steps

- [Azure Local multi-rack VM management overview](multi-rack-azure-arc-vm-management-overview.md)
