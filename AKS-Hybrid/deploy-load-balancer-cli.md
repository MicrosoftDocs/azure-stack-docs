---
title: Create a MetalLB load balancer using the Azure CLI
description: Learn how to create a MetalLB load balancer on your Kubernetes cluster using an Arc extension and Azure CLI.
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 04/02/2024
author: sethmanheim
ms.author: sethm
ms.reviewer: xinyuhe
ms.lastreviewed: 04/02/2024
---

# Create a MetalLB load balancer using Azure Arc and Azure CLI

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

The main purpose of a load balancer is to distribute traffic across multiple nodes in a Kubernetes cluster. This can help prevent downtime and improve overall performance of applications. AKS enabled by Azure Arc supports creating [MetalLB](https://metallb.universe.tf/) load balancer instance on your Kubernetes cluster using the `Arc Networking` k8s-extension.

## Prerequisites

- A Kubernetes cluster with at least one Linux node. You can create a Kubernetes cluster on Azure Stack HCI 23H2 using the [Azure CLI](aks-create-clusters-cli.md) or the [Azure portal](aks-create-clusters-portal.md).
- Make sure you have enough IP addresses for the load balancer. Ensure that the IP addresses reserved for the load balancer do not conflict with the IP addresses in Arc VM logical networks and control plane IPs. For more information about IP address planning and networking in Kubernetes, see [Networking requirements for AKS on Azure Stack HCI 23H2](aks-hci-network-system-requirements.md).
- This how-to guide assumes you understand how Metal LB works. For more information, see the [overview for MetalLB in Arc Kubernetes clusters](load-balancer-overview.md).

## Install the Azure CLI extension

Run the following command to install the necessary Azure CLI extension:

```azurecli
az extension add -n k8s-runtime --upgrade
```

## Enable load balancer Arc extension

Configure the following variables before proceeding:

| Parameter                      | Description             | 
| ----------------------------- | ------------------------ |
| `$subId`    | Azure subscription ID of your Kubernetes cluster. |
| `$rgName` | Azure resource group for your Kubernetes cluster. |
| `$clusterName` | The name of your AKS Arc cluster. |

Use the [`az k8s-runtime load-balancer enable`](/cli/azure/k8s-runtime/load-balancer#az-k8s-runtime-load-balancer-enable) command to install the Arc extension and register the resource provider for your Kubernetes cluster. The `--resource-uri` parameter refers to the resource manager ID of your AKS Arc cluster.

```azurecli
az k8s-runtime load-balancer enable --resource-uri subscriptions/$subId/resourceGroups/$rgName/providers/Microsoft.Kubernetes/connectedClusters/$clusterName
```

## Deploy MetalLB load balancer on your Kubernetes cluster

You can now create a load balancer for your Kubernetes cluster remotely by running the [`az k8s-runtime load-balancer create`](/cli/azure/k8s-runtime/load-balancer#az-k8s-runtime-load-balancer-create) command. This command creates a custom resource of kind `IPAddressPool` in namespace `kube-system`.

Configure the following variables before proceeding:

| Parameter                      | Description             | 
| ----------------------------- | ------------------------ |
| `$lbName`    | The name of your MetalLB load balancer instance. |
| `$advertiseMode` | The mode for your MetalLB load balancer. Supported values are `ARP`, `BGP`, or `Both`. |
| `$ipRange` | The IP range for the MetalLB load balancer in `ARP` or `Both` mode. |

If the advertise mode is `BGP` or `Both`, it also creates a custom resource of kind `BGPAdvertisement`. If the advertise mode is `ARP` or `Both`, it also creates a custom resource of type `L2Advertisement`:

```azurecli
az k8s-runtime load-balancer create --load-balancer-name $lbName --resource-uri subscriptions/$subId/resourceGroups/$rgName/providers/Microsoft.Kubernetes/connectedClusters/$clusterName --addresses $ipRange --advertise-mode $advertiseMode
```

## Create a BGP peer for your Kubernetes cluster

Create a BGP peer for your Kubernetes cluster remotely by running the [`az k8s-runtime bgp-peer create`](/cli/azure/k8s-runtime/bgp-peer#az-k8s-runtime-bgp-peer-create) command. Note that the BGP peer is effective for all load balancers that have `BGP` or `Both` advertise mode. Creating BGP peers is mandatory if you're using the MetalLB load balancer in `BGP` or `Both` mode.

Configure the following variables before proceeding:

| Parameter                      | Description             | 
| ----------------------------- | ------------------------ |
| `$peerName` | The name of your BGP peer. |
| `$myASN` | AS number to use for the local end of the session. |
| `$peerASN` | AS number to expect from the remote end of the session. |
| `$peerIP` | Address to dial when establishing the session. |

```azurecli
az k8s-runtime bgp-peer create --bgp-peer-name $peerName --resource-uri subscriptions/$subId/resourceGroups/$rgName/providers/Microsoft.Kubernetes/connectedClusters/$clusterName --my-asn $myASN --peer-asn $peerASN --peer-address $peerIP
```

## Next steps

-[Use GitOps Flux v2 Arc extension to deploy applications on your Kubernetes cluster](/azure/azure-arc/kubernetes/monitor-gitops-flux-2)
