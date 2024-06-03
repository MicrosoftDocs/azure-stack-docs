---
author: ManikaDhiman
ms.author: v-manidhiman
ms.service: azure-stack
ms.topic: include
ms.date: 05/31/2024
ms.reviewer: alkohli
---

## Redeploy SDN Network Controller

If the Network Controller deployment fails or you want to deploy it again, do the following:

1. Delete all Network Controller VMs and their VHDs from all server nodes.
1. Remove the following registry keys from all hosts by running this command:

   ```powershell
    Remove-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\NcHostAgent\Parameters\' -Name Connections
    Remove-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\NcHostAgent\Parameters\' -Name NetworkControllerNodeNames
   ```

1. After removing the registry key, remove the cluster from the Windows Admin Center management, and then add it back.

   > [!NOTE]
   > If you don't do this step, you may not see the SDN deployment wizard in Windows Admin Center.

1. (Additional step only if you plan to uninstall Network Controller and not deploy it again) Run the following cmdlet on all the servers in your Azure Stack HCI cluster, and then skip the last step.
    
    ```powershell
    Disable-VMSwitchExtension -VMSwitchName "<Compute vmswitch name>" -Name "Microsoft Azure VFP Switch Extension"
    ```

1. Run the deployment wizard again.