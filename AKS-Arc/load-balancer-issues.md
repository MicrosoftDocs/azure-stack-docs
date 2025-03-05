---
title: Intermittent connectivity issues with MetalLB or Kubernetes services of type Load Balancer
description: Learn how to mitigate connection issues with MetalLB or Kubernetes services of type Load Balancer.
author: sethmanheim
ms.author: sethm
ms.topic: troubleshooting
ms.date: 02/26/2025

---

# Intermittent connectivity issues with MetalLB or Kubernetes services of type Load Balancer

You might sometimes experience intermittent connectivity issues when accessing a Kubernetes service of type **LoadBalancer** using the assigned external IP address. This article describes how to identify and resolve connection issues with MetalLB or Kubernetes services of type **LoadBalancer**.

## Symptoms

- The service is accessible sometimes, but not consistently.
- The client experiences unexpected disconnects.
- The external IP intermittently appears and disappears from the control plane when running `Get-VMNetworkAdapter`:

  ```powershell
  Get-VMNetworkAdapter -VMName * | select name, ipaddresses 

  ...

  # The external IP appears in the get-vmnetworkadapter output 

  nocpip26-55bc418a-control-plane-kjqcm-nic-b607b1e0                         
  {172.16.0.11, 172.16.0.10, ***172.16.100.0***, fe80::ec:d3ff:fe8b:1} 

  # Now it's gone 

  Get-VMNetworkAdapter -VMName * | select name, ipaddresses 

  ...

  nocpip26-55bc418a-control-plane-kjqcm-nic-b607b1e0                         
  {172.16.0.11, 172.16.0.10, ***Now it is gone*** fe80::ec:d3ff:fe8b:1} 

  # Now it's back 

  Get-VMNetworkAdapter -VMName * | select name, ipaddresses

  ... 

  nocpip26-55bc418a-control-plane-kjqcm-nic-b607b1e0                         
  {172.16.0.11, 172.16.0.10, ***172.16.100.0***, fe80::ec:d3ff:fe8b:1}
  ```

## Mitigation

This issue was fixed in [AKS on Azure Local, version 2411](aks-whats-new-23h2.md#release-2411).

If you're on an older build, please update to Azure Local, version 2411. Once you update to 2411, you can:

- Create a new AKS cluster. The new AKS cluster should not have any intermittent load balancer connectivity issues.
- [Upgrade the Kubernetes version](cluster-upgrade.md) of your existing AKS cluster to get the fix.

## Next steps

[Troubleshoot issues in AKS enabled by Azure Arc](aks-troubleshoot.md)
