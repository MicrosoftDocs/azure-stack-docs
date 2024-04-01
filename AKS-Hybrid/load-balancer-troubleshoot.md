---
title: Troubleshooting Guide for MetalLB Load Balancer 
description: Provide common symptoms, cause and resolution when using load balancers in Arc Kubernetes
ms.topic: how-to
ms.date: 04/01/2024
author: upxinxin
ms.author: xinyichen
---

# Troubleshooting Guide for MetalLB Load Balancer 

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

## Symptoms 1: When you try to create load balanacer from portal, notification error code shows 403. 
- **Invalid user authentication**  

**Error Message**: `ipaddresspools.metallb.io is forbidden: User \"xx\" cannot create resource \"ipaddresspools\" in API group \"metallb.io\" in the namespace \"kube-system\"`  
**Cause**:  The arcnetworking extension components may be inaccidently changed.  
**Resolution**: Uninstall arcnetworking extension and reinstall it. 

:::image type="content" source="media/load-balancer-troubleshoot/uninstall-extension.png" alt-text="Screenshot showing arcnetworking extension uninstall on the portal." lightbox="media/load-balancer-troubleshoot/uninstall-extension.png":::

Navigate to Extension blade and click on **uninstall** button for arcnetworking extension. Then navigate to Networking blade and click on **Install** button.

- **Invalid IP range field**   

**Error Message 1**: `admission webhook "ipaddresspoolvalidationwebhook.metallb.io" denied the request: CIDR "100.72.19.130/32" in pool "xx" overlaps with already defined CIDR "100.72.19.130/31"`  
**Cause**: IP range of "100.72.19.130/32" overlaps with existing IP range of "100.72.19.130/31".  
**Resolution**: Use valid IP range and avoid IP address overlap.

**Error Message 2**: `admission webhook "ipaddresspoolvalidationwebhook.metallb.io" denied the request: parsing address pool xx: invalid CIDR "100.72.19.130" in pool "xx": invalid CIDR "100.72.19.130"`  
**Cause**: IP range field format is incorrect.  
**Resolution**: Fill in IP range with right format like "100.72.19.130/32" or "100.72.19.130-100.72.19.140".

## Symptoms 2: When you run `az extension add --name k8s-runtime` cli command, error message is like `The 'k8s-runtime' extension version 1.0.0b1 is not compatible with your current CLI core version 2.53.0`.
**Cause**: "k8s-runtime" extension requires a min of 2.55.0 CLI core.  
**Resolution**: Run `az upgrade`to uprage CLI version.

## Symptoms 3: When you try to run `kubectl get bgppeers -n kube-system` command inside the kubernetes cluster, error message is like `No resources found`.
**Cause**: Calico CRD of "bgppeers.crd.projectcalico.org" conflicts with MetalLB CRD of "bgppeers.metallb.io".  
**Resolution**: Try `kubectl get bgppeers.metallb.io -n kube-system` command.
