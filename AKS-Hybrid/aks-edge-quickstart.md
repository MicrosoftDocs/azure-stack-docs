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

## Step 1: Download scripts for easy deployment

Microsoft provides a few samples and tools, which you can download from the [AKS Edge Essentials GitHub repo](https://github.com/Azure/AKS-Edge). Navigate to the **Code** tab and click the **Download Zip** button to download the repository as a **.zip** file. Extract the GitHub **.zip** file to a working folder.

## Step 2: Configure deployment parameters

In your working folder, open the [aide-userconfig.json](https://github.com/Azure/AKS-Edge/blob/main/tools/aide-userconfig.json) file and provide the following information:

   | Attribute | Type / Values |  Description |
   | :------------ |:-----------|:--------|
   |`AksEdgeProduct` | [`AKS Edge Essentials - K8s` / `AKS Edge Essentials - K3s` ]| Specify the desired product K3s or K8s.|
   |`InstallOptions.InstallPath` | string | File path for the AKS Edge installation.|
   |`InstallOptions.VhdxPath` | string | File path for the vhdx files. |
   |`VSwitch.AdapterName` | string | Physical network adapter name, required only for `ScalableCluster`. You can get this using `Get-NetAdapter -Physical \| Where-Object { $_.Status -eq 'Up'}`.|
   |`VSwitch.Name` | string | Switch name for the virtual switch (External), required only for `ScalableCluster`.|
   |`AksEdgeConfigFile` | string | The file name for the AKS Edge config (`aksedge-config.json`)|

In your working folder, open the [aksedge-config.json](https://github.com/Azure/AKS-Edge/blob/main/tools/aksedge-config.json) file and review the json configuration for singlemachinecluster cluster. You may want to change the `Network.NetworkPlugin` to `calico` if you are using K8s configuration.

## Step 3: Install AKS Edge Essentials PowerShell modules

You can load AKS Edge Essentials modules by running the **AksEdgePrompt** file from the **tools** folder in the downloaded [GitHub repo](https://github.com/Azure/AKS-Edge/blob/main/tools/AksEdgePrompt.cmd). This PowerShell script checks for prerequisites such as Hyper-V, system CPU and memory resources, and the AKS Edge Essentials program, and loads the corresponding PowerShell modules.

![Screenshot showing the PowerShell prompt.](./media/aks-edge/aksedge-prompt.png)

Install the AKS Edge Essentials msi using

```powershell
Install-AideMsi
```

You can see the full list of supported commands by running the following cmdlet:

```powershell
Get-Command -Module AKSEdge | Format-Table Name, Version
```

![Screenshot of installed PowerShell modules.](media/aks-edge/aks-edge-prompt-get-module.png)

## Step 4: Check AKS Edge Essentials-related device settings

You can run the `Install-AksEdgeHostFeatures` command to validate the Hyper-V, SSH and Power settings on the machine. Running this command might require a system reboot.

```powershell
Install-AksEdgeHostFeatures
```

![Screenshot showing the checks that are done.](media/aks-edge/aks-edge-prompt-install-host.png)

## Step 5: Configure Azure Arc-related settings

1. In your working folder, open the [aide-userconfig.json](https://github.com/Azure/AKS-Edge/blob/main/tools/aide-userconfig.json) file and provide the following information:

   | Attribute | Value type      |  Description |
   | :------------ |:-----------|:--------|
   |`Azure.ClusterName` | string | Provide a name for your cluster. By default, `hostname_cluster` is the name used. |
   |`Azure.Location` | string | The location of your resource group. Choose the location closest to your deployment. |
   |`Azure.SubscriptionName` | string | Your subscription Name. |
   |`Azure.SubscriptionId` | GUID | Your subscription ID. In the Azure portal, click on the subscription you're using and opy/paste the subscription ID string into the JSON. |
   |`Azure.ServicePrincipalName` | string | Azure Service Principal name. AKS Edge uses this service principal to connect your cluster to Arc. You can use an existing service principal or if you add a new name, the system creates one for you in the later step. |
   |`Azure.TenantId` | GUID | Your tenant ID. In the Azure portal, search Azure Active Directory, which should take you to the Default Directory page. From here, you can copy/paste the tenant ID string into the JSON. |
   |`Azure.ResourceGroupName` | string | The name of the Azure resource group to host your Azure resources for AKS Edge. You can use an existing resource group, or if you add a new name, the system creates one for you. |
   |`Azure.Auth.ServicePrincipalId` | GUID | The AppID of `Azure.ServicePrincipalName` to use as credentials. Leave this blank if you creating a new service principal. |
   |`Azure.Auth.Password` | string | The password (in clear) for `Azure.ServicePrincipalName` to use as credentials. Leave this blank if you're creating a new service principal. |

2. In the **AksEdgePrompt**, run the **AksEdgeAzureSetup.ps1** script from the **tools\scripts\AksEdgeAzureSetup** folder. This script prompts you to log in with your credentials for setting up your Azure subscription.

    ```powershell
    # prompts for interactive login for service principal creation with Contributor role at resource group level
    ..\tools\scripts\AksEdgeAzureSetup\AksEdgeAzureSetup.ps1 .\aide-userconfig.json -spContributorRole
    ```

3. Once the script completes, you will have the service principal authentication details in the `aide-userconfig.json` file.

## Step 6: Create a single-machine deployment

1. You can now run the `Start-AideWorkflow` cmdlet to deploy a single-machine AKS Edge Essentials cluster with a single Linux control-plane node:

    ```PowerShell
    Start-AideWorkflow
    ```

2. Confirm that the deployment was successful by running:

    ```powershell
    kubectl get nodes -o wide
    kubectl get pods -A -o wide
    ```

The following image shows pods on a K3S cluster:

![Screenshot showing all pods running.](./media/aks-edge/all-pods-running.png)

## Step 8: Connect your cluster to Azure using Arc

1. You can now run the following command to connect your cluster to Azure:

    ```powershell
   # Connect Arc-enabled server and Arc-enabled kubernetes
   Connect-AideArc
   ```

    > [!NOTE]
    > This step can take up to 10 minutes and PowerShell may be stuck on "Establishing Azure Connected Kubernetes for `your cluster name`". The PowerShell will output `True` and return to the prompt when the process is completed.

## Step 9: View the AKS Edge Essentials cluster in Azure

1. Once the process is complete, you can view your cluster in the Azure portal if you navigate to your resource group:

   ![Screenshot showing the cluster in azure portal](media/aks-edge/cluster-in-az-portal.png)

2. On the left panel, select the **Namespaces** blade under **Kubernetes resources (preview)**:

   ![Screenshot of Kubernetes resources.](media/aks-edge/kubernetes-resources-preview.png)

3. To view your Kubernetes resources, you need a bearer token:

   ![Screenshot showing the bearer token required page.](media/aks-edge/bearer-token-required.png)

4. You can run `Get-AksEdgeManagedServiceToken` to retrieve your service token:

   ![Screenshot showing where to paste token in portal.](media/aks-edge/bearer-token-in-portal.png)

5. Now you can view resources on your cluster. The **Workloads** blade, shows the pods running on your cluster.

    ```powershell
    kubectl get pods --all-namespaces
    ```

    ![Screenshot showing all pods in Arc.](media/aks-edge/all-pods-in-arc.png)

You now have an Arc-connected AKS Edge Essentials K3S cluster with a Linux node. You can now explore deploying a sample application on this cluster.

## Next steps

- [Deploy your application](aks-edge-howto-deploy-app.md).
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
