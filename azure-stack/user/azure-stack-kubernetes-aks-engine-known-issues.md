---
title: Known issues with the AKS engine on Azure Stack Hub 
description: Learn Known issues using the AKS engine on Azure Stack Hub. 
author: mattbriggs

ms.topic: article
ms.date: 09/02/2020
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 09/02/2020

# Intent: Not done: As a < type of user >, I want < what? > so that < why? >
# Keyword: Not done: keyword noun phrase

---

# Known issues with the AKS engine on Azure Stack Hub

This topic covers known issues for the AKS engine on Azure Stack Hub.

## Upgrade issues in AKS Engine 0.51.0

* During upgrade (aks-engine upgrade) of a Kubernetes cluster from version 1.15.x to 1.16.x, upgrade of the following kubernetes components requires extra manual steps: **kube-proxy**, **azure-cni-networkmonitor**, **csi-secrets-store**, **kubernetes-dashboard**. The following describes what you may observe and how to work around the issues.

  * In connected environments, it is not obvious to notice this issue since there are no signs in the cluster that the affected components were not upgraded. Everything appears to work as expected.
  <!-- * In disconnected environments, you can see this problem when you run a query for the system pods status and see that the pods for the components mentioned below are not in "Ready" state: -->

    ```bash  
    kubectl get pods -n kube-system
    ```

  * As a workaround to solve this issue for each of these components, run the command in the Workaround column in the following table.

    |Component Name	|Workaround	|Affected Scenarios|
    |---------------|-----------|------------------|
    |**kube-proxy**	    | `kubectl delete ds kube-proxy -n kube-system`	|Connected, Disconnected |
    |**azure-cni-networkmonitor**	| `kubectl delete ds azure-cni-networkmonitor -n kube-system`	| Connected, Disconnected |
    |**csi-secrets-store**	|`sudo sed -i s/Always/IfNotPresent/g /etc/kubernetes/addons/secrets-store-csi-driver.yaml`<br>`kubectl delete ds csi-secrets-store -n kube-system` | Disconnected |
    |**kubernetes-dashboard** |Run the following command on each master node:<br>`sudo sed -i s/Always/IfNotPresent/g /etc/kubernetes/addons/kubernetes-dashboard.yaml` |Disconnected |

* Kubernetes 1.17 is not supported in this release. Although there are GitHub pull requests (PR)s referencing 1.17, it is not supported.

## aks-engine get-versions command limitations

The output of the **aks-engine** `get-versions` command only relates to global Azure rather than Azure Stack Hub. For more information about the various upgrade paths, see [Steps to upgrade to a newer Kubernetes version](azure-stack-kubernetes-aks-engine-upgrade.md#steps-to-upgrade-to-a-newer-kubernetes-version).

## Next steps

[AKS engine on Azure Stack Hub overview](azure-stack-kubernetes-aks-engine-overview.md)
