---
title: AKS lite deployment options 
description: Deployment options and flow
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 11/07/2022
ms.custom: template-concept
---

<!--Remove all the comments in this template before you sign-off or merge to the 
main branch.
-->

<!--
This template provides the basic structure of a concept article.
See the [concept guidance](contribute-how-write-concept.md) in the contributor guide.

To provide feedback on this template contact 
[the templates workgroup](mailto:templateswg@microsoft.com).
-->

<!-- 1. H1
Required. Set expectations for what the content covers, so customers know the 
content meets their needs. Should NOT begin with a verb.
-->

# Deployment options
After you setup your machines, AKS lite can be deployed in the following options:
- Simple Deployment - Simple deployment is running Kubernetes nodes on a single machine to create a single machine cluster. 
- Full Deployment - Full deployment lets you create a multi-node Kubernetes cluster and also enables you to scale out to additional nodes as needed. 
![Conceptual diagram showing deployment options.](media/aks-lite/deployment-options.png)
Once you have created your cluster, you can deploy your applications and connect your cluster to Arc to enable Arc extensions like Azure Monitor and Azure Policy. You can also choose to use GitOps to manage your deployments. 


## Next steps

- Try out the [Quickstart](aks-lite-quickstart.md)
- [Setup your machine](./aks-lite-howto-setup-machine.md) 
