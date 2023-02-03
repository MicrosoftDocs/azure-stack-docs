---
title: AKS Edge Essentials deployment options 
description: Deployment options and flow
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 12/05/2022
ms.custom: template-concept
---


# AKS Edge Essentials Deployment options

After you set up your machines, you can deploy AKS Edge Essentials in the following configurations:

- **Single machine Kubernetes**: Runs Kubernetes nodes on a single machine to create a single machine cluster. This deployment uses an internal network switch to enable communication across the nodes. This deployment supports only one Linux node and one Windows node, both running on a single machine.
- **Full Kubernetes**: Lets you create a multi-node Kubernetes cluster that can be scaled across multiple machines.
-
  :::image type="content" source="media/aks-edge/deployment-options.png" alt-text="Conceptual diagram showing deployment options." lightbox="media/aks-edge/deployment-options.png":::
  
Once you've created your cluster, you can deploy your applications and connect your cluster to Arc to enable Arc extensions such as Azure Monitor and Azure Policy. You can also choose to use GitOps to manage your deployments.

## Next steps

- [Set up your machine](./aks-edge-howto-setup-machine.md)
