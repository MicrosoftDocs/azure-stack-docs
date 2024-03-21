---
title: Known issues in AKS enabled by Azure Arc on VMware (preview)
description: Learn about known issues in AKS enabled by Arc on VMware.
ms.topic: how-to
author: sethmanheim
ms.date: 03/19/2024
ms.author: sethm 
ms.lastreviewed: 03/19/2024
ms.reviewer: leslielin

---

# Known issues in AKS enabled by Azure Arc on VMware

This article identifies important known issues and their workarounds in the AKS Arc on VMware preview. You can also review the troubleshooting guide [here](link to: troubleshoot) or follow the [troubleshooting overview](link to: troubleshooting overview) to report bugs or provide product feedback.

We continuously update this page. As we identify critical problems that require workarounds, we add them here. Review this information carefully before deploying AKS Arc on VMware.

| Known issue               | Root cause/issue description                                                                                                                | Workaround/comments                                                                                                        |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| VM size **Standard_A4_v2**  | The VM size **Standard_A4_v2** is currently deployed with incorrect specifications: 2 vCPU and 8 GB memory. It should be 4 vCPU and 8 GB memory.  | This issue doesn't affect the proper creation of the AKS cluster. We're aware of the problem and are working on a resolution.  |
 | Control Plane IP is in use | This error indicates that the control plane IP is in use, even though it may not be in use by any party. |  1. Before creating an AKS cluster, ping the control plane IP to check if it's already in use. 2. If the system returns an error stating "control plane IP is in use" and it's actually not currently in use, try creating an AKS cluster using a different control plane IP.  |


## Next steps

- [Troubleshooting overview](aks-vmware-troubleshoot.md)
- [AKS on VMware overview](aks-vmware-overview.md)
- [System requirements](aks-vmware-system-requirements.md)
