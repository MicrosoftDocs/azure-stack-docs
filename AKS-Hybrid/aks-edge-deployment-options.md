---
title: AKS Edge Essentials deployment options 
description: Deployment options and flow
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 12/05/2022
ms.custom: template-concept
---


# Deployment options

After you set up your machines, you can deploy AKS Edge Essentials in the following configurations:

- **Single machine Kubernetes**: Runs Kubernetes nodes on a single machine to create a single machine cluster. This deployment uses an internal network switch to enable communication across the nodes. This deployment supports only one Linux node and one Windows node, both running on a single machine.
- **Full Kubernetes**: Lets you create a multi-node Kubernetes cluster and also enables you to scale out to multiple machines as needed.

  :::image type="content" source="media/aks-edge/deployment-options.png" alt-text="Conceptual diagram showing deployment options." lightbox="media/aks-edge/deployment-options.png":::
  
Once you've created your cluster, you can deploy your applications and connect your cluster to Arc to enable Arc extensions such as Azure Monitor and Azure Policy. You can also choose to use GitOps to manage your deployments.

## Maximum supported hardware specifications

| Parameter | Permissible limit |
  | ---------- | --------- |
  | Maximum number of VMs per machine  | 1 Linux VM + 1 Windows VM (optional) |
  | Maximum number of vCPUs per machine  | 16 vCPUs |
  | Maximum number of machines per cluster | 15 machines |

## Feature support matrix

||Public preview   |Experimental|
|------------|-----------|--------|
|Kubernetes (K8S)|Version : 1.22.6|
|Kubernetes (K3S)|Version : 1.23.6|
|Network plugin | Calico on K8S <br> Flannel on K3S | Flannel on K8S <br> Calico on K3S|
|Configuration|SingleMachine Cluster (Internal Switch)<br>Full Kubernetes (External Switch)|
|Scaling to additional nodes| |Non-CAPI  on K8S and K3S|

## Next steps

- [Set up your machine](./aks-edge-howto-setup-machine.md)
