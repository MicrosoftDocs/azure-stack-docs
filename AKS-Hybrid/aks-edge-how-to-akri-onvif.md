---
title: Discover ONVIF cameras with Akri
description: Learn how to discover and stream video from your ONVIF cameras with Akri.
author: yujinkim-msft
ms.author: yujinkim
ms.topic: how-to
ms.date: 01/24/2023
ms.custom: template-how-to
---

# Discover ONVIF cameras with Akri

Akri is a Kubernetes resource interface that lets you easily expose heterogenous leaf devices (such as IP cameras and USB devices) as resources in a Kubernetes cluster, and it continually detects nodes that have access to these devices to schedule workloads based on them. Akri is a CNCF sandbox project made for the edge, handling the dynamic appearance and disappearance of leaf devices. It currently supports OPC UA, ONVIF and udev protocols, but you can also implement custom protocol handlers provided by the template. [Read more about Akri here](https://github.com/project-akri/akri-docs).

This article describes how you can discover ONVIF cameras that are connected to the same network as your AKS Edge Essentials cluster. ONVIF is an open industry standard for IP security devices, commonly used for video surveillance. [Read more about ONVIF profiles here](https://www.onvif.org/profiles-add-ons-specifications/). This demo helps you get started using Akri to discover IP cameras through the ONVIF protocol and use them via a video broker that enables you to consume the footage from the camera and display it in a web application.

[ ![Diagram that shows the flow of Akri ONVIF demo.](media/aks-edge/akri-onvif-demo-flow.svg) ](media/aks-edge/akri-onvif-demo-flow.svg#lightbox)

## Prerequisites

- A [full deployment](aks-edge-howto-multi-node-deployment.md) of AKS Edge Essentials with an external switch up and running.
- An ONVIF IP camera connected to the same network as your external switch cluster.
- Akri only works on Linux: use Linux nodes for this exercise.

## Run Akri

1. Open a PowerShell window as administrator. Akri depends on `critcl` to track pod information. To use it, the Akri agent must know where the container runtime socket lives. To specify this information, set a variable `$AKRI_HELM_CRICTL_CONFIGURATION` and add it to each Akri installation.

   If you're using K3s:
   
   ```powershell
   $AKRI_HELM_CRICTL_CONFIGURATION="--set kubernetesDistro=k3s"
   ```
   
   If you're using K8s:
   
   ```powershell
   $AKRI_HELM_CRICTL_CONFIGURATION="--set kubernetesDistro=k8s"
   ```
   
2. Add the Akri helm charts if you've haven't already:

    ```powershell
    helm repo add akri-helm-charts https://project-akri.github.io/akri/
    ```
    
    If you have already added Akri helm chart previously, update your repo for the latest build:
    
    ```powershell
    helm repo update akri
    ```

3. Install Akri using Helm. When installing Akri, specify that you want to deploy the ONVIF discovery handlers by setting the helm value `onvif.discovery.enabled=true`. Also, specify that you want to deploy the ONVIF video broker:  
    
   ```powershell
   helm install akri akri-helm-charts/akri `
    $AKRI_HELM_CRICTL_CONFIGURATION  `
    --set onvif.discovery.enabled=true `
    --set onvif.configuration.enabled=true `
    --set onvif.configuration.capacity=2 `
    --set onvif.configuration.brokerPod.image.repository='ghcr.io/project-akri/akri/onvif-video-broker' `
    --set onvif.configuration.brokerPod.image.tag='latest'
   ```
   
   Learn more about the [ONVIF configuration settings here](https://docs.akri.sh/discovery-handlers/onvif).

## Open the WS-Discovery port

In order for the AKS Edge Essentials cluster to discover your camera, open the port for WS-Discovery (Web Services Dynamic Discovery), which is a multicast discovery protocol that operates over TCP and UDP port `3072`. 

1. Run the following command to open port 3072 within the Linux node:

    ```powershell
    Invoke-AksEdgeNodeCommand -command "sudo iptables -A INPUT -p udp --sport 3702 -j ACCEPT"
    ```
    
2. Save the IP tables so that even if the node is stopped and restarted, the rules for opening port 3072 will be saved:

    ```powershell
    Invoke-AksEdgeNodeCommand -command "sudo iptables-save | sudo tee /etc/systemd/scripts/ip4save > /dev/null"
    ```

3. Verify that Akri can now discover your camera. You should see one Akri instance for your ONVIF camera:

    ```powershell
    kubectl get akrii
    ```
    
    [ ![Screenshot showing the Akri instance for the discovered ONVIF camera.](media/aks-edge/akri-onvif-instance-discovered.png) ](media/aks-edge/akri-onvif-instance-discovered.png#lightbox)

## Deploy video streaming web application

1. Open a blank YAML file and copy/paste the following contents into the file:

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: akri-video-streaming-app
    spec:
      replicas: 1
      selector:
          matchLabels:
          app: akri-video-streaming-app
      template:
        metadata:
          labels:
            app: akri-video-streaming-app
        spec:
          nodeSelector:
            "kubernetes.io/os": linux
          serviceAccountName: akri-video-streaming-app-sa
          containers:
          - name: akri-video-streaming-app
            image: ghcr.io/project-akri/akri/video-streaming-app:latest-dev
            imagePullPolicy: Always
            env:
            - name: CONFIGURATION_NAME
              value: akri-onvif
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: akri-video-streaming-app
      namespace: default
      labels:
        app: akri-video-streaming-app
    spec:
      selector:
        app: akri-video-streaming-app
      ports:
      - name: http
        port: 80
        targetPort: 5000
      type: NodePort
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: akri-video-streaming-app-sa
    ---
    kind: ClusterRole
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: akri-video-streaming-app-role
    rules:
    - apiGroups: [""]
      resources: ["services"]
      verbs: ["list"]
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: akri-video-streaming-app-binding
    roleRef:
      apiGroup: ""
      kind: ClusterRole
      name: akri-video-streaming-app-role
    subjects:
      - kind: ServiceAccount
        name: akri-video-streaming-app-sa
        namespace: default
    ```

2. Save the file as **akri-video-streaming-app.yaml**. 

3. In your PowerShell window, change the directory to the location of your **akri-video-straming-app.yaml** file and deploy it to your cluster:

    ```powershell
    kubectl apply -f akri-video-streaming-app.yaml
    ```
    
4. Make sure all your pods are up and running:

    [ ![Screenshot showing the Akri pods and video app pod is running.](media/aks-edge/akri-onvif-pods-running.png) ](media/aks-edge/akri-onvif-pods-running.png#lightbox)

5. Find your Linux node IP and the port of your web app service:

    ```powershell
    Get-AksEdgeNodeAddr
    ```
    
    ```powershell
    kubectl get svc
    ```

    [ ![Screenshot showing the node address and port of the web app service.](media/aks-edge/akri-web-app-address.png) ](media/aks-edge/akri-web-app-address.png#lightbox)

6. Now you can view the video footage by navigating to your web application, which is `<NODE IP>:<PORT OF SERVICE>`. 

    [ ![Screenshot showing livestream footage from IP camera being displayed on web application.](media/aks-edge/akri-video-streaming-app.png) ](media/aks-edge/akri-video-streaming-app.png#lightbox)

## Clean up

1. Delete the video streaming web application.

   ```powershell
    kubectl delete -f akri-video-streaming-app.yaml
    ```

2. Uninstall Akri from your cluster.

   ```powershell
    helm delete akri
   ```


## Next steps

[AKS Edge Essentials overview](aks-edge-overview.md)
