---
title: Connect to an Azure Local virtual machine (VM) using SSH
description: Learn how to use SSH to connect to an Azure Local VM enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 04/04/2025
ms.subservice: hyperconverged
#customer intent: As a Senior Content Developer, I want to provide customers with the highest level of content for using disconneced operations to deploy and manage their Azure Local instances.
---

# Connect to an Azure Local VM using SSH / RDP over SSH or VM Connect

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to connect to an Azure Local VM in two scenarios:

  1. Using **SSH and RDP over SSH** to connect to an Azure Local VM enabled by Azure Arc.
  2. Using **VM Connect** to connect to an Azure Local VM that does not have network connectivity or has boot failures (Preview).

## Connect to an Azure Local VM using SSH and RDP over SSH

### About SSH Server Extension

You can enable SSH-based connectivity to Azure Local VMs without requiring a public IP address, line-of-sight to the VM and Azure Local instance, or additional open ports. For more information, see [SSH access to Azure Arc-enabled servers](/azure/azure-arc/servers/ssh-arc-overview?tabs=azure-cli).

SSH server extension provides access to both Windows and Linux Azure Local VMs.

### SSH Prerequisites

Before you begin, ensure that you:

1. Have access to Azure Local that is running the latest version of software.

1. Install the OpenSSH Server Extension.

   You can install the OpenSSH Server Extension via Azure portal or using PowerShell. Installing the extension via Azure portal is the recommended method.

   Note that starting with Windows Server 2025, OpenSSH is installed by default.

   ### Install the OpenSSH Server Extension via Azure portal

   To install the extension via Azure portal, navigate to **Extensions** and select the **OpenSSH for Windows - Azure Arc** option.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/install-open-ssh-server-1.png" alt-text="Screenshot of the Azure Arc Extensions page." lightbox="./media/connect-arc-vm-using-ssh/install-open-ssh-server-1.png":::

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

   f. You can see `WindowsOpenSSH` Extension in the Azure portal Extensions list view.

      :::image type="content" source="./media/connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png" alt-text="Screenshot of Azure portal Extensions list view." lightbox="./media/connect-arc-vm-using-ssh/azure-portal-extensions-list-view-3.png":::

### Use SSH to connect to an Azure Local VM

> [!NOTE]
> You may be asked to allow Arc SSH to set up port 22 for SSH.

Use the following steps to connect to an Azure Local VM.

1. Run the following command to launch Arc SSH and sign in to the server:

   ```powershell
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser
   ```

   You're now connected to an Azure Local VM over SSH:

   :::image type="content" source="./media/connect-arc-vm-using-ssh/server-connection-6.png" alt-text="Screenshot of server connection over SSH." lightbox="./media/connect-arc-vm-using-ssh/server-connection-6.png":::

### Use RDP over SSH to connect to an Azure Local VM

1. For Windows VMs, you can use RDP over SSH to access the VM. Run the following command with the RDP parameter:

   ```powershell
   az ssh arc --resource-group $resourceGroup --name $serverName --local-user $localUser --rdp
   ```

1. Sign in to the local server for RDP over SSH.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png" alt-text="Screenshot of server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/server-login-dialog-for-ssh-arc-connection-5.png":::

1. Sign in to authenticate for RDP.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/rdp-login-dialog-for-ssh-arc-connection-6.png" alt-text="Screenshot of the RDP server sign-in dialog to connect to Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/rdp-login-dialog-for-ssh-arc-connection-6.png":::

1. You can see the desktop for the remote desktop connection.

   :::image type="content" source="./media/connect-arc-vm-using-ssh/rdp-desktop-for-ssh-arc-connection-9.png" alt-text="Screenshot of the RDP desktop to connect to Windows Server over SSH." lightbox="./media/connect-arc-vm-using-ssh/rdp-desktop-for-ssh-arc-connection-9.png":::

## Connect to an Azure Local VM using VM Connect (Preview)

### About VM Connect

VM Connect allows you to connect to both Windows and Linux Azure Local VMs that do not have network connectivity or have boot failures. VM Connect is in preview starting with Azure Local version 2601.

VM Connect requires line-of-sight from the client machine running Azure CLI to the Azure Local instance hosting the VM. This means that the client machine must have a VPN connection to the Azure Local instance or be on the same network.

VM Connect is meant to be used as a troubleshooting and recovery tool for VMs that are not accessible via standard connection methods such as SSH and RDP over SSH.

See [Azure Local VM Connect Azure CLI reference](https://learn.microsoft.com/cli/azure/stack-hci-vm/vmconnect?view=azure-cli-latest) for more information about the VM Connect commands.

### VM Connect Prerequisites

Before you begin, ensure that you:

1. Have access to Azure Local that is running version 2601 or later.
2. Install the latest version of Azure CLI and [stack-hci-vm extension](https://learn.microsoft.com/cli/azure/stack-hci-vm?view=azure-cli-latest). For more information, see [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
3. Ensure the Azure CLI user has "Azure Stack HCI Administrator" role or higher in the Azure subscription containing the Azure Local VM and Azure Local instance.
4. Ensure line-of-sight from the client machine running Azure CLI to the Azure Local instance hosting the VM.

### Use VM Connect to connect to an Azure Local VM

Use the following steps to connect to an Azure Local VM using VM Connect.

1. Sign into Azure CLI with the following command:

    ```powershell
    az login --use-device-code
    ```

1. Set appropriate parameters:

    ```powershell
    $VMName="<your VM name>"
    $ResourceGroup="<your resource group of the VM>"
    $ClusterName="<your Azure Local instance name>"
    $RDPFilePath="<path to save RDP file>" # Optional, will be saved in current directory if not specified
    ```

    > [!NOTE]
    > VM Connect currently only supports VMs that are located in the same resource group as the Azure Local instance. Ensure that the VM is in the same resource group as the Azure Local instance. 

1. Run the following command to enable VM Connect and connect to the VM. Optionally, you can specify the path to save the generated RDP file using the `--path` parameter.

    ```powershell
    az stack-hci-vm vmconnect enable --name $VMName --resource-group $ResourceGroup --cluster-name $clusterName
    ```

    Running this command will take up to 10 minutes to complete. This command performs the following actions:

    - Locates the Azure Local machine hosting the desired VM.
    - Opens port 2179 on the VM host machine to allow VM Connect traffic for 8 hours by default.
    - Generates an RDP file with VM host machine IP and details configured to connect to the VM.

1. After the command completes, navigate to the location of the generated RDP file and open it to connect to the VM. If you did not specify a path for the RDP file, it will be saved in the current directory. Ensure that you have line-of-sight from the client machine to the Azure Local instance hosting the VM when opening the RDP file, otherwise the connection will fail.

1. You will be shown two login prompts with this RDP file:

   - The first prompt is to authenticate to the VM host machine. Use the credentials of a local administrator account on the Azure Local instance hosting the VM.
   - The second prompt is to authenticate to the VM itself. Use the credentials of a local administrator account on the VM.
     - In case you need to "Press Ctrl+Alt+Delete to unlock", you can do so by pressing "Ctrl + Alt + End" on your keyboard, which sends the "Ctrl+Alt+Delete" command through the RDP session. You can also use the on-screen keyboard to send the "Ctrl+Alt+Delete" command.

1. You are now connected to the Azure Local VM using VM Connect. You can use this connection to troubleshoot and recover the VM as needed.

1. When you are done using VM Connect, it is recommended to disable VM Connect to close the opened port on the VM host machine. You can do this by running the following command:

     ```powershell
    
      az stack-hci-vm vmconnect disable --name $VMName --resource-group $ResourceGroup --cluster-name $clusterName
    ```

### Known Limitations

**VM Connect requires VMs to be in the same resource group as the Azure Local instance**.  
VM connect will not work if the VM is in a different resource group than the Azure Local instance. This limitation will be removed in a future release.

**VM Connect occasionally may fail if the Azure Local host machine has multiple network interfaces.**  
In some cases, VM Connect may fail when executing the RDP file if the Azure Local host machine has multiple network interfaces. This is due to the RDP file containing an IP address that is not reachable from the client machine. As a workaround, you can manually edit the RDP file to replace the IP address with one that is reachable from the client machine before opening it. To do this:

1. Find the correct IP address of the Azure Local host machine that is reachable from the client machine by navigating in the Azure portal to the Azure Local instance > Infrastructure > Machines > select the host machine > Properties > Networking.
2. Open the generated RDP file in a text editor.
3. Locate the line that starts with `full address:s:` and replace the IP address with the correct one.
4. Save the changes to the RDP file and then open it to connect to the VM.

### Feedback

We appreciate your feedback on VM Connect. If you encounter any issues or have suggestions for improvement, please provide your feedback through the [Azure Local VM Connect Feedback Forum](https://aka.ms/AzureLocalVMConnectFeedback).

## Next steps

- [What is Azure Local VM management?](azure-arc-vm-management-overview.md)
