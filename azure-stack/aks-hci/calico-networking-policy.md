---
title: How to - How to use Calico network policy
description: Learn about network policy in Azure Kubernetes Service (AKS) on Azure Stack HCI.
ms.topic: conceptual
ms.date: 03/03/2021
ms.custom: fasttrack-edit
ms.author: mikek
author: mkostersitz
---

# Use Calico network policy

This step-by-step guide can be used to verify and try out basic pod-to-pod connectivity and the application of network policy in a cluster using Calico network policies.
We will create client and server pods on Linux and Windows nodes, verify connectivity between the pods, and then we’ll apply a basic network policy to isolate pod traffic.

## Prerequisites

To use this guide, you will need an AKS on Azure Stack HCI cluster deployed with Windows worker nodes.
Follow the steps in [Installing AKS on Azure Stack HCI](setup-powershell.md) to deploy AKS on Azure Stack HCI.

## Create pods on Linux nodes

First, create a client (busybox) and server (nginx) pod on the Linux nodes:

```yaml
kubectl apply -f - <<EOF
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
EOF
```

## Create pods on Window nodes

Next, we’ll create a client (pwsh) and server (porter) pod on the Windows nodes. First create the PowerShell pod using `kubectl`.

>[!Note]
>The pwsh and porter pod manifests below use images based on mcr.microsoft.com/windows/servercore:1809. If you are using a more recent Windows Server version, update the manifests to use a servercore image that matches your Windows Server version.

```bash
kubectl apply -f - <<EOF
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
EOF
```

Next, you will create the porter server pod:

```bash
kubectl apply -f - <<EOF
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
EOF
```

### Check connectivity between pods on Linux and Windows nodes

Now that client and server pods are running on both Linux and Windows nodes, let’s verify that client pods on Linux nodes can reach server pods on Windows nodes.
 
1.Find the porter pod IP address:

```powershell
kubectl get po porter -n calico-demo -o 'jsonpath={.status.podIP}'
```

2. Log into the busybox pod and try reaching the porter pod on port 80:

```powershell
kubectl exec -n calico-demo busybox -- nc -vz <porter_ip> 80
```

>[!Note]
>You can also combine both of the above steps:

```powershell
kubectl exec -n calico-demo busybox -- nc -vz $(kubectl get po porter -n calico-demo -o 'jsonpath={.status.podIP}') 80
```

If the connection from the busybox pod to the porter pod succeeds, you will get output similar to the following:

```powershell
192.168.40.166 (192.168.40.166:80) open
```

3. Now you can verify that the pwsh pod can reach the nginx pod:

```powershell
kubectl exec -n calico-demo pwsh -- powershell Invoke-WebRequest -Uri http://$(kubectl get po nginx -n calico-demo -o 'jsonpath={.status.podIP}') -UseBasicParsing -TimeoutSec 5
```

If the connection succeeds, you will see output similar to:

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

4. Verify that the pwsh pod can reach the porter pod:

```powershell
kubectl exec -n calico-demo pwsh -- powershell Invoke-WebRequest -Uri http://$(kubectl get po porter -n calico-demo -o 'jsonpath={.status.podIP}') -UseBasicParsing -TimeoutSec 5
```

If that succeeds, you will see something like:

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

### Conclusion

You have now verified that communication is possible between all pods in the application.

## Apply policy to the Windows client pod

In a real world deployment you would want to make sure only pods that are supposed to communicate with each other, are actually allowed to do so.

To achieve this you wil apply a basic network policy which allows only the busybox pod to reach the porter pod.

>[!Note]
>`calicoctl` is the command line utility used for managing Calico policies.

```powershell
calicoctl apply -f - <<EOF
apiVersion: projectcalico.org/v3
kind: NetworkPolicy
metadata:
name: allow-busybox
namespace: calico-demo
spec:
selector: app == 'porter'
types:
- Ingress
ingress:
- action: Allow
    protocol: TCP
    source:
    selector: app == 'busybox'
EOF
```

With the policy in place, the busybox pod should still be able to reach the porter pod:

```powershell
kubectl exec -n calico-demo busybox -- nc -vz $(kubectl get po porter -n calico-demo -o 'jsonpath={.status.podIP}') 80
```

However, the pwsh pod will not able to reach the porter pod:

```powershell
kubectl exec -n calico-demo pwsh -- powershell Invoke-WebRequest -Uri http://$(kubectl get po porter -n calico-demo -o 'jsonpath={.status.podIP}') -UseBasicParsing -TimeoutSec 5
```

The request times out with a message like:

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

## Wrap up

In this demo we’ve brought up pods on Linux and Windows nodes, verified basic pod connectivity, and tried a basic network policy to isolate pod to pod traffic. Finally, we can clean up all of our demo resources:

```powershell
kubectl delete ns calico-demo
```