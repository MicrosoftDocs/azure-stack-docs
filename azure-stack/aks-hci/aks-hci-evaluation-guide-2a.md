---
title: Deploy your AKS-HCI infrastructure with Windows Admin Center
description: Step 2 in an overview of what's necessary to deploy AKS on Azure Stack HCI in an Azure Virtual Machine using Windows Admin Center
author: sethmanheim
ms.topic: conceptual
ms.date: 08/29/2022
ms.author: sethm 
ms.lastreviewed: 08/29/2022
ms.reviewer: oadeniji
# Intent: As an IT Pro, I need to learn how to deploy AKS on Azure Stack HCI in an Azure Virtual Machine
# Keyword: Azure Virtual Machine deployment
---

# Step 2: Deploy your AKS-HCI infrastructure with Windows Admin Center

With your Windows Server Hyper-V host up and running, you can now deploy AKS on Azure Stack HCI. You'll first use Windows Admin Center to deploy the AKS on Azure Stack HCI management cluster onto your Windows Server Hyper-V host, and finally, deploy a target cluster, onto which you can test deployment of a workload.

> [!NOTE]
> In this step, you'll be using Windows Admin Center to deploy AKS on Azure Stack HCI. If you prefer to use PowerShell, see the [PowerShell guide](aks-hci-evaluation-guide-2b.md).

## Architecture

The following image shows the different layers and interconnections between the different components:

:::image type="content" source="media/aks-hci-evaluation-guide/nested-virt.png" alt-text="Architecture of AKS on Azure Stack HCI in Azure":::

You've already deployed the outer box, which represents the Azure Resource Group. Inside here, you've deployed the virtual machine itself, and accompanying network adapter, storage and so on. You've also completed some host configuration.

In this section, you'll first install and configure Windows Admin Center. You'll use this to deploy the management cluster, also known as a management cluster. This provides the core orchestration mechanism and interface for deploying and managing one or more target clusters, which are shown on the right-hand side of the diagram. These target, or workload clusters contain worker nodes and are where application workloads run. These nodes are managed by a management cluster. To learn more about the building blocks of the Kubernetes infrastructure, [read more here](kubernetes-concepts.md).

## Set Microsoft Edge as default browser

To streamline things later, set Microsoft Edge as the default browser.

1. Inside your **AKSHCIHOST001 VM**, select **Start**, type **default browser**, and then under **Best match**, select **Choose a default web browser**.
2. In the **Default apps** settings view, under **Web browser**, select **Internet Explorer**.
3. In the **Choose an app** popup, select **Microsoft Edge**, then close the **Settings** window.

### Allow popups in Edge browser

To give the optimal experience with Windows Admin Center, you should enable **Microsoft Edge** to allow popups for Windows Admin Center.

1. Still inside your **AKSHCIHOST001 VM**, double-click the **Microsoft Edge icon** on your desktop.
2. Navigate to **edge://settings/content/popups**.
3. In the **Allow** box, select **Add**.
4. In the **Add a site** box, enter **https://akshcihost001** (assuming you didn't change the host name at deployment time).
5. Close the **Settings** tab.

## Configure Windows Admin Center

Your Azure Virtual Machine deployment automatically installed Windows Admin Center 2103, however there are some additional configuration steps that must be performed before you can use it to deploy AKS on Azure Stack HCI:

1. Double-click the **Windows Admin Center** shortcut on the desktop.
2. In Windows Admin Center, you might receive notifications in the top-right corner, indicating that some extensions are updating automatically. Let these updates finish before proceeding. Windows Admin Center may refresh automatically during this process.
3. Once complete, navigate to **Settings**, then **Extensions**.
4. Select **Installed extensions** and you should see **Azure Kubernetes Service** listed as installed.

   :::image type="content" source="media/aks-hci-evaluation-guide/installed-extensions.png" alt-text="Screenshot of installed extensions in Windows Admin Center":::

   > [!NOTE]
   > Ensure that your Azure Kubernetes Service extension is the latest available version. If the **Status** shows **Installed**, then you have the latest version. If the **Status** shows **Update available (1.#.#)**, ensure that you apply this update and refresh before proceeding.

In order to deploy AKS on Azure Stack HCI with Windows Admin Center, connect your Windows Admin Center instance to Azure.

1. Still in **Settings**, under **Gateway**, select **Azure**.
2. Select **Register**, and in the **Get started with Azure in Windows Admin Center** blade, follow the instructions to **Copy the code**, then select the link to configure device login.
3. When prompted for credentials, enter your Azure credentials for a tenant you want to use to register Windows Admin Center.
4. Back in Windows Admin Center, note that your tenant information has been added. You can now select **Connect** to connect Windows Admin Center to Azure.

   :::image type="content" source="media/aks-hci-evaluation-guide/azure-connect.png" alt-text="Screenshot of connecting Windows Admin Center to Azure":::

5. Select **Sign in** and when prompted for credentials, enter your Azure credentials and you should see a popup that asks for you to accept the permissions. Make sure you select **Consent on behalf of your organization**, and then select **Accept**.

   > [!NOTE]
   > If you receive an error when signing in, still in **Settings**, under **User**, click on **Account** and click **Sign-in**. You should then be prompted for Azure credentials and permissions, to which you can then click **Accept**. Sometimes it just takes a few moments from Windows Admin Center creating the Azure AD application and being able to sign in. Retry the sign-in until you've successfully signed in.

## Validate Azure integration

In order to successfully deploy AKS on Azure Stack HCI with Windows Admin Center, additional permissions were applied on the Windows Admin Center Azure AD application that was created when you connected Windows Admin Center to Azure. In this step, you can quickly validate those permissions.

1. Still in Windows Admin Center, click the **Settings** gear in the top-right corner.
2. Under **Gateway**, click **Azure**. You should see your previously registered Azure AD app:
3. Click on **View in Azure** to be taken to the Azure AD app portal, where you should see information about this app, including required permissions. If you're prompted to sign in, provide appropriate credentials.
4. Once signed in, under **Configured permissions**, you should see a few permissions listed with the status **Granted for...** and the name of your tenant. The **Microsoft Graph (5)** API permissions show as **not granted**, but this will be updated upon deployment.

   :::image type="content" source="media/aks-hci-evaluation-guide/azure-ad-grant.png" alt-text="Screenshot of confirm Azure AD app permissions in Windows Admin Center":::

   If you don't see Microsoft Graph listed in the API permissions, you can either [re-register Windows Admin Center using steps here](#configure-windows-admin-center) for the permissions to appear correctly, or manually add the **Microsoft Graph Appliation.ReadWrite.All** permission. To manually add the permission:

   1. Select **+ Add a permission**.
   1. Select **Microsoft Graph**, then **Delegated permissions**.
   1. Search for **Application.ReadWrite.All**, then if required, expand the **Application** dropdown.
   1. Select the **checkbox** and click **Add permissions**.

5. Switch back to the **Windows Admin Center** tab and select **Windows Admin Center** in the top-left corner to return to the home page.

   You'll notice that your **AKSHCIHOST001** VM is already under management, so at this point you're ready to deploy the AKS on Azure Stack HCI management cluster onto your Windows Server Hyper-V host.

   :::image type="content" source="media/aks-hci-evaluation-guide/aks-hci-host.png" alt-text="Screenshot of VM under management in Windows Admin Center":::

## Optional - enable/disable DHCP

Static IP configurations are supported for deployment of the management cluster and workload clusters. When you deployed your Azure Virtual Machine, DHCP was installed and configured automatically for you, but you had the chance to control whether it was enabled or disabled on your Windows Server host OS. If you want to adjust DHCP now, make changes to the **$dhcpState** below and run the following PowerShell command as administrator:

```powershell
# Check current DHCP state for Active/Inactive
Get-DhcpServerv4Scope -ScopeId 192.168.0.0
# Adjust DHCP state if required
$dhcpState = "Active" # Or Inactive
Set-DhcpServerv4Scope -ScopeId 192.168.0.0 -State $dhcpState -Verbose
```

## Deploy AKS on Azure Stack HCI management cluster

The next section walks through configuring the AKS on Azure Stack HCI management cluster, on your single node Windows Server Hyper-V host.

1. From the Windows Admin Center homepage, click on your **akshcihost001.akshci.local \[Gateway\]** machine.
1. You'll be presented with information about your akshcihost001 machine. You can explore the different options and metrics. When you're ready, on the left-hand side, click **Azure Kubernetes Service**.

   :::image type="content" source="media/aks-hci-evaluation-guide/aks-extension.png" alt-text="Screenshot of VM options":::

   The terminology used refers to the **Azure Kubernetes Service Runtime on Windows Server​​** - the naming differs depending on whether you're running the installation of AKS on a Windows Server Hyper-V platform, or on the newer Azure Stack HCI 21H2 platform. The overall deployment experience is the same regardless of the underlying platform.

1. Select **Set up** to start the deployment process.
1. Review the prerequisites - your Azure Virtual Machine environment will meet all the prerequisites, so you should be fine to click **Next: System checks**.
1. On the **System checks** page, enter the password for your **azureuser** account and when successfully validated, select the **Install** button to install the required PowerShell modules.
1. During the system checks stage, Windows Admin Center will begin to validate its own configuration, and the configuration of your target nodes, which in this case, is the Windows Server Hyper-V host (running in your Azure Virtual Machine). Windows Admin Center validates memory, storage, networking, roles and features and more. If you've followed the guide correctly, you'll find you'll pass all the checks and can proceed.
1. Once validated, select **Next: Credential delegation**.
1. On the **Credential delegation** page, read the information about **CredSSP**, then click **Enable**. Once enabled, click **Next: Host configuration**.
1. On the **Host configuration** page, under **Host details**, select your **V:**, and leave the other settings with their defaults.

   :::image type="content" source="media/aks-hci-evaluation-guide/host-config-host-details.png" alt-text="Screenshot of host configuration details":::

1. Under **VM Networking**, ensure that **InternalNAT** is selected for the **Internet-connected virtual switch**.
1. For **Enable virtual LAN identification**, leave this selected as **No**.
1. For **Cloudagent IP**, this is optional, so leave this blank.
1. For **IP address allocation method** choose either **DHCP** or **Static**, depending on the choice you made for deployment of your Azure Virtual Machine. If you're not sure, you can check by [validating your DHCP config](#optional---enabledisable-dhcp).
1. If you select **Static**, you should enter the following:
    1. **Subnet Prefix**: 192.168.0.0/16
    2. **Gateway**: 192.168.0.1
    3. **DNS Servers**: 192.168.0.1
    4. **Kubernetes node IP pool start**: 192.168.0.3
    5. **Kubernetes node IP pool end**: 192.168.0.149
1. Under **Load balancer settings**, enter the range from **192.168.0.150** to **192.168.0.250** 
1. Scroll down and review the new proxy settings - these settings allow you to configure AKS on Azure Stack HCI for use in an environment that uses a proxy, including the ability to provide proxy credentials. Once you have reviewed the options, click **Next: Azure registration**.
   :::image type="content" source="media/aks-hci-evaluation-guide/proxy-settings.png" alt-text="Screenshot of proxy settings in Windows Admin Center":::

1. On the Azure registration page, your Azure account should be automatically populated. Use the drop-down to select your preferred subscription. If you are prompted, sign in to Azure with your Azure credentials. Once successfully authenticated, you should see your account, then choose your subscription.

   :::image type="content" source="media/aks-hci-evaluation-guide/aks-registration.png" alt-text="Screenshot of AKS on Azure Stack HCI Azure registration":::

   > [!NOTE]
   > No charges will be incurred for using AKS on Azure Stack HCI during the free trial period of 60 days.

1. Once you've chosen your subscription, choose an existing resource group or create a new one. Your resource group should be in the East US, Southeast Asia, or West Europe region.
1. Select **Next: Review**.
1. Review your choices and settings, then select **Apply**.
1. After a few minutes, you may be prompted to grant consent to the Windows Admin Center Azure AD application. Ensure you select **Consent on behalf of your organization**, then click **Accept**. The settings will be applied, and you should receive some notifications:
1. When confirmed, you can click **Next: New cluster** to start the deployment process of the management cluster.

   > [!NOTE]
   > Do not close the Windows Admin Center browser at this time. Leave it open and wait for successful completion.

1. Upon completion, you should receive a notification of success. In this case, you can see deployment of the AKS on Azure Stack HCI management cluster took just over 11 minutes.

   :::image type="content" source="media/aks-hci-evaluation-guide/deploy-success.png" alt-text="Screenshot of AKS-HCI management cluster deployment completed":::

1. Once reviewed, click **Finish**. You are then presented with a management dashboard in which you can create and manage your Kubernetes clusters.

### Updates and cleanup

For more information about updating, redeploying, or uninstalling AKS on Azure Stack HCI with Windows Admin Center, see [the documentation here](setup.md).

## Create a Kubernetes cluster (target cluster)

With the management cluster deployed successfully, you're ready to move on to deploying Kubernetes clusters that can host your workloads. We'll then briefly walk through how to scale your Kubernetes cluster and upgrade the Kubernetes version of your cluster.

There are two ways to create a Kubernetes cluster in Windows Admin Center:

### Option 1

1. From your Windows Admin Center landing page (https://akshcihost001), select **+Add**.
2. In the **Add or create resources** blade, in the **Kubernetes clusters** tile, select **Create new**.

### Option 2

1. From your Windows Admin Center landing page (https://akshcihost001), select your **akshcihost001.akshci.local \[Gateway\]** machine.
2. Then, on the left-hand side, scroll down and under **Extensions**, click **Azure Kubernetes Service**.
3. In the central pane, select **Add cluster**.

Whichever option you chose, you will now be at the start of the **Create kubernetes cluster** wizard.

1. First review the prerequisites. Your Azure Virtual Machine environment will meet all the prerequisites, so you should be fine to click **Next: Basics**.
1. On the **Basics** page, choose whether you want to optionally integrate with Azure Arc enabled Kubernetes. You can click the link on the page to learn more about Azure Arc. If you do want to integrate, select the **Enabled** radio button, then use the drop downs to select the **subscription**, **resource group** and **region**. Alternatively, you can create a new resource group, in a specific region, exclusively for the Azure Arc integration resource.

   :::image type="content" source="media/aks-hci-evaluation-guide/basics-arc.png" alt-text="Screenshot of enable Azure Arc integration with Windows Admin Center":::

1. Still on the **Basics** page, under **Cluster details**, provide a Kubernetes cluster name, Azure Kubernetes Service host, which should be **AKSHCIHost001**, enter your host credentials, and then select your preferred Kubernetes version from the drop down.
1. Under **Primary node pool**, accept the defaults, and then click **Next: Node pools**.
1. On the **Node pools** page, select **+Add node pool**.
1. In the **Add a node pool** blade, enter the following information, then click **Add**:
   1. **Node pool name**: linuxnodepool
   2. **OS type**: Linux
   3. **Node size**: Default (4 GB Memory, 4 CPU)
   4. **Node count**: 1
   5. **Max pods per node**: Leave the default
1. Optionally, repeat step 6, to add a Windows node and the following info, then click **Add**:
   1. **Node pool name**: windowsnodepool
   2. **OS type**: Windows
   3. **Node size**: Default (4 GB Memory, 4 CPU)
   4. **Node count**: 1
   5. **Max pods per node**: Leave the default

1. Once your node pools have been defined, click **Next: Authentication**.
1. For this evaluation, for **AD Authentication** select **Disabled** and then click **Next: Networking**.
1. On the **Networking** page, review the defaults. For this deployment, you'll deploy this Kubernetes cluster on the existing virtual network that was created when you installed AKS-HCI in the previous steps.
1. Select the **aks-default-network**, select **Calico** as the network configuration, and then click **Next: Review + Create**.
1. On the **Review + Create** page, review your chosen settings, then click **Create**.

   :::image type="content" source="media/aks-hci-evaluation-guide/create-cluster.png" alt-text="Finalize creation of AKS cluster in Windows Admin Center":::

1. The creation process begins, and takes a few minutes.
1. Once completed, you should see a message for successful creation, then click **Finish**.
1. Back in the **Azure Kubernetes Service Runtime on Windows Server**, you should now see your cluster listed.

   :::image type="content" source="media/aks-hci-evaluation-guide/aks-dashboard.png" alt-text="AKS cluster in Windows Admin Center":::

1. On the dashboard, if you chose to integrate with Azure Arc, you should be able to click the **Azure instance** link to be taken to the Azure Arc view in the Azure portal.
1. In addition, back in Windows Admin Center, you can download your **Kubernetes cluster kubeconfig** file in order to access this Kubernetes cluster via **kubectl** later.
1. Once you have your Kubeconfig file, you can click **Finish**.

## Scale your Kubernetes cluster (target cluster)

Next, you'll scale your Kubernetes cluster to add an additional Linux worker node. This has to be performed with **PowerShell**:

1. Open PowerShell as Administrator and run the following command to import the new modules, and list their functions:

   ```powershell
   Import-Module AksHci
   Get-Command -Module AksHci
   ```

2. Next, to check on the status of the existing cluster, run the following command:

   ```powershell
   Get-AksHciCluster
   ```

   :::image type="content" source="media/aks-hci-evaluation-guide/get-akshcicluster.png" alt-text="Screenshot of Get-AksHciCluster output":::

3. Next, you'll scale your Kubernetes cluster to have two Linux worker nodes. You'll do this by specifying a node pool to update.

### Node Pools, taints, and max pod counts

A *node pool* is a group of nodes, or virtual machines that run your applications, within a Kubernetes cluster that have the same configuration, giving you more granular control over your clusters. You can deploy multiple Windows node pools and multiple Linux node pools of different sizes, within the same Kubernetes cluster.

Another configuration option that can be applied to a node pool is the concept of *taints*. A taint can be specified for a particular node pool at cluster and node pool creation time, and essential allow you to prevent pods being placed on specific nodes based on characteristics that you specify. You can learn more about [taints here](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

This guide doesn't require you to specify a taint, but if you do want to explore the commands for adding a taint to a node pool, read the [documentation here](use-node-pools.md#specify-a-taint-for-a-node-pool).

In addition to taints, we have recently added support for configuring the maximum number of pods that can run on a node, with the `-nodeMaxPodCount` parameter. You can specify this parameter when creating a cluster, or when creating a new node pool, and the number has to be greater than 50.

You can confirm your node pool names and details by running the following command:

```powershell
Get-AksHciNodePool -clusterName akshciclus001
```

Next, run the following command to scale out the Linux node pool:

```powershell
Set-AksHciNodePool -clusterName akshciclus001 -name linuxnodepool -count 2
```

You can also scale your control plane node for this particular cluster, however it has to be scaled independently from the worker nodes themselves. You can scale the control plane nodes using the following command. Before you run this command however, check that you have an extra 16GB memory left of your AKSHCIHost001 OS. If your host has been deployed with 64GB RAM, you may not have enough capacity for an additional two control plane VMs.

```powershell
Set-AksHciCluster –Name akshciclus001 -controlPlaneNodeCount 3
```

> [!NOTE]
> The control plane node count should be an odd number, such as 1, 3, 5, etc.

Once these steps have been completed, you can verify the details by running the following command:

```powershell
Get-AksHciCluster
```

To access this **akshciclus001** cluster using **kubectl** (which was installed on your host as part of the overall installation process), you'll first need the **kubeconfig file**.

To retrieve the kubeconfig file for the akshciclus001 cluster, you'll need to run the following PowerShell command as administrator:

```powershell
Get-AksHciCredential -Name akshciclus001 -Confirm:$false
dir $env:USERPROFILE\.kube
```

## Next steps

In this step, you've successfully deployed the AKS on Azure Stack HCI management cluster using Windows Admin Center, optionally integrated with Azure Arc, and subsequently, deployed and scaled a Kubernetes cluster that you can move forward with to the next stage, in which you can deploy your applications.

- [Part 3 - Explore AKS on Azure Stack HCI](aks-hci-evaluation-guide-3.md)
