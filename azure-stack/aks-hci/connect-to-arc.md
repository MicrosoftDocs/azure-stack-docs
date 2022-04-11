---
title: Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc-enabled Kubernetes
description: Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc-enabled Kubernetes
author: mattbriggs
ms.topic: how-to
ms.date: 12/02/2020
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha
#intent: As an IT Pro, I want to learn how to connect an Azure Kubernetes Stack HCI cluster to Azure Arc-enabled Kubernetes so I can extend those capabilities to my Kubernetes clusters.
#keyword: AKS cluster HCI cluster
---

# Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc-enabled Kubernetes

> Applies to: AKS on Azure Stack HCI, AKS runtime on Windows Server 2019 Datacenter

When an Azure Kubernetes Service on Azure Stack HCI cluster is attached to Azure Arc, it will get an Azure Resource Manager representation. Clusters are attached to standard Azure subscriptions, are located in a resource group, and can receive tags just like any other Azure resource. Also the Azure Arc-enabled Kubernetes representation allows you to extend the following capabilities onto your Kubernetes cluster:

* Management services - Configurations (GitOps), Azure Monitor for containers, Azure Policy (Gatekeeper)
* Data Services - SQL Managed Instance, PostgreSQL Hyperscale
* Application services - App Service, Functions, Event Grid, Logic Apps, API Management

To connect a Kubernetes cluster to Azure, the cluster administrator needs to deploy agents. These agents run in a Kubernetes namespace named `azure-arc` and are standard Kubernetes deployments. The agents are responsible for connectivity to Azure, collecting Azure Arc logs and metrics, and enabling the above-mentioned scenarios on the cluster.

Azure Arc-enabled Kubernetes supports industry-standard SSL to secure data in transit. Also, data is stored encrypted at rest in an Azure Cosmos DB database to ensure data confidentiality.

The following steps describe how to connect Azure Kubernetes Service on Azure Stack HCI clusters to Azure Arc. **You may skip these steps if you've already connected your Kubernetes cluster to Azure Arc through Windows Admin Center.**

## Before you begin

Verify that you have the following requirements:

* An [Azure Kubernetes Service on Azure Stack HCI cluster](./kubernetes-walkthrough-powershell.md) with **at least one Linux worker node** that is up and running. 
* Installed the [AksHci PowerShell module](./kubernetes-walkthrough-powershell.md#install-the-akshci-powershell-module).
* **At least one** of the following access levels on your Azure subscription:
   - A user account with the built-in **Owner** role. You can check your access level by navigating to your subscription, selecting "Access control (IAM)" on the left hand side of the Azure portal, and then clicking on "View my access".
   - A service principal with either the built-in [Kubernetes Cluster - Azure Arc Onboarding](/azure/role-based-access-control/built-in-roles#kubernetes-cluster---azure-arc-onboarding) role (minimum), the built-in [Contributor](/azure/role-based-access-control/built-in-roles#contributor) role, or the built-in [Owner](/azure/role-based-access-control/built-in-roles#owner) role. 
* Run the commands in this document in a PowerShell administrative window.
* Ensure that you have met the [network requirements of Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements).

## Step 1: Log in to Azure

To log in to Azure, run the [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount) PowerShell command: 

```powershell
Connect-AzAccount
```

If you want to switch to a different subscription, run the [Set-AzContext](/powershell/module/az.accounts/set-azcontext?view=azps-5.9.0&preserve-view=true) PowerShell command.
```powershell
Set-AzContext -Subscription "myAzureSubscription"
```

## Step 2: Register the two providers for Azure Arc-enabled Kubernetes

You can skip this step if you've already registered the two providers for Azure Arc-enabled Kubernetes service on your subscription. Registration is an asynchronous process and needs to occur once per subscription. Registration may take approximately 10 minutes. 

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

Connect your AKS on Azure Stack HCI cluster to Azure Arc-enabled Kubernetes using the [Enable-AksHciArcConnection](./reference/ps/enable-akshciarcconnection.md) PowerShell command. This step deploys Azure Arc agents for Kubernetes into the `azure-arc` namespace.

```PowerShell
Enable-AksHciArcConnection -name mynewcluster 
```

## Connect your AKS cluster to Azure Arc using a service principal

If you do not have access to a subscription on which you're an "Owner", you can connect your AKS cluster to Azure Arc using a *service principal*.

The first command prompts for service principal credentials and stores them in the `credential` variable. Enter your application ID for the username and then use the service principal secret as the password when prompted. Make sure you get these values from your subscription admin. The second command connects your cluster to Azure Arc using the service principal credentials stored in the `credential` variable. 

```powershell
$Credential = Get-Credential
Enable-AksHciArcConnection -name "myCluster" -subscriptionId "3000e2af-000-46d9-0000-4bdb12000000" -resourceGroup "myAzureResourceGroup" -credential $Credential -tenantId "xxxx-xxxx-xxxx-xxxx" -location "eastus"
```

Make sure the service principal used in the command above has the "Owner", "Contributor" or "Kubernetes Cluster - Azure Arc Onboarding" role assigned to them and that it has scope over the subscription ID and resource group used in the command. For more information on service principals, see [Create a service principal with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps?view=azps-5.9.0&preserve-view=true#create-a-service-principal).

## Verify the connected cluster

You can view your Kubernetes cluster resource on the [Azure portal](https://portal.azure.com/). Once you have opened the portal in your browser, navigate to the resource group and the Azure Arc-enabled Kubernetes resource that's based on the resource name and resource group name inputs used in the [enable-akshciarcconnection](./reference/ps/enable-akshciarcconnection.md) PowerShell command.

> [!NOTE]
> After connecting the cluster, it may take a maximum of around five to ten minutes for the cluster metadata (cluster version, agent version, number of nodes) to surface on the overview page of the Azure Arc-enabled Kubernetes resource in Azure portal.

## Azure Arc agents for Kubernetes

Azure Arc-enabled Kubernetes deploys a few operators into the `azure-arc` namespace. You can view these deployments and pods by `kubectl` below. 

```console
kubectl -n azure-arc get deployments,pods
```

Azure Arc-enabled Kubernetes consists of a few agents (operators) that run in your cluster deployed to the `azure-arc` namespace. More information about these agents can be found [here](/azure/azure-arc/kubernetes/conceptual-agent-overview).

## Disconnect your AKS on Azure Stack HCI cluster from Azure Arc

If you want to disconnect your cluster from Azure Arc-enabled Kubernetes, run the [Disable-AksHciArcConnection](./reference/ps/disable-akshciarcconnection.md) PowerShell command. Make sure you login to Azure before running the command.

```powershell
Disable-AksHciArcConnection -Name mynewcluster
```

## Next steps

* [Use GitOps to deploy configurations](/azure/azure-arc/kubernetes/tutorial-use-gitops-connected-cluster)
* [Enable Azure Monitor to collect metrics and logs](/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters?toc=/azure/azure-arc/kubernetes/toc.json)
* [Enable Azure Policy addon to enforce admission control](/azure/governance/policy/concepts/policy-for-kubernetes?toc=/azure/azure-arc/kubernetes/toc.json)
