---
title: Using Custom Storage Classes in AKS to Consume External Storage (SAN) on Azure Local
description: Describes how to enable leverage external storage for containerized workloads on Azure Local.
author: ronmiab
ms.author: robess
ms.reviewer: ronmiab
ms.topic: how-to
ms.date: 03/27/2026
ms.subservice: hyperconverged
---
# Using Custom Storage Classes in AKS to Consume External Storage (SAN) on Azure Local

## Overview
This document provides step-by-step instructions for configuring an AKS cluster on Azure Local to consume external Storage Area Network (SAN) resources through custom Kubernetes Storage Classes and Persistent Volumes. The underlying mechanism is the Container Storage Interface (CSI), which allows Kubernetes to interact with a wide range of storage back-ends in a standardized way. By defining a custom StorageClass that maps to your SAN provisioner, workloads can dynamically request and bind persistent storage without manual administrator intervention for each volume.

## Prerequisites
- An Azure Local cluster deployed and registered in Azure.
- Azure CLI installed with the aksarc and connectedk8s extensions.
- A custom location configured for the Azure Local cluster.
- A logical network (vnet) created for the AKS cluster.
- A Microsoft Entra group with cluster administrator access.
- Access to external SAN storage (e.g., NetApp, Pure Storage, Hitachi) provisioned and accessible from the Azure Local cluster nodes.
- kubectl installed locally.

## Step 1: Create an AKS Cluster

### Option A: Azure Portal
- Navigate to your Azure Local cluster in the Azure portal.
- In the left menu, click Resources → Kubernetes clusters.
- Click Create Kubernetes cluster.
- Specify a cluster name, select the custom location for the Azure Local cluster, and fill in the remaining fields.
- Proceed through the wizard and click Create.

### Option B: Azure CLI
Install the necessary Azure CLI extensions before running the command below. Sign in to Azure and set your target subscription, then run:

```bash
az aksarc create \
  -n $aksclustername \
  -g $resource_group \
  --custom-location $customlocationID \
  --vnet-ids $logicnetId \
  --aad-admin-group-object-ids $aadgroupID \
  --generate-ssh-keys
```

## Step 2: Connect to the Kubernetes Cluster
Connect to the newly created cluster by running the az connectedk8s proxy command in a terminal window. This establishes a local proxy to the Arc-connected cluster. Then open a new PowerShell window pointed to the same working folder.

For all subsequent kubectl commands that operate on the cluster, you may need to explicitly specify the Kubernetes config file by appending the following flag:

```bash
--kubeconfig .\aks-arc-kube-config
```

## Step 3: Create a Custom Storage Class for Disks
A custom StorageClass is how Kubernetes maps a storage request to a specific SAN-backed disk type available on Azure Local. The StorageClass definition specifies the CSI provisioner, reclaim policy, binding mode, and any SAN-specific parameters required by your storage vendor's CSI driver.

Follow the Microsoft Learn documentation to create a custom storage class for disks:
Use Container Storage Interface (CSI) disk drivers in AKS enabled by Azure Arc - AKS enabled by Azure Arc | Microsoft Learn

Alternatively, use the Azure portal: navigate to the AKS cluster page, then click Kubernetes resources → Storage. From this page you can create and manage Storage Classes, Persistent Volume Claims, and Persistent Volumes.

## Step 4: Create a Persistent Volume Claim (PVC)
Once the StorageClass is created, define a Persistent Volume Claim (PVC) to request a Persistent Volume that is bound to your SAN storage resource. The example below requests a 1 GiB volume using your custom storage class:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: aks-hci-vhdx
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: <your custom storage class name>
  resources:
    requests:
      storage: 1Gi
```

## Step 5: Use the Persistent Volume in a Pod
Reference the PVC in your pod definition using a volumeMount. The example below deploys an nginx container that mounts the SAN-backed volume at /mnt/aks-hci, where the application can read and write data:

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: nginx
spec:
  containers:
    - name: myfrontend
      image: mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
      volumeMounts:
      - mountPath: "/mnt/aks-hci"
        name: volume
  volumes:
    - name: volume
      persistentVolumeClaim:
        claimName: aks-hci-vhdx
```

## Step 6: Deploy a Sample Application with Persistent Volumes
The following complete manifest deploys the Azure Vote application, consisting of a Redis back-end and a web front-end. Both components mount SAN-backed persistent volumes, demonstrating end-to-end integration with external storage on Azure Local.

>[!NOTE]
> Before applying this manifest, ensure that PVCs aks-hci-vhdx-1 and aks-hci-vhdx-2 have already been created using your custom storage class (as described in Step 4).

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
        "kubernetes.io/os": linux
      containers:
      - name: azure-vote-back
        image: mcr.microsoft.com/oss/bitnami/redis:6.0.8
        env:
        - name: ALLOW_EMPTY_PASSWORD
          value: "yes"
        ports:
        - containerPort: 6379
          name: redis
        volumeMounts:
        - mountPath: "/mnt/aks-hci"
          name: volume1
      volumes:
        - name: volume1
          persistentVolumeClaim:
            claimName: aks-hci-vhdx-1
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
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 5
  template:
    metadata:
      labels:
        app: azure-vote-front
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
      containers:
      - name: azure-vote-front
        image: lgmorand/azure-vote-front:v1
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 250m
          limits:
            cpu: 500m
        env:
        - name: REDIS
          value: "azure-vote-back"
        volumeMounts:
        - mountPath: "/mnt/aks-hci"
          name: volume2
      volumes:
        - name: volume2
          persistentVolumeClaim:
            claimName: aks-hci-vhdx-2
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