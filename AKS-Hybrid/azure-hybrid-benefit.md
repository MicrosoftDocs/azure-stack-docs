---
title: Azure Hybrid Benefit for Azure Kubernetes Service
description: Actvate Azure Hybrid Benefit for AKS.
author: baziwane
ms.author: rbaziwane
ms.topic: conceptual
ms.date: 11/17/2022

# Intent: As an IT Pro, I want to learn about Azure Hybrid Benefit for AKS.   
# Keyword: Azure Hybrid Benefit for AKS

---

# Azure Hybrid Benefit for Azure Kubernetes Service (AKS)

Azure Hybrid Benefit is a program that enables you to significantly reduce the costs of running workloads in the cloud. With Azure Hybrid Benefit for Azure Kubernetes Service, you can maximize the value of your on-premises licenses and modernize your applications at no additional cost.

## What is Azure Hybrid Benefit for AKS?

Azure Hybrid Benefit for Azure Kubernetes Service (AKS) is a new benefit that can help you significantly reduce the cost of running Kubernetes on-premises or on the edge. It works by letting you apply your on-premises Windows Server Datacenter or Standard licenses with Software Assurance (SA) to pay for AKS. Each Windows Server core license entitles use on 1 virtual core of AKS. There are a few important details to note regarding activation of the benefit for AKS:

1. Azure Hybrid Benefit for AKS is enabled at the management cluster (or AKS host) level. You don't need to enable the benefit for workload clusters.
2. If you have multiple AKS on Azure Stack HCI or Windows Server deployments, you need to enable the Azure Hybrid Benefit individually for each deployment.
3. Enabling Azure Hybrid Benefit on an AKS deployment during the trial period will not nullify your trial period. The benefit will be activated immediately but will be applied at the end of the trial period.
4. Reinstalling AKS will not automatically reinstate the benefit. You must reactivate this benefit for the new deployment.

To learn more about Software Assurance and with which agreements it is available, see [Benefits of Software Assurance] (https://www.microsoft.com/licensing/licensing-programs/software-assurance-by-benefits).

This rest of this article describes how to activate this benefit for AKS on Azure Stack HCI or Windows Server. 

> [!TIP] 
> You can maximize cost savings by also using Azure Hybrid Benefit for Azure Stack HCI. For more information see [Azure Hybrid Benefit for Azure Stack HCI](/azure-stack/hci/concepts/azure-hybrid-benefit.md). 

## Activate Azure Hybrid Benefit for AKS

### Prerequisites

1. Make sure you've installed the AKS on Azure Stack HCI or Windows Server host. 
2. Make sure you have the latest version of [Az CLI installed](/cli/azure/install-azure-cli) on your local machine. You can also choose to upgrade your Az CLI version using `az upgrade`.

### Retrieve your management cluster name

You can verify the AKS host management cluster by running the following command on any one node in your physical cluster to retrieve the (`kvaName`) name:

```PowerShell
Get-AksHciConfig | ConvertTo-Json
```

#### Sample output

```json

{
    "Moc":  {
                ...
            },
    "AksHci":  {
                ...    
               },
    "Kva":  {
                ...
                "kvaName":  "<manangement cluster name>"
            }
}

```

### Verify that Azure Hybrid Benefit for AKS is not already enabled

Check that the benefit has not already enabled on your management cluster. If the benefit has already been enabled, you should see the property `AzureHybridBenefit` set to `true`.

```shell
az login --use-device-code

az account set -s <subscription ID>

az connectedk8s show -n <management cluster name> -g <resource group> 
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

To activate the benefit for an AKS cluster, run the following command in PowerShell and set the `azure-hybrid-benefit` property to `true`. You will be prompted to confirm compliance with Azure Hybrid Benefit terms before proceeding. 

```powershell
az connectedk8s update -n <name> -g <resource group name> --azure-hybrid-benefit true 
```

#### Sample output

```shell
I confirm I have an eligible Windows Server license with Azure Hybrid Benefit to apply this benefit to AKS on HCI or Windows Server. Visit https://aka.ms/ahb-aks for details (y/n)
```

### Verify that the benefit is enabled

Run the following command and check that the JSON property `AzureHybridBenefit` is set to  `True`.

```powershell
az connectedk8s show -n <management cluster name> -g <resource group> 
```

![Screenshot of activating Azure Hybrid Benefit for AKS.](media/concepts/aks-azurehybridbenefit.gif)

## Maintain compliance for Azure Hybrid Benefit

After activating Azure Hybrid Benefit for AKS, you must regularly check and maintain compliance for Azure Hybrid Benefit. You can perform an inventory of how many units you are running, and check this against the Software Assurance licenses you have. To determine how many clusters with Azure Hybrid Benefit for AKS you are running, you can look at your Microsoft Azure bill. 

To qualify for the Azure Hybrid Benefit for AKS, you must be running AKS on first party Microsoft infrastructure, such as Azure Stack HCI or Windows Server 2019/2022 and have the appropriate license to cover the underlying infrastructure. You can only use Azure Hybrid Benefit for AKS during the Software Assurance term. When the Software Assurance term is nearing expiration, either renew your agreement with Software Assurance, or deactivate the Azure Hybrid Benefit functionality.

### Verify that Azure Hybrid Benefit for AKS is applied to my Microsoft Azure Bill

Visit Cost Management and Billing in the Azure portal to verify that the Azure Hybrid Benefit for AKS has been applied to your Microsoft Azure bill. Please note that billing does not apply in real time. There will be a delay of several hours from the time you've activated Azure Hybrid Benefit before it shows on your bill.

### Deactivate Azure Hybrid Benefit for AKS

Run the following command to deactivate the benefit:

```powershell
az connectedk8s update -n <name> -g <group> --azure-hybrid-benefit false 
```

## Next steps

To learn more, including pricing, visit the [pricing page](pricing.md).
