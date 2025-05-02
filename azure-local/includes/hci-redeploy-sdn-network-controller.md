---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 10/11/2024
ms.reviewer: alkohli
---

## Redeploy SDN Network Controller

If the Network Controller deployment fails or you want to deploy it again, do the following:

1. Delete all Network Controller VMs and their VHDs from all machines.
1. Remove the following registry keys from all machines by running this command:

   ```powershell
    Remove-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\NcHostAgent\Parameters\' -Name Connections
    Remove-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\NcHostAgent\Parameters\' -Name NetworkControllerNodeNames
   ```

1. After removing the registry key, remove the cluster from the Windows Admin Center management, and then add it back.

   > [!NOTE]
   > If you don't do this step, you may not see the SDN deployment wizard in Windows Admin Center.

1. (Additional step only if you plan to uninstall Network Controller and not deploy it again) Run the following cmdlet on all the machines in your Azure Local instance, and then skip the last step.
    
    ```powershell
    Disable-VMSwitchExtension -VMSwitchName "<Compute vmswitch name>" -Name "Microsoft Azure VFP Switch Extension"
    ```

1. Run the deployment wizard again.