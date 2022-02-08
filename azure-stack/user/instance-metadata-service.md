---
title: Azure Instance Metadata Service in Azure Stack Hub 
description: Learn about the Azure Instance Metadata Service in Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 02/02/2022
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 02/02/2022

---

# Azure Instance Metadata Service – public preview

The Azure Instance Metadata Service (IMDS) provides information about currently running virtual machine instances. You can use it to manage and configure your virtual machines. This information includes the SKU, storage, and network configurations. For a complete list of the data available, see the [endpoint categories summary](#supported-endpoint-categories).

IMDS is available for running instances of virtual machines (VMs) and virtual machine scale set instances. All endpoints support VMs created and managed by using Azure Resource Manager.

IMDS is a REST API that's available at a well-known, non-routable IP address (169.254.169.254). You can only access it from within the VM. Communication between the VM and IMDS never leaves the host. You can have your HTTP clients bypass web proxies within the VM when querying IMDS, and treat 169.254.169.254 the same as 168.63.129.16.

## Usage

To learn more about IMDS and how to use it, see the [Azure Instance Metadata Service documentation](/azure/virtual-machines/windows/instance-metadata-service?tabs=windows). This article focuses on differences between Azure and Azure Stack Hub, as the service is in public preview.

## Differences between Azure and Azure Stack Hub

### Supported endpoint categories

The IMDS API contains multiple endpoint categories representing different data sources, each of which contains one or more endpoints. See each category for details.

|     Category root             |     Description                                       |     Available in Azure Stack Hub    |
|-------------------------------|-------------------------------------------------------|---------------------------------------|
|     /metadata/attested        |     See [Attested Data](/azure/virtual-machines/windows/instance-metadata-service?tabs=windows#attested-data)                               |     Not available                     |
|     /metadata/identity        |     See [Managed Identity via IMDS](/azure/virtual-machines/windows/instance-metadata-service?tabs=windows#managed-identity)                   |     Not available                     |
|     /metadata/instance        |     See [Instance metadata](/azure/virtual-machines/windows/instance-metadata-service?tabs=windows#instance-metadata)                           |     Azure Stack Hub 1.2108.2.73     |
|     /metadata/loadbalancer    |     See [Retrieve Load Balancer metadata via IMDS](/azure/virtual-machines/windows/instance-metadata-service?tabs=windows#load-balancer-metadata)    |     Not available                     |
|     /metadata/versions        |     See [Versions](/azure/virtual-machines/windows/instance-metadata-service?tabs=windows#versions)                                    |     Azure Stack Hub 1.2108.2.73     |

## Rest response

The following properties return either a different value or are expected to return nothing:

|     Property         |     Azure               |     Azure Stack Hub    |
|----------------------|-------------------------|------------------------|
|     azEnvironment    |     AZUREPUBLICCLOUD    |     AzureStack         |
|     customdata       |     supported           |     Not supported      |
|     plan             |     supported           |     Not supported      |
|     zone             |     supported           |     Not supported      |

Sample response:

```json
{
  "compute":  {
          "azEnvironment":  "AzureStack",
          "customData":  "",
          "evictionPolicy":  "",
          "extendedLocation":  {
                          "name":  "",
                          "type":  ""
                        },
          "isHostCompatibilityLayerVm":  "",
          "licenseType":  "",
          "location":  "orlando",
          "name":  "IMDSVALI",
          "offer":  "WindowsServer",
          "osProfile":  {
                            "adminUsername":  "sampleuser",
                            "computerName":  "IMDSVALI",
                            "disablePasswordAuthentication":  ""
                        },
          "osType":  "Windows",
          "placementGroupId":  "",
          "plan":  {
                       "name":  "",
                       "product":  "",
                       "publisher":  ""
                   },
          "platformFaultDomain":  "0",
          "platformUpdateDomain":  "0",
          "priority":  "",
          "provider":  "Microsoft.Compute",
          "publicKeys":  [

                     ],
          "publisher":  "MicrosoftWindowsServer",
          "resourceGroupName":  "IMDS",
          "resourceId":  "/subscriptions/1cf1cb48-fad3-4872-9366-c5c51fe748e6/resourceGroups/IMDS/providers/Microsoft.Compute/virtualMachines/IMDSVALI",
          "securityProfile":  {
                                  "secureBootEnabled":  "",
                                  "virtualTpmEnabled":  ""
                              },
          "sku":  "2019-Datacenter",
          "storageProfile":  {
                                 "dataDisks":  [
                                                ],
                                 "imageReference":  {
                                                        "id":  "",
                                                        "offer":  "WindowsServer",
                                                        "publisher":  "MicrosoftWindowsServer",
                                                        "sku":  "2019-Datacenter",
                                                        "version":  "17763.2114.2108051826"
                                                    },
                                 "osDisk":  {
                                                "caching":  "ReadWrite",
                                                "createOption":  "FromImage",
                                                "diffDiskSettings":  {
                                                                         "option":  ""
                                                                     },
                                                "diskSizeGB":  "127",
                                                "encryptionSettings":  {
                                                                           "enabled":  "false"
                                                                       },
                                                "image":  {
                                                              "uri":  ""
                                                          },
                                                "managedDisk":  {
                                                                    "id":  "/subscriptions/1cf1cb48-fad3-4872-9366-c5c51fe748e6/resourceGroups/IMDS/providers/Mi
crosoft.Compute/disks/IMDSVALI_OsDisk_1_589d8d9cdd8a4c34a004b0dcecd68b05",
                                                                    "storageAccountType":  "Premium_LRS"
                                                                },
                                                "name":  "IMDSVALI_OsDisk_1_589d8d9cdd8a4c34a004b0dcecd68b05",
                                                "osType":  "Windows",
                                                "vhd":  {
                                                            "uri":  ""
                                                        },
                                                "writeAcceleratorEnabled":  "false"
                                            },
                                 "resourceDisk":  {
                                                      "size":  ""
                                                  }
                             },
          "subscriptionId":  "1cf1cb48-fad3-4872-9366-c5c51fe748e6",
          "tags":  "",
          "tagsList":  [

                       ],
          "userData":  "",
          "version":  "17763.2114.2108051826",
          "virtualMachineScaleSet":  {
                                         "id":  ""
                                     },
          "vmId":  "fa4fb8e6-265d-4d5f-98cd-20b0a68bc678",
          "vmScaleSetName":  "",
          "vmSize":  "Standard_DS1_v2",
          "zone":  ""
      },
"network":  {
            "interface":  [
                            {
                            "ipv4":  {
                                      "ipAddress":  [
                                                         {
                                                          "privateIpAddress":  "10.0.2.4",
                                                          "publicIpAddress":  "10.217.119.162"
                                                         }
                                                    ],
                                       "subnet":  [
                                                         {
                                                          "address":  "10.0.2.0",
                                                          "prefix":  "24"
                                                         }
                                                  ]
                                  },
                              "ipv6": {
                                       "ipAddress":  [

                                                     ]
                                      },
                              "macAddress":  "001DD8B700C3"
                              }
                          ]
            }
}
```

## Supported API versions

- "2017-03-01",
- "2017-04-02",
- "2017-08-01",
- "2017-10-01",
- "2017-12-01",
- "2018-02-01",
- "2018-04-02",
- "2018-10-01",
- "2019-02-01",
- "2019-03-11",
- "2019-04-30",
- "2019-06-01",
- "2019-06-04",
- "2019-08-01",
- "2019-08-15",
- "2019-11-01",
- "2020-06-01",
- "2020-07-15",
- "2020-09-01",
- "2020-10-01",
- "2020-12-01",
- "2021-01-01",
- "2021-02-01",
- "2021-03-01",
- "2021-05-01"
