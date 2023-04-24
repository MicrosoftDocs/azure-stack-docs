---
title: Known issues with the AKS engine on Azure Stack Hub 
description: Learn Known issues using the AKS engine on Azure Stack Hub. 
author: sethmanheim
ms.topic: article
ms.date: 04/24/2023
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 11/1/2021

---

# Known issues with the AKS engine on Azure Stack Hub

This article describes known issues for the AKS engine on Azure Stack Hub.

[!INCLUDE [Expired secret for service principal (SPN) causes cluster to fail](../includes/known-issue-aks-2.md)]

[!INCLUDE [Expired certificates for the front-proxy](../includes/known-issue-aks-3.md)]

## Limit of 50 nodes per subscription

- **Applicable to**: Azure Stack Hub, AKS engine (all)
- **Description**: When creating clusters, you must ensure that there aren't more than 50 Kubernetes nodes (control plane and agent nodes) deployed per subscriptions. The total Kubernetes nodes deployed across all clusters within a single subscription should not exceed 50 nodes.
- **Remediation**: Use fewer than 51 nodes in your subscription.
- **Occurrence**: When attempting to add more than 50 nodes per subscription.

## Unable to resize cluster VMs with the Compute service

- **Applicable to**: Azure Stack Hub, AKS engine (all)
- **Description**: Resizing cluster VMs through the Compute service doesn't work with the AKS engine. The AKS engine maintains the state of the cluster in the API model JSON file. To ensure that the desired VM size is reflected in any create, upgrade, or scale operation that's done with the AKS engine, update the API model before you execute any of those operations. For example, if you change a VM size on an already deployed cluster to a different size using the Compute service, the state is lost when `aks-engine upgrade` is executed.
- **Remediation**: To make this work, locate the API model for the cluster, change the size there, and then run `aks-engine upgrade`.
- **Occurrence**: When attempting to resize using the Compute service.

## Disk detach operation fails in AKS engine 0.55.0

- **Applicable to**: Azure Stack Hub (update 2005), AKS engine 0.55.0
- **Description**: When you try to delete a deployment that contains persistent volumes, the delete operation triggers a series of attach/detach errors. This issue is due to a bug in the AKS engine v0.55.0 cloud provider. The cloud provider calls the Azure Resource Manager using a version of the API that's newer than the version Azure Resource Manager in Azure Stack Hub (update 2005) currently supports.
- **Remediation**: For details and mitigation steps, see [the AKS engine GitHub repository (issue 3817)](https://github.com/Azure/aks-engine/issues/3817#issuecomment-691329443). Upgrade as soon as a new build of the AKS engine and the corresponding image are available.
- **Occurrence**: When deleting a deployment that contains persistent volumes.

## Upgrade issues in AKS engine 0.51.0

- During the AKS engine upgrade of a Kubernetes cluster from version 1.15.x to 1.16.x, upgrading the following Kubernetes components requires extra manual steps: **kube-proxy**, **azure-cni-networkmonitor**, **csi-secrets-store**, **kubernetes-dashboard**. The following information describes what you might see and how to work around the issues.

  - In connected environments, this issue isn't obvious, since there are no signs in the cluster that the affected components were not upgraded. Everything appears to work as expected.
  
    ```bash  
    kubectl get pods -n kube-system
    ```

  - As a workaround to solve this issue for each of these components, run the command in the **Workaround** column in the following table.

    |Component Name    |Workaround    |Affected Scenarios|
    |---------------|-----------|------------------|
    |**kube-proxy**        | `kubectl delete ds kube-proxy -n kube-system`    |Connected, Disconnected |
    |**azure-cni-networkmonitor**    | `kubectl delete ds azure-cni-networkmonitor -n kube-system`    | Connected, Disconnected |
    |**csi-secrets-store**    |`sudo sed -i s/Always/IfNotPresent/g /etc/kubernetes/addons/secrets-store-csi-driver.yaml`<br>`kubectl delete ds csi-secrets-store -n kube-system` | Disconnected |
    |**kubernetes-dashboard** |Run the following command on each control plane node:<br>`sudo sed -i s/Always/IfNotPresent/g /etc/kubernetes/addons/kubernetes-dashboard.yaml` |Disconnected |

- Kubernetes 1.17 is not supported in this release. Although there are GitHub pull requests (PR)s referencing 1.17, it is not supported.

## Cluster node moves to "Not Ready" status and `k8s-kern.log` contains message "Memory cgroup out of memory"

- **Applicable to**: Azure Stack Hub, AKS engine (all)
- **Description**: A cluster node moves to "Not Ready" status and the **k8s-kern.log** file contains the message `Memory cgroup out of memory`. This issue applies to all AKS engine releases. To check whether this issue is occurring on your system, search the **k8s-kern.log** file for the string "Memory cgroup out of memory."

  You can find the **k8s-kern.log** file by:

  - Running `aks-engine get-logs` and navigating to **${NODE_NAME}/var/log/k8s-kern.log**, OR
  - Navigating to **/var/log/kern.log** on the node file system.

- **Remediation**: For control plane nodes, increase the master profile VM size. For agent nodes, increase the node pool VM size or scale up the node pool. To scale up the node pool, run the documented `scale` command and follow the instructions.

  To increase a pool VM size, update the API model and run `aks-engine upgrade` (all VMs are deleted and recreated with the new VM size).

- **Occurrence**: When the memory required/consumed by the cluster node exceeds the available memory.

## Next steps

[AKS engine on Azure Stack Hub overview](azure-stack-kubernetes-aks-engine-overview.md)
