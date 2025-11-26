---
title: Create network security groups on Azure Local VMs on multi-rack deployments (preview) 
description: Learn how to create network security groups on Azure Local VMs on multi-rack deployments using the Azure CLI (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 11/24/2025
ms.service: azure-local
---

# Create network security groups on Azure Local VMs on multi-rack deployments (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article explains how to create and configure network security groups (NSGs) to manage data traffic flow on a multi-rack deployment of your Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About NSGs on Azure Local VMs on multi-rack deployments

Use a network security group to filter network traffic between logical networks, virtual network (VNet) subnets, or virtual machines (VMs) on Azure Local. Configure a network security group with security rules that allow or deny either inbound or outbound network traffic. The network security rules control traffic based on:

- Source and destination IP addresses.
- Port numbers.
- Protocols (TCP/UDP).
- Direction (inbound or outbound).

The following diagrams show how you attach network security groups to logical networks, virtual network subnets, and VM network interfaces on a multi-rack deployment:

:::image type="content" source="./media/multi-rack-create-network-security-groups/multi-rack-create-network-security-groups-logical-networks.png" alt-text="Screenshot of conceptual diagram for network security groups attached to logical networks." lightbox="./media/multi-rack-create-network-security-groups/multi-rack-create-network-security-groups-logical-networks.png":::


Scenario-1 diagram shows a network setup with two logical networks:

- Logical Network A

    - Subnet: 192.168.1.0/24, VLAN 206
    - Has VM Web at 192.168.1.3.
    - NSG rule lets outbound internet access.
    - VM Web can access the internet.

- Logical Network B

    - Subnet: 192.168.2.0/24, VLAN 310
    - Has VM SQL at 192.168.2.3.
    - NSG rule blocks outbound internet access.
    - VM SQL runs SQL Server locally and isn't exposed to the internet.

In this example, the NSG controls traffic flow between logical networks A and B, and between VM Web and VM SQL.

:::image type="content" source="./media/multi-rack-create-network-security-groups/multi-rack-create-network-security-groups-virtual-networks.png" alt-text="Screenshot of conceptual diagram for network security groups attached to virtual network subnets and network interfaces." lightbox="./media/multi-rack-create-network-security-groups/multi-rack-create-network-security-groups-virtual-networks.png":::

Scenario-2 shows a network setup with two virtual networks:
	
-	Virtual Network A:
    - This network has a private IP space of 10.0.0.0/24.
    - Contains two subnets hosting the frontend and backend VMs.
	
    	- Subnet A (10.0.0.0/26)
    	   - Hosts VM Frontend at 10.0.0.5.
    	   - NSG rules allow both inbound and outbound Internet access.
    	   - VM Frontend can send and receive Internet traffic freely.
	
    	- Subnet B (10.0.1.64/26)
    	   - Hosts VM Backend at 10.0.1.6.
    	   - NSG rules allow outbound traffic to local WAN to reach the other virtual networks and deny all inbound Internet traffic.
    	   - VM Backend can communicate with VM Frontend and with virtual network B via enterprise WAN.
    	   - VM Backend isn’t exposed to the Internet.
	
- Virtual Network B:
    - This network also has a private IP space of 10.0.0.0/24.
    - Contains internal-only application components.
	
    - Subnet C (10.0.0.0/26)
        - Hosts VM SQL at 10.0.1.6 and Internal VM at 10.0.1.7.
        - NSG rules defined at the subnet level deny all outbound Internet access.
        - NSG rules defined at the network interface level (10.0.1.7) override the subnet-level NSG and denies all inbound and outbound HTTPS traffic. However, the internal VM can communicate with the SQL VM.
        - Internal VMs are isolated from the Internet.
	
	The diagram highlights how different parts of an application can have public-facing Internet access, limited enterprise WAN-only access, and fully isolated, internal-only access. Granular traffic controls can be implemented with NSGs associated with either the virtual network subnets or the network interfaces.

## Prerequisites

- You have access to a multi-rack deployment.

    - This instance has a custom location.
    - You have access to an Azure subscription with the appropriate Role-based access control (RBAC) role and permissions assigned. For more information, see  [Assign Azure Local RBAC roles](./multi-rack-assign-vm-rbac-roles.md#custom-roles).
    - You have at least one logical network or one virtual network with one or more subnets. You can optionally have network interfaces configured on these network resources as well. For more information, see [Create logical networks](./multi-rack-create-logical-networks.md#create-a-static-logical-network), [Create virtual networks](./multi-rack-create-virtual-networks.md), and [Create network interfaces](./multi-rack-create-network-interfaces.md#network-interface-with-static-ip-using-logical-network).

- If you use a client to connect to your instance, make sure you install the latest Azure CLI and the `stack-hci-vm` extension. For more information, see [Azure Local VM management prerequisites](./multi-rack-vm-management-prerequisites.md).


## Create network security groups and network security rules

The following sections explain how to create network security groups (NSGs) and network security rules on your multi-rack deployments by using the Azure CLI.

## Sign in and set subscription

1. Connect to a machine on your instance.
1. Sign in. Run the following command to sign in to your Azure account:

    ```azurecli
    az login --use-device-code
    ```

1. Set your subscription. Run the following command to set your subscription context to the subscription where your Azure Local instance is deployed:

    ```azurecli
    az account set --subscription "<Subscription ID or Name>"
    ```

## Create a network security group (NSG)

Create a network security group (NSG) to manage data traffic flow on Azure Local. You can create an NSG and associate it with a network interface, a virtual network subnet, or a logical network.

> [!WARNING]
> NSGs must have at least one network security rule. An empty NSG denies all inbound traffic by default. A VM or logical network associated with this NSG isn't reachable.

<!-- open comment in word doc -->

1. Set the following parameters in your Azure CLI session.

    ```azurecli
    $resource_group="examplerg"      
    $nsgname="examplensg"     
    $customLocationId="/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl" 
    $location="eastus"
    ```

    The parameters for network security group creation are tabulated as follows:
    
    | Parameters | Description |
    |------------|-------------|
    | **name**  |Name for the network security group that you create. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking)|
    | **location** |Azure region to associate with your network security group. For example, this could be `eastus`, `westeurope`. <br><br> For ease of management, use the same location as your Azure Local instance.  |
    | **resource-group** |Name of the resource group where you create the network security group. For ease of management, use the same resource group as your Azure Local. |
    | **subscription** |Name or ID of the subscription where your Azure Local is deployed. <!--This could be another subscription you use for your Azure Local VMs.--> |
    | **custom-location** |Azure Resource Manager ID of the custom location associated with your Azure Local. |


1. Run the following command to create a network security group (NSG) on your instance.

    ```azurecli
    az stack-hci-vm network nsg create -g $resource_group --name $nsgname --custom-location $customLocationId --location $location  
    ```

1. The command creates a network security group (NSG) with the specified name and associates it with the specified custom location.

    <details>
    <summary>Expand to see an example output.</summary>

    ```output
    { 
      "eTag": null, 
      "extendedLocation": { 
    
        "name": "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl", 
        "type": "CustomLocation" 
    
      }, 
    
      "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/networkSecurityGroups/examplensg", 
    
      "location": "eastus", 
      "name": "examplensg", 
      "properties": { 
        "networkInterfaces": [], 
        "provisioningState": "Succeeded", 
        "subnets": [] 
      }, 
    
      "resourceGroup": "examplerg", 
      "systemData": { 
        "createdAt": "2025-03-11T22:56:05.968402+00:00", 
        "createdBy": "gus@contoso.com", 
        "createdByType": "User", 
        "lastModifiedAt": "2025-03-11T22:56:13.438321+00:00", 
        "lastModifiedBy": "<User ID>", 
        "lastModifiedByType": "Application" 
      }, 
    
      "tags": null, 
      "type": "microsoft.azurestackhci/networksecuritygroups" 
    } 
    ```

    </details>

> [!TIP]
> Use `az stack-hci-vm network nsg create -h` for help with CLI.

## Create a network security rule

After you create a network security group, create network security rules. To apply rules to both inbound and outbound traffic, create two rules.

### Create an inbound security rule

1. Set the following parameters in your Azure CLI session.

    ```azurecli
    $resource_group="examplerg"      
    $nsgname="examplensg"     
    $customLocationId="/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl" 
    $location="eastus"
    $securityrulename_in="examplensr" 
    $sportrange="*" 
    $saddprefix="10.0.0.0/24" 
    $dportrange="80" 
    $daddprefix="192.168.99.0/24" 
    $description="Inbound security rule" 
    ```

    The parameters for network security group creation are tabulated as follows:

    | Parameters | Description |
    |------------|-------------|
    | **name**  | Name for the network security rule that you create for your Azure Local. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking)|
    | **nsg-name**  | Name for the network security group that contains this network security rule. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking)|
    | **location** |Azure regions as specified by Azure regions as specified by `az account list-locations -o table`. For example, this could be `eastus`, `westeurope`. If you don't specify the location, the resource group location is used. |
    | **resource-group** | Name of the resource group where you create the network security group. For ease of management, use the same resource group as your Azure Local. |
    | **subscription** | Name or ID of the subscription where your Azure Local is deployed. This subscription can be different from the one you use for your Azure Local VMs. |
    | **custom-location** |Use this parameter to provide the custom location associated with your Azure Local where you're creating this network security group. |
    | **direction** | Direction of the rule specifies if the rule applies to incoming or outgoing traffic. Allowed values are outbound or inbound (default). |
    | **source-port-ranges** | Specify the source port range 0 and 65535 to match either an incoming or outgoing packet. The default `*` specifies all source ports. |
    | **source-address-prefixes** | Specify the CIDR or source addresses. The default is `*`.|
    | **destination-address-prefixes** | Specify the CIDR or destination IP ranges. The default is `*`.  |  
    | **destination-port-ranges** | Enter a specific port or a port range that this rule allows or denies. Enter an asterisk (*) to allow traffic on any port.  |
    | **protocol** | Protocol to match either an incoming or outgoing packet. Acceptable values are `*` (default), **All**, **TCP** and **UDP**. |
    | **access** | If the above conditions are matched, specify either to allow or block the packet. Acceptable values are **Allow** and **Deny** with default being **Allow**. |
    | **priority** | Specify a unique priority for each rule in the collection. Acceptable values are from **100** to **4096**. A lower value denotes a higher priority.<br> NSGs evaluate rules by priority and stop at the first match. We recommend that you leave room in the priority range for future rules.  |
    | **description** | An optional description for this network security rule. The description is a maximum of 140 characters.  |

1. Run the following command to create an inbound network security rule on your instance. This rule blocks all inbound ICMP traffic to Azure Local VMs (except the management ports you want enabled) and allows all outbound access.

    ```azurecli
    az stack-hci-vm network nsg rule create -g $resource_group --nsg-name $nsgname --name $securityrulename_in --priority 400 --custom-location $customLocationId --access "Deny" --direction "Inbound" --location $location --protocol "*" --source-port-ranges $sportrange --source-address-prefixes $saddprefix --destination-port-ranges $dportrange --destination-address-prefixes $daddprefix --description $description  
    ```

1. The command creates a network security rule and associates it with the specified network security group.
  
    <br></br>
    <details>
    <summary>Expand this section to see an example output.</summary>  
    
    ```output
    { 
      "extendedLocation": { 
        "name": "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl", 
        "type": "CustomLocation" 
      }, 
    
      "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/networkSecurityGroups/examplensg/securityRules/examplensr", 
      "name": "examplensr", 
      "properties": { 
        "access": "Deny", 
        "description": "Inbound security rule", 
        "destinationAddressPrefixes": [ 
          "192.168.99.0/24" 
        ], 
    
        "destinationPortRanges": [ 
          "80" 
        ], 
    
        "direction": "Inbound", 
        "priority": 400, 
        "protocol": "*", 
        "provisioningState": "Succeeded", 
        "sourceAddressPrefixes": [ 
          "10.0.0.0/24" 
        ], 
    
        "sourcePortRanges": [ 
          "*" 
        ] 
    
      }, 
    
      "resourceGroup": "examplerg", 
      "systemData": { 
        "createdAt": "2025-03-11T23:25:37.369940+00:00", 
        "createdBy": "gus@contoso.com", 
        "createdByType": "User", 
        "lastModifiedAt": "2025-03-11T23:25:37.369940+00:00", 
        "lastModifiedBy": "gus@contoso.com", 
        "lastModifiedByType": "User" 
      }, 
    
      "type": "microsoft.azurestackhci/networksecuritygroups/securityrules" 
    } 
    
    ```
    
    </details>

> [!TIP]
> Use `az stack-hci-vm network nsg rule create -h` for help with Azure CLI.

### Create an outbound security rule

Run the following command to create an outbound network security rule that denies traffic to destination `port 80` and the specified prefixes.

```azurecli
az stack-hci-vm network nsg rule create -g $resource_group --nsg-name $nsgname --name $securityrulename_out --priority 500 --custom-location $customLocationId --access "Deny" --direction "Outbound" --location $location --protocol "*" --source-port-ranges $sportrange --source-address-prefixes $saddprefix --destination-port-ranges $dportrange --destination-address-prefixes $daddprefix --description $description
```

Run the following command to block all outbound traffic:

```azurecli
Set --source-address-prefixes "" --source-port-ranges "" --destination-address-prefixes "" --destination-port-ranges "" --protocol "*"
```
  
<!--## Next steps

- [Manage NSGs on Azure Local](../manage/manage-network-security-groups.md)-->
