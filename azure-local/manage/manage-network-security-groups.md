---
title: Create network security groups, network security rules on Azure Local VMs (Preview)
description: Learn how to create network security groups, network security rules, network default access policies for Azure Local virtual machines(Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/09/2025
ms.service: azure-local
---

# Manage network security groups on Azure Local Virtual Machines (Preview)

Applies to: Azure Local 2504 or later

This article describes how to manage network security groups (NSGs) and network security rules on your Azure Local virtual machines enabled by Azure Arc. Once you have created network security groups and network security rules on your Azure Local VMs, you can list, show details, updates, delete these resources.

[!INCLUDE [important](../includes/hci-preview.md)]




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


## Manage network security groups

### List network security groups

### Show details of a network security group

### Delete a network security group



## Manage network security rules

<br></br>
<details>
<summary>Expand this section to see an example output.</summary>

```output


```

</details>

### Show details of a network security rule


```azurecli
az stack-hci-vm network nsg rule show -g $resource_group -n $securityrulename --nsg-name $nsgname
```

<br></br>
<details>
<summary>Expand this section to see an example output.</summary>

```output

[Machine 1]: PS C:\HCIDeploymentUser> az stack-hci-vm network nsg rule show -g $resource_group -n $securityrulename --nsg-name $nsgname
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

### Update a network security rule

<br></br>
<details>
<summary>Expand this section to see an example output.</summary>

```output


```

</details>

### List network security rules in a network security group

```azurecli


```


### Delete a network security rule



<br></br>
<details>
<summary>Expand this section to see an example output.</summary>

```output


```

</details>


# [Azure portal](#tab/azureportal)





## Associate network security group with a logical network

You can associate a network security group with a logical network. This association allows you to apply the same network security rules to all the VMs in the logical network.

To associate a network security group with a logical network, follow these steps:

1. Go to **Azure Local resource page > Resources > Logical networks**.
1. In the right pane, from the list of logical networks, select a network.
1. Go to **Settings > Network security groups**.
1. In the right-pane, from the top command bar, select **+ Associate network security group**.
1. In the **Associate network security group** page, from the dropdown, select a network security group.
1. Select **Add network security group**. The operation will take a few minutes to complete. You can see the status of the operation in the **Notifications** pane.
1. Once the network security group is associated with the logical network, you can see the network security group in the **Network security groups** tab of the logical network.

## Dissociate network security group from a logical network

You can dissociate a network security group from a logical network.

To dissociate a network security group from a logical network, follow these steps:

1. Go to **Azure Local resource page > Resources > Logical networks**.
1. In the right pane, from the list of logical networks, select a network.
1. Go to **Settings > Network security groups**.
1. In the right-pane, from the top command bar, select **Dissociate network security group**. The operation will take a few minutes to complete. You can see the status of the operation in the **Notifications** pane.
1. Once the network security group is dissociated from the logical network, the page refreshes to indicate the dissociation.

## Associate network security group with a network interface

You can associate a network security group with a network interface. This association allows you to apply the same network security rules to all the VMs in the logical network.

To associate a network security group with a network interface, follow these steps:

1. Go to **Azure Local resource page > Resources > Network interfaces**.
1. In the right pane, from the list of network interfaces, select a network interface.
1. Go to **Settings > Network security group**.
1. In the right-pane, from the top command bar, select **+ Associate network security group**.
1. In the **Associate network security group** page, input the following information:
    1. **Network security group** - Select a network security group from the list of network security groups available in your Azure Local instance.

## Dissociate network security group from a network interface



---

## Next steps

- [Manage NSGs on Azure Local](../index.yml)