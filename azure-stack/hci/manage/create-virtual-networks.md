---
title: Create virtual networks
description: Learn how to create virtual networks.
author: ksurjan
ms.author: ksurjan
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/02/2022
---

# Create virtual networks

> Applies to: Azure Stack HCI, versions 22H2 and 21H2

This article describes how to add virtual network for your Azure Stack HCI. You can create or add virtual networks using Windows Admin Center or PowerShell for the custom location associated with the Azure Stack HCI cluster.

## Create virtual networks for custom location

# [Windows Admin Center](#tab/windows-admin-center)

To create or add virtual networks and images for the custom location associated with the Azure Stack HCI cluster:

Access **Azure Arc VM setup for Azure Stack HCI** under cluster **Settings** again. On this page, project the vmswitch name that is used for network interfaces during VM provisioning. Also project the OS gallery images that are used for creating VMs through Azure Arc.

# [Azure CLI](#tab/azurecli)

To create or add virtual networks for the custom location associated with the Azure Stack HCI cluster.

1. Make sure you have an external VM switch deployed on all hosts of the Azure Stack HCI cluster. Run the following command to get the name of the VM switch and provide this name in the subsequent step.

    ```azurecli
    Get-VmSwitch
    ```

1. Create a virtual network on the VM switch that is deployed on all hosts of your cluster. Run the following commands:

   ```azurecli
   $vlanid=<vLAN identifier for Arc VMs>   
   $vnetName=<user provided name of virtual network>
   New-MocGroup -name "Default_Group" -location "MocLocation"
   New-MocVirtualNetwork -name "$vnetName" -group "Default_Group" -tags @{'VSwitch-Name' = "$vswitchName"} [[-ipPools] <String[]>] [[-vlanID] <UInt32>]
   az azurestackhci virtualnetwork create --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --network-type "Transparent" --name $vnetName --vlan $vlanid
   ```

   where:

   | Parameter | Description |
   | ----- | ----------- |
   | **vlanid** | vLAN identifier for Arc VMs. |
   | **vnetName** | User provided name of virtual network. |

1. Create an OS gallery image that will be used for creating VMs by running the following cmdlets, supplying the parameters described in the following table.
   
   Make sure you have a Windows or Linux VHDX image copied locally on the host. The VHDX image must be gen-2 type and have secure-boot enabled. It should reside on a Cluster Shared Volume available to all servers in the cluster. Arc-enabled Azure Stack HCI supports Windows and Linux operating systems.

   ```azurecli
   $galleryImageName=<gallery image name>
   $galleryImageSourcePath=<path to the source gallery image>
   $osType="<Windows/Linux>"
   az azurestackhci galleryimage create --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --image-path $galleryImageSourcePath --name $galleryImageName --os-type $osType
   ```

---

## Next steps

- [Go to the Azure portal to create VMs](https://portal.azure.com/#home)
- [Manage virtual machines in the Azure portal](manage-virtual-machines-in-azure-portal.md)