---
title: Manage including restart, start, stop or delete Azure Local VMs for multi-rack deployments (Preview) 
description: Learn how to manage Azure Local VMs enabled by Azure Arc. This includes operations such as start, stop, restart, view properties of Azure Local VMs for multi-rack deployments (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/07/2025
---

# Manage Azure Local VMs for multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to manage Azure Local virtual machines (VMs) enabled by Azure Arc for multi-rack deployments. The procedures to enable guest management, start, stop, restart, or delete an Azure Local VM, are detailed.

## Prerequisites

- Access to an Azure Local Rack Scale instance that's deployed and registered.
- On the Azure Local Rack Scale overview page, find the custom location of the instance. 

- One or more Azure Local VMs running on your Azure Local instance. For more information, see [Create Azure Local virtual machines](../manage/create-arc-virtual-machines.md).

- The Azure Local VM must have access to public network connectivity to enable guest management.

## Enable guest management

When you enable guest management on an Azure Local VM, the [Azure Connected Machine agent](/azure/azure-arc/servers/agent-overview) is installed on the VM. You use the Azure Connected Machine agent to manage Azure Local VM extensions on your VM.

#### Verify that guest management is enabled in the Azure portal

1. Go to the Azure portal.

1. Go to **Your Azure Local** > **Virtual machines**, and then select the VM on which you enabled guest management.

1. On the **Overview** page, on the **Properties** tab, go to **Configuration**. **Guest management** should show **Enabled (Connected)**.

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machines/verify-guest-management-enabled-1.png" alt-text="Screenshot of the Azure portal that shows the area for verifying that guest management is enabled." lightbox="./media/multi-rack-manage-arc-virtual-machines/verify-guest-management-enabled-1.png":::

## View VM properties

To view VM properties for your Azure Local instance, follow these steps in the Azure portal:

1. Go to the Azure Local resource, and then go to **Virtual machines**.

1. In the list of virtual machines, select the name of the VM whose properties you want to view.

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machines/view-virtual-machine-properties-1.png" alt-text="Screenshot of a virtual machine selected from the list of virtual machines." lightbox="./media/multi-rack-manage-arc-virtual-machines/view-virtual-machine-properties-1.png":::

1. On the **Overview** page, select the **Properties** tab to view the properties of your VM.

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machines/view-virtual-machine-properties-2.png" alt-text="Screenshot of the properties of a selected Azure Local virtual machine." lightbox="./media/multi-rack-manage-arc-virtual-machines/view-virtual-machine-properties-2.png":::

## Start a VM

To start a VM, follow these steps in the Azure portal for your Azure Local instance:

1. Go to the Azure Local resource, and then go to **Virtual machines**.

1. In the list of virtual machines, select a VM that isn't running and that you want to start.

1. On the **Overview** page for the VM, on the command bar, select **Start**.

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machines/start-virtual-machine.png" alt-text="Screenshot of the button for starting a virtual machine on the overview page." lightbox="./media/multi-rack-manage-arc-virtual-machines/start-virtual-machine.png":::

1. On the confirmation dialog, select **Yes**.

1. Verify that the VM started.

## Restart a VM

To restart a VM, follow these steps in the Azure portal for your Azure Local instance:

1. Go to the Azure Local resource, and then go to **Virtual machines**.

1. In the list of virtual machines, select a VM that's stopped and that you want to restart.

1. On the **Overview** page for the VM, on the command bar, select **Restart**.

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machines/restart-virtual-machine.png" alt-text="Screenshot of the button for restarting a virtual machine on the overview page." lightbox="./media/multi-rack-manage-arc-virtual-machines/restart-virtual-machine.png":::

1. On the confirmation dialog, select **Yes**.

1. Verify that the VM restarted.

## Stop a VM

To stop a VM, follow these steps in the Azure portal for your Azure Local instance:

1. Go to the Azure Local resource, and then go to **Virtual machines**.

1. In the list of virtual machines, select a VM that's running and that you want to stop.

1. On the **Overview** page for the VM, on the command bar, select **Stop**.

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machines/stop-virtual-machine.png" alt-text="Screenshot of the button for stopping a virtual machine on the overview page." lightbox="./media/multi-rack-manage-arc-virtual-machines/stop-virtual-machine.png":::

1. On the confirmation dialog, select **Yes**.

1. Verify that the VM stopped.

## Delete a VM

Deleting a VM doesn't delete all the resources associated with the VM. For example, it doesn't delete the data disks and the network interfaces associated with the VM. You need to locate and delete these resources separately.

To delete a VM, follow these steps in the Azure portal for your Azure Local instance:

1. Go to the Azure Local resource, and then go to **Virtual machines**.

1. In the list of virtual machines, select a VM that you want to remove from your system.

1. On the **Overview** page for the VM, on the command bar, select **Delete**.

1. On the confirmation dialog, select **Yes**.

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machines/delete-virtual-machine-warning.png" alt-text="Screenshot of the warning for deleting a virtual machine." lightbox="./media/multi-rack-manage-arc-virtual-machines/delete-virtual-machine-warning.png":::

1. Go to the resource group where this VM was deployed. Verify that the VM is removed from the list of resources in the resource group.

1. Locate the associated resources, such as the network interfaces and data disks, and delete them. You might need to select **Show hidden types** to view the resources associated with this VM that weren't deleted.

    :::image type="content" source="./media/multi-rack-manage-arc-virtual-machines/locate-network-interfaces-data-disks-deleted-virtual-machine.png" alt-text="Screenshot of hidden types of resources associated with a virtual machine." lightbox="./media/multi-rack-manage-arc-virtual-machines/locate-network-interfaces-data-disks-deleted-virtual-machine.png":::

## Change the local account password

Follow these steps to change the local account passwords for an Azure Local VM deployed on your Azure Local instance. The steps are different for Windows and Linux VMs.

### Change the local account password for Windows VMs

1. Sign in to the Azure Local VM.

1. Run the following Azure PowerShell command:

    ```powershell
    # Define the username
    $username = "AccountName"
    
    # Prompt the user to enter the new password
    $newPassword = Read-Host -AsSecureString "Enter the new password for $username"
    
    # Prompt the user to re-enter the new password for verification
    $verifyPassword = Read-Host -AsSecureString "Re-enter the new password for verification"
    
    # Convert the secure strings to plain text for comparison
    $plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))
    $plainVerifyPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($verifyPassword))
    
    # Check if the passwords match, and change the password if they match. Fail if the passwords don't match.
    if ($plainPassword -eq $plainVerifyPassword) {
        $account = [ADSI]"WinNT://./$username,user"
        $account.SetPassword($plainPassword)
        $account.SetInfo()
    
        Write-Host "Password for user $username has been reset successfully." -ForegroundColor Green
    } else {
        Write-Host "The passwords do not match. Please try again." -ForegroundColor Red
    }    
    ```

### Change the local account password for Linux VMs

If Bash is in a different directory, be sure to change the `#!/bin/bash` line accordingly.

1. Sign in to the Azure Local VM.

1. Run the following script from where Bash is installed:

    ```Bash
    #!/bin/bash
    
    # Define the username
    username="AccountName"
    
    # Prompt the user to enter the new password
    echo -n "Enter the new password for $username: "
    read -s newPassword
    echo
    
    # Prompt the user to re-enter the new password for verification
    echo -n "Re-enter the new password for verification: "
    read -s verifyPassword
    echo
    
    # Check if the passwords match
    if [ "$newPassword" == "$verifyPassword" ]; then
        # Reset the password for the local account
        echo "$username:$newPassword" | sudo chpasswd
        echo -e "\e[32mPassword for user $username has been reset successfully.\e[0m"
    else
        echo -e "\e[31mThe passwords do not match. Please try again.\e[0m"
    fi
    ```

## Change cores and memory

To change cores and memory, follow these steps in the Azure portal for your Azure Local instance:

1. Go to your Azure Local resource, and then go to **Virtual machines**.

1. In the list of VMs, select and go to the VM whose cores and memory you want to modify.

    > [!NOTE]
    > You can't change VM CPU and memory of a running VM. You need to stop a VM and then update CPU and memory.

1. Under **Settings**, select **Size**. Edit the **Virtual processor count** or **Memory (MB)** values to change the cores or the memory size for the VM. For memory, only the size can be changed. You can't change the memory type after a VM is created.

## Related content

- [Manage Azure Local VM resources such as data disks and network interfaces](../manage/manage-arc-virtual-machine-resources.md).
