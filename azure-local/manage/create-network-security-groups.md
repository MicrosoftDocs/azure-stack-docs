---
title: Manage network security groups, network security rules on Azure Local VMs (Preview)
description: Learn about the Azure verification for VMs feature on Azure Local (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/09/2025
ms.service: azure-local
---

# Create network security groups on Azure Local Virtual Machines (Preview)

Applies to: Azure Local 2504 or later

This article describes how to create network security groups (NSGs), network security rules and default network access policies on your Azure Local virtual machines enabled by Azure Arc. Once the software defined networking (SDN) is enabled on your existing Azure Local instance, you can create and attach NSGs to network interfaces or logical networks to filter network traffic.  

This how-to article is designed for the IT administrators who know how to configure and deploy workloads on Azure Local instances.

[!INCLUDE [important](../includes/hci-preview.md)]


## About NSGs on Azure Local VMs

You can use a network security group to filter network traffic between Azure resources in a logical network on your Azure Local instance. A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of resources.  

For each security rule, you can specify source and destination, port, and protocol.

## Prerequisites

# [Azure CLI](#tab/azurecli)

- You've access to an Azure Local instance.

    - This instance is running 2504 or later.
    - This instance has a custom location created.
    - This instance has the SDN feature enabled. For more information, see [Enable software defined networking (SDN) on Azure Local](../deploy/enable-sdn-ece-action-plan.md).


# [Azure portal](#tab/azureportal)

- You've access to an Azure Local instance.

    - This instance is running 2504 or later.
    - This instance has a custom location created.
    - This instance has the SDN feature enabled. For more information, see [Enable software defined networking (SDN) on Azure Local](../deploy/enable-sdn-ece-action-plan.md).
    
---

## Create network security groups and network security rules

# [Azure CLI](#tab/azurecli)

## Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]


## Create a network security group (NSG)

Create a network security group (NSG) on Azure Local. The NSG can be associated with a network interface or a logical network.

```azurecli
az stack-hci-vm network nsg create -g $resource_group --name $nsgname --custom-location $customLocationId --location $location  
```

<br></br>
<details>
<summary>Expand this section to see an example output.</summary>

```output
az stack-hci-vm network nsg create -g $resource_group --name $nsgname --custom-location $customLocationId --location $location 

[Machine 1]: PS C:\HCIDeploymentUser> $resource_group="examplerg"  

[Machine 1]: PS C:\HCIDeploymentUser> $nsgname="examplensg" 

[Machine 1]: PS C:\HCIDeploymentUser> $customLocationId="/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl" 

[Machine 1]: PS C:\HCIDeploymentUser> $location="eastus2euap" 

[Machine 1]: PS C:\HCIDeploymentUser> az stack-hci-vm network nsg create -g $resource_group --name $nsgname --custom-location $customLocationId --location $location 

{ 
  "eTag": null, 
  "extendedLocation": { 

    "name": "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl", 
    "type": "CustomLocation" 

  }, 

  "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/networkSecurityGroups/examplensg", 

  "location": "eastus2euap", 
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

[Machine 1]: PS C:\HCIDeploymentUser>
```

</details>

> [!TIP]
Use `az stack-hci-vm network nsg create -h` for help with CLI.

## Create a network security rule

After you create a network security group, you're ready to create network security rules. If you want to apply network security rules to both inbound and outbound traffic, you need to create two rules.

### Create an inbound security rule

```azurecli
az stack-hci-vm network nsg rule create -g $resource_group --nsg-name $nsgname --name $securityrulename --priority 400 --custom-location $customLocationId --access "Deny" --direction "Inbound" --location $location --protocol "ICMP" --source-port-ranges $sportrange --source-address-prefixes $saddprefix --destination-port-ranges $dportrange --destination-address-prefixes $daddprefix --description $description  
```
  
<br></br>
<details>
<summary>Expand this section to see an example output.</summary>  

```output
[Machine 1]: PS C:\HCIDeploymentUser> $securityrulename="examplensr" 
[Machine 1]: PS C:\HCIDeploymentUser> $sportrange="*" 
[Machine 1]: PS C:\HCIDeploymentUser> $saddprefix="10.0.0.0/24" 
[Machine 1]: PS C:\HCIDeploymentUser> $dportrange="80" 
[Machine 1]: PS C:\HCIDeploymentUser> $daddprefix="192.168.99.0/24" 
[Machine 1]: PS C:\HCIDeploymentUser> $description="Inbound security rule" 

[Machine 1]: PS C:\HCIDeploymentUser> az stack-hci-vm network nsg rule create -g $resource_group --nsg-name $nsgname --name $securityrulename --priority 400 --custom-location $customLocationId --access "Deny" --direction "Inbound" --location $location --protocol "ICMP" --source-port-ranges $sportrange --source-address-prefixes $saddprefix --destination-port-ranges $dportrange --destination-address-prefixes $daddprefix --description $description 

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

[Machine 1]: PS C:\HCIDeploymentUser>
```

</details>

> [!TIP]
> Use `az stack-hci-vm network nsg rule create -h` for help with Azure CLI.

### Create an outbound security rule

Create an outbound security rule blocking all traffic

```azurecli
az stack-hci-vm network nsg rule create -g $resource_group --nsg-name $nsgname --name $securityrulename --priority 500 --custom-location $customLocationId --access "Deny" --direction "Outbound" --location $location --protocol "*" --source-port-ranges $sportrange --source-address-prefixes $saddprefix --destination-port-ranges $dportrange --destination-address-prefixes $daddprefix --description $description
```



## Create default network access policy

Default network policies can be used to protect Azure Local virtual machines from external unauthorized attacks. These policies block all inbound access to Azure Local VMs (except the specified management ports you want enabled) while allowing all outbound access. Use these policies to ensure that your workload VMs have access to only required assets, thereby making it difficult for the threats to spread laterally.

You can attach a default network access policy to Azure Local VM in two ways:

- During VM creation. You'll need to attach the VM to a logical netowrk. For more information, see [Create a logical network](./create-logical-networks.md)
- Post VM creation. 

### Apply default network access policy when creating a VM

While creating a VM, you can create a network interface and attach a default network access policy to it. The following command creates a VM with a network interface attached to a default network access policy.

```azurecli

```

<br></br>
<details>
<summary>Expand this section to see an example output.</summary>

```output


```

</details>


# [Azure portal](#tab/azureportal)

## Create a network security group

Follow these steps in Azure portal for your Azure Local.

1. Go to **Azure Local resource page > Resources > Network security groups**. You see a list of network security groups present on your Azure Local.
1. In the right pane, from the top command bar, select **+ Create network security group**.
1. On the **Basics** tab, input the following information:
    1. **Subscription** - Choose the subscription you want to use for the NSG.
    1. **Resource group** - Create new or choose an existing resource group where you deploy all the resources associated with you Azure Local VM.
    1. **Instance name** - Enter a name for the network security group you wish to create. 
    1. **Region** - Choose the Azure region where your Azure Local instance is deployed. The region must be the same as the region of the Azure Local instance.
    1. **Custom location**: Select the custom location associated with the Azure Local instance.
    1. Select Review + create

1. On the **Review + create** tab, follow these steps:
    1. Review the settings.
    1. Select **Create**.

1. A job starts and after the job is completed, you see a notification. Select **Go to resource**. On the **Resource group**, you see an NSG is created.

1. Go to **Azure Local cluster resource > Resources > Network security groups**. A new NSG is added to the list of the NSG on your Azure Local.

## Create a network security rule

The same procedure works for both inbound and outbound security rules. The only difference is the direction of the rule.

Follow these steps in Azure portal for your Azure Local:

1. Go to **Azure Local resource page > Resources > Network security groups**.
1. In the right pane, from the list of network security groups, select a network security group.
1. Go to **Settings > Inbound security rules** for inbound rules or **Outbound security rules** for outbound rule.
1. In the right-pane, from the top command bar, select **+ Create**.
1. In the **Add inbound security rule** page, input the following information:
    1. **Source** - Choose between **IP address** or **Any**. The source specifies the incoming traffic from a specific IP address range that will be allowed or denied by this rule.
    1. **Source IP address/CIDR ranges** - Provide an address range using CIDR notation (for example, 192.168.99.0/24) or an IP address (for example, 192.168.99.0) if you chose IP address as the source.
    1. **Source port ranges** - Provide a specific port or a port range that will be denied or allowed by this rule. Provide an asterisk* to allow traffic on any port.
    1. **Destination** - Choose between **IP address** or **Any**. The destination specifies the outgoing traffic to a specific IP address range that will be allowed or denied by this rule.
    1. **Destination IP address/CIDR ranges** - Provide an address range using CIDR notation (for example, 192.168.99.0/24) or an IP address (for example, 192.168.99.0) if you chose IP address as the destination.
    1. **Destination port ranges** - Provide a specific port or a port range that will be denied or allowed by this rule. Provide an asterisk* to allow traffic on any port.
    1. **Protocol** - Choose  a protocol from **Any**, **TCP**, **UDP** or **ICMP**. The protocol specifies the type of traffic that will be allowed or denied by this rule.
    1. **Action** - Choose between **Allow** or **Deny**. The action specifies whether the traffic that matches this rule will be allowed or denied.
    1. **Priority** - Enter a number between 100 and 4096. The priority specifies the order in which the rules are applied. Lower numbers are processed first.
    1. **Name** - Enter a name for the rule. The name must be unique within the network security group.
    1. **Description** - Enter a description for the rule. The description is optional but recommended.
1. Select **Add**.

1. **Refresh** the list. The newly created network security rule should show up.

## Create default network access policy

Create a default network access policy to block all inbound traffic to Azure Local VMs (except the specified management ports you want enabled) while allowing all outbound access. Use these policies to ensure that your workload VMs have access to only required assets, thereby making it difficult for the threats to spread laterally.

You can attach a default network access policy to Azure Local VM in two ways:
- During VM creation. You'll need to attach the VM to a logical netowrk. For more information, see [Create a logical network](./create-logical-networks.md).
- Post VM creation.

### Apply default network access policy when creating a VM

While creating a VM, you can create a network interface and attach a default network access policy to it. 

For more information, see [Create Azure Local VM via Azure portal](./create-arc-virtual-machines.md). In this procedure, when you reach the **Networking** tab, follow these steps to add a default network access policy:

1. On the Networking tab, select **+ Add network interface**.
1. In the **Add network interface** page, input the following information:
    1. **Name** - Enter a name for the network interface.
    1. **Network** - Select a logical network from the list of logical networks available in your Azure Local instance.
    1. IPv4 type - Select **Static** or **Dynamic**. If you select **Static**, enter a static IP address for the VM. If you select **Dynamic**, the system assigns a random IP address from the subnet.
    1. Allocation method: Select Automatic or Manual. If you select Automatic, the system assigns a random IP address from the subnet. If you select Manual, enter a static IP address for the VM.
    1. **NIC Network security group** - There are three options:
        1. **None** - Choose this option if you don't want to enforce any network access policies to your VM. When this option is selected, all ports on your VM are exposed to external networks thereby posing a security risk. This option isn't recommended.
        1. **Basic** - Choose this option to attach a **Default network access policy**. The default policies block all inbound access and allow all outbound access. You can optionally enable inbound access to one or more well defined ports, for example, HTTP, HTTPS, SSH, or RDP as per your requirements.
        1. **Advanced** - Choose this option to attach a custom network access policy. You can create a custom network access policy with one or more inbound and outbound rules. For more information, see [Create a custom network access policy](../index.yml).
    1. Select **Add**.
1. Continue with the rest of the VM creation process.

> [!IMPORTANT]
> The default network access policy is only available for the first network interface of the VM. If you add a second network interface, the default network access policy isn't available to attach to the interface.

### Apply default network access policy to an existing VM

You can apply a default network access policy to an existing VM.

---

## Next steps

- [Manage NSGs on Azure Local](../index.yml)