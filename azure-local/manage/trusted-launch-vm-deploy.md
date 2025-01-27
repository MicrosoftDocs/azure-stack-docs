---
title: Deploy Trusted launch for Azure Arc VMs on Azure Local, version 23H2
description: Learn how to deploy Trusted launch for Azure Arc VMs on Azure Local, version 23H2.
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 01/08/2025
---

# Deploy Trusted launch for Azure Arc VMs on Azure Local, version 23H2

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to deploy Trusted launch for Azure Arc virtual machines (VMs) on Azure Local, version 23H2.

## Prerequisites

Make sure that you have access to an Azure Local, version 23H2 system that is deployed and registered with Azure. For more information, see [deploy using the Azure portal](../deploy/deploy-via-portal.md).

## Create a Trusted launch Arc VM

You can create a Trusted launch VM using Azure portal or by using Azure Command-Line Interface (CLI). Use the tabs below to select a method.

# [Azure portal](#tab/azure-portal)

To create a Trusted launch Arc VM on Azure Local, follow the steps in the [Create Arc virtual machines on Azure Local](create-arc-virtual-machines.md) using Azure portal, with the following changes:

1. While creating the VM, select **Trusted launch virtual machines** for security type.

    :::image type="content" source="media/trusted-launch-vm-deploy/create-arc-vm-1.png" alt-text="Screenshot showing Trusted launch type selection." lightbox="media/trusted-launch-vm-deploy/create-arc-vm-1.png":::

1. Select a VM guest OS image from the list of supported images:

    :::image type="content" source="media/trusted-launch-vm-deploy/create-arc-vm-2.png" alt-text="Screenshot showing supported guest image selection." lightbox="media/trusted-launch-vm-deploy/create-arc-vm-2.png":::

1. Once a VM is created, go to the **VM properties** page and verify the security type shown is **Trusted launch**.
 
    :::image type="content" source="media/trusted-launch-vm-deploy/create-arc-vm-3.png" alt-text="Screenshot showing properties page." lightbox="media/trusted-launch-vm-deploy/create-arc-vm-3.png":::

# [Azure CLI](#tab/azure-cli)

To create a Trusted launch Arc VM on Azure Local, follow the steps in the [Create Arc virtual machines on Azure Local](create-arc-virtual-machines.md) using Azure CLI, with the following changes:

1. Create a VM image using a [supported VM guest OS image](trusted-launch-vm-overview.md#guest-operating-system-images) by Trusted launch from Azure Marketplace. For more information, see [Create Azure Local VM image using Azure Marketplace](/azure-stack/hci/manage/virtual-machine-image-azure-marketplace?tabs=azurecli).

1. Create a VM using CLI as follows:

    ```PowerShell
    $vmName="<Name of the VM>" 
    $subscription="<Subscription ID associated with your Azure Local system>" 
    $resourceGroup="<Resource group name for your Azure Local system>" 
    $location="<Location for your Azure Local system>" 
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for your Azure Local system>" --query id -o tsv) 
    $guestName="<Name of the guest>" 
    $userName="<Username for VM>" 
    $password="<Password for VM>" 
    $galleryImageName="<Name of VM guest image>" 
    $vNic="<Name of virtual network interface>" 

    az stack-hci-vm create --name $vmName --subscription $subscription --resource-group $resourceGroup --custom-location=$customLocationID --location $location --size="Default" --computer-name $guestName --admin-username $userName --admin-password $password --image $galleryImageName --nics $vNic --enable-secure-boot true --enable-vtpm true --security-type "TrustedLaunch"
    ```

    Sample output:

    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/myhci-sub/resourceGroups/myhci-rg/Microsoft.ExtendedLocation/customLocations/myhci-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/myhci-sub/resourceGroups/myhci-rg/providers/Microsoft.HybridCompute/machines/tvm1/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default",
      "name": "default",
      "properties": {
        "hardwareProfile": {
          "dynamicMemoryConfig": {
            "maximumMemoryMb": null,
            "minimumMemoryMb": null,
            "targetMemoryBuffer": null
          },
          "memoryMb": 4096,
          "processors": 4,
          "vmSize": "Custom"
        },
        "instanceView": {
          "vmAgent": {
            "statuses": []
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "ram-nic"
            }
          ]
        },
        "osProfile": {
          "adminPassword": null,
          "adminUsername": "admin",
          "computerName": "myhci-tvm",
          "linuxConfiguration": {
            "disablePasswordAuthentication": null,
            "provisionVmAgent": false,
            "provisionVmConfigAgent": false,
            "ssh": {
              "publicKeys": null
            }
          },
          "windowsConfiguration": {
            "enableAutomaticUpdates": null,
            "provisionVmAgent": false,
            "provisionVmConfigAgent": false,
            "ssh": {
              "publicKeys": null
            },
            "timeZone": null
          }
        },
        "provisioningState": "Succeeded",
        "securityProfile": {
          "enableTpm": true,
          "securityType": "TrustedLaunch",
          "uefiSettings": {
            "secureBootEnabled": true
          }
        },
        "status": {
          "powerState": "Running"
        },
        "storageProfile": {
          "dataDisks": [],
          "imageReference": {
            "id": "/subscriptions/myhci-sub/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/marketplacegalleryimages/Win11EntMulti21H2",
            "resourceGroup": "myhci-rg"
          },
          "osDisk": {
            "id": null,
            "osType": "Windows"
          },
          "storagepathId": null
        },
        "vmId": "myhci-tvm-1234567890"
      },
      "resourceGroup": "myhci-rg",
      "systemData": {
        "createdAt": "2023-10-24T19:15:47.152610+00:00",
        "createdBy": "registration@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-10-24T19:41:05.196469+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/virtualmachineinstances"
    }
    ```

1. Once VM is created, verify the security type of the VM as **Trusted launch**.

1. Run the following cmdlet to find the owner node of the VM:

    ```PowerShell
    Get-ClusterGroup $vmName
    ```

1. Run the following cmdlet on the owner node of the VM:  

    ```PowerShell
    (Get-VM $vmName).GuestStateIsolationType
    ```

1. Ensure a value of **TrustedLaunch** is returned.

---

## Automatic transfer of virtual TPM state

The virtual TPM (vTPM) state is automatically transferred in the case of Trusted launch Arc VMs when the VM migrates or fails over to another machine in the system.

Enabling Trusted launch for Arc VMs preserves the vTPM state and allows applications that rely on the vTPM state to function normally, even when the VM migrates or fails over to another machine in the system. 

### Example

This example shows a Trusted launch Arc VM running Windows 11 guest with BitLocker encryption enabled. Here are the steps to run this example: 

1. Create a Trusted launch Arc VM running a supported Windows 11 guest operating system.

1. Sign on to the Windows 11 guest and enable BitLocker encryption for the OS volume:

    1. In the search box on the task bar, enter "Manage BitLocker", and then select it from the list of results.

    1. Select **Turn on BitLocker** and then follow the instructions to encrypt the OS volume (C:). BitLocker uses vTPM as a key protector for the OS volume.

1. Confirm the owner node of the VM.

    ```powershell
    Get-ClusterGroup <VM name>
    ```

1. Migrate the VM to another machine in the system. Run the following PowerShell command from the machine that the VM is on.

    ```powershell
    Move-ClusterVirtualMachineRole -Name <vm name> -Node <destination node name> -MigrationType Shutdown
    ```

1. Confirm that the owner node of the VM is the specified destination node.

    ```powershell
    Get-ClusterGroup <VM name>
    ```

1. After VM migration completes, verify if the VM is available and BitLocker is enabled.

1. Verify that you can sign on to the Windows 11 guest in the VM, and if BitLocker encryption for the OS volume remains enabled. If true, this confirms that the vTPM state was preserved during VM migration.

    > [!NOTE]
    > If vTPM state wasn't preserved during VM migration, VM startup would've resulted in BitLocker recovery during guest boot up. That is, you would've been prompted for the BitLocker recovery password when you attempted to sign on to the Windows 11 guest. This happens because the boot measurement (stored in the vTPM) of the migrated VM on the destination node is different from that of the original VM.

1. Force the VM to failover to another machine in the system.

    1. Confirm the owner node of the VM using this command.

    ```powershell
    Get-ClusterGroup <VM name>
    ```

    1. Use Failover Cluster Manager to stop the cluster service on the owner node as follows: Select the owner node as displayed in Failover Cluster Manager.  On the **Actions** right pane, select **More Actions** and then select **Stop Cluster Service**.

    1. Stopping the cluster service on the owner node causes the VM to be automatically migrated to another available machine in the system. Restart the cluster service afterwards.

1. After failover completes, verify if the VM is available and BitLocker is enabled after failover.

1. Confirm that the owner node of the VM is the specified destination node.

    ```powershell
    Get-ClusterGroup <VM name>
    ```

1. After VM failover completes, verify if the VM is available and BitLocker is enabled.

1. Verify that you can sign on to the Windows 11 guest in the VM, and if BitLocker encryption for the OS volume remains enabled. If true, this confirms that the vTPM state was preserved during VM failover.

    > [!NOTE]
    > If vTPM state wasn't preserved during VM migration, VM startup would've resulted in BitLocker recovery during guest boot up. That is, you would've been prompted for the BitLocker recovery password when you attempted to sign on to the Windows 11 guest. This happens because the boot measurement (stored in the vTPM) of the migrated VM on the destination node is different from that of the original VM.


## Next steps

- [Manage Trusted launch Arc VM guest state protection key](trusted-launch-vm-import-key.md).
