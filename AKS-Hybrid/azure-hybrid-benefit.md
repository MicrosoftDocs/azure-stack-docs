---
title: Azure Hybrid Benefit for AKS enabled by Azure Arc (AKS on Azure Stack HCI 23H2)
description: Activate Azure Hybrid Benefit for AKS enabled by Arc on Azure Stack HCI 23H2.
author: sethmanheim
ms.author: sethm
ms.date: 01/30/2024
ms.topic: conceptual
ms.reviewer: rbaziwane
ms.lastreviewed: 01/30/2024
ms.custom:

# Intent: As an IT Pro, I want to learn about Azure Hybrid Benefit for AKS.   
# Keyword: Azure Hybrid Benefit for AKS
---

# Azure Hybrid Benefit for AKS enabled by Azure Arc (AKS on Azure Stack HCI 23H2)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

Azure Hybrid Benefit is a program that enables you to significantly reduce the costs of running workloads in the cloud. With Azure Hybrid Benefit for AKS enabled by Azure Arc, you can maximize the value of your on-premises licenses and modernize your applications at no additional cost.

## What is Azure Hybrid Benefit for AKS enabled by Arc?

Azure Hybrid Benefit for AKS enabled by Arc can help you significantly reduce the cost of running Kubernetes on-premises or at the edge. It works by letting you apply your on-premises Windows Server Datacenter or Standard licenses with Software Assurance (SA) to pay for AKS. Each Windows Server core license entitles use on 1 virtual core of AKS. There are a few important details to note regarding activation of the benefit for AKS:

- Azure Hybrid Benefit for AKS Arc is enabled at the management cluster (or AKS host) level. You don't need to enable the benefit for workload clusters.
- If you have multiple AKS on Azure Stack HCI or Windows Server deployments, you must enable Azure Hybrid Benefit individually for each deployment.
- If you enable Azure Hybrid Benefit on an AKS Arc deployment during the trial period, it doesn't nullify your trial period. The benefit is activated immediately, and is applied at the end of the trial period.
- Reinstalling AKS Arc doesn't automatically reinstate the benefit. You must reactivate this benefit for the new deployment.

For more information about Software Assurance and with which agreements it's available, see [Benefits of Software Assurance](https://www.microsoft.com/licensing/licensing-programs/software-assurance-by-benefits).

The rest of this article describes how to activate this benefit for AKS on Azure Stack HCI or Windows Server.

> [!TIP]
> You can maximize cost savings by also using Azure Hybrid Benefit for Azure Stack HCI. For more information, see [Azure Hybrid Benefit for Azure Stack HCI](/azure-stack/hci/concepts/azure-hybrid-benefit).

## Use Azure Hybrid Benefit for AKS enabled by Arc when setting up a cluster

> [!WARNING]
> Azure Hybrid Benefit for AKS Arc does not work on a bundled OEM partner SKU. If enabled, the setting has no effect.

To enable Azure Hybrid Benefit for AKS during cluster creation, use the `--enable-ahub` flag when you run `az aksarc create`:

```azurecli
az aksarc create -n <cluster name> -g <resource group> --custom-location <custom location> --enable-ahub
```

Sample output:

```json
{
  "extendedLocation": { 
    "name": "<custom location>", 
    "type": "CustomLocation" 
  }, 
  "id": "/subscriptions/<subscription id>/resourceGroups/<resource group>/providers/Microsoft.Kubernetes/connectedClusters/<cluster name>/providers/Microsoft.HybridContainerService/provisionedClusterInstances/default", 
  "name": "default", 
  "properties": { 
    "agentPoolProfiles": [ 
      { 
        "osSku": "CBLMariner", 
        "osType": "Linux", 
        "vmSize": "Standard_A4_v2" 
      } 
    ], 
    "autoScalerProfile": { 
    }, 
    "cloudProviderProfile": { 
      "infraNetworkProfile": { 
        "vnetSubnetIds": [    ] 
      } 
    }, 
    "clusterVmAccessProfile": { 
      "authorizedIpRanges": null 
    }, 
    "controlPlane": { 
      "controlPlaneEndpoint": { 
        "hostIp": null 
      }, 
      "count": 1, 
      "vmSize": "Standard_A4_v2" 
    }, 
    "kubernetesVersion": "1.25.11", 
    "licenseProfile": { 
      "azureHybridBenefit": "True" 
    }, 
    "linuxProfile": { 
      "ssh": { 
        "publicKeys": [ 
          { 
            "keyData": "<ssh key>" 
          } 
        ] 
      } 
    }, 
    "networkProfile": { 
      "networkPolicy": "calico", 
      "podCidr": "10.244.0.0/16" 
    }, 
    "provisioningState": "Succeeded", 
    "status": { 
      "controlPlaneStatus": [ 
      ], 
      "currentState": "Succeeded", 
      "errorMessage": null, 
      "operationStatus": null 
    }, 
    "storageProfile": { 
      "nfsCsiDriver": { 
        "enabled": true 
      }, 
      "smbCsiDriver": { 
        "enabled": true 
      } 
    } 
  }, 
  "resourceGroup": "<resource group>", 
  "systemData": { 
  }, 
  "type": "microsoft.hybridcontainerservice/provisionedclusterinstances" 
}
```

## Use Azure Hybrid Benefit for AKS Arc on an existing cluster

Run the `az aksarc update` command with the `--enable-ahub` flag to activate Azure Hybrid Benefit for AKS enabled by Arc on a cluster that was already created without the benefit enabled:

```azurecli
az aksarc update --name <cluster name> -g <resource group> --enable-ahub
```

## Deactivate Azure Hybrid Benefit for AKS Arc

To deactivate Azure Hybrid Benefit for AKS Arc, run the following command:

```azurecli
az aksarc update --name <cluster name> -g <resource group> --disable-ahub
```

Sample output:

```json
{ 
"extendedLocation": { 
    "name": "<custom location>", 
    "type": "CustomLocation" 
  }, 
  "id": "/subscriptions/<subscription id>/resourceGroups/<resource group>/providers/Microsoft.Kubernetes/connectedClusters/<cluster name>/providers/Microsoft.HybridContainerService/provisionedClusterInstances/default", 
  "name": "default", 
  "properties": { 
    "agentPoolProfiles": [ 
      { 
        "osSku": "CBLMariner", 
        "osType": "Linux", 
        "vmSize": "Standard_A4_v2" 
      } 
    ], 
    "autoScalerProfile": { 
    }, 
    "cloudProviderProfile": { 
      "infraNetworkProfile": { 
        "vnetSubnetIds": [    ] 
      } 
    }, 
    "clusterVmAccessProfile": { 
      "authorizedIpRanges": null 
    }, 
    "controlPlane": { 
      "controlPlaneEndpoint": { 
        "hostIp": null 
      }, 
      "count": 1, 
      "vmSize": "Standard_A4_v2" 
    }, 
    "kubernetesVersion": "1.25.11", 
    "licenseProfile": { 
      "azureHybridBenefit": "False" 
    }, 
    "linuxProfile": { 
      "ssh": { 
        "publicKeys": [ 
          { 
            "keyData": "<ssh key>" 
          } 
        ] 
      } 
    }, 
    "networkProfile": { 
      "networkPolicy": "calico", 
      "podCidr": "10.244.0.0/16" 
    }, 
    "provisioningState": "Succeeded", 
    "status": { 
      "controlPlaneStatus": [ 
      ], 
      "currentState": "Succeeded", 
      "errorMessage": null, 
      "operationStatus": null 
    }, 
    "storageProfile": { 
      "nfsCsiDriver": { 
        "enabled": true 
      }, 
      "smbCsiDriver": { 
        "enabled": true 
      } 
    } 
  }, 
  "resourceGroup": "<resource group>", 
  "systemData": { 
  }, 
  "type": "microsoft.hybridcontainerservice/provisionedclusterinstances" 
}
```

## Maintain compliance for Azure Hybrid Benefit

After activating Azure Hybrid Benefit for AKS Arc, you must regularly check and maintain compliance. You can perform an inventory of how many units you are running, and check this against the Software Assurance licenses you have. To determine how many clusters with Azure Hybrid Benefit for AKS you run, you can look at your Microsoft Azure bill.

To qualify for the Azure Hybrid Benefit for AKS Arc, you must be running AKS on first-party Microsoft infrastructure such as Azure Stack HCI or Windows Server 2019/2022 and have the appropriate license to cover the underlying infrastructure. You can only use Azure Hybrid Benefit for AKS Arc during the Software Assurance term. When the Software Assurance term nears expiration, you must either renew your agreement with Software Assurance, or deactivate the Azure Hybrid Benefit functionality.

### Verify that Azure Hybrid Benefit for AKS Arc is applied to my Microsoft Azure bill

See **Cost Management and Billing** in the Azure portal to verify that the Azure Hybrid Benefit for AKS Arc was applied to your Microsoft Azure bill. Note that billing does not apply in real time. There is a delay of several hours from the time you've activated Azure Hybrid Benefit until it shows on your bill.

## Next steps

- [Azure Hybrid Benefit (AKS on Azure Stack HCI 22H2)](azure-hybrid-benefit-22h2.md)
- [Pricing](pricing.md)
