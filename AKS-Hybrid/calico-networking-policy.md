---
title: Use Calico network policy to secure pod traffic 
description: Learn how to use network policy to secure traffic between pods in Azure Kubernetes Service deployments in AKS enabled by Arc.
ms.topic: how-to
ms.date: 06/27/2024
ms.custom: fasttrack-edit, linux-related-content
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: mikek
author: sethmanheim

# Intent: As an IT Pro, I want to learn how to use Calico's network policies to secure traffic between pods in my AKS Azure Stack HCI deployment.
# Keyword: secure network traffic, Calico network
---

# Use Calico network policy to secure pod traffic

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

Use this how-to guide to verify and try out basic pod-to-pod connectivity and to use Calico network policies in a cluster in an AKS enabled by Arc deployment. This article describes how to create client and server pods on Linux and Windows nodes, verify connectivity between the pods, and then apply a basic network policy to isolate pod traffic in AKS Arc.

## Prerequisites

To deploy AKS Arc, follow the steps to [set up an AKS host](./kubernetes-walkthrough-powershell.md).

To use this guide, you need:

- An AKS workload cluster.
- At least one Windows worker node deployed in the cluster.
- At least one Linux worker node deployed in the cluster.
- The Calico network plug-in must be enabled when creating the workload cluster. If this plug-in wasn't enabled, see [`New-AksHciCluster`](./reference/ps/new-akshcicluster.md) for instructions.

## Create pods on Linux nodes

First, create a client pod, **busybox**, and server pod, **nginx**, on the Linux nodes.

### Create a YAML file called policy-demo-linux.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: calico-demo

---

apiVersion: v1
kind: Pod
metadata:
  labels:
    app: busybox
  name: busybox
  namespace: calico-demo
spec:
  containers:
  - args:
    - /bin/sh
    - -c
    - sleep 360000
    image: busybox:1.28
    imagePullPolicy: Always
    name: busybox
  nodeSelector:
    beta.kubernetes.io/os: linux

---

apiVersion: v1
kind: Pod
metadata:
  labels:
    app: nginx
  name: nginx
  namespace: calico-demo
spec:
  containers:
  - name: nginx
    image: nginx:1.8
    ports:
    - containerPort: 80
  nodeSelector:
    beta.kubernetes.io/os: linux

```

### Apply the policy-demo-linux.yaml file to the Kubernetes cluster

Open a PowerShell window, and load the credentials for your target cluster using the [`Get-AksHciCredential`](./reference/ps/get-akshcicredential.md) command.

Next, use `kubectl` to apply the `policy-demo-linux.yaml` configuration, as follows:

```powershell
kubectl apply -f policy-demo-linux.yaml
```

## Create pods on Windows nodes

Create a client pod `pwsh` and server pod `porter` on the Windows nodes.

> [!NOTE]
> The pod manifests use images based on `mcr.microsoft.com/windows/servercore:1809`. If you are using a more recent Windows Server version, update the manifests to use a Server Core image that matches your Windows Server version.

### Create the policy-demo-windows.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pwsh
  namespace: calico-demo
  labels:
    app: pwsh
spec:
  containers:
  - name: pwsh
    image: mcr.microsoft.com/windows/servercore:1809
    args:
    - powershell.exe
    - -Command
    - "Start-Sleep 360000"
    imagePullPolicy: IfNotPresent
  nodeSelector:
    kubernetes.io/os: windows
---
apiVersion: v1
kind: Pod
metadata:
  name: porter
  namespace: calico-demo
  labels:
    app: porter
spec:
  containers:
  - name: porter
    image: calico/porter:1809
    ports:
    - containerPort: 80
    env:
    - name: SERVE_PORT_80
      value: This is a Calico for Windows demo.
    imagePullPolicy: IfNotPresent
  nodeSelector:
    kubernetes.io/os: windows
```

### Apply the policy-demo-windows.yaml file to the Kubernetes cluster

Open a PowerShell window, and load the credentials for your target cluster using the [`Get-AksHciCredential`](./reference/ps/get-akshcicredential.md) command.

Next, use `kubectl` to apply the `policy-demo-windows.yaml` configuration:

```powershell
kubectl apply -f policy-demo-windows.yaml
```

### Verify the four pods are created and running

> [!NOTE]
> Depending on your network download speed, it can take time to launch the Windows pods.

Open a PowerShell window, and load the credentials for your target cluster using the [`Get-AksHciCredential`](./reference/ps/get-akshcicredential.md) command.

Next, use `kubectl` to list the pods in the `calico-demo` namespace:

```powershell
kubectl get pods --namespace calico-demo
```

You should see output similar to the following example:

```output
NAME      READY   STATUS              RESTARTS   AGE
busybox   1/1     Running             0          4m14s
nginx     1/1     Running             0          4m14s
porter    0/1     ContainerCreating   0          74s
pwsh      0/1     ContainerCreating   0          2m9s
```

Repeat the command every few minutes until the output shows all four pods in the Running state.

```output
NAME      READY   STATUS    RESTARTS   AGE
busybox   1/1     Running   0          7m24s
nginx     1/1     Running   0          7m24s
porter    1/1     Running   0          4m24s
pwsh      1/1     Running   0          5m19s
```

### Check connectivity between pods on Linux and Windows nodes

Now that the client and server pods are running on both Linux and Windows nodes, verify that client pods on Linux nodes can reach server pods on Windows nodes.

1. Open a PowerShell window, and load the credentials for your target cluster using the [`Get-AksHciCredential`](./reference/ps/get-akshcicredential.md) command.

1. Use `kubectl` to determine the porter pod IP address:

    ```powershell
    kubectl get pod porter --namespace calico-demo -o 'jsonpath={.status.podIP}'
    ```

1. Sign in to the **busybox** pod and try to reach the **porter** pod on port 80. Replace the '<porter_ip>' tag with the IP address returned from the previous command:

    ```powershell
    kubectl exec --namespace calico-demo busybox -- nc -vz <porter_ip> 80
    ```

   You can also combine both of the previous steps:

    ```powershell
    kubectl exec --namespace calico-demo busybox -- nc -vz $(kubectl get pod porter --namespace calico-demo -o 'jsonpath={.status.podIP}') 80
    ```

   If the connection from the **busybox** pod to the **porter** pod succeeds, you get output similar to the following example:

    ```output
    192.168.40.166 (192.168.40.166:80) open
    ```

   > [!NOTE]
   > The IP addresses returned can vary depending on your environment setup.

1. Verify that the **pwsh** pod can reach the **nginx** pod:

    ```powershell
    kubectl exec --namespace calico-demo pwsh -- powershell Invoke-WebRequest -Uri http://$(kubectl get po nginx -n calico-demo -o 'jsonpath={.status.podIP}') -UseBasicParsing -TimeoutSec 5
    ```

    If the connection succeeds, you see output similar to:

    ```output
    StatusCode        : 200
    StatusDescription : OK
    Content           : <!DOCTYPE html>
                        <html>
                        <head>
                        <title>Welcome to nginx!</title>
                        <style>
                            body {
                                width: 35em;
                                margin: 0 auto;
                                font-family: Tahoma, Verdana, Arial, sans-serif;
                            }
                        </style>
                        <...
    ```

1. Verify that the **pwsh** pod can reach the **porter** pod:

    ```powershell
    kubectl exec --namespace calico-demo pwsh -- powershell Invoke-WebRequest -Uri http://$(kubectl get po porter -n calico-demo -o 'jsonpath={.status.podIP}') -UseBasicParsing -TimeoutSec 5
    ```

    If that succeeds, you see output similar to the following example:

    ```output
    StatusCode        : 200
    StatusDescription : OK
    Content           : This is a Calico for Windows demo.
    RawContent        : HTTP/1.1 200 OK
                        Content-Length: 49
                        Content-Type: text/plain; charset=utf-8
                        Date: Fri, 21 Aug 2020 22:45:46 GMT
    
                        This is a Calico for Windows demo.
    Forms             :
    Headers           : {[Content-Length, 49], [Content-Type, text/plain;
                        charset=utf-8], [Date, Fri, 21 Aug 2020 22:45:46 GMT]}
    Images            : {}
    InputFields       : {}
    Links             : {}
    ParsedHtml        :
    RawContentLength  : 49

    ```

You have now verified that communication is possible between all pods in the application.

## Apply the policy to the Windows client pod

In a real-world deployment, you want to make sure that only pods that are supposed to communicate with each other are allowed to do so. To achieve this, you apply a basic network policy that allows only the **busybox** pod to reach the **porter** pod.

### Create the network-policy.yaml file

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-busybox
  namespace: calico-demo
spec:
  podSelector:
    matchLabels:
      app: porter
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: busybox
    ports:
    - protocol: TCP
      port: 80
```

### Apply the network-policy.yaml file

1. Open a PowerShell window.
1. Load the credentials for your target cluster using the [`Get-AksHciCredential`](./reference/ps/get-akshcicredential.md) command.
1. Use `kubectl` to apply the network-policy.yaml file:

   ```powershell
   kubectl apply -f network-policy.yaml
   ```

### Verify the policy is in effect

With the policy in place, the **busybox** pod should still be able to reach the **porter** pod. As noted previously, you can combine the steps in the command line:

```powershell
kubectl exec --namespace calico-demo busybox -- nc -vz $(kubectl get po porter -n calico-demo -o 'jsonpath={.status.podIP}') 80
```

However, the **pwsh** pod can't reach the **porter** pod:

```powershell
kubectl exec --namespace calico-demo pwsh -- powershell Invoke-WebRequest -Uri http://$(kubectl get po porter -n calico-demo -o 'jsonpath={.status.podIP}') -UseBasicParsing -TimeoutSec 5
```

The request times out with a message similar to this one:

```output
Invoke-WebRequest : The operation has timed out.
At line:1 char:1
+ Invoke-WebRequest -Uri http://192.168.40.166 -UseBasicParsing -Timeout ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:Htt
pWebRequest) [Invoke-WebRequest], WebException
    + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeWebRequestCommand
command terminated with exit code 1
```

In this demo, we configured pods on Linux and Windows nodes, verified basic pod connectivity, and tried a basic network policy to isolate pod-to-pod traffic.

As the final step, you can clean up all of the demo resources:

```powershell
kubectl delete namespace calico-demo
```

## Next steps

In this article, you learned how to secure traffic between pods using network policies. Next, you can:

- [Deploy a Linux application on a Kubernetes cluster](./deploy-linux-application.md)
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md)
