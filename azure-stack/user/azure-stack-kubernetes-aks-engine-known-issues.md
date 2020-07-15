---
title: Known issues with the AKS engine on Azure Stack Hub 
description: Learn Known issues using the AKS engine on Azure Stack Hub. 
author: mattbriggs

ms.topic: article
ms.date: 07/02/2020
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 07/02/2020

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

## Basic load balancer SKU limitations

* Single agent pool limitation. Currently, Azure Stack Hub only supports the Basic load balancer SKU. This SKU [limits](https://docs.microsoft.com/en-us/azure/load-balancer/concepts#limitations) the backend pool endpoints to virtual machines in a single availability set (or virtual machine scale set). This implies that all replicas of a LoadBalancer service should be deployed on the same agent pool and it also implies that each individual cluster can either have a Linux LoadBalancer service or a Windows LoadBalancer service.

  You can force Kubernetes to create pods in a specific agent pool by adding [node selector](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) "agentpool: MY_POOL_NAME" in your pod template.

  ```json
  nodeSelector:

        agentpool: linuxpool
  ```
  
  If a LoadBalancer service was already created in your cluster, you can find out which agent pool was selected as the backend pool of the load balancer by inspecting the load balancer backend pools blade in the Azure Stack Hub portal. Once you have that information, you can specify the target agent pool by updating your deployment/pod yaml (as explained in the previous paragraph).

* Command scope for `get-versions`. The output of the `get-versions` command only pertains to Azure and not Azure Stack Hub clouds. For more information about the different upgrade paths, see [Steps to upgrade to a newer Kubernetes version](azure-stack-kubernetes-aks-engine-upgrade.md#steps-to-upgrade-to-a-newer-kubernetes-version).

## Next steps

[AKS engine on Azure Stack Hub overview](azure-stack-kubernetes-aks-engine-overview.md)
