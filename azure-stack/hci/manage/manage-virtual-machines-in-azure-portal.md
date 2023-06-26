---
title: Create Arc virtual machines on Azure Stack HCI (preview)
description: Learn how to view your cluster in the Azure portal and create Arc virtual machines on your Azure Stack HCI (preview).
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 06/08/2023
---

# Use VM images to create Arc virtual machines on Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to create an Arc VM starting with the VM images that you've created on your Azure Stack HCI cluster. You can create Arc VMs using the Azure portal.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About Azure Stack HCI cluster resource

You can use the [Azure Stack HCI cluster resource page](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.AzureStackHCI%2Fclusters) for the following operations:

- You can create and manage Arc VM resources such as VM images, disks, network interfaces.
- You can use this page to view and access Azure Arc Resource Bridge and Custom Location associated with the Azure Stack HCI cluster.
- You can also use this page to provision and manage Arc VMs.

The procedure to create Arc VMs is described in the next section.

## Prerequisites

Before you create an Azure Arc-enabled VM, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-prerequisites](../../includes/hci-vm-prerequisites.md)]

- Access to a virtual network that you have created on your Azure Stack HCI cluster. For more information, see [Create virtual network]().
- Access to a client that can connect to your Azure Stack HCI cluster. This client should be:

    - Running PowerShell 5.0 or later.
    - Running the latest version of `az` CLI.
        - [Download the latest version of `az` CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli). Once you have installed `az` CLI, make sure to restart the system.
        -  If you have an older version of `az` CLI running, make sure to uninstall the older version first.
    - Running the latest version for `azurestackhci` module. To verify, run the `az version` command. Here is a sample output:
        
        ```azurecli
        PS C:\windows\system32> az version
        {
          "azure-cli": "2.42.0",
          "azure-cli-core": "2.42.0",
          "azure-cli-telemetry": "1.0.8",
          "extensions": {
            "azurestackhci": "0.2.6",
            "k8s-extension": "1.3.9"
          }
        }
        ```

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-prerequisites](../../includes/hci-vm-prerequisites.md)]

---

## Create Arc VMs

Follow these steps to create an Arc VM on your Azure Stack HCI cluster.

# [Azure CLI](#tab/azurecli)

Follow these steps on the client running az CLI and is connected to your Azure Stack HCI cluster.

### Parameters used to create virtual network interface

For a virtual network interface created on a DHCP or static virtual network, the *required* parameters to be specified are tabulated as follows:

| Parameter | Description |
| ----- | ----------- |
| **name** | Name for the virtual network interface that you'll create on the virtual network deployed on your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a virtual network interface after it's created. |
| **resource-group** |Name of the resource group where your Azure Stack HCI is deployed. This could also be another precreated resource group. |
| **subscription** |Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for virtual network on your Azure Stack HCI cluster. |
| **CustomLocation** |Name or ID of the custom location to use for virtual network on your Azure Stack HCI cluster. For more information, see how to create a custom location when you [Deploy an Arc Resource Bridge via the command line](../manage/deploy-arc-resource-bridge-using-command-line.md#set-up-arc-vm-management) |
| **Location** | Azure regions as specified by `az locations`. For example, this could be `eastus`, `eastus2euap`. |
| **subnet-id** |SHOULD THIS BE VNET? - Subnet address in CIDR notation. For example: "192.168.0.0/16".  |
 

For static IP only, additional *required* basic parameters are tabulated as follows:

| Parameter | Description |
| --------- | ----------- |
| **ip-allocation-method** |IP address allocation method and could be `dynamic` or `static` for your virtual network interface. If this parameter isn't specified, by default the virtual network interface is created with a dynamic configuration. |
| **ip-address** | An IPv4 address you want to assign to the virtual network interface that you are creating. For example: "192.168.0.10".  |
    

### Create virtual network interface

To create a VM, you'll first need to create a virtual network interface on your virtual network. The steps can be different depending on whether your virtual network is static or DHCP.

#### Configure for a DHCP virtual network

Follow these steps to create a virtual network interface on your DHCP virtual network. Replace the parameters in `< >` with the appropriate values.

1. Run PowerShell as an administrator.

1. Sign in. Type:

    ```azurecli
    az login
    ```

1. Set your subscription.

    ```azurecli
    az account set --subscription <Subscription ID>
    ```
 
1. Set the required parameters. Here's a sample output:

    ```azurecli
    $VNic = "testnic001"
    $VNetName = "test-vnet-dynamic"   
    $Subscription =  "hcisub" 
    $ResourceGroupName = "hcirg"
    $CustomLocName = "hci-hybridaks-cl" 
    $Location = "eastus2euap"

1. To create a virtual network interface, run the following command:
 
    ```azurecli
    az azurestackhci networkinterface create --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --subnet-id $VNet --name $VNic
    ```
   
    Here is a sample output:
    
    ```azurecli
    
    {
      "extendedLocation": {
        "name": "/subscriptions/0709bd7a-8383-4e1d-98c8-f81d1b3443fc/resourceGroups/hybridaksresgrp-491206666/providers/Microsoft.ExtendedLocation/customLocations/hci-hybridaks-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/0709bd7a-8383-4e1d-98c8-f81d1b3443fc/resourceGroups/hcirg/providers/Microsoft.AzureStackHCI/networkinterfaces/testnic001",
      "location": "eastus2euap",
      "name": "testnic001",
      "properties": {
        "ipConfigurations": [
          {
            "name": null,
            "properties": {
              "gateway": null,
              "prefixLength": null,
              "privateIpAddress": null,
              "privateIpAllocationMethod": null,
              "subnet": {
                "id": "test-vnet-dynamic"
              }
            }
          }
        ],
        "macAddress": null,
        "provisioningState": "Succeeded",
        "resourceName": "testnic001",
        "status": {}
      },
      "resourceGroup": "hcirg",
      "systemData": {
        "createdAt": "2023-02-08T23:25:10.984508+00:00",
        "createdBy": "hciuser@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-02-08T23:26:03.262252+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/networkinterfaces"
    }
    PS C:\windows\system32> 
    ```

#### Configure on a static virtual network


Follow these steps to create a virtual network interface on your static virtual network. Replace the parameters in `< >` with the appropriate values.

1. Run PowerShell as an administrator.


1. Sign in. Type:

    ```azurecli
    az login
    ```

1. Set your subscription.

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

1. Set the required parameters. Here's a sample output:

    ```azurecli
    $VNic = "test-vnic-SI-custom"
    $VNetName = "test-vnet-static"   
    $Subscription =  "hcisub" 
    $ResourceGroupName = "hcirg"
    $CustomLocName = "hci-hybridaks-cl" 
    $Location = "eastus2euap"
    $IpAddress = "10.0.0.14"
    $IpAllocationMethod = "Static"


1. To create a virtual network interface, run the following command:

    ```azurecli
    az azurestackhci networkinterface create --subscription $subscription --resource-group $resource_group --extended-location name=$customLocationID type="CustomLocation" --location $Location --name $VNic --ip-allocation-method $IpAllocationMethod --subnet-id $Vnet --ip-address $IpAddress
    ```
    
    Here's a sample output:
    
    ```console
    
    az azurestackhci networkinterface create --subscription $subscription --resource-group $resource_group --extended-location name=$customLocationID type="CustomLocation" --location "eastus2euap" --name "test-vnic-SI-custom" --ip-allocation-method "Static" --subnet-id "test-vnet-static" --ip-address "10.0.0.14"
    
    {
      "extendedLocation": {
        "name": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourcegroups/hcirg/hci-hybridaks-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourceGroups/hcirg/providers/Microsoft.AzureStackHCI/networkinterfaces/test-vnic-SI-custom",
      "location": "eastus2euap",
      "name": "test-vnic-SI-custom",
      "properties": {
        "dnsSettings": null,
        "ipConfigurations": [
          {
            "name": null,
            "properties": {
              "gateway": null,
              "prefixLength": "24",
              "privateIpAddress": "10.0.0.14",
              "privateIpAllocationMethod": "Static",
              "subnet": {
                "id": "test-vnet-static"
              }
            }
          }
        ],
        "macAddress": null,
        "provisioningState": "Succeeded",
        "resourceName": null,
        "status": {}
      },
      "resourceGroup": "hcirg",
      "systemData": {
        "createdAt": "2023-06-01T18:53:58.160639+00:00",
        "createdBy": "johndoe@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-06-01T19:01:34.021718+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/networkinterfaces"
    }
    ```


### Create VM

To create a VM with guest management enabled, you'll use the network interface that you created in the previous step. You can create a Windows VM or a Linux VM.

#### Create a Windows VM


1. Set the parameters.

    $galleryImageName = "<Name of the VM image you'll use to create VM. This is Windows or Linux image based on the VM you want to create.>" 

1. To create a Windows VM, run the following command:

    ```azurecli
    az azurestackhci virtualmachine create --name $vm_name --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --hardware-profile vm-size="Default" --computer-name "testvm0001" --admin-username "<VM administrator username>" --admin-password "<VM administrator password>" --image-reference $galleryImageName --nic-id $VNic --provision-vm-agent true --debug
    ```

    Make sure to provide the VM computer name, VM administrator username, and the VM administrator password.

    In the above cmdlet, the parameter `--provision-vm-agent` when set to `true` enables guest management in the VM that is created. To disable guest management, you can omit the parameter or set it to `false`.


    Here is a sample output:
    
    ```
    PS C:\windows\system32> az azurestackhci virtualmachine create --name $vm_name --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --hardware-profile vm-size="Default" --computer-name "testvm0001" --admin-username "admin" --admin-password "pass" --image-reference $galleryImageName --nic-id $VNic --provision-vm-agent true --debug
    Guest Management for Azure Stack HCI VMs is currently in Preview. This command enables password-based authentication for the created VM. Would you like to proceed? (y/N): y
    
    ********************************************************************************
    {
      "extendedLocation": {
        "name": "/subscriptions/0709bd7a-8383-4e1d-98c8-f81d1b3443fc/resourceGroups/hybridaksresgrp-491206666/providers/Microsoft.ExtendedLocation/customLocations/hci-hybridaks-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/0709bd7a-8383-4e1d-98c8-f81d1b3443fc/resourceGroups/hybridaksresgrp-491206666/providers/Microsoft.AzureStackHCI/virtualmachines/testvm001",
      "identity": {
        "principalId": "9ab8c590-8f6e-4657-89f4-54af762153d4",
        "tenantId": "72f988bf-86f1-41af-91ab-2d7cd011db47",
        "type": "SystemAssigned"
      },
      "location": "eastus",
      "name": "testvm001",
      "properties": {
        "guestAgentProfile": {
          "agentVersion": "1.25.02203.713",
          "errorDetails": [],
          "lastStatusChange": "2023-02-08T23:46:26.6921034Z",
          "status": "Connected",
          "vmuuid": "31B7B385-1502-467C-BCB0-A815CAB0C5F7"
        },
        "hardwareProfile": {
          "dynamicMemoryConfig": null,
          "memoryGb": 4,
          "processors": 4,
          "vmSize": "Custom"
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "testnic001"
            }
          ]
        },
        "osProfile": {
          "adminPassword": null,
          "adminUsername": "admin",
          "computerName": "testvm0001",
          "linuxConfiguration": {
            "disablePasswordAuthentication": false,
            "provisionVmAgent": true,
            "ssh": null
          },
          "osType": null,
          "windowsConfiguration": {
            "enableAutomaticUpdates": null,
            "provisionVmAgent": true,
            "ssh": null,
            "timeZone": null
          }
        },
        "provisioningState": "Succeeded",
        "resourceName": "testvm001",
        "securityProfile": {
          "enableTpm": null,
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
            "name": "windos"
          },
          "osDisk": {
            "id": null
          },
          "storagepathId": null
        },
        "vmId": "85679cec-a80a-11ed-bfb6-22ee2f11ced4"
      },
      "resourceGroup": "hybridaksresgrp-491206666",
      "systemData": {
        "createdAt": "2023-02-08T23:43:59.974877+00:00",
        "createdBy": "hciuser@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-02-08T23:46:35.803537+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/virtualmachines"
    }
    
    ```

The VM is successfully created when the `provisioningState` shows as `succeeded`in the output.

#### Create a Linux VM

To create a Linux VM, run the following command:


```azurecli
az azurestackhci virtualmachine create --name $vm_name --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --hardware-profile vm-size="Default" --computer-name "testvm0001" --admin-username "admin" --admin-password "pass" --image-reference $galleryImageName --nic-id $VNic --provision-vm-agent true --allow-password-auth true
```
This command will create a Linux VM with guest management enabled. The command is similar to the one used for Windows VM creation with the exception of the inclusion of `--allow-password-auth` parameter. The gallery image used should also be a Linux image. 

The VM is successfully created when the `provisioningState` shows as `succeeded`in the output.

# [Azure portal](#tab/azureportal)

Follow these steps in Azure portal of your Azure Stack HCI cluster.

1. Go to **Resources (Preview) > Virtual machines**.
1. From the top command bar, select **+ Create VM**.

   :::image type="content" source="./media/manage-vm-resources/select-create-vm.png" alt-text="Screenshot of select + Create VM." lightbox="./media/manage-vm-resources/select-create-vm.png":::

1. In the **Create an Azure Arc virtual machine** wizard, on the **Basics** tab, input the following parameters:

    1. **Subscription** – The subscription is tied to the billing. Choose the subscription that you want to use to deploy this VM.

    1. **Resource group** – Create new or choose an existing resource group where you'll deploy all the resources associated with your VM.

    1. **Virtual machine name** – Enter a name for your VM. The name should follow all the naming conventions for Azure virtual machines.  
    
        > [!IMPORTANT]
        > VM names should be in lowercase letters and may use hyphens and numbers.

    1. **Custom location** – Select the custom location for your VM. The custom locations are filtered to only show those locations that are enabled for your Azure Stack HCI.

    1. **Image** – Select the Marketplace or customer managed image to create the VM image.
    
        1. If you selected a Windows image, provide a username and password for the administrator account. You'll also need to confirm the password.
 
           :::image type="content" source="./media/manage-vm-resources/create-arc-vm-windows-image.png" alt-text="Screenshot showing how to Create a VM using Windows VM image." lightbox="./media/manage-vm-resources/create-arc-vm-windows-image.png":::       

        1. If you selected a Linux image, in addition to providing username and password, you'll also need SSH keys.

           :::image type="content" source="./media/manage-vm-resources/create-arc-vm-linux-vm-image.png" alt-text="Screenshot showing how to Create a VM using a Linux VM image." lightbox="./media/manage-vm-resources/create-arc-vm-linux-vm-image.png":::


    1. **Virtual processor count** – Specify the number of vCPUs you would like to use to create the VM.

    1. **Memory** – Specify the memory in GB for the VM you intend to create.

    1. **Memory type** – Specify the memory type as static or dynamic.

       :::image type="content" source="./media/manage-vm-resources/create-arc-vm.png" alt-text="Screenshot showing how to Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm.png":::
    
    1. **Administrator account** – Specify the username and the password for the administrator account on the VM.
    
    1. **Enable guest management** – Select the checkbox to enable guest management. You can install extensions on VMs where the guest management is enabled.
    
        > [!NOTE]
        > - You can't enable guest management via Azure portal if the Arc VM is already created.
        > - Add at least one network interface through the **Networking** tab to complete guest management setup.
        > - The network interface that you enable, must have a valid IP address and internet access. For more information, see [Arc VM management networking](../manage/azure-arc-vm-management-networking.md#arc-vm-virtual-network).

    1. If you selected a Windows VM image, you can domain join your Windows VM. Follow these steps: 
    
        1. Select **Enable domain join**.
    
        1. Only the Active Directory domain join is supported and selected by default.  
        
        1. Provide the UPN of an Active Directory user who has privileges to join the virtual machine to your domain.
        
        1. Provide the domain administrator password.

        1. Specify domain or organizational unit. You can join virtual machines to a specific domain or to an organizational unit (OU) and then provide the domain to join and the OU path.
        
            If the domain is not specified, the suffix of the Active Directory domain join UPN is used by default. For example, the user *azurestackhciuser@contoso.com* would get the default domain name *contoso.com*.
        
       :::image type="content" source="./media/manage-vm-resources/create-vm-enable-guest-management.png" alt-text="Screenshot guest management enabled during Create a VM." lightbox="./media/manage-vm-resources/create-vm-enable-guest-management.png":::

1. **(Optional)** Create new or add more disks to the VM by providing a name and size. You can also choose the disk type to be static or dynamic.

1. **(Optional)** Create or add network interface (NIC) cards for the VM by providing a name for the network interface. Then select the network and choose static or dynamic IP addresses.

    > [!NOTE]
    > If you enabled guest management, you must add at least one network interface.

   :::image type="content" source="./media/manage-vm-resources/create-arc-vm-2.png" alt-text="Screenshot of network interface added during Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm-2.png":::

1. **(Optional)** Add tags to the VM resource if necessary.

1. Review all the properties, and then select **Create**. It should take a few minutes to provision the VM.

---

## Next steps

- [Install and manage VM extensions](./virtual-machine-manage-extension.md).
- [Troubleshoot Arc VMs](troubleshoot-arc-enabled-vms.md).
- [Frequently Asked Questions for Arc VM management](faqs-arc-enabled-vms.md).