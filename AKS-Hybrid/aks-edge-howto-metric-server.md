---
title: Deploy metric server
description: Steps to deploy metric server.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 02/14/2023
ms.custom: template-how-to
---

# Metrics server on an AKS Edge Essentials cluster

The [metrics server](https://github.com/kubernetes-sigs/metrics-server) is a tool that inspects your containers' resource consumption. You can find the [YAML file](https://github.com/Azure/AKS-Edge/blob/main/samples/others/metrics-server.yamls) for the metrics server deployment in the `/Samples/Other` folder in the [GitHub repo](https://github.com/Azure/AKS-Edge/).

## Deploy metrics server

>[!NOTE]
> AKS Edge Essentials K8s does not support [Kubernetes TLS boostrapping](https://kubernetes.io/docs/reference/access-authn-authz/kubelet-tls-bootstrapping/). To deploy metrics server using K8s, ensure to use the `--kubelet-insecure-tls` in your deployment yaml. 

### Step 1: Deploy the metrics server manifest

```powershell
kubectl apply -f https://raw.githubusercontent.com/Azure/AKS-Edge/main/samples/others/metrics-server.yaml

Wait for the metrics server pods to reach **running** status. It might take a few minutes.

```powershell
kubectl get pods -A --watch
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

If your metrics server fails to display, you may have run into an MTU issue in which the Linux VM's MTU doesn't match that of your network. This can happen on Azure VMs. You may need to set your MTU parameter to 1300 in your AksEdgeConfig file.

 ```json
       "LinuxVm": {
           "CpuCount": 4,
           "MemoryInMB": 4096,
           "Mtu": 1300
       }
   ```

## Next steps

- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
