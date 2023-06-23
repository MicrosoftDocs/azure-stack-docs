---
title: Scale a Kubernetes cluster using AKS engine on Azure Stack Hub 
description: Learn how to scale a Kubernetes cluster using AKS engine on Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 02/13/2023
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 09/02/2020

# Intent: As an Azure Stack Hub user, I want to scale a Kubernetes cluster using AKS on Azure Stack Hub.
# Keyword: scale kubernetes cluster aks azure stack hub

---


# Scale a Kubernetes cluster using AKS engine on Azure Stack Hub

You can scale your Kubernetes cluster on Azure Stack Hub with AKS engine using the `scale` command. The `scale` command reuses your cluster configuration file (**apimodel.json**) inside the output directory as input for a new Azure Resource Manager deployment. The engine executes the scaling operation against the specified agent pool. When the scaling operation is done, the engine updates the cluster definition in that same **apimodel.json** file to reflect the new node count in order to reflect the updated, current cluster configuration.

## Scale a cluster

For AKS Engine versions 0.73.0 and below: the `aks-engine scale` command can increase or decrease the number of nodes in an existing agent pool in an `aks-engine` Kubernetes cluster.

For AKS Engine versions 0.75.3 and above: the `aks-engine-azurestack scale` command can increase or decrease the number of nodes in an existing agent pool in an `aks-engine` Kubernetes cluster. 

Nodes will always be added or removed from the end of the agent pool. Nodes will be cordoned and drained before deletion.

### Values for the scale command

The following parameters are used by the scale command to find your cluster definition file and update your cluster.

| Parameter | Example | Description |
| --- | --- | --- | 
| azure-env | AzureStackCloud | On Azure Stack Hub, the environment name should be `AzureStackCloud`. | 
| location | local | The region for your Azure Stack Hub instance. For an ASDK, the region is set to `local`.  | 
| resource-group | kube-rg | The name of the resource group that contains your cluster. | 
| subscription-id |  | The GUID of the subscription that contains the resources used by your cluster. Make sure you have enough quota on your subscription to scale. | 
| client-id |  | The client ID of the service principal used in creating your cluster from AKS engine. | 
| client-secret |  | The service principal secret used when creating your cluster. | 
| api-model | kube-rg/apimodel.json | The path to your cluster definition file (**apimodel.json**). The file may be located at: **_output/\<dnsPrefix>/apimodel.json** | 
| new-node-count | 9 | Desired node count. | 
| apiserver |  | Master FQDN. Needed when scaling down. |
| identity-system | adfs | Optional. Specify your identity management solution if you're using Active Directory Federated Services (AD FS). |

You must specify the **--azure-env** parameter when scaling a cluster in Azure Stack Hub. For more information about parameters and their values used in the **scale** command for the AKS engine, see [Scale - parameters](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/scale.md#parameters).

### Command to scale your cluster

To scale the cluster, run the following command:

> [!Note]
> For AKSe version 0.75.3 and above, the command to scale a cluster is `aks-engine-azurestack scale`.

```bash
aks-engine scale \
    --azure-env AzureStackCloud   \
    --location <for an ASDK is local> \
    --resource-group <cluster resource group>
    --subscription-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --client-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --client-secret xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --api-model <path to your apomodel.json file>
    --new-node-count <desired node count> \
    --apiserver <master FQDN> \
    --identity-system adfs # required if using AD FS
```

## Next steps

- Read about the [AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)
- [Upgrade a Kubernetes cluster on Azure Stack Hub](azure-stack-kubernetes-aks-engine-upgrade.md)
