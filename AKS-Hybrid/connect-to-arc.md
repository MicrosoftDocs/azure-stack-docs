---
title: Connect an Azure Kubernetes Service cluster to Azure Arc in AKS hybrid
description: Connect an Azure Kubernetes Service (AKS) cluster to Kubernetes.
author: sethmanheim
ms.topic: how-to
ms.custom:
  - devx-track-azurepowershell
ms.date: 11/09/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha

# Intent: As an IT Pro, I want to learn how to connect an Azure Kubernetes Service cluster to Kubernetes so I can extend those capabilities to my Kubernetes clusters.
# Keyword: AKS cluster HCI cluster
---

# Connect an Azure Kubernetes Service cluster to Azure Arc in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

When an Azure Kubernetes Service (AKS) cluster is attached to Azure Arc, it will get an Azure Resource Manager representation. Clusters are attached to standard Azure subscriptions, are located in a resource group, and can receive tags just like any other Azure resource. Also the Kubernetes representation allows you to extend the following capabilities onto your Kubernetes cluster:

* Management services - Configurations (GitOps), Azure Monitor for containers, Azure Policy (Gatekeeper)
* Data Services - SQL Managed Instance, PostgreSQL Hyperscale
* Application services - App Service, Functions, Event Grid, Logic Apps, API Management

To connect a Kubernetes cluster to Azure, the cluster administrator needs to deploy agents. These agents run in a Kubernetes namespace named `azure-arc` and are standard Kubernetes deployments. The agents are responsible for connectivity to Azure, collecting Azure Arc logs and metrics, and enabling the above-mentioned scenarios on the cluster.

AKS supports industry-standard SSL to secure data in transit. Also, data is stored encrypted at rest in an Azure Cosmos DB database to ensure data confidentiality.

The following steps describe how to connect AKS clusters to Azure Arc in AKS hybrid. **You may skip these steps if you've already connected your Kubernetes cluster to Azure Arc through Windows Admin Center.**

## Before you begin

Verify that you have the following requirements:

* An [AKS cluster](./kubernetes-walkthrough-powershell.md) with **at least one Linux worker node** that is up and running. 
* Installed the [AksHci PowerShell module](./kubernetes-walkthrough-powershell.md#install-the-akshci-powershell-module).
* The following access level on your Azure subscription:
   - A user account with the built-in **Owner** role. You can check your access level by navigating to your subscription, selecting "Access control (IAM)" on the left hand side of the Azure portal, and then clicking on "View my access".
   - A service principal with the built-in **[Owner](/azure/role-based-access-control/built-in-roles#owner) role**
* Run the commands in this document in a PowerShell administrative window.
* Ensure that you have met the [network requirements of AKS](/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements).

## Step 1: Log in to Azure

To log in to Azure, run the [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount) PowerShell command: 

```powershell
Connect-AzAccount $tenantId
```

If you want to switch to a different subscription, run the [Set-AzContext](/powershell/module/az.accounts/set-azcontext?view=azps-5.9.0&preserve-view=true) PowerShell command.

```powershell
Set-AzContext -Subscription $subscriptionId
```

## Step 2: Register the two providers for AKS

You can skip this step if you've already registered the two providers for Azure Kubernetes Service on your subscription. Registration is an asynchronous process and needs to occur once per subscription. Registration may take approximately 10 minutes. 

```PowerShell
Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
Register-AzResourceProvider -ProviderNamespace Microsoft.ExtendedLocation
```

You can check if you're registered with the following commands:

```powershell
Get-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Get-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
Get-AzResourceProvider -ProviderNamespace Microsoft.ExtendedLocation
```

## Step 3: Connect to Azure Arc using the Aks-Hci PowerShell module

Connect your AKS cluster to Kubernetes using the [Enable-AksHciArcConnection](./reference/ps/enable-akshciarcconnection.md) PowerShell command. This step deploys Azure Arc agents for Kubernetes into the `azure-arc` namespace.

```PowerShell
Enable-AksHciArcConnection -name $clusterName 
```

## Connect your AKS cluster to Azure Arc using a service principal

If you do not have access to a subscription on which you're an "Owner", you can connect your AKS cluster to Azure Arc using a *service principal*.

The first command prompts for service principal credentials and stores them in the `credential` variable. Enter your application ID for the username and then use the service principal secret as the password when prompted. Make sure you get these values from your subscription admin. The second command connects your cluster to Azure Arc using the service principal credentials stored in the `credential` variable. 

```powershell
$Credential = Get-Credential
Enable-AksHciArcConnection -name $clusterName -subscriptionId $subscriptionId -resourceGroup $resourceGroup -credential $Credential -tenantId $tenantId -location $location
```

Make sure the service principal used in the command above has the "Owner" role assigned to it and that it has scope over the subscription ID used in the command. For more information on service principals, see [Create a service principal with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps?view=azps-5.9.0&preserve-view=true#create-a-service-principal).

## Connect your AKS cluster to Azure Arc and enable custom locations
If you want to enable custom locations on your cluster along with Azure Arc, run the following command to get the object ID of the custom location application, and connect to Azure Arc using a service principal -
```powershell
$objectID = (Get-AzADServicePrincipal -ApplicationId "bc313c14-388c-4e7d-a58e-70017303ee3b").Id
Enable-AksHciArcConnection -name $clusterName -subscriptionId $subscriptionId -resourceGroup $resourceGroup -credential $Credential -tenantId $tenantId -location -customLocationsOid $objectID
```

## Verify the connected cluster

You can view your Kubernetes cluster resource on the [Azure portal](https://portal.azure.com/). Once you have opened the portal in your browser, navigate to the resource group and the AKS resource that's based on the resource name and resource group name inputs used in the [enable-akshciarcconnection](./reference/ps/enable-akshciarcconnection.md) PowerShell command.

> [!NOTE]
> After connecting the cluster, it may take a maximum of around five to ten minutes for the cluster metadata (cluster version, agent version, number of nodes) to surface on the overview page of the AKS resource in Azure portal.

## Azure Arc agents for Kubernetes

AKS deploys a few operators into the `azure-arc` namespace. You can view these deployments and pods by `kubectl` below. 

```console
kubectl -n azure-arc get deployments,pods
```

AKS consists of a few agents (operators) that run in your cluster deployed to the `azure-arc` namespace. More information about these agents can be found [here](/azure/azure-arc/kubernetes/conceptual-agent-overview).

## Disconnect your AKS cluster from Azure Arc

If you want to disconnect your cluster from AKS, run the [Disable-AksHciArcConnection](./reference/ps/disable-akshciarcconnection.md) PowerShell command. Make sure you log in to Azure before running the command.

```powershell
Disable-AksHciArcConnection -Name $clusterName
```

## Next steps

* [Use GitOps to deploy configurations](/azure/azure-arc/kubernetes/tutorial-use-gitops-connected-cluster)
* [Enable Azure Monitor to collect metrics and logs](/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters?toc=/azure/azure-arc/kubernetes/toc.json)
* [Enable Azure Policy add-on to enforce admission control](/azure/governance/policy/concepts/policy-for-kubernetes?toc=/azure/azure-arc/kubernetes/toc.json)
