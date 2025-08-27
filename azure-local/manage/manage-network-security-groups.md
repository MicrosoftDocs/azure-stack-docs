---
title: Manage network security groups and network security rules on Azure Local VMs (preview)
description: Learn how to manage network security groups and network security rules for Azure Local virtual machines (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 07/02/2025
ms.service: azure-local
---

# Manage network security groups on Azure Local (preview)

::: moniker range=">=azloc-2506"

This article describes how to manage network security groups (NSGs) on your Azure Local virtual machines (VMs) enabled by Azure Arc. Once you create network security groups on your Azure Local VMs, you can then list, show details, associate, dissociate, update, and delete these resources.

*The only VMs that are in scope for using NSGs with this feature are Azure Local VMs. These are VMs that were deployed from Azure client interfaces (Azure CLI, Azure portal, Azure Resource Manager). Do not use an Azure Local VM in conjunction with an NSG that is managed and applied from on-premises tools.*

[!INCLUDE [important](../includes/hci-preview.md)]


## Prerequisites

# [Azure CLI](#tab/azurecli)

- You have access to an Azure Local instance.

    - This instance is running 2506 with OS version 26100.xxxx, or later.
    - This instance has a custom location created.
    - You have access to an Azure subscription with the Azure Stack HCI Administrator role-based access control (RBAC) role. This role grants full access to your Azure Local instance and its resources. For more information, see [Assign Azure Local RBAC roles](../manage//assign-vm-rbac-roles.md#about-built-in-rbac-roles).
    - This instance has the SDN feature enabled. For more information, see [Enable software defined networking (SDN) on Azure Local](../deploy/enable-sdn-integration.md).
    - If using a client to connect to your Azure Local, ensure you've installed the latest Azure CLI and the `az-stack-hci-vm` extension. For more information, see [Azure Local VM management prerequisites](../manage/azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).
    - This instance has at least one network security group created and configured with a network security rule. For more information, see [Create a network security group](../manage/create-network-security-groups.md).

# [Azure portal](#tab/azureportal)

- You have access to an Azure Local instance.

    - This instance is running 2506 or later.
    - This instance has a custom location created.
    - You have access to an Azure subscription with the Azure Stack HCI Administrator role-based access control (RBAC) role. This role grants full access to your Azure Local instance and its resources. For more information, see [Assign Azure Local RBAC roles](../manage//assign-vm-rbac-roles.md#about-built-in-rbac-roles).
    - This instance has the SDN feature enabled. For more information, see [Enable software defined networking (SDN) on Azure Local](../deploy/enable-sdn-integration.md).
    
---

## Manage network security groups and network security rules

# [Azure CLI](#tab/azurecli)

## Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]


## Manage network security groups

This section describes the manage operations supported for network security groups.

### List network security groups

Follow these steps to list network security groups:

1. Set the following parameters in your Azure CLI session.

    ```azurecli
    $resource_group = "examplerg"
    $location = "eastus"
    $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
    $nsgname = "examplensg"
    ```

2. Run the following command to list network security groups on your Azure Local instance.

    ```azurecli
    az stack-hci-vm network nsg list -g $resource_group
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>
    
    ```output
    [
      {
        "eTag": null,
        "extendedLocation": {
          "name": "/subscriptions/<Subscription ID>/resourcegroups/<Resource Group Name>/providers/microsoft
    .extendedlocation/customlocations/examplecl",
          "type": "CustomLocation"
        },
        "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>/providers/Microsoft.Azu
    reStackHCI/networkSecurityGroups/examplensg",
        "location": "eastus",
        "name": "examplensg",
        "properties": {
          "networkInterfaces": [],
          "provisioningState": "Succeeded",
          "status": {
            "errorCode": "",
            "errorMessage": "",
            "provisioningStatus": {
              "operationId": "<Operation ID>",
              "status": "Succeeded"
            }
          },
          "subnets": []
        },
        "resourceGroup": "examplerg",
        "systemData": {
          "createdAt": "2025-04-24T17:33:49.304682+00:00",
          "createdBy": "gus@contoso.com",
          "createdByType": "User",
          "lastModifiedAt": "2025-04-24T17:34:00.133215+00:00",
          "lastModifiedBy": "<User ID>",
          "lastModifiedByType": "Application"
        },
        "tags": {},
        "type": "microsoft.azurestackhci/networksecuritygroups"
      }
    ]
    ```

    </details>

### Show details of a network security group

Follow these steps to show details of a network security group:

1. Set the following parameters in your Azure CLI session.
  
      ```azurecli
      $resource_group = "examplerg"
      $location = "eastus"
      $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
      $nsgname = "examplensg"
      ```

1. Run the following command to show details of a network security group (NSG) on your Azure Local instance.

    ```azurecli
    az stack-hci-vm network nsg show -g $resource_group --name $nsgname 
    ```

1. The command outputs the details of a specified network security group (NSG).

    - In this example, the NSG has no network interface attached.

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

    - In this example, the NSG has a network interface attached.

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
            "lastModifiedBy": "User ID",
            "lastModifiedByType": "Application"
          },
          "tags": null,
          "type": "microsoft.azurestackhci/networksecuritygroups"
        }       
        ```

        </details>


### Delete a network security group

Follow these steps to delete a network security group:

1. Set the following parameters in your Azure CLI session.

    ```azurecli
    $resource_group = "examplerg"
    $location = "eastus"
    $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
    $nsgname = "examplensg"
    ```

1. Run the following command to delete a network security group (NSG) on your Azure Local instance.

    ```azurecli
    az stack-hci-vm network nsg delete -g $resource_group --name $nsgname --yes
    ```

    Use the `list` command to verify that the NSG is deleted.


## Associate network security group with network interface

In this example, we create a network interface with an existing network security group in one step. The IP address for the network interface is optional and isn't passed in this example. If you don't pass the IP address, the system assigns a random IP address from the subnet.

1. Set the following parameters in your Azure CLI session.

    ```azurecli
    $resource_group = "examplerg"
    $location = "eastus"
    $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
    $nsgname = "examplensg"
    $lnetname="static-lnet" 
    $nicname="examplenic" 
    ```

1. Run the following command to create a network interface (NIC) on your Azure Local instance.

    ```azurecli
    az stack-hci-vm network nic create --resource-group $resource_group --custom-location $customLocationId --location $location --subnet-id $lnetname --ip-address $ipaddress --name $nicname --network-security-group $nsgname 
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>
    
    ```output
    { 
    
      "extendedLocation": { 
        "name": "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl", 
        "type": "CustomLocation" 
      }, 
    
      "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/networkInterfaces/examplenic", 
      "location": "eastus", 
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
    
        "macAddress": "<Mac Address>", 
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
        "createdByType": "<User>", 
        "lastModifiedAt": "2025-03-12T15:49:32.143520+00:00", 
        "lastModifiedBy": "<User ID>", 
        "lastModifiedByType": "Application" 
      }, 
    
      "tags": null, 
      "type": "microsoft.azurestackhci/networkinterfaces" 
    } 
    
    ```

</details>


## Associate network security group with logical network

In this example,  we associate a static logical network with an existing network security group. No IP pools are passed in this example as they are optional.

1. Set the following parameters in your Azure CLI session.

  
    ```azurecli
    $resource_group = "examplerg"
    $location = "eastus"
    $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
    $nsgname = "examplensg"
    $nicname="examplenic" 
    $lnetname="static-lnet3" 
    $ipaddress="100.78.98.10" 
    $ipaddprefix="100.78.98.0/24" 
    $vmswitchname='"ConvergedSwitch(managementcompute)"' 
    $dnsservers="100.71.93.111" 
    $gateway="100.78.98.1" 
    $vlan="301"
    ```

1. Run the following command to associate a logical network with a network security group on your Azure Local instance.

    ```azurecli
    az stack-hci-vm network lnet create --resource-group $resource_group --custom-location $customLocationId --location $location --name $lnetname --ip-allocation-method "static" --address-prefixes $ipaddprefix --vm-switch-name $vmswitchname --dns-servers $dnsservers --gateway $gateway --vlan $vlan –network-security-group $nsgname 
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>
    
    ```output
    { 
    
      "extendedLocation": { 
    
        "name": "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/ 
    
    customlocations/examplecl", 
    
        "type": "CustomLocation" 
    
      }, 
    
      "id": "/subscriptions/<Subscription ID>/resourceGroups/examplerg/providers/Microsoft.AzureStackHCI/logicalNetworks/static-lnet3", 
      "location": "eastus", 
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
    ```

    </details>

## Dissociate network security group from logical network

You can dissociate a network security group from a logical network. This dissociation allows you to remove the network security rules applied to the logical network.

Follow these steps to dissociate a network security group from logical network:

1. Set the following parameters in your Azure CLI session. Make sure to pass the NSG name as an empty string encased in double quotes followed by single quotes ('""').

    ```azurecli
    $resource_group = "examplerg"
    $location = "eastus"
    $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
    $nsgname = '""'
    $lnetname="static-lnet3" 
    ```

2. To dissociate a network security group from a logical network, run the following command:

    ```azurecli
    az stack-hci-vm network lnet update -g $resource_group --name $lnetname --network-security-group '""'
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>
    
    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/<Subscription ID>/resourcegroups/<Resource Group Name>/providers/microsoft.extendedlocation/customlocations/s46r2004-cl-custo
    mlocation",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>/providers/microsoft.azurestackhci/logicalnetworks/static-lnet2",
      "location": "eastus",
      "name": "static-lnet2",
      "properties": {
        "dhcpOptions": {
          "dnsServers": [
            "100.71.84.238"
          ]
        },
        "provisioningState": "Succeeded",
        "status": {
          "errorCode": "",
          "errorMessage": "",
          "provisioningStatus": {
            "operationId": "<Operation ID>",
            "status": "Succeeded"
          }
        },
        "subnets": [
          {
            "name": "static-lnet2",
            "properties": {
              "addressPrefix": "100.69.174.0/24",
              "addressPrefixes": null,
              "ipAllocationMethod": "Static",
              "ipConfigurationReferences": [
                {
                  "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>/providers/Microsoft.AzureStackHCI/networkInterfaces/sdnbbnic-0
    1",
                  "resourceGroup": "<Resource Group Name>"
                }
              ],
              "ipPools": [
                {
                  "end": "100.69.174.126",
                  "info": {
                    "available": "30",
                    "used": "1"
                  },
                  "ipPoolType": null,
                  "name": null,
                  "start": "100.69.174.96"
                }
              ],
              "networkSecurityGroup": {
                "id": null
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
                        "nextHopIpAddress": "100.69.174.1"
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
      "resourceGroup": "<Resource Group Name>",
      "systemData": {
        "createdAt": "2025-06-08T16:46:38.085581+00:00",
        "createdBy": "gus@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2025-06-09T13:45:08.531262+00:00",
        "lastModifiedBy": "<User ID>",
        "lastModifiedByType": "Application"
      },
      "tags": {},
      "type": "microsoft.azurestackhci/logicalnetworks"
    }
    ```

    </details>

## Dissociate network security group from network interface

You can dissociate a network security group from a network interface. This dissociation allows you to remove the network security rules applied to the network interface.

Follow these steps to dissociate a network security group from a network interface card:

1. Set the following parameters in your Azure CLI session.

    ```azurecli
    $resource_group = "examplerg"
    $location = "eastus"
    $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
    $nsgname = '""'
    $nicname ="examplenic" 
    ```

1. To dissociate a network security group from a network interface, run the following command:

    ```azurecli
    az stack-hci-vm network nic update -g $resource_group --name $nicname --network-security-group '""'
    ```

  <details>
  <summary>Expand this section to see an example output.</summary>
  
  ```output
  {
    "extendedLocation": {
      "name": "/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>/providers/Microsoft.ExtendedLocation/customLocations/s46r2004-cl-custo
  mlocation",
      "type": "CustomLocation"
    },
    "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>/providers/Microsoft.AzureStackHCI/networkInterfaces/sdnbbnic-01",
    "location": "eastus",
    "name": "sdnbbnic-01",
    "properties": {
      "createFromLocal": null,
      "dnsSettings": null,
      "ipConfigurations": [
        {
          "name": null,
          "properties": {
            "gateway": "100.69.174.1",
            "prefixLength": "24",
            "privateIpAddress": "100.69.174.96",
            "subnet": {
              "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>/providers/microsoft.azurestackhci/logicalNetworks/static-lnet2",
              "resourceGroup": "<Resource Group Name>"
            }
          }
        }
      ],
      "macAddress": "<Mac Address>",
      "networkSecurityGroup": {
        "id": null
      },
      "provisioningState": "Succeeded",
      "status": {
        "errorCode": null,
        "errorMessage": null,
        "provisioningStatus": {
          "operationId": "<Operation ID>",
          "status": "Succeeded"
        }
      }
    },
    "resourceGroup": "<Resource Group Name>",
    "systemData": {
      "createdAt": "2025-06-08T17:01:05.701432+00:00",
      "createdBy": "gus@contoso.com",
      "createdByType": "User",
      "lastModifiedAt": "2025-06-09T13:38:33.989674+00:00",
      "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
      "lastModifiedByType": "Application"
    },
    "tags": null,
    "type": "microsoft.azurestackhci/networkinterfaces"
  }  

  ``` 
  </details>


## Manage network security rules

This section describes the manage operations supported for network security rules.

### Show details of a network security rule

1. Set the following parameters in your Azure CLI session:

    ```azurecli
    $resource_group = "examplerg"
    $location = "eastus"
    $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
    $nsgname = "examplensg"
    ```

1. Run this command to show details of a network security rule:

    ```azurecli
    az stack-hci-vm network nsg rule show -g $resource_group -n $securityrulename --nsg-name $nsgname
    ```

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

1. Set the following parameters in your Azure CLI session.

    ```azurecli
    $resource_group = "examplerg"
    $location = "eastus"
    $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
    $nsgname = "examplensg"
    $securityrulename = "examplensr"
    $destinationport = "80"
    ```

1. Run this command to update a network security rule:

    ```azurecli
    az stack-hci-vm network nsg rule update --name $securityrulename --nsg-name $nsgname --resource-group $resouce_group --destination-port-ranges $destinationport
    ```

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
        "access": "Allow",
        "description": "This NSG is intended to allow traffic from any source IP/port range to hit any destination IP/port range",
        "destinationAddressPrefixes": [
          "*"
        ],
        "destinationPortRanges": [
          "80"
        ],
        "direction": "Inbound",
        "priority": 100,
        "protocol": "*",
        "provisioningState": "Succeeded",
        "sourceAddressPrefixes": [
          "*"
        ],
        "sourcePortRanges": [
          "*"
        ]
      },
      "resourceGroup": "examplerg",
      "systemData": {
        "createdAt": "2025-04-24T17:37:24.766786+00:00",
        "createdBy": "gus@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2025-04-24T18:21:13.803650+00:00",
        "lastModifiedBy": "gus@contoso.com",
        "lastModifiedByType": "User"
      },
      "type": "microsoft.azurestackhci/networksecuritygroups/securityrules"
    }

    ```

    </details>

### List network security rules in a network security group

Run this command to list network security rules in a network security group:

```azurecli
az stack-hci-vm network nsg rule list --resource-group "<Resource group name>" --nsg-name "<NSG name>"

```

<br></br>
<details>
<summary>Expand this section to see an example output.</summary>

```output
{
    "extendedLocation": {
      "name": "/subscriptions/<Subscription ID>/resourcegroups/<Resource Group Name>/providers/microsoft.extendedlocation/customlocations/examplecl",
      "type": "CustomLocation"
    },
    "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>/providers/Microsoft.AzureStackHCI/networkSecurityGroups/examplensg/securityRules/contoso-retail-any-any-rule",
    "name": "contoso-retail-any-any-rule",
    "properties": {
      "access": "Allow",
      "description": "This NSG is intended to allow traffic from any source IP/port range to hit any destination IP/port range",
      "destinationAddressPrefixes": [
        "*"
      ],
      "destinationPortRanges": [
        "80"
      ],
      "direction": "Inbound",
      "priority": 100,
      "protocol": "*",
      "provisioningState": "Succeeded",
      "sourceAddressPrefixes": [
        "*"
      ],
      "sourcePortRanges": [
        "*"
      ]
    },
    "resourceGroup": "<Resource Group Name>",
    "systemData": {
      "createdAt": "2025-04-24T17:37:24.766786+00:00",
      "createdBy": "gus@microsoft.com",
      "createdByType": "User",
      "lastModifiedAt": "2025-04-24T18:21:13.803650+00:00",
      "lastModifiedBy": "gus@microsoft.com",
      "lastModifiedByType": "User"
    },
    "type": "microsoft.azurestackhci/networksecuritygroups/securityrules"
  }

```

</details>

### Delete a network security rule

You may need to delete a network security rule if you no longer need it. You can delete a network security rule from a network security group (NSG).

> [!WARNING]
> NSGs must have a network security rule associated with them. An empty NSG that doesn't have a security rule configured, denies all inbound traffic by default. A VM or a logical network associated with this NSG won't be reachable.

1. Set the following parameters in your Azure CLI session.

    ```azurecli
    $resource_group = "examplerg"
    $location = "eastus"
    $customLocationId = "/subscriptions/<Subscription ID>/resourcegroups/examplerg/providers/microsoft.extendedlocation/customlocations/examplecl"    
    $nsgname = "examplensg"
    $securityrulename = "examplensr"
    ```

1. Run this command to delete a network security rule:

    ```azurecli
    az stack-hci-vm network nsg rule delete --resource-group $resource_group --name $securityrulename --yes
    ```

    Use the `list` command to verify that the network security rule is deleted.

# [Azure portal](#tab/azureportal)

This section describes the manage operations supported for network security groups and network security rules. These operations are available in the Azure portal.

## List network security groups

Go to **Azure Local resource page > Resources > Network security groups**. You see a list of network security groups present on your Azure Local.

:::image type="content" source="./media/create-network-security-groups/create-network-security-group-1.png" alt-text="Screenshot of list of create network security groups." lightbox="./media/create-network-security-groups/create-network-security-group-1.png":::


## Associate network security group with a logical network

You can associate a network security group with a logical network. This association allows you to apply the same network security rules to all the VMs in the logical network.

To associate a network security group with a logical network, follow these steps in Azure portal:

1. Go to **Azure Local resource page > Resources > Logical networks**.
1. In the right pane, from the list of logical networks, select a network.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-logical-network-1.png" alt-text="Screenshot of selecting a logical network to associate with network security group." lightbox="./media/manage-network-security-groups/associate-network-security-group-logical-network-1.png":::

1. Go to **Settings > Network security groups**.
1. In the right-pane, from the top command bar, select **+ Associate network security group**.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-logical-network-2.png" alt-text="Screenshot of selecting Associate network security group for the specified logical network." lightbox="./media/manage-network-security-groups/associate-network-security-group-logical-network-2.png":::

1. In the **Associate network security group** page:

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-logical-network-3.png" alt-text="Screenshot of a filled out Associate network security group page." lightbox="./media/manage-network-security-groups/associate-network-security-group-logical-network-3.png":::

    1. From the dropdown, select a network security group.
    1. Select **Add network security group**. The operation takes a few minutes to complete. You can see the status of the operation in the **Notifications** pane.

    Once the network security group is associated with the logical network, you can see the network security group in the **Network security groups** tab of the logical network.

## Dissociate network security group from a logical network

You can dissociate a network security group from a logical network.

To dissociate a network security group from a logical network, follow these steps:

1. Go to **Azure Local resource page > Resources > Logical networks**.
1. In the right pane, from the list of logical networks, select a network.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-logical-network-1.png" alt-text="Screenshot of selecting a logical network." lightbox="./media/manage-network-security-groups/associate-network-security-group-logical-network-1.png":::

1. Go to **Settings > Network security groups**.
1. In the right-pane, from the top command bar, select **Dissociate network security group**.

    :::image type="content" source="./media/manage-network-security-groups/dissociate-network-security-group-logical-network-2.png" alt-text="Screenshot of selecting Dissociate network security group for the specified logical network." lightbox="./media/manage-network-security-groups/dissociate-network-security-group-logical-network-2.png":::

1. Confirm the dissociation.

The operation takes a few minutes to complete. You can see the status of the operation in the **Notifications** pane. Once the network security group is dissociated from the logical network, the page refreshes to indicate the dissociation.

## Associate network security group with a network interface

You can associate a network security group with a network interface. This association allows you to apply the same network security rules to all the VMs in the logical network.

To associate a network security group with a network interface, follow these steps:

1. Go to **Azure Local resource page > Resources > Network interfaces**.
1. In the right pane, from the list of network interfaces, select a network interface.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-network-interface-1.png" alt-text="Screenshot of selecting a network interface." lightbox="./media/manage-network-security-groups/associate-network-security-group-network-interface-1.png":::

1. Go to **Settings > Network security group**.
1. In the right-pane, from the top command bar, select **+ Associate network security group**.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-network-interface-2.png" alt-text="Screenshot of selecting Associate network security group with the selected network interface." lightbox="./media/manage-network-security-groups/associate-network-security-group-network-interface-2.png":::

1. In the **Associate network security group** page, input the following information:

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-network-interface-3.png" alt-text="Screenshot of filled out Associate network security group page." lightbox="./media/manage-network-security-groups/associate-network-security-group-network-interface-3.png":::

    1. **Network security group** - Select a network security group from the list of network security groups available in your Azure Local instance.
    1. Select **Associate network security group**. The operation takes a few minutes to complete. You can see the status of the operation in the **Notifications** pane.

## Dissociate network security group from a network interface

You can dissociate a network security group from a network interface.

To dissociate a network security group from a network interface, follow these steps:

1. Go to **Azure Local resource page > Resources > Network interfaces**.

    :::image type="content" source="./media/manage-network-security-groups/associate-network-security-group-network-interface-1.png" alt-text="Screenshot of selecting network interface to dissociate from the network security group." lightbox="./media/manage-network-security-groups/associate-network-security-group-network-interface-1.png":::

1. In the right pane, from the list of network interfaces, select an interface that has a network security group attached to it.
1. Go to **Settings > Network security groups**.
1. In the right-pane, from the top command bar, select **Dissociate network security group**. 

    :::image type="content" source="./media/manage-network-security-groups/dissociate-network-security-group-network-interface-2.png" alt-text="Screenshot of selecting Dissociate network security group." lightbox="./media/manage-network-security-groups/dissociate-network-security-group-network-interface-2.png":::

1. Confirm the dissociation.

    :::image type="content" source="./media/manage-network-security-groups/dissociate-network-security-group-network-interface-3.png" alt-text="Screenshot of confirmation for Dissociated network security group." lightbox="./media/manage-network-security-groups/dissociate-network-security-group-network-interface-3.png":::

The operation takes a few minutes to complete. You can see the status of the operation in the **Notifications** pane.
After the network security group is dissociated from the network interface, the page refreshes to indicate the dissociation.

## List network security rules in a network security group

To list network security rules in a network security group, follow these steps:

1. Go to **Azure Local resource page > Resources > Network security groups**.
1. In the right pane, from the list of network security groups, select a network security group.
1. In the right pane, from the list of network security rules, select a network security rule. The details of the network security rule are displayed in the right pane.

## Update a network security rule

To update a network security rule, follow these steps:

1. Go to **Azure Local resource page > Resources > Network security groups**.
1. In the right pane, from the list of network security groups, select a network security group.
1. In the right pane, from the list of network security rules, select a network security rule.
1. In the right pane, the **Edit network security rule** page opens.
1. Update the required fields and select **Save**. The operation takes a few minutes to complete. You can see the status of the operation in the **Notifications** pane.
1. Once the network security rule is updated, the page refreshes to indicate the update.

---

## Next steps

- [Troubleshoot SDN enabled by Arc](sdn-troubleshooting.md).

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506 or later.

::: moniker-end
