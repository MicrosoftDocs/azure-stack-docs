---
title: Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc for Kubernetes
description: Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc for Kubernetes
author: abha
ms.topic: how-to
ms.date: 09/21/2020
ms.author: abha
ms.reviewer: 
---

# Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc for Kubernetes

## Overview

When an Azure Kubernetes Service on Azure Stack HCI cluster is attached to Azure Arc, it will appear in the Azure portal. It will have an Azure Resource Manager ID and a managed identity. Clusters are attached to standard Azure subscriptions, are located in a resource group, and can receive tags just like any other Azure resource.

To connect a Kubernetes cluster to Azure, the cluster administrator needs to deploy agents. These agents run in a Kubernetes namespace named azure-arc and are standard Kubernetes deployments. The agents are responsible for connectivity to Azure, collecting Azure Arc logs and metrics, and watching for configuration requests.

Azure Arc enabled Kubernetes supports industry-standard SSL to secure data in transit. Also, data is stored encrypted at rest in an Azure Cosmos DB database to ensure data confidentiality.

The following steps provide a walkthrough on onboarding Azure Kubernetes Service on Azure Stack HCI clusters to Azure Arc.

## Before you begin

Verify you have the following requirements ready:

* An Azure Kubernetes Service on Azure Stack HCI cluster that is up and running. 
* You'll need a kubeconfig file to access the cluster and cluster-admin role on the cluster for deployment of Arc enabled Kubernetes agents.
* Have the Azure Kubernetes Service on Azure Stack HCI PowerShell module installed.
* An Azure subscription on which you are an Owner or Contributor. 
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

## Step 1: Login to Azure

Log in to Azure and after logging in, set an Azure subscription on which you are an owner or contributor as your default subscription.

```PowerShell
az login
az account set --subscription "00000000-aaaa-bbbb-cccc-000000000000"
```

## Step 2: Register the two providers for Azure Arc enabled Kubernetes:

You can skip this step if you have already registered the two providers for Azure Arc enabled Kubernetes service on your subscription. 
Registration is an asynchronous process and only needs to be done once per subscription. Registration may take approximately 10 minutes. 

```PowerShell
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.KubernetesConfiguration
```

You can check if you are registered with the following commands:

```PowerShell
az provider show -n Microsoft.Kubernetes -o table
az provider show -n Microsoft.KubernetesConfiguration -o table
```

## Step 3: Create a resource group

You need a resouce group to hold the connected cluster resource. You can use an existing resource group in East US or West Europe locations. If you do not have an existing resouce group in the East US or West Europe location, use the following command to create a new resource group:

```PowerShell
az group create --name AzureArcTest -l EastUS -o table
```

## Step 4: Create a new Service Principal

Create a new Service Principal with an informative name. Note that this name must be unique for your Azure Active Directory tenant. 
You can also re-use this service principal to on-board multiple clusters to Azure Arc. Save the service principal's appID, password and tenant values as you will need these details in subsequent steps.

You can skip this step if you have already created a service principal and know the service principal's appID, password and tenant values.

```PowerShell
az ad sp create-for-RBAC --skip-assignment --name "https://azure-arc-for-k8s"
```

**Output:**

```PowerShell
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "azure-arc-for-k8s",
  "name": "https://azure-arc-for-k8s",
  "password": "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee",
  "tenant": "ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj"
}
```

## Step 5: Assign permissions to the service principal

After creating the new Service Principal, assign the "Contributor" role to the newly created principal. 

You can skip this step if you have re-suing a service principal with Contributor permissions, and know the service principal's appID, password and tenant values.

```PowerShell
az role assignment create 
    --role Contributor 
    --assignee 00000000-0000-0000-0000-000000000000  #use the appId from the service principal
    --resource-group Azure Arc Test #Azure resource group that will store the cluster resource
```

## Step 6: Conect to Azure Arc using service principal and the Aks-Hci PowerShell module

Next, we will connect our Kubernetes cluster to Azure using service principal and the Aks-Hci PowerShell module. This step deploys Azure Arc Agents for Kubernetes into the `azure-arc` namespace.

Reference the newly created service principal and run the Install-AksHciArcOnboarding command available in the Aks-Hci PowerShell module.

```PowerShell
Install-AksHciArcOnboarding 
    -clusterName "mynewcluster" #Kubernetes cluster name
    -resourcegroup "AzureArcTest" 
    -location "eastus" #resource group location
    -subscriptionid "00000000-aaaa-bbbb-cccc-000000000000"
    -clientid "00000000-0000-0000-0000-000000000000" #use the appId from service principal 
    -clientsecret  "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" #use the secret from service principal 
    -tenantid "ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj" #use the tenant from service principal
```
## Verify connected cluster

You can view your Kubernetes cluster resource on the [Azure portal](https://portal.azure.com/). Once you have the portal open in your browser, navigate to the resource group and the Azure Arc enabled Kubernetes resource based on the resource name and resource group name inputs used earlier in the `Install-AksHciArcOnboarding` PowerShell command.

> [!NOTE]
> After onboarding the cluster, it takes around 5 to 10 minutes for the cluster metadata (cluster version, agent version, number of nodes) to surface on the overview page of the Azure Arc enabled Kubernetes resource in Azure portal.

To delete your cluster, or to connect your cluster if it is behind an outbound proxy server, visit [Connect an Azure Arc-enabled Kubernetes cluster](https://docs.microsoft.com/azure/azure-arc/kubernetes/connect-cluster).

## Next steps

* [Use GitOps in a connected cluster](https://docs.microsoft.com/azure/azure-arc/kubernetes/use-gitops-connected-cluster)
* [Use Azure Policy to govern cluster configuration](https://docs.microsoft.com/azure/azure-arc/kubernetes/use-azure-policy)
* [Enable Azure Monitor on an Azure Arc enabled Kubernetes cluster](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-enable-arc-enabled-clusters)
