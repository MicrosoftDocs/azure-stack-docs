---
title: Create network security groups, network security rules, default network access policies on Azure Local VMs (Preview)
description: Learn how to create network security groups, network security rules, and default network access policies on Azure Local VMs using the Azure CLI or the Azure portal (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 06/18/2025
ms.service: azure-local
---

# Create network security groups on Azure Local (Preview)

::: moniker range=">=azloc-2506"

This article describes how to create and configure network security groups (NSGs) to manage the data traffic flow after network controller is enabled on your Azure Local.


[!INCLUDE [important](../includes/hci-preview.md)]


## About NSGs on Azure Local VMs

Use a network security group to manage network traffic between logical networks or VMs on Azure Local. Configure a network security group with security rules that allow or deny either inbound or outbound network traffic. The network security rules control traffic based on:

- Source and destination IP addresses.
- Port numbers.
- Protocols (TCP/UDP).

Here is a diagram that shows how network security groups are attached to logical networks and VM network interfaces on Azure Local:

:::image type="content" source="./media/create-network-security-groups/network-security-groups.png" alt-text="Screenshot of conceptual diagram for network security groups attached to logical networks." lightbox="./media/create-network-security-groups/network-security-groups.png":::


The diagram outlines a network setup with two logical networks:

- Logical Network A

    - Subnet: 192.168.1.0/24, VLAN 206
    - Contains: VM Web at 192.168.1.3
    - NSG rule allows outbound internet access.
    - VM web can talk to the internet.

- Logical Network B

    - Subnet: 192.168.2.0/24, VLAN 310
    - Contains: VM SQL at 192.168.2.3
    - NSG rule denies outbound internet access.
    - VM SQL is running SQL Server locally and is not exposed to the internet.

In this example, NSG is used to control traffic flow between logical networks A and B and the VM Web and VM SQL. The NSG can be applied to each logical network or network interface to enforce specific security rules. For example, here the logical network B might allow only specific traffic over SQL port 1433 from logical network A.

## Prerequisites

# [Azure CLI](#tab/azurecli)

- You have access to an Azure Local instance.

    - This instance must be running 2506 with OS version 26100.xxxx, or later.
    - This instance has a custom location created.
    - You have access to an Azure subscription with the Azure Stack HCI Administrator role-based access control (RBAC) role. This role grants full access to your Azure Local instance and its resources. For more information, see [Assign Azure Local RBAC roles](../manage//assign-vm-rbac-roles.md#about-built-in-rbac-roles).
    - This instance has the SDN feature enabled. For more information, see [Enable software defined networking (SDN) on Azure Local](../deploy/enable-sdn-integration.md).
    - You have atleast one static logical network and one static network interface created on this instance. For more information, see [Create logical networks](./create-logical-networks.md#create-a-static-logical-network-via-cli) and [Create network interfaces](./create-network-interfaces.md#virtual-network-interface-with-static-ip).
    - If using a client to connect to your Azure Local, ensure you have installed the latest Azure CLI and the `az-stack-hci-vm` extension. For more information, see [Azure Local VM management prerequisites](../manage/azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).


# [Azure portal](#tab/azureportal)

- You have access to an Azure Local instance.

    - This instance must be running 2506 with OS version 26100.xxxx, or later.
    - This instance has a custom location created.
    - You have access to an Azure subscription with the Azure Stack HCI Administrator role-based access control (RBAC) role. This role grants full access to your Azure Local instance and its resources. For more information, see [Assign Azure Local RBAC roles](../manage//assign-vm-rbac-roles.md#about-built-in-rbac-roles).
    - This instance has the SDN feature enabled. For more information, see [Enable software defined networking (SDN) on Azure Local](../deploy/enable-sdn-integration.md).
---


## Create network security groups and network security rules

# [Azure CLI](#tab/azurecli)

## Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]


## Create a network security group (NSG)

Create a network security group (NSG) to manage data traffic flow on Azure Local. You can create an NSG by itself, or associate NSG with a network interface or a logical network.

NSGs are only available for static logical networks. DHCP-based logical networks aren't supported.

> [!WARNING]
> NSGs must have a network security rule associated with them. An empty NSG that doesn't have a security rule configured, denies all inbound traffic by default. A VM or a logical network associated with this NSG won't be reachable.

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
    | **location** |Azure region to associate with your network security group. For example, this could be `eastus`, `westeurope`. <br><br> For ease of management, we recommend that you use the same location as your Azure Local instance.  |
    | **resource-group** |Name of the resource group where you create the network security group. For ease of management, we recommend that you use the same resource group as your Azure Local. |
    | **subscription** |Name or ID of the subscription where your Azure Local is deployed. <!--This could be another subscription you use for your Azure Local VMs.--> |
    | **custom-location** |Custom location associated with your Azure Local. |


1. Run the following command to create a network security group (NSG) on your Azure Local instance.

    ```azurecli
    az stack-hci-vm network nsg create -g $resource_group --name $nsgname --custom-location $customLocationId --location $location  
    ```

1. The command creates a network security group (NSG) with the specified name and associates it with the specified custom location. 
    <br></br>
    <details>
    <summary>Expand this section to see an example output.</summary>
    
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

After you create a network security group, you're ready to create network security rules. If you want to apply network security rules to both inbound and outbound traffic, you need to create two rules.

### Create an inbound security rule

1. Set the following parameters in your Azure CLI session.

    ```azurecli
    $resource_group="examplerg"      
    $nsgname="examplensg"     
    $customLocationId="/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl" 
    $location="eastus"
    $securityrulename="examplensr" 
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
    | **location** |Azure regions as specified by `az locations`. For example, this could be `eastus`, `westeurope`. If the location isn't specified, the resource group location is used. |
    | **resource-group** | Name of the resource group where you create the network security group. For ease of management, we recommend that you use the same resource group as your Azure Local. |
    | **subscription** | Name or ID of the subscription where your Azure Local is deployed. This could be another subscription you use for your Azure Local VMs. |
    | **custom-location** |Use this to provide the custom location associated with your Azure Local where you're creating this network security group. |
    | **direction** | Direction of the rule specifies if the rule applies to incoming or outgoing traffic. Allowed values are outbound or inbound (default). |
    | **source-port-ranges** | Specify the source port range 0 and 65535 to match either an incoming or outgoing packet. The default `*` will specify all source ports. |
    | **source-address-prefixes** | Specify the CIDR or destination IP ranges. The default is `*`.|
    | **destination-address-prefixes** | Specify the CIDR or destination IP ranges. The default is `*`.  |  
    | **destination-port-ranges** | Specify the destination port range from 0 to 65535 (default 80) to match either an incoming or outgoing packet. You can enter `*` to specify all destination ports.  |
    | **protocol** | Protocol to match either an incoming or outgoing packet. Acceptable values are `*` (default), **All**, **TCP** and **UDP**. |
    | **access** | If the above conditions are matched, specify either to allow or block the packet. Acceptable values are **Allow** and **Deny** with default being **Allow**. |
    | **priority** | Specify a unique priority for each rule in the collection. Acceptable values are from **100** to **4096**. A lower value denotes a higher priority.  |
    | **description** | An optional description for this network security rule. The description is a maximum of 140 characters.  |

1. Run the following command to create an inbound network security rule on your Azure Local instance. This rule blocks all inbound ICMP traffic to Azure Local VMs (except the specified management ports you want enabled) while allowing all outbound access.

    ```azurecli
    az stack-hci-vm network nsg rule create -g $resource_group --nsg-name $nsgname --name $securityrulename --priority 400 --custom-location $customLocationId --access "Deny" --direction "Inbound" --location $location --protocol "*" --source-port-ranges $sportrange --source-address-prefixes $saddprefix --destination-port-ranges $dportrange --destination-address-prefixes $daddprefix --description $description  
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
        "protocol": "Icmp", 
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

Run the following command to create an outbound network security rule that blocks all network traffic.

  ```azurecli
  az stack-hci-vm network nsg rule create -g $resource_group --nsg-name $nsgname --name $securityrulename --priority 500 --custom-location $customLocationId --access "Deny" --direction "Outbound" --location $location --protocol "*" --source-port-ranges $sportrange --source-address-prefixes $saddprefix --destination-port-ranges $dportrange --destination-address-prefixes $daddprefix --description $description
  ```

# [Azure portal](#tab/azureportal)

## Create a network security group

Follow these steps in Azure portal to create a network security group.

1. Go to **Azure Local resource page > Resources > Network security groups**. You see a list of network security groups present on your Azure Local.

    :::image type="content" source="./media/create-network-security-groups/create-network-security-group-1.png" alt-text="Screenshot of Network security groups option in left-pane." lightbox="./media/create-network-security-groups/create-network-security-group-1.png":::

1. In the right pane, from the top command bar, select **+ Create network security group**.

    :::image type="content" source="./media/create-network-security-groups/create-network-security-group-2.png" alt-text="Screenshot of Create network security group option selected." lightbox="./media/create-network-security-groups/create-network-security-group-2.png":::

1. On the **Basics** tab, input the following information:

    :::image type="content" source="./media/create-network-security-groups/create-network-security-group-3.png" alt-text="Screenshot of Basics tab filled out for creation of network security group." lightbox="./media/create-network-security-groups/create-network-security-group-3.png":::

    1. **Subscription** - Choose the subscription you want to use for the NSG.
    1. **Resource group** - Create new or choose an existing resource group where you deploy all the resources associated with your Azure Local VM.
    1. **Instance name** - Enter a name for the network security group you wish to create. 
    1. **Region** - Choose the Azure region where your Azure Local instance is deployed. The region must be the same as the region of the Azure Local instance.
    1. **Custom location**: Select the custom location associated with the Azure Local instance.
    1. Select **Review + create**.

1. On the **Review + create** tab, follow these steps:
    1. Review the settings.
    1. Select **Create**.

    :::image type="content" source="./media/create-network-security-groups/create-network-security-group-4.png" alt-text="Screenshot of Review + Create tab for creation of network security group." lightbox="./media/create-network-security-groups/create-network-security-group-4.png":::

1. A job starts and after the job is completed, you see a notification. Select **Go to resource**. On the **Resource group**, you see an NSG is created.

    :::image type="content" source="./media/create-network-security-groups/create-network-security-group-5.png" alt-text="Screenshot of newly created network security group in the resource group." lightbox="./media/create-network-security-groups/create-network-security-group-5.png":::

1. Go to **Azure Local cluster resource > Resources > Network security groups**. A new NSG is added to the list of the NSG on your Azure Local.

    :::image type="content" source="./media/create-network-security-groups/create-network-security-group-6.png" alt-text="Screenshot of newly created network security group in the list of network security groups." lightbox="./media/create-network-security-groups/create-network-security-group-6.png":::

## Create a network security rule

The same procedure works for both inbound and outbound security rules. The only difference is the direction of the rule.

Follow these steps in Azure portal for your Azure Local:

1. Go to **Azure Local resource page > Resources > Network security groups**.

    :::image type="content" source="./media/create-network-security-groups/create-network-security-rule-1.png" alt-text="Screenshot of network security groups option selected for the creation of network security rule." lightbox="./media/create-network-security-groups/create-network-security-rule-1.png":::

1. In the right pane, from the list of network security groups, select a network security group.

    :::image type="content" source="./media/create-network-security-groups/create-network-security-rule-2.png" alt-text="Screenshot of a network security group selected for the creation of network security rule." lightbox="./media/create-network-security-groups/create-network-security-rule-2.png":::

1. Go to **Settings > Inbound security rules** for inbound rules or **Outbound security rules** for outbound rule. In the right-pane, from the top command bar, select **+ Create**.

    :::image type="content" source="./media/create-network-security-groups/create-network-security-rule-3.png" alt-text="Screenshot of for an inbound network security rule with Create selected." lightbox="./media/create-network-security-groups/create-network-security-rule-3.png":::

1. In the **Add inbound security rule** page, input the following information:

    :::image type="content" source="./media/create-network-security-groups/create-network-security-rule-4.png" alt-text="Screenshot of Inbound security rule with all the parameters filled out." lightbox="./media/create-network-security-groups/create-network-security-rule-4.png":::

    1. **Source** - Choose between **IP address** or **Any**. The source specifies the incoming traffic from a specific IP address range that is allowed or denied by this rule.
    1. **Source IP address/CIDR ranges** - Provide an address range using CIDR notation (for example, 192.168.99.0/24) or an IP address (for example, 192.168.99.0) if you chose IP address as the source.
    1. **Source port ranges** - Provide a specific port or a port range that will be denied or allowed by this rule. Provide an asterisk* to allow traffic on any port.
    1. **Destination** - Choose between **IP address** or **Any**. The destination specifies the outgoing traffic to a specific IP address range that will be allowed or denied by this rule.
    1. **Destination IP address/CIDR ranges** - Provide an address range using CIDR notation (for example, 192.168.99.0/24) or an IP address (for example, 192.168.99.0) if you chose IP address as the destination.
    1. **Destination port ranges** - Provide a specific port or a port range that will be denied or allowed by this rule. Provide an asterisk* to allow traffic on any port.
    1. **Protocol** - Choose  a protocol from **Any**, **TCP**, **UDP, or **ICMP**. The protocol specifies the type of traffic that is allowed or denied by this rule.
    1. **Action** - Choose between **Allow** or **Deny**. The action specifies whether the traffic that matches this rule will be allowed or denied.
    1. **Priority** - Enter a number between 100 and 4096. The priority specifies the order in which the rules are applied. Lower numbers are processed first.
    1. **Name** - Enter a name for the rule. The name must be unique within the network security group.
    1. **Description** - Enter a description for the rule. The description is optional but recommended.
1. Select **Add**.

1. **Refresh** the list. The newly created network security rule should show up.

    :::image type="content" source="./media/create-network-security-groups/create-network-security-rule-5-a.png" alt-text="Screenshot of the new network security rule." lightbox="./media/create-network-security-groups/create-network-security-rule-5-a.png":::

## Create default network access policy

Create a default network access policy to block all inbound traffic to Azure Local VMs (except the specified management ports you want enabled) while allowing all outbound access. Use these policies to ensure that your workload VMs have access to only required assets, thereby making it difficult for the threats to spread laterally.

You can attach a default network access policy to Azure Local VM in two ways:
- During VM creation. You need to attach the VM to a logical network. For more information, see [Create a logical network](./create-logical-networks.md).
- Post VM creation.

### Apply default network access policy when creating a VM

While creating a VM, you can create a network interface and attach a default network access policy to it. 

For more information, see [Create Azure Local VM via Azure portal](./create-arc-virtual-machines.md). In this procedure, when you reach the **Networking** tab, follow these steps to add a default network access policy:

1. On the Networking tab, select **+ Add network interface**.

    :::image type="content" source="./media/create-network-security-groups/create-default-network-access-policy-1.png" alt-text="Screenshot showing addition of a network interface." lightbox="./media/create-network-security-groups/create-default-network-access-policy-1.png":::

1. In the **Add network interface** page, input the following information:

    :::image type="content" source="./media/create-network-security-groups/create-default-network-access-policy-3.png" alt-text="Screenshot showing network interface NSG options for the new network interface." lightbox="./media/create-network-security-groups/create-default-network-access-policy-1.png":::

    1. **Name** - Enter a name for the network interface.
    1. **Network** - Select a logical network from the list of logical networks available in your Azure Local instance.
    1. IPv4 type - Select **Static** or **Dynamic**. If you select **Static**, enter a static IP address for the VM. If you select **Dynamic**, the system assigns a random IP address from the subnet.
    1. Allocation method: Select Automatic or Manual. If you select Automatic, the system assigns a random IP address from the subnet. If you select Manual, enter a static IP address for the VM.
    1. **NIC Network security group** - There are three options:
        1. **None** - Choose this option if you don't want to enforce any network access policies to your VM. When this option is selected, all ports on your VM are exposed to external networks thereby posing a security risk. This option isn't recommended.
        1. **Basic** - Choose this option to specify a default network access policy. The default policies block all inbound access and allow all outbound access. You can optionally enable inbound access to one or more well defined ports, for example, HTTP, HTTPS, SSH, or RDP as per your requirements.
        1. **Advanced** - Choose this option to specify a network security group.
    1. Select **Add**.
1. Continue with the rest of the VM creation process.

> [!IMPORTANT]
> The default network access policy is only available for the first network interface of the VM. If you add a second network interface, the default network access policy isn't available to attach to the interface.

### Apply default network access policy to an existing VM

You can apply a default network access policy to an existing VM.

---


## Next steps

- [Manage NSGs on Azure Local](../manage/manage-network-security-groups.md)

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506 or later.

::: moniker-end