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

This quickstart describes how to set up an Azure Kubernetes Service (AKS) Edge Essentials single-machine K3S cluster.

## Prerequisites

- See the [system requirements](aks-edge-system-requirements.md). For this quickstart tutorial, ensure that you have a minimum of 4.5 GB RAM free, 4 vCPUs and 20 GB free disk space.
- OS requirements: install Windows 10/11 IoT Enterprise/Enterprise/Pro on your machine and activate Windows. We recommend using the latest [client version 22H2 (OS build 19045)](/windows/release-health/release-information) or [Server 2022 (OS build 20348)](/windows/release-health/windows-server-release-info). You can [download a version of Windows 10 here](https://www.microsoft.com/software-download/windows10) or [Windows 11 here](https://www.microsoft.com/software-download/windows11).
- See the [Microsoft Software License Terms](aks-edge-software-license-terms.md) terms as they apply to your use of the software. By using the `AksEdgeQuickStart` script, you accept the Microsoft Software License Terms and the `AcceptEULA` flag is set to `true` indicating acceptance of the license terms.

## Step 1: Download script for easy deployment

Download the [AksEdgeQuickStart.ps1 script](https://raw.githubusercontent.com/Azure/AKS-Edge/main/tools/scripts/AksEdgeQuickStart/AksEdgeQuickStart.ps1). To do so, right-click and choose **Save link as...** to a working folder. Depending on the policy setup on your machine, you may have to unblock the file before running.

```powershell
Unblock-File .\AksEdgeQuickStart.ps1
```

This script automates the following steps:

- Downloads the GitHub repo [`Azure/AKS-Edge`](https://github.com/Azure/AKS-Edge) to the current working folder.
- Uses the [`AksEdgeAzureSetup.ps1` script](https://github.com/Azure/AKS-Edge/blob/main/tools/scripts/AksEdgeAzureSetup/AksEdgeAzureSetup.ps1) to prompt the user to log in to the Azure portal using their Azure credentials and creates a service principal that is used to connect the cluster to Azure Arc.
- Invokes the `Start-AideWorkflow` function that performs the following tasks:
  - Downloads and installs the AKS Edge Essentials MSI.
  - Installs required host OS features (`Install-AksEdgeHostFeatures`). The machine may reboot when Hyper-V is enabled, and you must restart the script again.
  - Deploy a single machine cluster with internal switch (Linux node only).
- Invokes the `Connect-AideArc` function if the Azure parameters are provided. This function performs the following tasks:
  - Installs the Azure Connected Machine Agent and connects the host machine to Arc for Servers.
  - Connects the deployed cluster to Arc for connected Kubernetes.

### Get your Azure subscription parameters

For connecting your cluster to Azure Arc, you need to provide these parameters. If you skip these parameters, the Arc connection is skipped, but the cluster will be deployed.

   | Attribute | Value type      |  Description |
   | :------------ |:-----------|:--------|
   |`SubscriptionId` | GUID | Your subscription ID. In the Azure portal, select the subscription you're using and copy the subscription ID string. |
   |`TenantId` | GUID | Your tenant ID. In the Azure portal, search Azure Active Directory, which should take you to the Default Directory page. From here, you can copy the tenant ID string. |
   |`Location` | string | The location of your resource group. Choose the location closest to your deployment. See [Azure Arc by Region](/explore/global-infrastructure/products-by-region/?products=azure-arc) for the Locations supported by **Azure Arc enabled servers** and **Azure Arc enabled Kubernetes** services. Choose a region where both are supported. |

## Step 2: Deploy AKS Edge Essentials

In an elevated PowerShell prompt, run the `AksEdgeQuickStart.ps1` script.

```powershell
.\AksEdgeQuickStart.ps1 -SubscriptionId "<subscription-id>" -TenantId "<tenant-id>" -Location "<location>"
```

For installing K8s version, specify the `-UseK8s` flag

```powershell
.\AksEdgeQuickStart.ps1 -SubscriptionId "<subscription-id>" -TenantId "<tenant-id>" -Location "<location>" -UseK8s
```

The script installs AKS Edge Essentials and connects your cluster to Azure using Azure Arc.

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

3. On the left panel, select the **Namespaces** under **Kubernetes resources (preview)**:

   ![Screenshot of Kubernetes resources.](media/aks-edge/kubernetes-resources-preview.png)

4. To view your Kubernetes resources, you need a bearer token:

   ![Screenshot showing the bearer token required page.](media/aks-edge/bearer-token-required.png)

5. You can run `Get-AksEdgeManagedServiceToken` to retrieve your service token:

   ![Screenshot showing where to paste token in portal.](media/aks-edge/bearer-token-in-portal.png)

6. Now you can view resources on your cluster. The **Workloads** shows the pods running on your cluster.

    ```powershell
    kubectl get pods --all-namespaces
    ```

    ![Screenshot showing all pods in Arc.](media/aks-edge/all-pods-in-arc.png)

You now have an Arc-connected AKS Edge Essentials K3S cluster with a Linux node. You can now explore deploying a sample application on this cluster.

## Next steps

- [Deploy your application](aks-edge-howto-deploy-app.md).
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
