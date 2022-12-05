---
title: AKS Edge Essentials deployment options 
description: Deployment options and flow
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 11/07/2022
ms.custom: template-concept
---


# Deployment options

After you set up your machines, AKS Edge Essentials can be deployed in the following options:

- **Single machine Kubernetes**: Runs Kubernetes nodes on a single machine to create a single machine cluster. This deployment uses an internal network switch to enable communication across the nodes. This deployment supports only one Linux node and one Windows node, both running on a single machine. 
- **Full Kubernetes**: Lets you create a multi-node Kubernetes cluster and also enables you to scale out to multiple machines as needed.

  ![Conceptual diagram showing deployment options.](media/aks-edge/deployment-options.png)
  
Once you've created your cluster, you can deploy your applications and connect your cluster to Arc to enable Arc extensions such as Azure Monitor and Azure Policy. You can also choose to use GitOps to manage your deployments.

## Next steps

- [Set up your machine](./aks-edge-howto-setup-machine.md)
