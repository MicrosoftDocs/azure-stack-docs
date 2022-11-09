---
title: Deploy a sample AKS on Windows application
description: Learn how to deploy a sample Linux containerized application on AKS on Windows.
author: rcheeran
ms.author: rcheeran
ms.topic: quickstart
ms.date: 11/07/2022
ms.custom: template-quickstart #Required; leave this attribute/value as-is.
---

# Quickstart: deploy a sample AKS on Windows application

In this quickstart, you'll learn how to set up an Azure Kubernetes Service (AKS) host. You create an AKS single node cluster on a single machine, and deploy a sample containerized Linux application on this cluster.

## Prerequisites

- **Hardware requirements**:

    > [!IMPORTANT]
    > The minimum setup required to run the latest version of AKS is a single machine with the following specs:
    
    | Specs | Requirement |
    | ---------- | --------- |
    | Memory | 4GB at least 2GB free (cluster-only), 8GB (Arc and GitOps) |
    | CPU | 2 logical processors, clock speed at least 1.8 GHz |
    | Disk Space | At least 14 GB free |
    | Host OS | Windows 10/11 IoT Enterprise/Enterprise/Pro/Server |
    
    This is your primary machine.

- **OS requirements** : Install Windows 10/11 IoT Enterprise/Enterprise/Pro/Server on your machine and activate Windows. We recommend using the latest [version 21H2 (OS build 19044)](/windows/release-health/release-information). You can [download a version of Windows 10 here](https://www.microsoft.com/software-download/windows10) or Windows 11 [here](https://www.microsoft.com/software-download/windows11).

## Set up your primary machine

1. On your primary machine, navigate to the [GitHub releases](https://github.com/Azure/AKS-IoT-preview/releases) to download the **AksIot-k3s(.msi)** or **AksIot-k8s(.msi)** file, depending on which Kubernetes distribution you want to use.

 ![Screenshot of release assets needed.](media/aks-lite/aks-lite-release-assets.png)

2. In the upper left-hand corner of the releases page, navigate to the **Code** tab, and select the green **Code** button to download the repository as a **.zip** file.  

3. Extract the GitHub **.zip** file and move the MSI and all the other files in to the extracted folder. This will be your working directory.

4. Before you install, make sure you have removed any existing AKS-IoT clusters and have uninstalled any previous versions of AKS-IoT. If you have uninstalled a previous version of AKS-IoT, please reboot your system before proceeding.

    ![Screenshot of Add and remove program.](media/aks-lite/aks-lite-uninstall.png)

> [!NOTE]
> This release supports both k8s and k3s. We have provided two separate MSI installers for each Kubernetes distribution. Do not install both k8s and k3s at the same time. If you want to install a different Kubernetes distribution, uninstall the existing one first (i.e. if you have k3s installed, uninstall before installing k8s, and vice-versa).

5. Double-click the **AksIot-<k8s** or **k3s>.msi** files to install the latest version.

6. Once installation is complete, go to your working directory and in the **bootstrap** folder, you will find **LaunchPrompt.cmd**. Open this command window to make sure you have downloaded the proper modules for AKS-IoT.

7. Make sure your install was successful by running the following command:

    ```powershell
    Get-Command -Module AksIot
    ```

    You should see the output below with version showing v0.4.222.

    ![Screenshot of AKS lite module cmdlets.](media/aks-lite/aks-lite-modules-installed.png)

    See the [AKS-IoT PowerShell cmdlets](./reference/aks-lite-ps/index.md) for a full list of supported commands.

## Create a single-node Kubernetes cluster

Create a Kubernetes node(s) on your machine on a private network, making it easy to get a single machine cluster up and running.

1. Open an elevated PowerShell window or open **LaunchPrompt.cmd** from your **bootstrap** folder.

2. This quickstart uses the `New-AksIotDeployment` cmdlet, with default parameters.

   ```powershell
   New-AksIotDeployment -SingleMachineCluster
   ```

   To get a full list of the parameters and their default values, run `Get-Help New-AksIotDeployment -full` in your LaunchPrompt.

   > [!NOTE]
   > In this release, `New-AksIotDeployment` automatically gets the kube config file and overrides the old one.

3. Confirm that the installation was successful by running:

   ```powershell
   kubectl get nodes -o wide
   kubectl get pods -A -o wide
   ```

   ![Screenshot of all pods running. ](media/aks-lite/all-pods-running.png)

## Deploy a sample application

This example runs a sample Linux application based on [Microsoft's azure-vote-front image](https://github.com/microsoft/containerregistry). See the **linux-sample.yaml** file in the downloaded package for the deployment manifest. Note that the YAML specifies a `nodeSelector` tagged for Linux. All sample code and the deployment manifest can be found under the **Samples** folder.

1. Deploy the application using the YAML manifest:

   ```bash
   kubectl apply -f linux-sample.yaml
   ```

 2. Verify that sample pods are running. Wait a few minutes for the pods to be in the **running** state:

   ```bash
   kubectl get pods -o wide
   ```

   ![Screenshot of linux pods running.](media/aks-lite/linux-pods-running.png)

3. Verify that your service is up

   > [!IMPORTANT]
   > This example deployed the Kubernetes cluster without specifying a `-ServiceIPRangeSize` parameter, so we have not allocated IPs for our workload services and you won't have an external IP address. In this case, find the IP address of your Linux VM (using the `Get-AksIotLinuxNodeAddr` cmdlet), then append the external port (for example, **192.168.1.12:31458**).

   ```bash
   kubectl get services
   ```

   ![Screenshot of Linux svc running.](media/aks-lite/linux-svc-running.png)

4. View your running Linux sample. To do so, open a web browser and navigate to the external IP of your application.

   ![Screenshot of linux app running.](media/aks-lite/linux-app-up.png)

## Clean up resources

1. Delete the sample application:

   ```bash
   kubectl delete -f linux-sample.yaml
   ```

2. To remove your single machine cluster, run:

   ```powershell
   Remove-AksIotNode
   ```

> [!NOTE]
> If your single machine cluster doesn't clean up properly, run `hnsdiag list networks`, then delete any existing AKS-IoT network objects using `hnsdiag delete networks <ID>`.

