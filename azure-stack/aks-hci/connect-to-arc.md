---
title: Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc for Kubernetes
description: Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc for Kubernetes
author: abha
ms.topic: how-to
ms.date: 09/22/2020
ms.author: abha
ms.reviewer: 
---

# Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc for Kubernetes

When an Azure Kubernetes Service on Azure Stack HCI cluster is attached to Azure Arc, it will appear in the Azure portal. It will have an Azure Resource Manager ID and a managed identity. Clusters are attached to standard Azure subscriptions, are located in a resource group, and can receive tags just like any other Azure resource.

To connect a Kubernetes cluster to Azure, the cluster administrator needs to deploy agents. These agents run in a Kubernetes namespace named `azure-arc` and are standard Kubernetes deployments. The agents are responsible for connectivity to Azure, collecting Azure Arc logs and metrics, and watching for configuration requests.

Azure Arc enabled Kubernetes supports industry-standard SSL to secure data in transit. Also, data is stored encrypted at rest in an Azure Cosmos DB database to ensure data confidentiality.

The following steps provide a walkthrough on onboarding Azure Kubernetes Service on Azure Stack HCI clusters to Azure Arc. **You may skip these steps if you've already onboarded your Kubernetes cluster to Azure Arc through Windows Admin Center.**

## Before you begin

Verify you've the following requirements ready:

* An Azure Kubernetes Service on Azure Stack HCI cluster with atleast 1 Linux worker node that is up and running. 
* You'll need a kubeconfig file to access the cluster and cluster-admin role on the cluster for deployment of Arc enabled Kubernetes agents.
* Have the Azure Kubernetes Service on Azure Stack HCI PowerShell module installed.
* Azure CLI version 2.3+ is required for installing the Azure Arc enabled Kubernetes CLI extensions. [Install Azure CLI](/cli/azure/install-azure-cli?view=azure-cli-latest). You can also update to the latest version to ensure that you have Azure CLI version 2.3+.
* An Azure subscription on which you're an owner or contributor. 
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

Log in to Azure and after logging in, set an Azure subscription on which you're an owner or contributor as your default subscription.

```console
az login
az account set --subscription "00000000-aaaa-bbbb-cccc-000000000000"
```

## Step 2: Register the two providers for Azure Arc enabled Kubernetes:

You can skip this step if you've already registered the two providers for Azure Arc enabled Kubernetes service on your subscription. 
Registration is an asynchronous process and needs to be once per subscription. Registration may take approximately 10 minutes. 

```console
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.KubernetesConfiguration
```

You can check if you're registered with the following commands:

```console
az provider show -n Microsoft.Kubernetes -o table
az provider show -n Microsoft.KubernetesConfiguration -o table
```

## Step 3: Create a resource group

You need a resource group to hold the connected cluster resource. You can use an existing resource group in East US or West Europe locations. If you do not have an existing resource group in the East US or West Europe location, use the following command to create a new resource group:

```console
az group create --name AzureArcTest -l EastUS -o table
```

## Step 4: Create a new Service Principal

You can skip this step if you've already created a service principal with `contributor` role and know the service principal's appID, password, and tenant values.

Create a new service principal with an informative name. This name must be unique for your Azure Active Directory tenant. The default role for a service principal is `Contributor`. This role has full permissions to read and write to an Azure account. You can also reuse this service principal to on-board multiple clusters to Azure Arc. 
Set the scope of your service principal to *subscriptions/resource-group*. *Make sure you save the service principal's appID, password, and tenant values as you will need these details in subsequent steps.*

```console
az ad sp create-for-RBAC --name "azure-arc-for-k8s" --scope /subscriptions/{Subscription ID}/resourceGroups/{Resource Group Name}
```

**Output:**

```
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "azure-arc-for-k8s",
  "name": "https://azure-arc-for-k8s",
  "password": "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee",
  "tenant": "ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj"
}
```
## Step 5: Save service principal details
Save the created service principal's appId, password and tenant values and cluster name, Azure subscription ID, resource group name and location in PowerShell variables. This will ensure you can reuse the details in other tutorials. Ensure that you also save these values in a notepad in case you want to close your powerShell session.

```PowerShell
$clusterName = #<name of your Kubernetes cluster>
$resourceGroup = #<Azure resource group to store your connected Kubernetes cluster in Azure Arc>
$location = #<Azure resource group location. This can only be eastus or westeurope for Azure Arc for Kubernetes>
$subscriptionId = #<Azure subscription Id>
$appId = #<appID from the service principal created above>
$password = #<password from the service principal created above>
$tenant = #<tenant from the service principal created above>
```
Ensure that you have assigned the right values to the variables by running:

```PowerShell
echo $clusterName 
echo $resourceGroup
echo $location 
echo $subscriptionId 
echo $appId 
echo $password 
echo $tenant 
```

## Step 6: Connect to Azure Arc using service principal and the Aks-Hci PowerShell module

Next, we will connect our Kubernetes cluster to Azure using service principal and the Aks-Hci PowerShell module. This step deploys Azure Arc agents for Kubernetes into the `azure-arc` namespace.

Reference the newly created service principal and run the `Install-AksHciArcOnboarding` command available in the Aks-Hci PowerShell module.

```PowerShell
Install-AksHciArcOnboarding -clusterName $clusterName -resourcegroup $resourceGroup -location $location -subscriptionid $subscriptionId -clientid $appId -clientsecret $password -tenantid $tenant
```
## Verify connected cluster

You can view your Kubernetes cluster resource on the [Azure portal](https://portal.azure.com/). Once you've the portal open in your browser, navigate to the resource group and the Azure Arc enabled Kubernetes resource based on the resource name and resource group name inputs used earlier in the `Install-AksHciArcOnboarding` PowerShell command.

> [!NOTE]
> After onboarding the cluster, it takes around 5 to 10 minutes for the cluster metadata (cluster version, agent version, number of nodes) to surface on the overview page of the Azure Arc enabled Kubernetes resource in Azure portal.

To delete your cluster, or to connect your cluster if it is behind an outbound proxy server, visit [Connect an Azure Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/connect-cluster).

## Azure Arc agents for Kubernetes

Azure Arc enabled Kubernetes deploys a few operators into the `azure-arc` namespace. You can view these deployments and pods here:

```console
kubectl -n azure-arc get deployments,pods
```

Azure Arc enabled Kubernetes consists of a few agents (operators) that run in your cluster deployed to the `azure-arc` namespace.

* `deployment.apps/config-agent`: watches the connected cluster for source control configuration resources applied on the cluster and updates compliance state
* `deployment.apps/controller-manager`: is an operator of operators and orchestrates interactions between Azure Arc components
* `deployment.apps/metrics-agent`: collects metrics of other Arc agents to ensure that these agents are exhibiting optimal performance
* `deployment.apps/cluster-metadata-operator`: gathers cluster metadata - cluster version, node count, and Azure Arc agent version
* `deployment.apps/resource-sync-agent`: syncs the above mentioned cluster metadata to Azure
* `deployment.apps/clusteridentityoperator`: Azure Arc enabled Kubernetes currently supports system assigned identity. clusteridentityoperator maintains the managed service identity (MSI) certificate used by other agents for communication with Azure.
* `deployment.apps/flux-logs-agent`: collects logs from the flux operators deployed as a part of source control configuration

## Next steps

* [Use GitOps in a connected cluster](/azure/azure-arc/kubernetes/use-gitops-connected-cluster)
* [Use Azure Policy to govern cluster configuration](/azure/azure-arc/kubernetes/use-azure-policy)
* [Enable Azure Monitor on an Azure Arc enabled Kubernetes cluster](/azure/azure-monitor/insights/container-insights-enable-arc-enabled-clusters)
