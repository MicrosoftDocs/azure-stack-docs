---
title: Deploy a Windows application in AKS on Azure Stack HCI
description: Learn how to deploy a multi-container application to your cluster using a custom image stored in Azure Container Registry.
author: abha
ms.topic: how-to
ms.date: 09/21/2020
ms.author: abha
ms.reviewer: 
---

# Run Windows applications in Azure Kubernetes Service on Azure Stack HCI

In this how-to guide, you run an ASP.NET sample application in a Windows Server container to the cluster. You then see how to test and scale your application. 

This how-to guide assumes a basic understanding of Kubernetes concepts. For more information, see Kubernetes core concepts for Azure Kubernetes Service on Azure Stack HCI.

## Scheduling Windows Containers in Azure Kubernetes Service on Azure Stack HCI
If you have Linux only worker nodes or Windows only worker nodes, you may skip this section.

You have to ensure that OS-specific workloads land on the appropriate container host. If you have a mixed Linux and Windows worker nodes Kubernetes cluster, you may follow the best practices in your deployments as explained below and choose either “use nodeSelector” or “taints and tolerations”. 

### Using `nodeSelector` in your Azure Kubernetes Service on Azure Stack HCI cluster

All Kubernetes nodes today have the following default label:

```yaml
kubernetes.io/os = [Windows|linux]
```

The Kubernetes manifest file must define a `node selector` to ensure OS specific workloads land on the appropriate Windows or Linux container host.

### Using Taints and Tolerations in your Azure Kubernetes Service on Azure Stack HCI cluster

Sometimes, users have a large number of pre-existing deployments for Linux containers as well as an ecosystem of off-the-shelf configurations, such as community Helm charts and programmatic pod generation cases, such as  Operators. 

In these situations, you may be hesitant to make configuration changes by adding a `nodeSelector`. The alternative is to use `taints`. 

Windows Server nodes can be tainted with the following key-value pair

```yaml
node.kubernetes.io/os=Windowss:NoSchedule
```
The default Azure Kubernetes Service on Azure Stack HCI infrastructure services on Windows tolerate the above taint. We do not recommending using a different taint. 

Run `kubectl get` and identify your Windows server worker nodes.

```PowerShell
kubectl get nodes --all-namespaces -o=custom-columns=NAME:.metadata.name,OS:.status.nodeInfo.operatingSystem
```

The following example output shows the Deployments and Services created successfully:

```output
NAME                                     OS
my-aks-hci-cluster-control-plane-krx7j   linux
my-aks-hci-cluster-md-md-1-5h4bl         windows
my-aks-hci-cluster-md-md-1-5xlwz         windows
```

Taint all Windows server worker nodes using `kubectl taint node`

```PowerShell
kubectl taint node my-aks-hci-cluster-md-md-1-5h4bl node.kubernetes.io/os=Windows:NoSchedule
kubectl taint node my-aks-hci-cluster-md-md-1-5xlwz node.kubernetes.io/os=Windows:NoSchedule
```

For a Windows Pod to be scheduled on a Windows node, you need both a `nodeSelector` to choose Windows OS and the matching `toleration`.

```yaml
nodeSelector:
  kubernetes.io/os: Windows
```
```yaml
tolerations:
- effect: NoSchedule
  key: node.kubernetes.io/os
  operator: Equal
  value: Windows
```

## Run the application

A Kubernetes manifest file defines a desired state for the cluster, such as what container images to run. In this article, a manifest is used to create all objects needed to run the ASP.NET sample application in a Windows Server container. This manifest includes a Kubernetes deployment for the ASP.NET sample application and an external Kubernetes service to access the application from the internet.

The ASP.NET sample application is provided as part of the .NET Framework Samples and runs in a Windows Server container. Azure Kubernetes Service on Azure Stack HCI requires Windows Server containers to be based on images of *Windows Server 2019*. 

The Kubernetes manifest file must also define a [node selector][node-selector] to tell your AKS cluster to run your ASP.NET sample application's pod on a node that can run Windows Server containers.

Create a file named `sample.yaml` and copy in the following YAML definition. 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample
  labels:
    app: sample
spec:
  replicas: 1
  template:
    metadata:
      name: sample
      labels:
        app: sample
    spec:
      nodeSelector:
        "beta.kubernetes.io/os": windows
      containers:
      - name: sample
        image: mcr.microsoft.com/dotnet/framework/samples:aspnetapp
        resources:
          limits:
            cpu: 1
            memory: 800M
          requests:
            cpu: .1
            memory: 300M
        ports:
          - containerPort: 80
  selector:
    matchLabels:
      app: sample
---
apiVersion: v1
kind: Service
metadata:
  name: sample
spec:
  type: LoadBalancer
  ports:
  - protocol: TCP
    port: 80
  selector:
    app: sample
```

Deploy the application using the `kubectl apply` command and specify the name of your YAML manifest:

```console
kubectl apply -f sample.yaml
```

The following example output shows the Deployment and Service created successfully:

```output
deployment.apps/sample created
service/sample created
```

## Test the application

When the application runs, a Kubernetes service exposes the application front end to the internet. This process can take a few minutes to complete. Occasionally the service can take longer than a few minutes to provision. Allow up to 10 minutes in these cases.

To monitor progress, use the `kubectl get service` command with the `--watch` argument.

```PowerShell
kubectl get service sample --watch
```

Initially the *EXTERNAL-IP* for the *sample* service is shown as *pending*.

```output
NAME               TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
sample             LoadBalancer   10.0.37.27   <pending>     80:30572/TCP   6s
```

When the *EXTERNAL-IP* address changes from *pending* to an actual public IP address, use `CTRL-C` to stop the `kubectl` watch process. The following example output shows a valid public IP address assigned to the service:

```output
sample  LoadBalancer   10.0.37.27   52.179.23.131   80:30572/TCP   2m
```

To see the sample app in action, open a web browser to the external IP address of your service.

If you receive a connection timeout when trying to load the page then you should verify the sample app is ready with the following command [kubectl get pods --watch]. Sometimes the windows container will not be started by the time your external IP address is available.

## Using Persistent Storage for your Windows Application

A persistent volume represents a piece of storage that has been provisioned for use with Kubernetes pods. A persistent volume can be used by one or more pods and is meant for long term storage. It is independent of the pod or node lifecycle. 

In this section, you will see how to create a persistent volume and how to use this volume in your application. 

### Create a persistent volume claim

A Persistent Volume Claim (PVC) is used to automatically provision storage based on a storage class. Create a file named pvc-AKS-HCI-csi.yaml and copy in the following YAML definition. The claim requests a disk that is 10GB in size with ReadWriteOnce access. The default storage class is specified as the storage class (vhdx). 

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-AKS-HCI-csi
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

Create the volume by running the following command

```PowerShell
Kubectl create -f pvc-AKS-HCI-csi.yaml
```

### Use the persistent volume

Once the persistent volume claim has been created and the vhdx successfully provisioned, a pod can be created with access to the volume. 

Create a file named winwebserver.yaml and copy in the following YAML definition. Please add tolerations in the YAML below if you tainted your Windows nodes.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: win-webserver
  name: win-webserver
spec:
  replicas: 1
  selector:
    matchLabels:
      app: win-webserver
  template:
    metadata:
      labels:
        app: win-webserver
      name: win-webserver
    spec:
     containers:
      - name: windowswebserver
        image: mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
        ports: 
          - containerPort: 80   
        volumeMounts:
            - name: AKS-HCIscsi
              mountPath: "/mnt/AKS-HCIscsi"
     volumes:
        - name: AKS-HCIscsi
          persistentVolumeClaim:
            claimName:  pvc-AKS-HCI-csi
     nodeSelector:
      kubernetes.io/os: windows
```

`mountPath` is the path to mount a volume inside container. You will see a subdirectory “mnt” will be created in c:\ in container, as well as a subdirectory “AKS-HCIscsi” under “mnt”. 

5.	Create the pod by running the following command: 
Kubectl create -f winwebserver.yaml

6.	Make sure the pod’s status is running (it might take a few minutes until pod is in a running state, since pulling IIS image may take a while)
Kubectl get pods -o wide

7.	Once your pod is running, view pod status by running the following command:
kubectl.exe describe pod %podName%


## Next steps

* [Use Azure Monitor to monitor your cluster and application](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-enable-arc-enabled-clusters)