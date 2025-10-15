---
title: Enable guest management for migrated VMs (preview)
description: Learn how to enable guest management for migrated VMs (preview).
author: alkohli
ms.topic: how-to
ms.date: 10/08/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.custom: sfi-image-nochange
---

# Enable guest management for migrated VMs (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to enable guest management after migration for Azure Local virtual machines (VMs) enabled by Arc.

For more information on other scenarios, see [Manage Azure Local VMs](../manage/manage-arc-virtual-machines.md).

The output properties may vary depending on whether VMs were migrated or not.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

Before you begin, complete the following:

- You have access to a deployed and registered Azure Local instance, with an Azure Arc resource bridge and custom location configured.

- Your system is running Azure Local release 2405 or later.

- You are able to [connect to the target Azure Local instance remotely](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-remotely).

- Familiarize yourself with Azure Local VMs and guest management features and considerations - see [Enable guest management](../manage/manage-arc-virtual-machines.md#enable-guest-management).

- Check the list of supported guest OS on Azure Local. See [Supported Guest Operating Systems on Azure Local](/windows-server/virtualization/hyper-v/supported-windows-guest-operating-systems-for-hyper-v-on-windows).

- The Azure Local VM must have access to public network connectivity to enable guest management.

## Enable the guest agent on migrated VMs

All Hyper-V generation 1 VMs must be powered off before proceeding with the following steps. There is no such requirement for Hyper-V generation 2 VMs, they can be either on or off and both power states are expected to work.

**Step 1**: Check the power state of the migrated VMs as follows:

1. For Hyper-V Generation 1, make sure the VM is stopped. See the Appendix for the error message if it is not stopped.

    **Using Azure portal (recommended)**

    1. To stop migrated VM from Azure portal, select **Stop** on the VM details page:

    :::image type="content" source="./media/migrate-enable-guest-management/vm-stop.png" alt-text="Screenshot of Azure portal showing how to stop a VM." lightbox="./media/migrate-enable-guest-management/vm-stop.png":::

    2. Wait and refresh the page to see the VM **Status** is shown as **Stopped**.

    **Using Azure CLI**

    1. Connect to Azure Local machine and open a PowerShell window. Sign on with Azure CLI.

        ```azurecli
        az login --use-device-code --tenant $tenantId
         ```

    1. Check the VM power state using Azure CLI as follows:

        ```azurecli
        az stack-hci-vm show --name $vmName --resource-group $rgName --query "properties.status"
        ``` 

        Sample output:

        ```azurecli
        PS C : \Users\AzureStackAdminD> az stack-hci-vm show --name <VM name> --resource-group <resource group> --query "properties.status"
        {
            "errorCode":
            "errorMessage" :
            "powerstate": "Stopped",
            "provisioningstatus": null
        }
        ```

1. For Hyper-V generation 2 VMs, ensure the power status shown on Azure portal matches the actual power state of the migrated VM on Hyper-V Manager, regardless of whether it is **On** or **Off**:

    **Azure portal view**

    :::image type="content" source="./media/migrate-enable-guest-management/vm-running-portal.png" alt-text="Screenshot showing VM power state in Azure portal." lightbox="./media/migrate-enable-guest-management/vm-running-portal.png":::

    **Hyper-V Manager view**

    :::image type="content" source="./media/migrate-enable-guest-management/vm-running-hyperv-manager.png" alt-text="Screenshot showing VM power state in Hyper-V Manager." lightbox="./media/migrate-enable-guest-management/vm-running-hyperv-manager.png":::

**Step 2**: Attach the ISO for the guest agent on the migrated VM as follows:

Connect to an Azure Local machine and run the following command in PowerShell, where `$vmName` is the name of the migrated VM to have guest agent enabled and `$rgName` is the name of the resource group where this VM lives on Azure:

```azurecli
az stack-hci-vm update --name $vmName --resource-group $rgName --enable-vm-config-agent true
```

**Sample output:**

```azurecli
PS C:\Users\AzureStackAdminD> az stack-hci-vm update --name $vmName -enable-vm-config-agent true --resource-group $resourceGroup
{
"endTime": "2024-08-19T22:01:22.1060463z",
"error": {},
"extendedLocation": null ,
"id": "<ID>",
"identity": null,
"name": "<Name>",
"properties": null,
"resourceld": "<Resource ID>",
"startTime": "2024-08-19T22: 01:09.4898702z" ,
"status": "Succeeded",
"systemData" : null,
"type": null
}
```

Sample state of the VM with the ISO attached, viewed from the Azure Local system:

:::image type="content" source="./media/migrate-enable-guest-management/vm-settings.png" alt-text="Screenshot showing ISO attachment." lightbox="./media/migrate-enable-guest-management/vm-settings.png":::

**Step 3**: Turn on the migrated VM, if needed, in Azure portal and ensure it has public network connectivity as follows:

1. Check that the VM **Status** on Azure portal is **Running**:

    :::image type="content" source="./media/migrate-enable-guest-management/vm-running-portal.png" alt-text="Screenshot showing VM status in Azure portal." lightbox="./media/migrate-enable-guest-management/vm-running-portal.png":::

1. Check that the VM **powerState**  is **Running** by running following command on your Azure Local machine in a PowerShell window:

    ```azurecli
    az stack-hci-vm show --name $vmName --resource-group $rgName --query “properties.status” 
    ```

    ```azurecli
    PS C: \Users\AzureStackAdminD> az stack-hci-vm show --name <Name> --resource-group <Resource group> --query "properties.status" 
    {
    "errorCode":
    "errorMessage":
    "powerState": "Running",
    "provisioningStatus": null
    }
    ```

**Step 4**: Install the guest agent ISO on the migrated VM as follows:

1. Connect to the VM using your applicable OS-specific steps.

1. Establish public network connectivity on the VM.

1. Run the following command to enable the guest agent on the VM based on the OS you are using:

    - If on Linux, open **Terminal** and run:

        ```azurecli
        sudo -- sh -c 'mkdir /mociso && mount -L mocguestagentprov /mociso && bash /mociso/install.sh && umount /mociso && rm -df /mociso'
        ```

        **Sample output (Linux):**

        ```azurecli
        migration@migration-virtual-machine: $ sudo -- sh -c 'mkdir /mociso && mount -L mocguestagentprov /nociso && bash /mociso/install.sh && umount /mociso && rm -df/mociso && eject LABEL=mocguestagentprov'
        [sudo] password for migration:
        mount: /moctso: WARNING: device write-protected, mounted read-only.
        Loading configuration version 've.16.5'...
        The agent could not find the '/opt/mocguestagent/v0.16.5/config.yaml' config file. Looking for older versions to upgrade from...
        Service installed.
        Service started.
        The guest agent was successfully installed.
        ```

    - If on Windows, open PowerShell as administrator and run:

      ```azurecli
        $d=Get-Volume -FileSystemLabel mocguestagentprov;$p=Join-Path ($d.DriveLetter+':\') 'install.ps1';powershell $p 
        ```

        **Sample output (Windows):**

```azurecli
PS C:\Users\Administrator> $d=Get-Volume -FilesystemLabel mocguestagentprov;$p=Join-Path ($d.DriveLetter+':\') 'install ps1';powershell $p

Directory : C : \ProgramData\mocguestagent


Mode	LastWriteTime	Length Name
----    -------------   -----------
d------	8/19/2024	5:46 PM	certs
Loading configuration version 'v0.16.5'...
The agent could not find the 'C:\ProgramData\mocguestagent\v0.16.5\config.yaml' config file. Looking for older versions to upgrade from...
Service installed.
Service started.
The guest agent was successfully installed.
```


## Enable guest management

You can enable guest management after the guest agent is running as follows:

1. Enable guest management from your Azure Local instance by running the following command in Azure CLI:

    ```azurecli
    az stack-hci-vm update --name $vmName --resource-group $rgName --enable-agent true
    ```

    Sample output:

    ```azurecli
    PS C:\Users\AzureStackAdminD> az stack-hci-vm update --name $vmName --resource-group $resourceGroup --enable-agent true
    {
    "endTime": "2024-08-19T22:59:13.9583373Z”,
    "error": {},
    "extendedLocation" : null,
    "id": "/<ID>",
    "identity": null,
    "name": "<Name>",
    "properties": null,
    "resourceld": "<Resource ID",
    "startTime": "2024-08-19t22:28:23.8158331Z",
    "status": "Succeeded",
    "systemData": null,
    "type": null
    }
    ```

1. Check for guest management enablement status in Azure portal:

    :::image type="content" source="./media/migrate-enable-guest-management/guest-management-enabled-portal.png" alt-text="Screenshot of guest management enablement in Azure portal." lightbox="./media/migrate-enable-guest-management/guest-management-enabled-portal.png":::

1. You are now ready to add the Azure extensions of your choice.

If you encounter any issues, contact Microsoft Support and provide your logs and deployment details.

## Appendix

If you forgot to turn off Hyper-V Generation 1 VM before running the update command with `--enable-vm-config-agent true`, the update command will fail and the VM may become unmanageable from Azure portal:

```azurecli
PS C:\Users\AzureStackAdminD> az stack-hci-vm update --name <VM name> -- resource-group <Resource group> --enable-vm-config-agent true
(Failed) moc-operator virtualmachine serviceclient returned an error while reconciling: rpc error: code = Unknown dasc = AddlSODisk for IsoFile mocguestagentprov.iso failed. Error: ErrorCode[32768] ErrorDescription[<VM name>' failed to add device 'Synthetic DVD Drive'. (Virtual machine ID <VM ID>)] ErrorSummaryDescription [Failed to add device 'Synthetic DVD Drive'.]: WMI Error 0x00008000: Failed
Code: Failed
Message: moc-operator virtualmachine serviceclient returned an error while reconciling: rpc error: code = Unknown desc = AddlSODisk for IsoFile mocguestagentprov.iso failed. Error: ErrorCode[32768] ErrorDescription['<VM name>' failed to add device 'Synthetic DVD Drive'. (Virtual machine ID <VM ID>)] ErrorSummaryDescription [Failed to add device 'Synthetic DVD Drive'.]: WMI Error 0x00008000: Failed
```

To resolve this, stop the VM in Azure portal by selecting **Stop**. If this doesn't work, run the following command from Azure CLI:

```azurecli
az stack-hci-vm stop --name $vmName --resource-group $rgName
```

You may see a **Resource failed to provision** error in Azure portal with **Start**, **Restart**, and **Stop** selections disabled, but Hyper-V Manager should show the VM is actually stopped:

:::image type="content" source="./media/migrate-enable-guest-management/appendix-portal.png" alt-text="Screenshot showing the Resource failed to provision error." lightbox="./media/migrate-enable-guest-management/appendix-portal.png":::

```azurecli
az stack-hci-vm update --name $vmName --resource-group $rgName --enable-vm-config-agent true 
```

## Next steps

- If you experience any issues, see [Troubleshoot VMware migration issues](./migrate-troubleshoot.md).
