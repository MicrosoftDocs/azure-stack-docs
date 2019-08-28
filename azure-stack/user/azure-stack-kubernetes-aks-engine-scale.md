---
title: Scale a Kubernetes cluster on Azure Stack | Microsoft Docs
description: Description
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na (Kubernetes)
ms.devlang: nav
ms.topic: article
ms.date: 08/30/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/30/2019

---

# Scale a Kubernetes cluster on Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can scale your cluster with the AKS Engine using the **scale** command. The ((scale)) command reuses your cluster configuration file (`apimodel.json`) inside the output directory as input for a new Azure Resource Manager deployment. The engine executes the scaling operation against the specified agent pool. When the scaling operation is done, the engine updates the cluster definition in that same `apimodel.json` file to reflect the new node count in order to reflect the updated, current cluster configuration.

## Scale a cluster

The `aks-engine scale` command can increase or decrease the number of nodes in an existing agent pool in an `aks-engine` Kubernetes cluster. Nodes will always be added or removed from the end of the agent pool. Nodes will be cordoned and drained before deletion.

### Values for the scale command

The following parameters are used by the scale command to find your cluster definition file and update your cluster.

| Parameter | Example | Description |
| --- | --- | --- | 
| azure-env | AzureStackCloud | When using Azure Stack, the environment names needs to be set to `AzureStackCloud`. | 
| location | local | This is the region for your Azure Stack instance. For an ASDK, the region is set to `local`.  | 
| resource-group | kube-rg | The name of the resource group that contains your cluster. | 
| subscription-id |  | The GUID of the subscription that contains the resources used by your cluster. Make sure you have enough quota on your subscription to scale. | 
| client-id |  | The client ID of the service principal used in creating your cluster from the AKS Engine. | 
| client-secret |  | The service principal secret used when creating your cluster. | 
| api-model | kube-rg/apimodel.json | The path to your cluster definition file (apimodel.json). This may be at:  _output/\<dnsPrefix>/apimodel.json | 
| -new-node-count | 9 | Desired node count. | 
| -master-FQDN |  | Master FQDN. Needed when scaling down. | 

You must specify the **–azure-env** parameter when scaling a cluster in Azure Stack. For more information about parameters and their values used in the **scale** command for the AKS Engine, see [Scale - parameters](https://github.com/Azure/aks-engine/blob/master/docs/topics/scale.md#parameters).

### Command to scale your cluster

To scale the cluster you run the following command:

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
    --master-FQDN <master FQDN> \
```

## Next steps

- Read about the [The AKS Engine on Azure Stack](azure-stack-kubernetes-aks-engine-overview.md)
- [Upgrade a Kubernetes cluster on Azure Stack](azure-stack-kubernetes-aks-engine-upgrade.md)
- [Rotate certificates for a Kubernetes cluster on Azure Stack](azure-stack-kubernetes-aks-engine-cert-rotate.md)