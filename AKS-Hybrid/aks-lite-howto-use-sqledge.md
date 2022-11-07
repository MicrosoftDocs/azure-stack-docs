---
title: SQL Edge on AKS IoT
description: Learn how to use SQL Edge on AKS IoT.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Azure SQL Edge on AKS lite

Azure SQL Edge is an optimized relational database engine geared for IoT deployments, providing capabilities to create a high-performance data storage and processing layer for IoT applications and solutions.

In this demo, you will learn to deploy an Azure SQL Edge container on your AKS-IoT cluster.

## Step 1: Create namespace and password

First, create a namespace by running the following PowerShell cmdlet:

```powershell
kubectl create namespace sqledge
```

Then, create a secret password. Replace `MyC0m9l&xP@ssw0rd` with your own password:

```powershell
kubectl create secret generic mssql --from-literal=SA_Password="MyC0m9l&xP@ssw0rd" -n sqledge
```

## Step 2: Deploy SQL Edge

In your admin PowerShell window, navigate to the path of the samples folder by entering. Then run:

```powershell
kubectl apply -f sqledge\ -n sqledge
```

This will do the following:

- Create a local storage (learn more about [creating local storage on your AKS-IoT cluster here](/docs/additionalconfigs.md)).
- Create a persistent volume and persistent volume claim (learn more about [PVs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolume) and [PVCs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolumeclaim)).
- Deploy SQL Edge.

![image](media/aks-lite/sqledge_pods.png)

## Step 3: Run SQL

We must also allow this to run as the root user. In order to do so, SSH into the SQL Edge pod. To get the pod name, run:

```powershell
kubectl get pods -n sqledge
```

Then copy the full pod name which looks something like: **sqledge-deployment-<pod id>**. Then run:

```powershell
kubectl exec -it <sqledge-deployment-pod> -n sqledge --bash
```

Once you're in the bash shell of the pod, run the following command, replacing `MyC0m9l&xP@ssw0rd` with the password you created earlier:

```bash
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "MyC0m9l&xP@ssw0rd"
```

Now you are ready to use SQL Edge. See the following resources to learn how to use Azure SQL Edge:

- [Azure SQL Edge: Deploy in Kubernetes](/azure/azure-sql-edge/deploy-kubernetes)
- [Create and query data with Azure SQL Edge](/azure/azure-sql-edge/disconnected-deployment#create-and-query-data)
- [Create a data streaming job in Azure SQL Edge](/azure/azure-sql-edge/create-stream-analytics-job)

## Step 4: Clean up deployments

Once you're finished with SQL Edge, go to PowerShell, navigate to the samples folder, and clean up your workspace by running:

```powershell
kubectl delete -f sqledge -n sqledge
kubectl delete namespace sqledge
```

Return to the [deployment guidance homepage](/docs/AKS-IoT-Deployment-Guidance.md) or the main [README](/README.md).

## Next steps

[Overview](aks-lite-overview.md)
[Uninstall AKS cluster](aks-lite-howto-uninstall.md)
