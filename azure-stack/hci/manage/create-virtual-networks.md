---
title: Create virtual networks for Azure Stack HCI cluster (preview)
description: Learn how to create virtual networks on your Azure Stack HCI cluster. The Arc VM running on your cluster used this virtual network (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/25/2023
---

# Create virtual networks for Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, versions 22H2 and 21H2

This article describes how to create virtual networks for your Azure Stack HCI cluster. Virtual networks are an Azure resource and can be used to deploy virtual machines on your cluster. After a virtual network is created, you can create virtual network interfaces and associate those with the virtual machines you'll create.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]


## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure that you have access to an Azure Stack HCI cluster. This cluster should have Arc Resource Bridge installed on it and a custom location created as per the instructions in [Set up Arc Resource Bridge using Azure CLI](./deploy-arc-resource-bridge-using-command-line.md).
    
    Go to the resource group in Azure. You can see the custom location and Azure Arc Resource Bridge that you've created for the Azure Stack HCI cluster. Make a note of the subscription, resource group, and the custom location as you use these later in this scenario.

1. Make sure you have an external VM switch that can be accessed by all the servers in your Azure Stack HCI cluster. The virtual network that you create is associated with this external switch. 

    By default, an external switch is created during the deployment of your Azure Stack HCI cluster that you can use. You can also create another external switch on your cluster.

    Run the following command to get the name of the external VM switch on your cluster.

    Make a note of the name of the switch. You use this information when you create a virtual network.

    ```powershell
    Get-VmSwitch -SwitchType External
    ```

    Here's a sample output:

    ```powershell
    PS C:\Users\hcideployuser> Get-VmSwitch -SwitchType External
    Name                               SwitchType       NetAdapterInterfaceDescription
    ----                               ----------       ----------------------------
    ConvergedSwitch(compute_management) External        Teamed-Interface
    PS C:\Users\hcideployuser>
    ```
1. To create VMs with static IP addresses in your address space, add a virtual network with static IP allocation. Reserve an IP range with your network admin and make sure to get the address prefix for this IP range.

1. When creating the static virtual network and network interface, make sure that you are running the following module versions:
    1. Microsoft On-premises Cloud (MOC) version 1.0.64.
    1. Kubernetes version 2.0.2.
    
    > [!NOTE]
    > Make sure to run the prescribed versions of both the components to successfully create a static virtual network and network interface.

    To verify the MOC version and the Kubernetes versions you are running, follow these steps:
     
    1. Use the `az arcappliance list --resource-group $resource_group` command to get the name of your Arc Resource Bridge.
    1. Set `$ClusterName` parameter:
        ```powershell
        $ClusterName
        ``````
    1. Get the version number for Kubernetes. Verify the `version` is 2.0.2.
        ```azurecli
        az k8s-extension list --resource-group $resource_group --cluster-name $cluster_name --cluster-type appliances
        ```
        If you are not running the required version, update the components to the required version.

        ```azurecli
        az k8s-extension update --cluster-type appliances --cluster-name $ClusterName --resource-group $resource_group --name $name --configuration-settings Microsoft.CustomLocation.ServiceAccount=$serviceAccount --config-protected-file $workingDir\hci-config.json --configuration-settings HCIClusterID=$hciClusterId --version "2.0.2"
        ```
        where,
            
        |Parameters  |Description  |
        |---------|---------|
        |`$clusterName`     | Name of your Arc Resource Bridge. To get this name, run `az arcappliance list --resource-group $resource_group` cmdlet.      |
        |`$name`     |Name for the operator. To get this, run `az k8s-extension list --resource-group $resource_group --cluster-name $cluster_name --cluster-type appliances` cmdlet. Get the `name` parameter under `extensionType`. For example, `vmss-hci`.         |
        |`$serviceAccount`     |Name of your service account. Run `az k8sextension list --resource-group $resource_group --cluster-name $cluster_name --cluster-type appliances` and get the value against `Microsoft.CustomLocation.ServiceAccount`.         |
        |`$workingDir`     |Name of your working directory. Run `Get-MocConfig` and look for `workingDir`.       |
        |`$hciClusterId`    |Cluster ID for your Azure Stack HCI cluster. Run `(Get-AzureStackHCI).AzureResourceUri`.        |
      

    1. Get the version number for MOC extension. Verify the `moduleVersion` is 1.0.64.
        ```azurecli
        Get-MocConfig
        ``` 
        If you are not running the required version, update the extension to the required version.
        ```azurecli
        Update-Moc 
        ```          
        > [!NOTE]
        > Depending on the MOC version your cluster is running, you may need multiple updates to get to the required version. Run `Get-MocConfig` after each update to verify the version number.

## Create virtual network

You can use the `azurestackhci virtualnetwork` cmdlet to create a virtual network on the VM switch for DHCP or a static configuration. The parameters used to create a DHCP and a static virtual network are different.

### Parameters used to create virtual network

   For both DHCP and static, the *required* parameters to be specified are tabulated as follows:

   | Parameter | Description |
   | ----- | ----------- |
   | **name** | Name for the virtual network that you'll create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a virtual network after it's created. |
   | **vm-switch-name** |Name of the external virtual switch on your Azure Stack HCI cluster where you deploy the virtual network. |
   | **resource-group** |Name of the resource group where you create the virtual network. For ease of management, we recommend that you use the same resource group as your Azure Stack HCI cluster. |
   | **subscription** |Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for virtual network on your Azure Stack HCI cluster. |
   | **CustomLocation** |Name or ID of the custom location associated with your Azure Stack HCI cluster where you are creating this virtual network. |
   | **Location** | Azure regions as specified by `az locations`. |

   For static IP only, the *required* basic parameters are tabulated as follows:


   | Parameter | Description |
   | --------- | ----------- |
   | **IPAllocationMethod** |IP address allocation method and could be `Dynamic` or `Static`. If this parameter isn't specified, by default the virtual network is created with a dynamic configuration. |
   | **IpAddressPrefix** | Subnet address in CIDR notation. For example: "192.168.0.0/16".  |


   For static IP only, you can specify the following *optional* parameters:

   | Parameter | Description |
   | --------- | ----------- |
   | **DNSServers** | List of IPv4 addresses of DNS servers. Specify multiple DNS servers in a space separated format. For example: "10.0.0.5" "10.0.0.10"|
   | **Gateway** | Ipv4 address of the default gateway. |
   | **VLan ID** | vLAN identifier for Arc VMs. Contact your network admin to get this value. A value of 0 implies that there's no vLAN ID.  |

### Create a DHCP virtual network

Create a DHCP virtual network when the underlying network to which you want to connect your virtual machines has DHCP. Follow these steps to configure a DHCP virtual network:

1. Set the parameters. Here's an example using the default external switch:

    ```azurecli
    $vNetName = "test-vnet-dynamic"
    $vSwitchName = "ConvergedSwitch(compute_management)"    
    $subscription =  "hcisub" 
    $resourceGroupName = "hcirg"
    $customLocName = "altsnclus-cl" 
    $location = "eastus2euap"
    ```

1. Run the following cmdlet to create a DHCP virtual network:

   ```azurecli
   az azurestackhci virtualnetwork create --subscription $subscription --resource-group $resourceGroupName --extended-location name="/subscriptions/$Subscription/resourceGroups/$resourceGroupName/providers/Microsoft.ExtendedLocation/customLocations/$customLocName" type="CustomLocation" --location $location --IpAllocationMethod "Dynamic" --network-type "Transparent" --name $vNetName --vm-switch-name $vSwitchName
   ```

    Here's a sample output:

    ```console

    {
      "extendedLocation": {
        "name": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourceGroups/hcirg/providers/Microsoft.ExtendedLocation/customLocations/altsnclus-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourceGroups/hcirg/providers/Microsoft.AzureStackHCI/virtualnetworks/test-vnet-dynamic",
      "location": "eastus2euap",
      "name": "test-vnet-dynamic",
      "properties": {
        "dhcpOptions": {
          "dnsServers": null
        },
        "networkType": "Transparent",
        "provisioningState": "Succeeded",
        "status": {},
        "subnets": [],
        "vmSwitchName": "ConvergedSwitch(compute_management)"
      },
      "resourceGroup": "hcirg",
      "systemData": {
        "createdAt": "2023-06-06T00:10:40.562941+00:00",
        "createdBy": "johndoe@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-06-06T00:11:26.659220+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/virtualnetworks"
    }
    ```


### Create a static virtual network

Create a static virtual network when you want to create virtual machines with network interfaces on these virtual networks. Follow these steps to configure a static virtual network:

1. Set the parameters. Here's an example:

    ```azurecli
    $vNetName = "test-vnet-static"
    $vSwitchName = '"ConvergedSwitch(compute_management)"' 
    $subscription =  "hcisub" 
    $resourceGroupName = "hcirg"
    $customLocName = "altsnclus-cl" 
    $location = "eastus2euap" 
    $addressPrefix = "10.0.0.0/24"
    ```

    > [!NOTE]
    > For the default VM switch created at the deployment, pass the name string encased in double quotes followed by single quotes. For example, a default VM switch ConvergedSwitch(compute_management) is passed as '"ConvergedSwitch(compute_management)"'.

1. Create a static virtual network. Run the following cmdlet:
 
    ```azurecli
    az azurestackhci virtualnetwork create --subscription $subscription --resource-group $resourceGroupName --extended-location name=$customLocationID type="CustomLocation" --location $location --network-type "Transparent" --name $vNetName --vm-switch-name $vSwitchName --ip-allocation-method "Static" --address-prefix $addressPrefix   
    ```
    Here's a sample output:

    ```console
    {
      "extendedLocation": {
        "name": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourcegroups/hcirg/providers/microsoft.extendedlocation/customlocations/altsnclus-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourceGroups/hcirg/providers/Microsoft.AzureStackHCI/virtualnetworks/test-vnet-static",
      "location": "eastus2euap",
      "name": "test-vnet-static",
      "properties": {
        "dhcpOptions": {
          "dnsServers": null
        },
        "networkType": "Transparent",
        "provisioningState": "Succeeded",
        "status": {},
        "subnets": [
          {
            "name": "test-vnet-si-cidr",
            "properties": {
              "addressPrefix": "10.0.0.0/24",
              "addressPrefixes": null,
              "ipAllocationMethod": "Static",
              "ipConfigurationReferences": null,
              "ipPools": [
                {
                  "end": "10.0.0.16",
                  "info": {},
                  "ipPoolType": null,
                  "start": "10.0.0.0"
                }
              ],
              "routeTable": {
                "id": null,
                "name": null,
                "properties": {
                  "routes": null
                },
                "type": null
              },
              "vlan": null
            }
          }
        ],
        "vmSwitchName": "ConvergedSwitch(compute_management)"
      },
      "resourceGroup": "hcirg",
      "systemData": {
        "createdAt": "2023-06-01T18:59:38.879658+00:00",
        "createdBy": "johndoe@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-06-01T18:59:50.714931+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/virtualnetworks"
    }
    ```

Once the virtual network creation is complete, you are ready to create virtual machines with network interfaces on these virtual networks.

## Next steps

- [Manage virtual machines in the Azure portal](manage-virtual-machines-in-azure-portal.md)
