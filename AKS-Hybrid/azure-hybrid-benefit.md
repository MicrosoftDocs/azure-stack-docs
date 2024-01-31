---
title: Azure Hybrid Benefit for AKS enabled by Azure Arc 
description: Activate Azure Hybrid Benefit for AKS enabled by Arc.
author: sethmanheim
ms.author: sethm
ms.date: 01/30/2024
ms.topic: conceptual
ms.reviewer: rbaziwane
ms.lastreviewed: 01/30/2024
ms.custom:
  - devx-track-azurepowershell
zone_pivot_groups: version-select

# Intent: As an IT Pro, I want to learn about Azure Hybrid Benefit for AKS.   
# Keyword: Azure Hybrid Benefit for AKS
---

# Azure Hybrid Benefit for AKS enabled by Azure Arc

Azure Hybrid Benefit is a program that enables you to significantly reduce the costs of running workloads in the cloud. With Azure Hybrid Benefit for AKS enabled by Arc, you can maximize the value of your on-premises licenses and modernize your applications at no additional cost.

## What is Azure Hybrid Benefit for AKS?

Azure Hybrid Benefit for AKS enabled by Arc is a new benefit that can help you significantly reduce the cost of running Kubernetes on-premises or at the edge. It works by letting you apply your on-premises Windows Server Datacenter or Standard licenses with Software Assurance (SA) to pay for AKS. Each Windows Server core license entitles use on 1 virtual core of AKS. There are a few important details to note regarding activation of the benefit for AKS:

- Azure Hybrid Benefit for AKS is enabled at the management cluster (or AKS host) level. You don't need to enable the benefit for workload clusters.
- If you have multiple AKS on Azure Stack HCI or Windows Server deployments, you must enable Azure Hybrid Benefit individually for each deployment.
- If you enable Azure Hybrid Benefit on an AKS Arc deployment during the trial period, it doesn't nullify your trial period. The benefit is activated immediately, and is applied at the end of the trial period.
- Reinstalling AKS Arc doesn't automatically reinstate the benefit. You must reactivate this benefit for the new deployment.

For more information about Software Assurance and with which agreements it's available, see [Benefits of Software Assurance](https://www.microsoft.com/licensing/licensing-programs/software-assurance-by-benefits).

The rest of this article describes how to activate this benefit for AKS on Azure Stack HCI or Windows Server.

> [!TIP]
> You can maximize cost savings by also using Azure Hybrid Benefit for Azure Stack HCI. For more information, see [Azure Hybrid Benefit for Azure Stack HCI](/azure-stack/hci/concepts/azure-hybrid-benefit).

::: zone pivot="aks-22h2"
## Activate Azure Hybrid Benefit for AKS

### Prerequisites

Make sure you have an AKS hybrid cluster deployed on either an Azure Stack HCI or a Windows Server host.

# [Azure PowerShell](#tab/powershell)

To use Azure PowerShell, you can upgrade Azure PowerShell to the latest version (make sure to start PowerShell with administrator privileges).

1. Install or update the `Az.Accounts` and `Az.ConnectedKubernetes` modules:

   ```PowerShell
   Update-Module Az.Accounts 
   Update-Module Az.ConnectedKubernetes 
   ```

1. (Optional) If the `Az.*` modules installation is not successful and does not work, you must grant additional PowerShell permissions to execute external scripts:

   ```PowerShell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process 
   ```

# [Azure CLI](#tab/azurecli)

Make sure you have the latest version of [Azure CLI installed](/cli/azure/install-azure-cli) on your local machine. You can also choose to upgrade your Azure CLI version using `az upgrade`.

---

> [!NOTE]
> You must have the **Microsoft.Kubernetes/connectedClusters/write** permission to the Azure Arc-enabled Kubernetes cluster resoruce of the management cluster (`microsoft.kubernetes/connectedclusters`) to activate the Azure Hybrid Benefit for AKS hybrid.

### Retrieve your management cluster name

You can verify the AKS host management cluster by running the following command on any one node in your physical cluster to retrieve the `kvaName` name:

```PowerShell
(Get-AksHciConfig).Kva.kvaName
```

#### Sample output

```json
"<manangement cluster name>"
```

### Verify that Azure Hybrid Benefit for AKS is not already enabled

Check that the benefit has not already enabled on your management cluster. If the benefit has already been enabled, you should see the property `AzureHybridBenefit` set to `true`.

```PowerShell
Connect-AzAccount -Tenant <TenantId> -Subscription <SubscriptionId> -UseDeviceAuthentication
Set-AzContext -Subscription <Subscription>
Get-AzConnectedKubernetes -ClusterName <management cluster name> -ResourceGroupName <resource group name> | fl
```

#### Sample output

```json
{
  "agentVersion": "1.8.14",
  "azureHybridBenefit": "NotApplicable",
  "connectivityStatus": "Connected",
  "distribution": "AKS_Management",
  "distributionVersion": null,
  "id": "/subscriptions/<subscription>/resourceGroups/<resource group>/providers/Microsoft.Kubernetes/connectedClusters/<cluster name>",
  "identity": {

  },
  "infrastructure": "azure_stack_hci",
  "kubernetesVersion": "1.23.12",
  "lastConnectivityTime": "2022-11-04T14:59:59.050000+00:00",
  "location": "eastus",
  "miscellaneousProperties": null,
  "name": "<management cluster name>",
  "offering": "AzureStackHCI_AKS_Management",
  "provisioningState": "Succeeded",
  "resourceGroup": "<resource group>",
  "systemData": {},
  "tags": {},
  "totalCoreCount": 4,
  "totalNodeCount": 1,
  "type": "microsoft.kubernetes/connectedclusters"
}
```

> [!WARNING]
> If you have an empty value for the JSON property `distribution`, [follow this link to patch your cluster](https://github.com/Azure/aks-hybrid/issues/270) before proceeding with activating Azure Hybrid Benefit for AKS.

### Activate Azure Hybrid Benefit

To activate the benefit for an AKS cluster, run the following command in PowerShell and set the `AzureHybridBenefit` or `azure-hybrid-benefit` property to `true`. You will be prompted to confirm compliance with Azure Hybrid Benefit terms before proceeding.

# [Azure PowerShell](#tab/powershell)

```PowerShell
Update-AzConnectedKubernetes -ClusterName <management cluster name> -ResourceGroupName <resource group name> -AzureHybridBenefit True
```

# [Azure CLI](#tab/azurecli)

```azurecli
az connectedk8s update -n <name> -g <resource group name> --azure-hybrid-benefit true 
```

---

#### Sample output

```shell
I confirm I have an eligible Windows Server license with Azure Hybrid Benefit to apply this benefit to AKS on HCI or Windows Server. Visit https://aka.ms/ahb-aks for details (y/n)
```

> [!NOTE]
> You can also do the Azure Hybrid Benefit for AKS hybrid activation operation from an [Azure Cloud Shell](https://shell.azure.com) instance.

### Verify that the benefit is enabled

Run the following command and check that the JSON property `AzureHybridBenefit` is set to  `True`.

# [Azure PowerShell](#tab/powershell)

```PowerShell
Get-AzConnectedKubernetes -ClusterName <management cluster name> -ResourceGroupName <resource group name> | fl
```

# [Azure CLI](#tab/azurecli)

```azurecli
az connectedk8s show -n <management cluster name> -g <resource group> 
```

---

::: zone-end

::: zone pivot="aks-23h2"
## Use Azure Hybrid Benefit for AKS when setting up a cluster

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

## Use Azure Hybrid Benefit for AKS on an existing cluster

Run the `az aksarc update` command with the `--enable-ahub` flag to activate Azure Hybrid Benefit for AKS on a cluster that was already created without the benefit enabled:

```azurecli
az aksarc update --name <cluster name> -g <resource group> --enable-ahub
```

## Deactivate Azure Hybrid Benefit for AKS

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
::: zone-end

## Maintain compliance for Azure Hybrid Benefit

After activating Azure Hybrid Benefit for AKS, you must regularly check and maintain compliance for Azure Hybrid Benefit. You can perform an inventory of how many units you are running, and check this against the Software Assurance licenses you have. To determine how many clusters with Azure Hybrid Benefit for AKS you are running, you can look at your Microsoft Azure bill.

To qualify for the Azure Hybrid Benefit for AKS, you must be running AKS on first-party Microsoft infrastructure such as Azure Stack HCI or Windows Server 2019/2022 and have the appropriate license to cover the underlying infrastructure. You can only use Azure Hybrid Benefit for AKS during the Software Assurance term. When the Software Assurance term is nearing expiry, you must either renew your agreement with Software Assurance, or deactivate the Azure Hybrid Benefit functionality.

### Verify that Azure Hybrid Benefit for AKS is applied to my Microsoft Azure Bill

See **Cost Management and Billing** in the Azure portal to verify that the Azure Hybrid Benefit for AKS has been applied to your Microsoft Azure bill. Please note that billing does not apply in real time. There will be a delay of several hours from the time you've activated Azure Hybrid Benefit until it shows on your bill.

::: zone pivot="aks-22h2"
### Deactivate Azure Hybrid Benefit for AKS

Run the following command to deactivate the benefit:

# [Azure PowerShell](#tab/powershell)

```powershell
Update-AzConnectedKubernetes -ClusterName <management cluster name> -ResourceGroupName <resource group name> -AzureHybridBenefit False
```

# [Azure CLI](#tab/azurecli)

```azurecli
az connectedk8s update -n <name> -g <group> --azure-hybrid-benefit false 
```

---
::: zone-end

## Next steps

To learn more, including pricing, see the [pricing page](pricing.md).
