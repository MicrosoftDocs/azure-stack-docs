---
title: Deploy metric server
description: Steps to deploy metric server
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/05/2022
ms.custom: template-how-to
---

# Metrics server on an AKS Edge Essentials cluster

The [metrics server](https://github.com/kubernetes-sigs/metrics-server) is a popular tool to inspect your containers' resource consumption. You can find the YAML file for the metrics server in the /Samples/Other
 folder in the [GitHub Repo](https://github.com/Azure/aks-edge-utils/)

## Deploy metrics server

### Step 1: Deploy the metrics server manifest

```powershell
kubectl apply -f metrics-server.yaml
```

Wait for the metrics server pods to reach **running** status. It might take a few minutes.

```powershell
kubectl get pods -A
```

![Screenshot of results showing metrics pod running.](media/aks-edge/metrics-pod-running.png)

#### Step 2: View your resource consumption

```powershell
kubectl top nodes
```

```powershell
kubectl top pods -A
```

![Screenshot of results showing metrics server installed.](media/aks-edge/metrics-server-installed.png)

If your metrics server fails to display, you may have run into an MTU issue in which the Linux VM's MTU doesn't match that of your network. This can happen on Azure VMs. Run `Invoke-AksIotLinuxVmCommand "sudo ip link set dev eth0 mtu 1300"`.

## Next steps

- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
