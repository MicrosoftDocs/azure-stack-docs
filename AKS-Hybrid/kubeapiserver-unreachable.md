---
title: Troubleshoot the Failed to either reach kube-apiserver or control plane IP of Kubernetes cluster from Arc Resource Bridge IP Error
description: Learn how to troubleshoot the failed to either reach kube-apiserver or control plane IP of Kubernetes cluster from Arc Resource Bridge IP error when you try to create and deploy an Azure Kubernetes Service, enabled by Arc cluster.
ms.topic: troubleshoot
ms.date: 05/29/2024
ms.reviewer: abha
ms.author: abha
#Customer intent: As an Azure Kubernetes user, I want to troubleshoot the "failed to either reach kube-apiserver or control plane IP of Kubernetes cluster from Arc Resource Bridge IP error" error code so that I can successfully start or create and deploy an Azure Kubernetes Service Arc cluster.

---

# Troubleshoot the failed to either reach kube-apiserver or control plane IP of Kubernetes cluster from Arc Resource Bridge IP error

This article discusses how to identify and resolve the failed to either reach kube-apiserver or control plane IP of Kubernetes cluster from Arc Resource Bridge IP error that occurs when you try to create and deploy a Microsoft Azure Kubernetes Service Arc cluster.

## Symptoms

When you try to create an AKS cluster, you receive the following error message:

```output
Failed to either reach kube-apiserver or control plane IP %s:%d of Kubernetes cluster %s from Arc Resource Bridge IP %v. Read aka.ms/aks-arc-kubeapiserver-unreachable for more information.
```

## Possible causes and follow-ups

- Check whether the logical network you deployed the AKS cluster in is reachable from the management network. The management network is a [block of 6 IP addresses that were allocated during Azure stack HCI deployment.](/azure-stack/hci/deploy/deploy-via-portal#specify-network-settings).
- Check whether the `control plane IP` address of the AKS cluster is reachable from the management network. The control plane IP address can be found by running [`az aksarc show`](/cli/azure/aksarc?view=azure-cli-latest#az-aksarc-show) command.
- One possible reason for connectivity issues here is if the Arc Resource Bridge is in a different vlan than the logical network where you created the AKS cluster. If the Arc Resource Bridge is in a different vlan, ensure cross-vlan communication has been enabled.
- Another frequent issue is if you have a firewall that isolates the management network from logical networks. Ensure that you've opened the required ports so the management network can reach AKS Arc VMs. Review [network requirements](aks-hci-network-system-requirements#network-port--cross-vlan-requirements) for more information on required ports.
- Duplicate IPs and IP address collisions is another reason why the API server may be unreachable. Ensure that you've not used the IP addresses provided in the management network anywhere else. Likewise, ensure that the control plane IP provided during the AKS cluster creation operation isnt used anywhere else. 

## Contact Microsoft Support
If the problem persists, collect the following before [creating a support request](aks-troubleshoot#open-a-support-request). Collect [AKS cluster logs](get-on-demand-logs) before creating the support request.

## More information
- [Review known issues for AKS on Azure Stack HCI 23H2](aks-known-issues)
- [Review AKS on Azure Stack HCI 23H2 architecture](cluster-architecture)
- [Review networking pre-requisities for AKS on Azure Stack HCI 23H2](aks-hci-network-system-requirements)

