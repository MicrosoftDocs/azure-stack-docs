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

This article describes how to create or add virtual network for your Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Create virtual networks for custom location

You can create or add virtual networks using Windows Admin Center or PowerShell for the custom location associated with the Azure Stack HCI cluster.

# [Windows Admin Center](#tab/windows-admin-center)

Access **Azure Arc VM setup for Azure Stack HCI** under cluster **Settings** again. On this page, project the vmswitch name that is used for network interfaces during VM provisioning. Also project the OS gallery images that are used for creating VMs through Azure Arc.

# [Azure CLI](#tab/azurecli)

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

---

## Next steps

- [Manage virtual machines in the Azure portal](manage-virtual-machines-in-azure-portal.md)