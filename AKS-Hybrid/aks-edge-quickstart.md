---
title: Quickstart for AKS Edge Essentials
description: Bring up an AKS Edge Essentials cluster and connect it to Arc. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 12/05/2022
ms.custom: template-how-to
---

# AKS Edge Essentials quickstart guide

This quickstart describes how to set up an Azure Kubernetes Service (AKS) Edge Essentials single-node K3S cluster.

## Prerequisites

- See the [system requirements](aks-edge-system-requirements.md).
- OS requirements: install Windows 10/11 IoT Enterprise/Enterprise/Pro on your machine and activate Windows. We recommend using the latest [client version 22H2 (OS build 19045)](/windows/release-health/release-information) or [Server 2022 (OS build 20348)](/windows/release-health/windows-server-release-info). You can [download a version of Windows 10 here](https://www.microsoft.com/software-download/windows10) or [Windows 11 here](https://www.microsoft.com/software-download/windows11).

## Step 1: Download script for easy deployment

Download the [AKSEdgeRemoteDeployment.ps1](https://raw.githubusercontent.com/Azure/AKS-Edge/main/tools/scripts/AksEdgeRemoteDeploy/AksEdgeRemoteDeploy.ps1) to a working folder.

### Configure deployment parameters

The deployment script has configuration set for single machine cluster with linux node. If you require a different configuration, you can modify these configuration settings. For the quickstart, this step is optional.

### Configure Azure parameters

For connecting your cluster to Azure Arc, you need to provide these parameters. If you skip these parameters, the Arc connection will be skipped, but the cluster will still be deployed.

In your working folder, open the `AKSEdgeRemoteDeployment.ps1` file and update the `$jsonContent` content with your own Azure specific information:

   | Attribute | Value type      |  Description |
   | :------------ |:-----------|:--------|
   |`Azure.ClusterName` | string | Provide a name for your cluster. By default, `hostname_cluster` is the name used. |
   |`Azure.Location` | string | The location of your resource group. Choose the location closest to your deployment. |
   |`Azure.SubscriptionName` | string | Your subscription Name. |
   |`Azure.SubscriptionId` | GUID | Your subscription ID. In the Azure portal, click on the subscription you're using and opy/paste the subscription ID string into the JSON. |
   |`Azure.ServicePrincipalName` | string | Azure Service Principal name. AKS Edge uses this service principal to connect your cluster to Arc. You can use an existing service principal or if you add a new name, the system creates one for you in the later step. |
   |`Azure.TenantId` | GUID | Your tenant ID. In the Azure portal, search Azure Active Directory, which should take you to the Default Directory page. From here, you can copy/paste the tenant ID string into the JSON. |
   |`Azure.ResourceGroupName` | string | The name of the Azure resource group to host your Azure resources for AKS Edge. You can use an existing resource group, or if you add a new name, the system creates one for you. |
   |`Azure.Auth.ServicePrincipalId` | GUID | The AppID of `Azure.ServicePrincipalName` to use as credentials. Leave this blank if you're creating a new service principal. |
   |`Azure.Auth.Password` | string | The password (in clear) for `Azure.ServicePrincipalName` to use as credentials. Leave this blank if you're creating a new service principal. |

See [AksEdgeAzureSetup](https://github.com/Azure/AKS-Edge/blob/main/tools/scripts/AksEdgeAzureSetup/README.md) to setup your Azure account and create the required service principal.

## Step 2: Deploy AKS Edge Essentials

In an elevated powershell prompt, run the `AKSEdgeRemoteDeployment.ps1` script.

```powershell
.\AKSEdgeRemoteDeployment.ps1
```

For installing K8s version, specify the `-UseK8s` flag

```powershell
.\AKSEdgeRemoteDeployment.ps1 -UseK8s
```

This script will do the following

- Download and install AKS Edge Essentials MSI.
- Install required Host OS features (`Install-AksEdgeHostFeatures`). The machine may reboot when Hyper-V is enabled and you'll need to restart the script again.
- Deploy a single machine cluster with internal switch (linux node only).
- Connect the host machine to Arc for Servers and the deployed cluster to Arc for Kubernetes.

## Step 3: Verify deployment

1. Confirm that the deployment was successful by running:

    ```powershell
    kubectl get nodes -o wide
    kubectl get pods -A -o wide
    ```

    The following image shows pods on a K3S cluster:

    ![Screenshot showing all pods running.](./media/aks-edge/all-pods-running.png)

2. You can view your cluster in the Azure portal if you navigate to your resource group:

   ![Screenshot showing the cluster in azure portal](media/aks-edge/cluster-in-az-portal.png)

3. On the left panel, select the **Namespaces** blade under **Kubernetes resources (preview)**:

   ![Screenshot of Kubernetes resources.](media/aks-edge/kubernetes-resources-preview.png)

4. To view your Kubernetes resources, you need a bearer token:

   ![Screenshot showing the bearer token required page.](media/aks-edge/bearer-token-required.png)

5. You can run `Get-AksEdgeManagedServiceToken` to retrieve your service token:

   ![Screenshot showing where to paste token in portal.](media/aks-edge/bearer-token-in-portal.png)

6. Now you can view resources on your cluster. The **Workloads** blade, shows the pods running on your cluster.

    ```powershell
    kubectl get pods --all-namespaces
    ```

    ![Screenshot showing all pods in Arc.](media/aks-edge/all-pods-in-arc.png)

You now have an Arc-connected AKS Edge Essentials K3S cluster with a Linux node. You can now explore deploying a sample application on this cluster.

## Next steps

- [Deploy your application](aks-edge-howto-deploy-app.md).
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
