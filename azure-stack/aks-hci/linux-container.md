---
title: Deploy a Linux application in AKS on Azure Stack HCI
description: Learn how to deploy a multi-container application to your cluster using a custom image stored in Azure Container Registry.
author: abha
ms.topic: how-to
ms.date: 09/21/2020
ms.author: abha
ms.reviewer: 
---

# Run Linux applications in Azure Kubernetes Service on Azure Stack HCI

In this how-to guide, you run a multi-container application that includes a web front end and a Redis instance in your Azure Kubernetes Service on Azure Stack HCI cluster. You then see how to test and scale your application. 

This how-to guide assumes a basic understanding of Kubernetes concepts. For more information, see Kubernetes core concepts for Azure Kubernetes Service on Azure Stack HCI.

## Run the application

A Kubernetes manifest file defines a desired state for the cluster, such as what container images to run. In this quickstart, a manifest is used to create all objects needed to run the [Azure Vote application](https://github.com/Azure-Samples/azure-voting-app-redis). This manifest includes two Kubernetes deployments - one for the sample Azure Vote Python applications, and the other for a Redis instance. Two Kubernetes Services are also created - an internal service for the Redis instance, and an external service to access the Azure Vote application from the internet.

Create a file named `azure-vote.yaml` and copy in the following YAML definition.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: azure-vote-back
spec:
  replicas: 1
  selector:
    matchLabels:
      app: azure-vote-back
  template:
    metadata:
      labels:
        app: azure-vote-back
    spec:
      nodeSelector:
        "beta.kubernetes.io/os": linux
      containers:
      - name: azure-vote-back
        image: redis
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 250m
            memory: 256Mi
        ports:
        - containerPort: 6379
          name: redis
---
apiVersion: v1
kind: Service
metadata:
  name: azure-vote-back
spec:
  ports:
  - port: 6379
  selector:
    app: azure-vote-back
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: azure-vote-front
spec:
  replicas: 1
  selector:
    matchLabels:
      app: azure-vote-front
  template:
    metadata:
      labels:
        app: azure-vote-front
    spec:
      nodeSelector:
        "beta.kubernetes.io/os": linux
      containers:
      - name: azure-vote-front
        image: mcr.microsoft.com/azuredocs/azure-vote-front:v1
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 250m
            memory: 256Mi
        ports:
        - containerPort: 80
        env:
        - name: REDIS
          value: "azure-vote-back"
---
apiVersion: v1
kind: Service
metadata:
  name: azure-vote-front
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: azure-vote-front
```

Deploy the application using the `kubectl apply` command and specify the name of your YAML manifest:

```PowerShell
kubectl apply -f azure-vote.yaml
```

The following example output shows the Deployments and Services created successfully:

```output
deployment "azure-vote-back" created
service "azure-vote-back" created
deployment "azure-vote-front" created
service "azure-vote-front" created
```

## Test the application

When the application runs, a Kubernetes service exposes the application front end to the internet. This process can take a few minutes to complete.

To monitor progress, use the `kubectl get service` command with the `--watch` argument.

```PowerShell
kubectl get service azure-vote-front --watch
```

Initially the *EXTERNAL-IP* for the *azure-vote-front* service is shown as *pending*.

```output
NAME               TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
azure-vote-front   LoadBalancer   10.101.26.132   <pending>     80:32510/TCP   28m
```

When the *EXTERNAL-IP* address changes from *pending* to an actual public IP address, use `CTRL-C` to stop the `kubectl` watch process. The following example output shows a valid public IP address assigned to the service:

```output
NAME               TYPE           CLUSTER-IP   EXTERNAL-IP     PORT(S)        AGE
azure-vote-front   LoadBalancer   10.0.37.27   52.179.23.131   80:30572/TCP   2m
```

To see the Azure Vote app in action, open a web browser to the external IP address of your service.

## Scale application pods

We have created a single replica of the Azure Vote front-end and Redis instance. To see the number and state of pods in your cluster, use the `kubectl get` command as follows:

```console
kubectl get pods -n default
```

The following example output shows one front-end pod and one back-end pod:

```
NAME                                READY     STATUS    RESTARTS   AGE
azure-vote-back-6bdcb87f89-g2pqg    1/1       Running   0          25m
azure-vote-front-84c8bf64fc-cdq86   1/1       Running   0          25m
```

To change the number of pods in the *azure-vote-front* deployment, use the `kubectl scale` command. The following example increases the number of front-end pods to *5*:

```console
kubectl scale --replicas=5 deployment/azure-vote-front
```

Run `kubectl get pods` again to verify that additional pods have been created. After a minute or so, the additional pods are available in your cluster:

```console
kubectl get pods -n default

Name                                READY   STATUS    RESTARTS   AGE
azure-vote-back-6bdcb87f89-g2pqg    1/1     Running   0          31m
azure-vote-front-84c8bf64fc-cdq86   1/1     Running   0          31m
azure-vote-front-84c8bf64fc-56h64   1/1     Running   0          80s
azure-vote-front-84c8bf64fc-djkp8   1/1     Running   0          80s
azure-vote-front-84c8bf64fc-jmmvs   1/1     Running   0          80s
azure-vote-front-84c8bf64fc-znc6z   1/1     Running   0          80s
```

## Next steps

* [Use Azure Monitor to monitor your cluster and application](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-enable-arc-enabled-clusters)