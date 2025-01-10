---
title: Create Arc virtual machines using VHDs
description: Learn how to create Azure Arc virtual machines for Azure Local using existing VHDs.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack-hci
ms.date: 01/10/2025
---

# Create Arc virtual machines using VHDs 

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to create Azure Arc virtual machines (VMs) on Azure Local using an existing VHD or VHDX file, such as from an existing VM deployed on Hyper-V, Azure Stack Hub, or Azure Stack Edge. The steps described use REST API calls to create the network interface, operating system (OS) disk, and Arc VM.

An intermediate step replaces the new VM VHD/VHDX OS disk with the existing VHD/VHDX disk by copying or moving the VHD at the cluster shared volume and file system level of your Azure Local instance.

## Prerequisites

- If the source VM resides on Azure Stack Hub or Azure Stack Edge, you must remove the Azure agent that is installed on the Guest VM OS of the source VM. The steps to remove the Azure agent are detailed later.

- Export the OS and data disks from the source machine and configure the OS by copying the VHD/VHDX to the cluster shared volume *UserStorage_X*. No sysprep or generalization of the existing VM OS is required.

## On the target

1. Create vNICs for each of the VMs.

1. Create a placeholder disk for each VHD/VHDX to be added to the new Arc VM.

1. Swap the placeholder disks with the actual VHD/VHDX copied or moved on the cluster shared volume.

1. Create the Arc VM using ARM deployment triggered using the REST API.

## Using automation scripts

Steps 1 through 3 are run in the `AzContext` of your Azure subscription where the Azure Local instance is located. Use the CloudShell, ensuring that the `Get-AzContext` is set to the correct Azure SubID

Step 4 scripts are run on the Azure Local instance.

### 1. Create network adapters using APIs

Run this script:

```azurepowershell
<# 
// "<replace-with-sub-ID>" -> as the name says 
// "<resource-group>" -> Resource group  
// "<vm-nic-name>" -> NIC name 
// "<custom-location-name>" -> name of your custom location 
// "<logical-network-name>" -> logical network 
// "<azure-region-name>" -> example, eastus or other azure region 
#> 

$uri = "https://management.azure.com/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.AzureStackHCI/networkInterfaces/<vm-nic-name>?api-version=2023-09-01-preview" 

$payload= '{ 
    "extendedLocation": { 
        "name": "/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.ExtendedLocation/customLocations/<custom-location-name>", 
        "type": "CustomLocation" 
    }, 

    "tags": {}, 
    "location": "<azure-region-name>", 
    "properties": { 
        "ipConfigurations": [ 
            { 
                "name": "<vm-nic-name>", 
                "properties": { 
                    "subnet": { 
                        "id": "/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/microsoft.azurestackhci/logicalnetworks/<logical-network-name>" 
                    } 
                } 
            } 
        ] 
    } 
}'

Invoke-AzRestMethod -Method PUT -Uri $uri -Payload $payload 
```

### 2. Create a placeholder OS disk

Run this script:

```azurepowershell
<# 
// "<vm-name-osdisk>" - os disk name 
// "<replace-with-sub-ID>" -> as the name says 
// "<resource-group>" -> Resource group  
// "UserStorage1-3b09dxxxxxx046c2a052" -> update with the target “Azure Local Storage path” of the instance 
// "<custom-location-name>" -> name of your custom location 
// "<azure-region-name>" -> example, eastus or other azure region 
// if using vhdx/v2 -> update the "hyperVGeneration" and "diskFileFormat" values below 
#> 

$uri = "https://management.azure.com/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.AzureStackHCI/virtualHardDisks/<vm-name-osdisk>?api-version=2023-09-01-preview"

$payload='{ 
        "extendedLocation": { 
            "name": "/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.ExtendedLocation/customLocations/<custom-location-name>", 
            "type": "CustomLocation" 
        }, 

        "location": "<azure-region-name>", 
        "properties": { 
            "diskSizeGB": 127, 
            "dynamic": true, 
            "hyperVGeneration": "V1", 
            "diskFileFormat": "vhd", 
            "containerId": "/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.AzureStackHCI/storageContainers/UserStorage1-3b09dxxxxxx046c2a052" 

        } 
    }' 

Invoke-AzRestMethod -Method PUT -Uri $uri -Payload $payload
```

### 3. Swap the placeholder disk with the source VHD disk

Find the disk created above on your Azure Local storage. You can either rename this (red box) and then use the full name for the new disk (purple box), or use this command:

```azurepowershell
move .\pathtoSourceDisk .\pathToClusterStorage\<ame-used-above-to-create-disks> -force 
```

The source VHD should now be in storage, with the names of the disks created above.

:::image type="content" source="./media/create-arc-virtual-machines-vhd/1.png" alt-text="Screenshot storage disks." lightbox="./media/create-arc-virtual-machines-vhd/1.png":::  

### 4. Create the Arc VM

```azurepowershell
#### Create Arc VM instance ####          

<# 
// "UserStorage1-3b09dxxxxxx046c2a052" -> update with the target “Azure Local Storage path” of the target instance, mapping to the cluster shared volume. 
// "<vm-name-osdisk>" -> the name of the OS disk 
// "<custom-location-name>" -> name of your custom location 
// If you’re doing a gen2, change the TPM and secureboot values to true 
#> 

$uri = "https://management.azure.com/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.HybridCompute/machines/migvm3os-migvm/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default?api-version=2023-09-01-preview" 

$payload = '{ 
    "extendedLocation": { 
        "name": "/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.ExtendedLocation/customLocations/<custom-location-name>", 
        "type": "CustomLocation" 
    }, 

    "properties": { 
        "hardwareProfile": { 
            "vmSize": "Custom", 
            "processors": 2, 
            "memoryMB": 4000 
        }, 

        "networkProfile": { 
            "networkInterfaces": [ 
                { 
                    "id": "/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.AzureStackHCI/networkInterfaces/<vm-nic-name>" 
                } 
            ] 
        }, 

        "securityProfile": { 
            "enableTPM": false, 
            "uefiSettings": { 
                "secureBootEnabled": false 
            } 
        }, 

        "osProfile": { 
            "linuxConfiguration": { 
                "provisionVMAgent": false, 
                "provisionVMConfigAgent": false 
            }, 

            "windowsConfiguration": { 
                "provisionVMAgent": false, 
                "provisionVMConfigAgent": false 
            } 
        }, 

        "storageProfile": { 
            "osDisk": { 
                "id": "/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.AzureStackHCI/virtualHardDisks/<vm-name-osdisk>", 
                "osType": "Windows" 
            }, 

            "vmConfigStoragePathId": "/subscriptions/<replace-with-sub-ID>/resourceGroups/<resource-group>/providers/Microsoft.AzureStackHCI/storageContainers/UserStorage1-3b09dxxxxxx046c2a052" 
        } 
    } 
}' 

Invoke-AzRestMethod -Method PUT -Uri $uri -Payload $payload 

az stack-hci-vm show -g '<resource-group>' --name migvm1os-migvm
```

## Enable guest management

To enable guest management, see [Enable guest management](manage-arc-virtual-machines.md?tabs=windows#enable-guest-management).


1. Run `az stack-hci-vm update --name "vmname" --resource-group "rg" --enable-vm-config-agent true`.

    If this is a generation 1 (gen1) VM, shutdown the VM first, run this command, and then turn it back on:

1. Sign on to the VM and install the agent: `az stack-hci-vm update --name "vmname" --enable-agent true  --resource-group rg`.

## Removing the Azure agent

Removing the Azure Agent needs to be done for both Hub and ASE.

Thse scripts are based on the Hub process and need to be reviewed for ASE.

### For Windows VMS

1. Before removing the folder, check that the service is stopped (WaAppAgent and WaSecAgentProv are gone):

    ```azurepowershell
    get-process | ? { $_.name -ilike "*wa*" }
    ```
  
1. If not, run:

    ```azurepowershell
    set-service -Name WindowsAzureGuestAgent -StartupType Disabled; stop-service  -Name WindowsAzureGuestAgent;

    #if remove-service isn't available, means no PS6

    $service = Get-WmiObject -Class Win32_Service -Filter             "Name='WindowsAzureGuestAgent'"

    $service.delete()

    #reboot
    ```

3. Remove the binary:

    ```azurepowershell
    remove-item -path c:\windowsazure\packages -recurse -force
    ```

### For Linux VMS

```azurepowershell
# for Linux  

<TO DO>
```

## Known issues

For generation 1 VMs: CRUD operations not working for the newly created VMs. Cannot enable guest management.

Trying to stop an Arc VM will trigger the following error:

`moc-operator virtualmachine serviceClient returned an arror while
reconciling: error moc vm power state failed to update the expected
value: Stopped: Timedout`

Leaving this running for a while, it eventually stops the VM. It will show as stopped, but still get the error:

`errorCode: Failed`,

`errorMessage: moc-operator virtualmachine serviceClient returned an error while reconciling: moc-operator virtualmachine serviceClient returned an error while reconciling: error moc vm power state failed to update to the expected value: Stopped: Timedout,`

`powerState: Stopped,`

`provisioningStatus: null`

This is done to enable guest management, but even if the VM is shutdown, this still fails:

`(Failed) moc-operator virtualmachine serviceClient returned an arror while reconciling: error moc vm power state failed to update the expected value: Stopped: Timedout`

`Code: Failed`

`Message: moc-operator virtualmachine serviceClient returned an arror while
reconciling: error moc vm power state failed to update the expected
value: Stopped: Timedout`

## Next steps
