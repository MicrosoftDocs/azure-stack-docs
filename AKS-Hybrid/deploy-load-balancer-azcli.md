---
title: Create a MetalLB load balancer using AZ CLI
description: Learn how to create a MetalLB load balancer on your Kubernetes cluster using an Arc extension.
ms.topic: how-to
ms.date: 03/20/2024
author: HE-Xinyu
ms.author: xinyuhe 
---

# Create a MetalLB load balancer using Azure Arc

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

The main purpose of a load balancer is to distribute traffic across multiple nodes in a Kubernetes cluster. This can help prevent downtime and improve overall performance of applications. AKS enabled by Azure Arc supports creating [MetalLB](https://metallb.universe.tf/) load balancer instance on your Kubernetes cluster using the Arc Networking extension.

## Prerequisites

- A Kubernetes cluster with at least one Linux node. You can create a Kubernetes cluster on AKS using the [Azure CLI](aks-create-clusters-cli.md) or the Azure portal.
- Make sure you have enough IP addresses for the load balancer. Ensure that the IP addresses reserved for the load balancer do not conflict with the IP addresses in Arc VM logical networks and control plane IPs. For more information about IP address planning and networking in Kubernetes, see [Networking requirements for AKS on Azure Stack HCI 23H2](aks-hci-network-system-requirements.md).

## Install the Azure CLI extension

Run the following command to install the necessary Azure CLI extension:

```azurecli
az extension add -n k8s-runtime --upgrade
```

## Enable load balancer service

Use the `az k8s-runtime load-balancer enable` command to install an Arc extension and register the resource provider for the target cluster.

```azurecli
az k8s-runtime load-balancer enable --resource-uri subscriptions/$subId/resourceGroups/$rgName/providers/Microsoft.Kubernetes/connectedClusters/$clusterName
```

## Create a load balancer

Now you can create load balancers for your AKS Arc clusters remotely by running the `az k8s-runtime load-balancer create` command. This command creates a custom resource of kind `IPAddressPool` in namespace `kube-system`.

If the advertise mode is `ARP` or `Both`, it also creates a custom resource of kind `L2Advertisement`. If the advertise mode is `BGP` or `Both`, it also creates a custom resource of kind `BGPAdvertisement`.

```azurecli
az k8s-runtime load-balancer create --load-balancer-name $lbName --resource-uri subscriptions/$subId/resourceGroups/$rgName/providers/Microsoft.Kubernetes/connectedClusters/$clusterName --addresses $ipRange --advertise-mode $advertiseMode
```

## (Optional) Create a BGP peer

BGP peer is effective for all load balancers that have `BGP` or `Both` advertise mode.
  
```azurecli
az k8s-runtime bgp-peer create --bgp-peer-name $peerName --resource-uri subscriptions/$subId/resourceGroups/$rgName/providers/Microsoft.Kubernetes/connectedClusters/$clusterName --my-asn $myASN --peer-asn $peerASN --peer-address $peerIP
```