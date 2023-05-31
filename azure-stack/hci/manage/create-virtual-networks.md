---
title: Create virtual networks for Azure Stack HCI cluster (preview)
description: Learn how to create virtual networks that can be used by Azure Arc VMs running on your Azure Stack HCI cluster (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/31/2022
---

# Create virtual networks for Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, versions 22H2 and 21H2

This article describes how to create or add virtual networks for your Azure Stack HCI cluster.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Create virtual networks for custom location

You can create or add virtual networks using Windows Admin Center or PowerShell for the custom location associated with the Azure Stack HCI cluster.

### [Azure CLI](#tab/azurecli)

### Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure that you've access to an Azure Stack HCI cluster.

1. Make sure you have an external VM switch deployed on all hosts of the Azure Stack HCI cluster. By default, an external switch is created during the deployment of your Azure Stack HCI cluster. You can also create another external switch on your cluster.

    Run the following command to get the name of the VM switch that you'll use. 

    ```azurecli
    Get-VmSwitch -SwitchType External
    ```

    Here's a sample output:

    ```azurecli
    
    ```
1. Make a note of the name of the switch. You'll use this information when you create a virtual switch.

### Create virtual network 

You can use the `New-MocVirtualNetwork` cmdlet to create a virtual network on the VM switch for DHCP or a static configuration. The parameters used for each case are different. Create a virtual network on the VM switch that is deployed on all hosts of your cluster. 

#### Parameters used to create virtual network

   For both DHCP and static, the *required* parameters to be specified are tabulated as follows:

   | Parameter | Description |
   | ----- | ----------- |
   | **Name** | User provided name for the virtual network. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a virtual network after it is created. |


   For static IP only, the *required* basic parameters are tabulated as follows:


   | Parameter | Description |
   | --------- | ----------- |
   | **IP allocation method** |IP address allocation method. Choose from dynamic or static. |
   | **Address prefix** | Subnet address in CIDR notation.  |
   | **IpPoolStart**, **IpPoolEnd** | Start and end IPv4 addresses of the IP pool. This pool maps to an available, reserved IP range by your network administrator. |

   For static IP only, you can specify the following *optional* parameters:

   | Parameter | Description |
   | --------- | ----------- |
   | **DNSServers** | IPv4 address of DNS servers. |
   | **Gateway** | Ipv4 address of the default gateway. |
   | **Routes** | User provided name of virtual network. |
   | **VLAN ID** | vLAN identifier for Arc VMs. Contact your network admin to get this value. A 0 value implies that there is no vLAN ID.  |

#### Configure DHCP

Follow these steps to configure a DHCP virtual network:

1. Set the following parameters:

    ```azurecli
    $MocLocation = 
    $VNetName =
    $VSwitchName = 
    $ResourceGroupName = 
    $CustomLocName = 
    $Subscription =    
    $Location = 
    ```

1. Run the following cmdlet to create a DHCP virtual network:

   ```azurecli
   New-MocGroup -name "Default_Group" -location "$MocLocation"
   New-MocVirtualNetwork -name "$VNetName" -group "Default_Group" -tags @{'VSwitch-Name' = "$VSwitchName"} 
   az azurestackhci virtualnetwork create --subscription $Subscription --resource-group $ResourceGroupName --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$CustomLocName" type="CustomLocation" --location $Location --network-type "Transparent" --name $vnetName 
   ```

    Here's a sample output:

    ```azurecli
    
    ```

#### Configure static

1. Set the following parameters:

    ```azurecli
    $VNetName = 
    $VSwitchName = 
    $Location = 
    $AddressPrefix = 
    $IpPoolStart = 
    $IpPoolEnd = 
    $DnsServers = 
    $Gateway = 
    $Routes = 
    $VLanId =     
    ```

1. Run the following cmdlet to create a static virtual network:


    Here's a sample output:

    ```azurecli
    
    ```

### [Windows Admin Center](#tab/windows-admin-center)

Access **Azure Arc VM setup for Azure Stack HCI** under cluster **Settings** again. On this page, project the virtual switch name that is used for network interfaces during VM provisioning. Also project the OS gallery images that are used for creating VMs through Azure Arc.

---

## Next steps

- [Manage virtual machines in the Azure portal](manage-virtual-machines-in-azure-portal.md)
