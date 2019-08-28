---
title: Upgrade a Kubernetes cluster on Azure Stack | Microsoft Docs
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

# Upgrade a Kubernetes cluster on Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

## Upgrade a cluster

The AKS Engine allows you to upgrade the cluster that was originally deployed using the tool. You can maintain the clusters using the AKS Engine. Your maintenance tasks are similar to any IaaS system. You should be aware of the availability of new updates and use the AKS Engine to apply them.

Microsoft doesn't manage your cluster.

For a deployed cluster upgrades cover:

-   Kubernetes
-   Azure Stack Kubernetes provider
-   Base OS

When upgrading a production cluster, consider:

-   Are you using the correct cluster specification (`apimodel.json`) and resource group for the target cluster?
-   Are you using a reliable machine for the client machine to run the AKS Engine and from which you are performing upgrade operations?
-   Make sure that you have a backup cluster and that it is operational.
-   If possible, run the command from a VM within the Azure Stack environment to decrease the network hops and potential connectivity failures.
-   Make sure that your subscription will have enough quota through the entire process. The process allocates new VMs during the process.
-   No system updates or scheduled tasks are planned.
-   Setup a staged upgrade on a cluster that is configured exactly as the production cluster and test the upgrade there before doing so in your production cluster

## Steps to upgrade

1. Follow the instructions in the article, [Upgrading Kubernetes Clusters](https://github.com/Azure/aks-engine/blob/master/docs/topics/upgrade.md). 
2. You need to first determine the versions you can target for the upgrade. This version depends on the version you currently have and then use that version value to perform the upgrade.

    Run the following commands:

    ```bash  
    $ aks-engine get-versions
    Version Upgrades
    1.15.0
    1.14.3  1.15.0
    1.14.1  1.14.3, 1.15.0
    1.13.7  1.14.1, 1.14.3
    1.13.5  1.13.7, 1.14.1, 1.14.3
    1.12.8  1.13.5, 1.13.7
    1.12.7  1.12.8, 1.13.5, 1.13.7
    1.11.10 1.12.7, 1.12.8
    1.11.9  1.11.10, 1.12.7, 1.12.8
    1.10.13 1.11.9, 1.11.10
    1.10.12 1.10.13, 1.11.9, 1.11.10
    1.9.11  1.10.12, 1.10.13
    1.9.10  1.9.11, 1.10.12, 1.10.13
    1.6.9   1.9.10, 1.9.11
    ```

    For example, according to the output of the `get-versions` command, if your current Kubernetes version is "1.13.5" you can upgrade to "1.13.7, 1.14.1, 1.14.3".

3. Collect the information you will need to run the `upgrade` command. The upgrade uses the following parameters:

    | Parameter | Example | Description |
    | --- | --- | --- |
    | azure-env | AzureStackCloud | To indicate to AKS Engine that your target platform is Azure Stack use `AzureStackCloud`. |
    | location | local | The region name for your Azure Stack. For the ASDK the region is set to `local`. |
    | resource-group | kube-rg | Enter the name of a new resource group or select an existing resource group. The resource name needs to be alphanumeric and lowercase. |
    | subscription-id | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter your Subscription ID. For more information see [Subscribe to an offer](https://docs.microsoft.com/azure-stack/user/azure-stack-subscribe-services#subscribe-to-an-offer) |
    | api-model | ./kubernetes-azurestack.json | Path to the cluster configuration file, or API model. |
    | client-id | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter the service principal GUID. The Client ID identified as the Application ID when your Azure Stack administrator created the service principal. |
    | client-secret | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter the service principal secret. This is the client secret you set up when creating your service. |


4. With your values in place, run the following command:

    ```bash  
    aks-engine upgrade \
    --azure-env AzureStackCloud   
    --location <for an ASDK is local> \
    --resource-group kube-rg \
    --subscription-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --api-model kube-rg/apimodel.json \
    --upgrade-version 1.13.5 \
    --client-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --client-secret xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    ```

5.  If for any reason the upgrade operation encounters a failure, you can re-run the upgrade command after addressing the issue. The AKS Engine will resume the operation where it failed the previous time.

## Forcing an Upgrade

There may be conditions where you may want to force an upgrade of your cluster. For example, on day one you deploy a cluster in a disconnected environment using the latest Kubernetes version. The following day Ubuntu releases a patch to a vulnerability for which Microsoft generates a new **AKS Base Image**. You can apply the new image by forcing an upgrade using the same Kubernetes version you already deployed.

    ```bash  
    aks-engine upgrade \
    --azure-env AzureStackCloud   
    --location <for an ASDK is local> \
    --resource-group kube-rg \
    --subscription-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --api-model kube-rg/apimodel.json \
    --upgrade-version 1.13.5 \
    --client-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --client-secret xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    --force
    ```

For instructions, see [Force upgrade](https://github.com/Azure/aks-engine/blob/master/docs/topics/upgrade.md#force-upgrade).

## Next steps

- Read about the [The AKS Engine on Azure Stack](azure-stack-kubernetes-aks-engine-overview.md)
- [Scale a Kubernetes cluster on Azure Stack](azure-stack-kubernetes-aks-engine-scale.md)
- [Rotate certificates for a Kubernetes cluster on Azure Stack](azure-stack-kubernetes-aks-engine-cert-rotate.md)