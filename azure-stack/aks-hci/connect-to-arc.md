---
title: Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc for Kubernetes
description: Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc for Kubernetes
author: abha
ms.topic: how-to
ms.date: 12/02/2020
ms.author: abha
ms.reviewer: 
---

# Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc for Kubernetes

> Applies to: AKS on Azure Stack HCI, AKS runtime on Windows Server 2019 Datacenter

When an Azure Kubernetes Service on Azure Stack HCI cluster is attached to Azure Arc, it will appear in the Azure portal. It will have an Azure Resource Manager ID and a managed identity. Clusters are attached to standard Azure subscriptions, are located in a resource group, and can receive tags just like any other Azure resource.

To connect a Kubernetes cluster to Azure, the cluster administrator needs to deploy agents. These agents run in a Kubernetes namespace named `azure-arc` and are standard Kubernetes deployments. The agents are responsible for connectivity to Azure, collecting Azure Arc logs and metrics, and watching for configuration requests.

Azure Arc enabled Kubernetes supports industry-standard SSL to secure data in transit. Also, data is stored encrypted at rest in an Azure Cosmos DB database to ensure data confidentiality.

The following steps provide a walkthrough on onboarding Azure Kubernetes Service on Azure Stack HCI clusters to Azure Arc. **You may skip these steps if you've already onboarded your Kubernetes cluster to Azure Arc through Windows Admin Center.**

## Before you begin

Verify you've the following requirements ready:

* An [Azure Kubernetes Service on Azure Stack HCI cluster](./kubernetes-walkthrough-powershell.md) with **at least one Linux worker node** that is up and running. 
* Have the [Azure Kubernetes Service on Azure Stack HCI PowerShell module](./kubernetes-walkthrough-powershell.md#install-the-azure-powershell-and-akshci-powershell-modules) installed.
- **At least one** of the following access levels on your Azure subscription:
   - A user account with the built-in **Owner** role. You can check your access level by navigating to your subscription, clicking on "Access control (IAM)" on the left hand side of the Azure Portal and then clicking on "View my access".
   - A service principal with either the built-in **Kubernetes Cluster - Azure Arc Onboarding** role (minimum), the built-in **Contributer** role, or the built-in **Owner** role. 
* Run the commands in this document in a PowerShell administrative window.


## Network requirements

Azure Arc agents require the following protocols/ports/outbound URLs to function.

* TCP on port 443 --> `https://:443`
* TCP on port 9418 --> `git://:9418`

| Endpoint (DNS)                                                                                               | Description                                                                                                                 |
| ------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------- |
| `https://management.azure.com`                                                                                 | Required for the agent to connect to Azure and register the cluster                                                        |
| `https://eastus.dp.kubernetesconfiguration.azure.com`, `https://westeurope.dp.kubernetesconfiguration.azure.com` | Data plane endpoint for the agent to push status and fetch configuration information                                      |
| `https://docker.io`                                                                                            | Required to pull container images                                                                                         |
| `https://github.com`, git://github.com                                                                         | Example GitOps repos are hosted on GitHub. Configuration agent requires connectivity to whichever git endpoint you specify. |
| `https://login.microsoftonline.com`                                                                            | Required to fetch and update Azure Resource Manager tokens                                                                                    |
| `https://azurearcfork8s.azurecr.io`                                                                            | Required to pull container images for Azure Arc agents                                                                  |
| `https://eus.his.arc.azure.com`, `https://weu.his.arc.azure.com`                                                                            |  Required to pull system-assigned managed identity certificates                                                                  |

## Step 1: Log in to Azure

To log in to Azure, run the [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount) PowerShell command: 

```powershell
Connect-AzAccount
```

If you want to switch to a different subscription, run the [Set-AzContext](/powershell/module/az.accounts/set-azcontext?view=azps-5.9.0&preserve-view=true) PowerShell command.
```powershell
Set-AzContext -Subscription "myAzureSubscription"
```

## Step 2: Register the two providers for Azure Arc enabled Kubernetes:

You can skip this step if you've already registered the two providers for Azure Arc-enabled Kubernetes service on your subscription. Registration is an asynchronous process and needs to be once per subscription. Registration may take approximately 10 minutes. 

```PowerShell
Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
```

You can check if you're registered with the following commands:

```powershell
Get-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Get-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
```

## Step 3: Connect to Azure Arc using the Aks-Hci PowerShell module

Connect your AKS on Azure Stack HCI cluster to Azure Arc-enabled Kubernetes using the [Enable-AksHciArcConnection](./enable-akshciarcconnection.md) PowerShell command. This step deploys Azure Arc agents for Kubernetes into the `azure-arc` namespace.

```PowerShell
Enable-AksHciArcConnection -name mynewcluster 
```

## Connect your AKS cluster to Azure Arc using a service principal

If you do not have access to a subscription on which you're an "Owner", you can connect your AKS cluster to Azure Arc using a service principal.

The first command prompts for service principal credentials and stores them in the `credential` variable. Enter your application ID for the username and service principal secret as the password when prompted. Make sure you get these values from your subscription admin. The second command connects your cluster to Azure Arc using the service principal credentials stored in the `credential` variable. 

```powershell
$Credential = Get-Credential
Enable-AksHciArcConnection -name "myCluster" -subscriptionId "3000e2af-000-46d9-0000-4bdb12000000" -resourceGroup "myAzureResourceGroup" -credential $Credential -tenantId "xxxx-xxxx-xxxx-xxxx" -location "eastus"
```

Make sure the service principal used in the command above has the "Owner", "Contributor" or "Kubernetes Cluster - Azure Arc Onboarding" role assigned to them and that it has scope over the subscription ID and resource group used in the command. For more information on service principals, visit [creating service principals with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps?view=azps-5.9.0&preserve-view=true#create-a-service-principal)

## Verify connected cluster

You can view your Kubernetes cluster resource on the [Azure portal](https://portal.azure.com/). Once you have the portal open in your browser, navigate to the resource group and the Azure Arc-enabled Kubernetes resource that's based on the resource name and resource group name inputs used earlier in the [enable-akshciarcconnection](./enable-akshciarcconnection.md) PowerShell command.

> [!NOTE]
> After onboarding the cluster, it takes around five to ten minutes for the cluster metadata (cluster version, agent version, number of nodes) to surface on the overview page of the Azure Arc-enabled Kubernetes resource in Azure portal.

## Azure Arc agents for Kubernetes

Azure Arc-enabled Kubernetes deploys a few operators into the `azure-arc` namespace. You can view these deployments and pods by `kubectl` below. 

```console
kubectl -n azure-arc get deployments,pods
```

Azure Arc-enabled Kubernetes consists of a few agents (operators) that run in your cluster deployed to the `azure-arc` namespace.

* `deployment.apps/config-agent`: watches the connected cluster for source control configuration resources applied on the cluster and updates compliance state
* `deployment.apps/controller-manager`: is an operator of operators and orchestrates interactions between Azure Arc components
* `deployment.apps/metrics-agent`: collects metrics of other Arc agents to ensure that these agents are exhibiting optimal performance
* `deployment.apps/cluster-metadata-operator`: gathers cluster metadata - cluster version, node count, and Azure Arc agent version
* `deployment.apps/resource-sync-agent`: syncs the above mentioned cluster metadata to Azure
* `deployment.apps/clusteridentityoperator`: Azure Arc-enabled Kubernetes currently supports system assigned identity. clusteridentityoperator maintains the managed service identity (MSI) certificate used by other agents for communication with Azure.
* `deployment.apps/flux-logs-agent`: collects logs from the flux operators deployed as a part of source control configuration

## Disconnect your AKS on Azure Stack HCI cluster from Azure Arc

If you want to disconnect your cluster from Azure Arc enabled Kubernetes, run the [Disable-AksHciArcConnection](./disable-akshciarcconnection.md) PowerShell command. Make sure you login to Azure before running the command.

```powershell
Disable-AksHciArcConnection -Name mynewcluster
```

## Next steps

* [Use GitOps in a connected cluster](/azure/azure-arc/kubernetes/use-gitops-connected-cluster)
* [Use Azure Policy to govern cluster configuration](/azure/azure-arc/kubernetes/use-azure-policy)
* [Enable Azure Monitor on an Azure Arc enabled Kubernetes cluster](/azure/azure-monitor/insights/container-insights-enable-arc-enabled-clusters)
