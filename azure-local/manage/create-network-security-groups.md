---
title: Create network security groups on Azure Local (Preview)
description: Learn about the Azure verification for VMs feature on Azure Local (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/04/2025
ms.service: azure-local
---

# Create network security groups on Azure Local (Preview)

Applies to: Azure Local 2504 or later

This article describes how to create network security groups (NSGs), network security rules and default network access policies on your Azure Local virtual machines enabled by Azure Arc. Once the software defined networking (SDN) is enabled on your existing Azure Local instance, you can create and attach NSGs to network interfaces or logical networks to filter network traffic.  

This how-to article is designed for the IT administrators who know how to configure and deploy workloads on Azure Local instances.

[!INCLUDE [important](../includes/hci-preview.md)]


## About NSGs on Azure Local VMs

You can use a network security group to filter network traffic between Azure resources in a logical network on your Azure Local instance. A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of resources.  

For each security rule, you can specify source and destination, port, and protocol.

## Create NSGs

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

## Create network security rule

### Create an inbound security rule.

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

> [TIP!]
> Use `az stack-hci-vm network nsg rule create -h` for help with Azure CLI.

### Create an outbound security rule

Create an outbound security rule blocking all traffic

```azurecli
az stack-hci-vm network nsg rule create -g $resource_group --nsg-name $nsgname --name $securityrulename --priority 500 --custom-location $customLocationId --access "Deny" --direction "Outbound" --location $location --protocol "*" --source-port-ranges $sportrange --source-address-prefixes $saddprefix --destination-port-ranges $dportrange --destination-address-prefixes $daddprefix --description $description
```

## Associate NSG with NIC

Create a NIC with the NSG created earlier in one step. IP address is optional and is not passed in this example. If you do not pass the IP address, the system assigns a random IP address from the subnet.

 
```azurecli
az stack-hci-vm network nic create --resource-group $resource_group --custom-location $customLocationId --location $location --subnet-id $lnetname --ip-address $ipaddress --name $nicname --network-security-group $nsgname 
```

<br></br>
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



## Associate NSG with logical network

Create a static logical network (lnet) with NSG. No IP pools are passed in this example as they are optional.

 
```azurecli
az stack-hci-vm network lnet create --resource-group $resource_group --custom-location $customLocationId --location $location --name $lnetname --ip-allocation-method "static" --address-prefixes $ipaddprefix --ip-poolstart $ippoolstart --ip-pool-end $ippoolend --vm-switch-name $vmswitchname --dns-servers $dnsservers --gateway $gateway --vlan $vlan –network-security-group $nsgname 
```
 
<br></br>
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

  "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/logical 

Networks/static-lnet3", 
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
            "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackH 

CI/networkSecurityGroups/examplensg3", 

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


### Create a NIC

```azurecli
az stack-hci-vm network nic create --resource-group $resource_group --custom-location $customLocationId --location $location --subnet-id $lnetname --name $nicname --network-security-group $nsgname
```

`az stack-hci-vm network nic update -h` (if NIC was already created then use this update command to associate NSG with existing nic) and use that command to associate a NIC with an NSG.

```azurecli
az stack-hci-vm network nic update --name $nicname --network-security-group $nsgname 
```

Check if the above is a correct one.

## Create default network access policy

Manage operations

Update security rule

Update destination port range on a security rule:
 
```azurecli
az stack-hci-vm network nsg rule update --name $securityrulename --nsg-name $name --resource-group $resource_group --destination-port-ranges $dportrange
```