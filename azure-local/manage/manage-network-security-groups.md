---
title: Manage network security groups, network security rules on Azure Local VMs (Preview)
description: Learn how to manage network security groups and network security rules for Azure Local virtual machines(Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/14/2025
ms.service: azure-local
---

# Manage network security groups on Azure Local Virtual Machines (Preview)

Applies to: Azure Local 2504 or later

This article describes how to manage network security groups (NSGs) and network security rules on your Azure Local virtual machines enabled by Azure Arc. Once you have created network security groups and network security rules on your Azure Local VMs, you can list, show details, associate, dissociate, update, and delete these resources.

[!INCLUDE [important](../includes/hci-preview.md)]


## Prerequisites

# [Azure CLI](#tab/azurecli)

- You've access to an Azure Local instance.

    - This instance is running 2504 or later.
    - This instance has a custom location created.
    - This instance has the SDN feature enabled. For more information, see [Enable software defined networking (SDN) on Azure Local](../deploy/enable-sdn-ece-action-plan.md).
    - If using a client to connect to your Azure Local, ensure you've installed the latest Azure CLI and the `az-stack-hci-vm` extension. For more information, see [Azure Local VM management prerequisites](../manage/azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).

# [Azure portal](#tab/azureportal)

- You've access to an Azure Local instance.

    - This instance is running 2504 or later.
    - This instance has a custom location created.
    - This instance has the SDN feature enabled. For more information, see [Enable software defined networking (SDN) on Azure Local](../deploy/enable-sdn-ece-action-plan.md).
    
---

## Manage network security groups and network security rules

# [Azure CLI](#tab/azurecli)

## Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]


## Manage network security groups

This section describes the manage operations supported for network security groups.

### List network security groups

Follow these steps to list network security groups:

```azurecli
az stack-hci-vm network nsg list -g $resource_group
```


### Show details of a network security group

Follow these steps to show details of a network security group:

1. Run the following command to show details of a network security group (NSG) on your Azure Local instance.

    ```azurecli
    az stack-hci-vm network nsg show -g $resource_group --name $nsgname 
    ```

2. The command outputs the details of a specified network security group (NSG). 

    - In this example, the NSG has no network interface attached.

        <details>
        <summary>Expand this section to see an example output.</summary>
        
        ```output
        [Machine 1]: PS C:\HCIDeploymentUser> az stack-hci-vm network nsg show -g $resource_group -n $nsgname
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

    - In this example, the NSG has a network interface attached.

        <details>
        <summary>Expand this section to see an example output.</summary>
        
        ```output
        [Machine 1]: PS C:\HCIDeploymentUser> az stack-hci-vm network nsg show -g $resource_group -n $nsgname
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
            "networkInterfaces": [
              {
                "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/networkInterfaces/examplenic",
                "resourceGroup": "examplerg"
              }
            ],
            "provisioningState": "Succeeded",
            "subnets": []
          },
          "resourceGroup": "examplerg",
          "systemData": {
            "createdAt": "2025-03-11T22:56:05.968402+00:00",
            "createdBy": "gus@contoso.com",
            "createdByType": "User",
            "lastModifiedAt": "2025-03-12T15:49:32.419759+00:00",
            "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
            "lastModifiedByType": "Application"
          },
          "tags": null,
          "type": "microsoft.azurestackhci/networksecuritygroups"
        }
        
        [Machine 1]: PS C:\HCIDeploymentUser>        
        ```

        </details>


### Delete a network security group

Follow these steps to delete a network security group:

```azurecli
az stack-hci-vm network nsg delete -g $resource_group --name $nsgname
```


## Associate network security group with network interface

Create a NIC with the NSG created earlier in one step. IP address is optional and is not passed in this example. If you do not pass the IP address, the system assigns a random IP address from the subnet.

 
```azurecli
az stack-hci-vm network nic create --resource-group $resource_group --custom-location $customLocationId --location $location --subnet-id $lnetname --ip-address $ipaddress --name $nicname --network-security-group $nsgname 
```

<details>
<summary>Expand this section to see an example output.</summary>

```output
[Machine 1]: PS C:\HCIDeploymentUser> $lnetname="static-lnet" 
[Machine 1]: PS C:\HCIDeploymentUser> $nicname="examplenic" 
[Machine 1]: PS C:\HCIDeploymentUser> az stack-hci-vm network nic create --resource-group $resource_group --custom-location $customLocationId --location $location --subnet-id $lnetname --name $nicname --network-security-group $nsgname 
{ 

  "extendedLocation": { 
    "name": "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl", 
    "type": "CustomLocation" 
  }, 

  "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/networkInterfaces/examplenic", 
  "location": "eastus2euap", 
  "name": "examplenic", 
  "properties": { 
    "dnsSettings": null, 
    "ipConfigurations": [ 
      { 
        "name": null, 
        "properties": { 
          "gateway": "100.78.98.1", 
          "prefixLength": "24", 
          "privateIpAddress": "100.78.98.224", 
          "subnet": { 
            "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/logicalNetworks/static-lnet", 
            "resourceGroup": "examplerg" 
          } 
        } 
      } 
    ], 

    "macAddress": "02:ec:ce:e0:00:01", 
    "networkSecurityGroup": { 
      "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/networkSecurityGroups/examplensg", 
      "resourceGroup": "examplerg" 
    }, 

    "provisioningState": "Succeeded", 
    "status": { 
      "errorCode": null, 
      "errorMessage": null, 
      "provisioningStatus": null 
    } 
  }, 

  "resourceGroup": "examplerg", 
  "systemData": { 
    "createdAt": "2025-03-11T23:38:19.228090+00:00", 
    "createdBy": "gus@contoso.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2025-03-12T15:49:32.143520+00:00", 
    "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05", 
    "lastModifiedByType": "Application" 
  }, 

  "tags": null, 
  "type": "microsoft.azurestackhci/networkinterfaces" 
} 

[Machine 1]: PS C:\HCIDeploymentUser>
```

</details>


## Associate network security group with logical network

Create a static logical network (lnet) with NSG. No IP pools are passed in this example as they are optional.

 
```azurecli
az stack-hci-vm network lnet create --resource-group $resource_group --custom-location $customLocationId --location $location --name $lnetname --ip-allocation-method "static" --address-prefixes $ipaddprefix --ip-poolstart $ippoolstart --ip-pool-end $ippoolend --vm-switch-name $vmswitchname --dns-servers $dnsservers --gateway $gateway --vlan $vlan –network-security-group $nsgname 
```
 
<details>
<summary>Expand this section to see an example output.</summary>

```output
[Machine 1]: PS C:\HCIDeploymentUser> $lnetname="static-lnet3" 
$ipaddress="100.78.98.10" 
$ipaddprefix="100.78.98.0/24" 
$vmswitchname='"ConvergedSwitch(managementcompute)"' 
$dnsservers="100.71.93.111" 
$gateway="100.78.98.1" 
$vlan="301" 

[Machine 1]: PS C:\HCIDeploymentUser> az stack-hci-vm network lnet create --resource-group $resource_group --custom-location $customLocationId --location $location --name $lnetname --ip-allocation-method "static" --address-prefixes $ipaddprefix --vm-switch-name $vmswitchname --dns-servers $dnsservers --gateway $gateway --vlan $vlan --network-security-group $nsgname 

{ 

  "extendedLocation": { 

    "name": "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/ 

customlocations/examplecl", 

    "type": "CustomLocation" 

  }, 

  "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/logicalNetworks/static-lnet3", 
  "location": "eastus2euap", 
  "name": "static-lnet3", 
  "properties": { 
    "dhcpOptions": { 
      "dnsServers": [ 
        "100.71.93.111" 
      ] 
    }, 

    "provisioningState": "Succeeded", 
    "status": { 
      "errorCode": "", 
      "errorMessage": "", 
      "provisioningStatus": null 
    }, 

    "subnets": [ 
      { 
        "name": "static-lnet3", 
        "properties": { 
          "addressPrefix": "100.78.98.0/24", 
          "addressPrefixes": null, 
          "ipAllocationMethod": "Static", 
          "ipConfigurationReferences": null, 
          "ipPools": [ 

            { 
              "end": "100.78.98.255", 
              "info": { 
                "available": "256", 
                "used": "0" 
              }, 

              "ipPoolType": null, 
              "name": null, 
              "start": "100.78.98.0" 
            } 
          ], 

          "networkSecurityGroup": { 
            "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/networkSecurityGroups/examplensg3", 

            "resourceGroup": "examplerg" 

          }, 

          "routeTable": { 
            "etag": null, 
            "name": null, 
            "properties": { 
              "routes": [ 

                { 
                  "name": null, 
                  "properties": { 
                    "addressPrefix": "0.0.0.0/0", 
                    "nextHopIpAddress": "100.78.98.1" 
                  } 
                } 
              ] 
            }, 

            "type": null 

          }, 

          "vlan": 301 

        } 
      } 
    ], 

    "vmSwitchName": "ConvergedSwitch(managementcompute)" 
  }, 

  "resourceGroup": "examplerg", 
  "systemData": { 
    "createdAt": "2025-03-13T01:04:07.645689+00:00", 
    "createdBy": "gus@contoso.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2025-03-13T01:04:15.389109+00:00", 
    "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05", 
    "lastModifiedByType": "Application" 
  }, 

  "tags": null, 
  "type": "microsoft.azurestackhci/logicalnetworks" 
} 
 
[Machine 1]: PS C:\HCIDeploymentUser>
```

</details>


### Create a network interface 

```azurecli
az stack-hci-vm network nic create --resource-group $resource_group --custom-location $customLocationId --location $location --subnet-id $lnetname --name $nicname --network-security-group $nsgname
```

`az stack-hci-vm network nic update -h` (if NIC was already created then use this update command to associate NSG with existing nic) and use that command to associate a NIC with an NSG.


## Manage network security rules

This section describes the manage operations supported for network security rules.

<br></br>
<details>
<summary>Expand this section to see an example output.</summary>

```output


```

</details>

### Show details of a network security rule

Run this command to show details of a network security rule:


```azurecli
az stack-hci-vm network nsg rule show -g $resource_group -n $securityrulename --nsg-name $nsgname
```

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

### Update a network security rule

Run this command to update a network security rule:


```azurecli

```

<details>
<summary>Expand this section to see an example output.</summary>

```output


```

</details>

### List network security rules in a network security group

Run this command to list network security rules in a network security group:

```azurecli


```


### Delete a network security rule

Run this command to delete a network security rule:

```azurecli
az stack-hci-vm network nsg rule delete -g $resource_group --nsg-name $nsgname -n $securityrulename
```

<details>
<summary>Expand this section to see an example output.</summary>

```output


```

</details>


# [Azure portal](#tab/azureportal)

This section describes the manage operations supported for network security groups and network security rules. Thsese operations are available in the Azure portal.

## List network security groups

Go to **Azure Local resource page > Resources > Network security groups**. You see a list of network security groups present on your Azure Local.

:::image type="content" source="./media/create-network-security-groups/create-network-security-group-1.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/create-network-security-groups/create-network-security-group-1.png":::


## Associate network security group with a logical network

You can associate a network security group with a logical network. This association allows you to apply the same network security rules to all the VMs in the logical network.

To associate a network security group with a logical network, follow these steps in Azure portal:

1. Go to **Azure Local resource page > Resources > Logical networks**.
1. In the right pane, from the list of logical networks, select a network.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-logical-network-1.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/associate-network-security-group-logical-network-1.png":::

1. Go to **Settings > Network security groups**.
1. In the right-pane, from the top command bar, select **+ Associate network security group**.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-logical-network-2.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/associate-network-security-group-logical-network-2.png":::

1. In the **Associate network security group** page:

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-logical-network-3.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/associate-network-security-group-logical-network-3.png":::

    1. From the dropdown, select a network security group.
    1. Select **Add network security group**. The operation will take a few minutes to complete. You can see the status of the operation in the **Notifications** pane.

    Once the network security group is associated with the logical network, you can see the network security group in the **Network security groups** tab of the logical network.

## Dissociate network security group from a logical network

You can dissociate a network security group from a logical network.

To dissociate a network security group from a logical network, follow these steps:

1. Go to **Azure Local resource page > Resources > Logical networks**.
1. In the right pane, from the list of logical networks, select a network.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-logical-network-1.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/associate-network-security-group-logical-network-1.png":::

1. Go to **Settings > Network security groups**.
1. In the right-pane, from the top command bar, select **Dissociate network security group**.

    :::image type="content" source="./media/manage-network-security-groups/dissociate-network-security-group-logical-network-2.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/dissociate-network-security-group-logical-network-2.png

1. Confirm the dissociation.

The operation will take a few minutes to complete. You can see the status of the operation in the **Notifications** pane. Once the network security group is dissociated from the logical network, the page refreshes to indicate the dissociation.

## Associate network security group with a network interface

You can associate a network security group with a network interface. This association allows you to apply the same network security rules to all the VMs in the logical network.

To associate a network security group with a network interface, follow these steps:

1. Go to **Azure Local resource page > Resources > Network interfaces**.
1. In the right pane, from the list of network interfaces, select a network interface.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-nic-1.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/associate-network-security-group-nic-1.png":::

1. Go to **Settings > Network security group**.
1. In the right-pane, from the top command bar, select **+ Associate network security group**.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-nic-2.png" alt-text="Screenshot of selecting create network security group." " lightbox="./media/manage-network-security-groups/associate-network-security-group-nic-2.png":::

1. In the **Associate network security group** page, input the following information:

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-nic-3.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/associate-network-security-group-nic-3.png":::

    1. **Network security group** - Select a network security group from the list of network security groups available in your Azure Local instance.
    1. Select **Assocaite network security group**. The operation will take a few minutes to complete. You can see the status of the operation in the **Notifications** pane.

## Dissociate network security group from a network interface

You can dissociate a network security group from a network interface.

To dissociate a network security group from a network interface, follow these steps:

1. Go to **Azure Local resource page > Resources > Network interfaces**.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-nic-1.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/associate-network-security-group-nic-1.png"::: 

1. In the right pane, from the list of network interfaces, select an interface that has a network security group attached to it.
1. Go to **Settings > Network security groups**.
1. In the right-pane, from the top command bar, select **Dissociate network security group**. The operation will take a few minutes to complete. You can see the status of the operation in the **Notifications** pane.

    :::image type="content" source="./media/manage-network-security-groups/dissociate-network-security-group-nic-2.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/dissociate-network-security-group-nic-2.png":::

1. Confirm the dissociation.

    :::image type="content" source="./media/manage-network-security-groups/dissociate-network-security-group-nic-3.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/manage-network-security-groups/dissociate-network-security-group-nic-3.png":::

Once the network security group is dissociated from the network interface, the page refreshes to indicate the dissociation.


## List network security rules in a network security group

List network security rules in a network security group.

To list network security rules in a network security group, follow these steps:

1. Go to **Azure Local resource page > Resources > Network security groups**.
1. In the right pane, from the list of network security groups, select a network security group.
1. In the right pane, from the list of network security rules, select a network security rule. The details of the network security rule are displayed in the right pane.

## Update a network security rule

Update a network security rule.

To update a network security rule, follow these steps:

1. Go to **Azure Local resource page > Resources > Network security groups**.
1. In the right pane, from the list of network security groups, select a network security group.
1. In the right pane, from the list of network security rules, select a network security rule.
1. In the right pane, the **Edit network security rule** page opens.
1. Update the required fields and select **Save**. The operation will take a few minutes to complete. You can see the status of the operation in the **Notifications** pane.
1. Once the network security rule is updated, the page refreshes to indicate the update.

---

## Next steps

- [Manage NSGs on Azure Local](../index.yml)