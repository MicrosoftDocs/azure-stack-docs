---
title: Connect to an Azure Local Virtual Machine using SSH or Remote Desktop Protocol over SSH or VM Connect (Preview)
description: Learn how to use SSH or RDP over SSH or VM Connect feature (preview) to connect to an Azure Local VM enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 01/07/2026
ms.subservice: hyperconverged
---

# Connect to an Azure Local VM using SSH, RDP over SSH, or VM Connect (preview)

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to connect to an Azure Local VM in two scenarios:

  1. **Use SSH and Remote Desktop Protocol (RDP) over SSH** to connect to an Azure Local VM enabled by Azure Arc.
  1. **Use VM Connect (preview)** to connect to an Azure Local VM that doesn't have network connectivity or has boot failures.

## Connect to an Azure Local VM using SSH and RDP over SSH

Azure Arc uses the SSH service (sshd) running inside the VM, but you establish connections through Azure Arc rather than directly over the network. You don't need to open any public IP address or inbound SSH ports on the VM for connectivity.
For more information, see [SSH access to Azure Arc-enabled servers](/azure/azure-arc/servers/ssh-arc-overview?tabs=azure-cli).

The SSH server extension provides access to both Windows and Linux Azure Local VMs.

### SSH prerequisites

Before you begin, make sure that you:

1. Have access to Azure Local that's running the latest version of software.

1. Install the OpenSSH server extension via Azure portal or via PowerShell. We recommend that you install the extension via Azure portal.

   > [!NOTE]
   > Starting with Windows Server 2025, OpenSSH is installed by default.

### Install the OpenSSH server extension through Azure portal

To install the extension through Azure portal, go to **Extensions** and select the **OpenSSH for Windows - Azure Arc** option.

:::image type="content" source="./media/connect-arc-vm-using-ssh/install-open-ssh-server-1.png" alt-text="Screenshot of the Azure Arc Extensions page." lightbox="./media/connect-arc-vm-using-ssh/install-open-ssh-server-1.png":::

### Install the OpenSSH server extension by using PowerShell

Follow these steps to install the OpenSSH Server Extension by using PowerShell:

1. Run PowerShell as an administrator.

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
    $location = "<your location>"
    $localUser = "<your username>" # Use a local admin account for testing        
    ```

1. Install the `OpenSSH` Arc Extension:

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

1. You can see `WindowsOpenSSH` Extension in the Azure portal Extensions list view.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png" alt-text="Screenshot of Azure portal Extensions list view." lightbox="./media/connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png":::

### Use SSH to connect to an Azure Local VM

> [!NOTE]
> You might be prompted to allow Azure Arc to use port 22 as the local SSH endpoint inside the VM.

Use the following steps to connect to an Azure Local VM.

1. Run the following command to launch Arc SSH and sign in to the server:

   ```powershell
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser
   ```

   You're now connected to an Azure Local VM over SSH:

   :::image type="content" source="./media/connect-arc-vm-using-ssh/server-connection-6.png" alt-text="Screenshot of server connection over SSH." lightbox="./media/connect-arc-vm-using-ssh/server-connection-6.png":::

### Use RDP over SSH to connect to an Azure Local VM

For Windows VMs only, you can use RDP over SSH to connect to an Azure Local VM. Linux VMs don't support RDP over SSH.

1. Run the following command with the RDP parameter:

   ```powershell
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser --rdp
   ```

1. Sign in to the local server for RDP over SSH.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png" alt-text="Screenshot of server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png":::

1. Sign in to authenticate for RDP.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/rdp-login-dialog-for-ssh-arc-connection-6.png" alt-text="Screenshot of the RDP server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/rdp-login-dialog-for-ssh-arc-connection-6.png":::

1. You can see the desktop for the remote desktop connection.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/rdp-desktop-for-ssh-arc-connection-9.png" alt-text="Screenshot of the RDP desktop to connect to Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/rdp-desktop-for-ssh-arc-connection-9.png":::

## Connect to an Azure Local VM using VM Connect (preview)

### About VM Connect

VM Connect allows you to connect to both Windows and Linux Azure Local VMs that don't have network connectivity or have boot failures. Use it for troubleshooting and recovery scenarios. VM Connect is in preview starting with Azure Local version 2601. 

VM Connect requires line-of-sight from the client machine running Azure CLI to the Azure Local instance hosting the VM. This requirement means that the client machine must have a VPN connection to the Azure Local instance or be on the same network.

For more information about the VM Connect commands, see [Azure Local VM Connect Azure CLI reference](/cli/azure/stack-hci-vm/vmconnect).

### VM Connect prerequisites

Before you begin, make sure that you:

1. Have access to Azure Local that's running version 2601 or later.
1. Install the latest version of Azure CLI and the [stack-hci-vm extension](/cli/azure/stack-hci-vm). For more information, see [Install Azure CLI](/cli/azure/install-azure-cli).
1. Assign the *Azure Stack HCI Administrator* role or higher to the Azure CLI user in the Azure subscription that contains the Azure Local VM and Azure Local instance.
1. Have line-of-sight from the client machine running Azure CLI to the Azure Local instance hosting the VM.
1. Have local administrator credentials for both the Azure Local instance hosting the VM and the VM itself. You need these credentials to authenticate when connecting to the VM by using VM Connect.

### Use VM Connect to connect to an Azure Local VM

Follow these steps to connect to an Azure Local VM by using VM Connect.

1. Sign in to Azure CLI by using the following command:

    ```powershell
    az login --use-device-code
    ```

1. Set appropriate parameters:

    ```powershell
    $vmName="<your VM name>"
    $resourceGroup="<your resource group of the VM>"
    $clusterName="<your Azure Local instance name>"
    $rdpFilePath="<path to save RDP file>" # Optional, will be saved in current directory if not specified
    ```

    > [!NOTE]
    > VM Connect currently only supports VMs that are located in the same resource group as the Azure Local instance. Ensure that the VM is in the same resource group as the Azure Local instance.

1. Run the following command to enable VM Connect and connect to the VM. Optionally, you can specify the path to save the generated RDP file by using the `--path` parameter.

    ```powershell
    az stack-hci-vm vmconnect enable --name $vmName --resource-group $resourceGroup --cluster-name $clusterName
    ```

    Running this command can take up to 10 minutes to complete. This command performs the following actions:

    - Locates the Azure Local machine hosting the desired VM.
    - Opens port 2179 on the VM host machine to allow VM Connect traffic for eight hours by default.
    - Generates an RDP file with VM host machine IP and details configured to connect to the VM.

1. After the command completes, go to the location of the generated RDP file and open it to connect to the VM. If you didn't specify a path for the RDP file, it's saved in the current directory. Ensure that you have line-of-sight from the client machine to the Azure Local instance hosting the VM when opening the RDP file, otherwise the connection fails.

1. You see two authentication prompts with this RDP file:

   - The first prompt authenticates to the VM host machine. Use the credentials of a local administrator account on the Azure Local instance hosting the VM.
   - The second prompt authenticates to the VM itself. Use the credentials of a local administrator account on the VM.
     - If you need to press *Ctrl + Alt + Delete* to unlock, you can do so by pressing *Ctrl + Alt + End* on your keyboard, which sends the *Ctrl + Alt + Delete* command through the RDP session. You can also use the on-screen keyboard to send the *Ctrl + Alt + Delete* command.

1. You're now connected to the Azure Local VM by using VM Connect. You can use this connection to troubleshoot and recover the VM as needed.

1. When you're done using VM Connect, disable VM Connect to close the opened port on the VM host machine. Run the following command:

     ```powershell
    
      az stack-hci-vm vmconnect disable --name $vmName --resource-group $resourceGroup --cluster-name $clusterName
    ```

### Known limitations

- **VM Connect requires VMs to be in the same resource group as the Azure Local instance**.  
    VM Connect doesn't work in the current release if the VM is in a different resource group than the Azure Local instance.

- **VM Connect occasionally fails if the Azure Local host machine has multiple network interfaces.**  
    In some cases, VM Connect fails when executing the RDP file if the Azure Local host machine has multiple network interfaces. This problem happens because the RDP file contains an IP address that isn't reachable from the client machine. As a workaround, you can manually edit the RDP file to replace the IP address with one that's reachable from the client machine before opening it. To do this:

    1. Find the correct IP address of the Azure Local host machine that's reachable from the client machine by navigating in the Azure portal to the Azure Local instance > Infrastructure > Machines > select the host machine > Properties > Networking.
    1. Open the generated RDP file in a text editor.
    1. Locate the line that starts with `full address:s:` and replace the IP address with the correct one.
    1. Save the changes to the RDP file and then open it to connect to the VM.
    
### VM Connect feedback

The product team appreciates your feedback on VM Connect. If you encounter any problems or have suggestions for improvement, provide your feedback through the [Azure Local VM Connect Feedback Forum](https://aka.ms/AzureLocalVMConnectFeedback).

## Next steps

- Once you connect, learn how to [Manage Azure Local VMs](./manage-arc-virtual-machines.md).
