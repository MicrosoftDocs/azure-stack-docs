---
title: Deploy your AKS-HCI infrastructure with Windows Admin Center
description: An overview of what's necessary to deploy AKS on Azure Stack HCI in an Azure VM using Windows Admin Center
author: sethmanheim
ms.topic: conceptual
ms.date: 08/04/2022
ms.author: sethm 
ms.lastreviewed: 08/04/2022
ms.reviewer: oadeniji
# Intent: As an IT Pro, I need to learn how to deploy AKS on Azure Stack HCI in an Azure VM
# Keyword: Azure VM deployment
---

# Deploy your AKS-HCI infrastructure with Windows Admin Center

With your Windows Server Hyper-V host up and running, it's now time to deploy AKS on Azure Stack HCI. You'll first use Windows Admin Center to deploy the AKS on Azure Stack HCI management cluster onto your Windows Server Hyper-V host, and finally, deploy a target cluster, onto which you can test deployment of a workload.

> [!NOTE]
> In this step, you'll be using Windows Admin Center to deploy AKS on Azure Stack HCI. If you prefer to use PowerShell, see the [PowerShell guide](2b_DeployAKSHCI_PS.md).

## Architecture

The following image shows the different layers and interconnections between the different components:

![Architecture diagram for AKS on Azure Stack HCI in Azure](/eval/media/nested_virt_arch_ga2.png "Architecture diagram for AKS on Azure Stack HCI in Azure")

You've already deployed the outer box, which represents the Azure Resource Group. Inside here, you've deployed the virtual machine itself, and accompanying network adapter, storage and so on. You've also completed some host configuration.

In this section, you'll first install and configure Windows Admin Center. You'll use this to deploy the management cluster, also known as a management cluster. This provides the the core orchestration mechanism and interface for deploying and managing one or more target clusters, which are shown on the right-hand side of the diagram. These target, or workload clusters contain worker nodes and are where application workloads run. These nodes are managed by a management cluster. To learn more about the building blocks of the Kubernetes infrastructure, [read more here](kubernetes-concepts.md).

## Set Microsoft Edge as default browser

To streamline things later, set Microsoft Edge as the default browser.

1. Inside your **AKSHCIHOST001 VM**, select **Start**, type **default browser**, and then under **Best match**, select **Choose a default web browser**.

   ![Set the default browser](/eval/media/default_browser.png "Set the default browser")

2. In the **Default apps** settings view, under **Web browser**, select **Internet Explorer**.
3. In the **Choose an app** popup, select **Microsoft Edge**, then close the **Settings** window.

### Allow popups in Edge browser

To give the optimal experience with Windows Admin Center, you should enable **Microsoft Edge** to allow popups for Windows Admin Center.

1. Still inside your **AKSHCIHOST001 VM**, double-click the **Microsoft Edge icon** on your desktop.
2. Navigate to **edge://settings/content/popups**.
3. In the **Allow** box, select **Add**.
4. In the **Add a site** box, enter **https://akshcihost001** (assuming you didn't change the host name at deployment time).

   ![Allow popups in Edge](/eval/media/allow_popup_edge.png "Allow popups in Edge")

5. Close the **Settings** tab.

## Configure Windows Admin Center

Your Azure VM deployment automatically installed Windows Admin Center 2103, however there are some additional configuration steps that must be performed before you can use it to deploy AKS on Azure Stack HCI:

1. Double-click the **Windows Admin Center** shortcut on the desktop.
2. In Windows Admin Center, you might receive notifications in the top-right corner, indicating that some extensions are updating automatically. Let these updates finish before proceeding. Windows Admin Center may refresh automatically during this process.
3. Once complete, navigate to **Settings**, then **Extensions**.
4. Select **Installed extensions** and you should see **Azure Kubernetes Service** listed as installed.

   ![Installed extensions in Windows Admin Center](/eval/media/installed_extensions.png "Installed extensions in Windows Admin Center")

   > [!NOTE]
   > Ensure that your Azure Kubernetes Service extension is the latest available version. If the **Status** shows **Installed**, then you have the latest version. If the **Status** shows **Update available (1.#.#)**, ensure that you apply this update and refresh before proceeding.

In order to deploy AKS on Azure Stack HCI with Windows Admin Center, connect your Windows Admin Center instance to Azure.

1. Still in **Settings**, under **Gateway**, select **Azure**.
2. Select **Register**, and in the **Get started with Azure in Windows Admin Center** blade, follow the instructions to **Copy the code**, then select the link to configure device login.
3. When prompted for credentials, enter your Azure credentials for a tenant you want to use to register Windows Admin Center.
4. Back in Windows Admin Center, note that your tenant information has been added. You can now select **Connect** to connect Windows Admin Center to Azure.

   ![Connecting Windows Admin Center to Azure](/eval/media/wac_azure_connect.png "Connecting Windows Admin Center to Azure")

5. Select **Sign in** and when prompted for credentials, enter your Azure credentials and you should see a popup that asks for you to accept the permissions. Make sure you select **Consent on behalf of your organization**, and then select **Accept**.

   ![Permissions for Windows Admin Center](/eval/media/wac_azure_permissions.png "Permissions for Windows Admin Center")

   > [!NOTE]
   > If you receive an error when signing in, still in **Settings**, under **User**, click on **Account** and click **Sign-in**. You should then be prompted for Azure credentials and permissions, to which you can then click **Accept**. Sometimes it just takes a few moments from Windows Admin Center creating the Azure AD application and being able to sign in. Retry the sign-in until you've successfully signed in.

## Validate Azure integration

In order to successfully deploy AKS on Azure Stack HCI with Windows Admin Center, additional permissions were applied on the Windows Admin Center Azure AD application that was created when you connected Windows Admin Center to Azure. In this step, you can quickly validate those permissions.

1. Still in Windows Admin Center, click the **Settings** gear in the top-right corner.
2. Under **Gateway**, click **Azure**. You should see your previously registered Azure AD app:

   ![Your Azure AD app in Windows Admin Center](/eval/media/wac_azureadapp.png "Your Azure AD app in Windows Admin Center")

3. Click on **View in Azure** to be taken to the Azure AD app portal, where you should see information about this app, including required permissions. If you're prompted to sign in, provide appropriate credentials.
4. Once signed in, under **Configured permissions**, you should see a few permissions listed with the status **Granted for...** and the name of your tenant. The **Microsoft Graph (5)** API permissions show as **not granted**, but this will be updated upon deployment.

   ![Confirm Azure AD app permissions in Windows Admin Center](/eval/media/wac_azuread_grant.png "Confirm Azure AD app permissions in Windows Admin Center")

   > [!NOTE]
   > If you don't see Microsoft Graph listed in the API permissions, you can either [re-register Windows Admin Center using steps here](#configure-windows-admin-center) for the permissions to appear correctly, or manually add the **Microsoft Graph Appliation.ReadWrite.All** permission. To manually add the permission:

   - Select **+ Add a permission**.
   - Select **Microsoft Graph**, then **Delegated permissions**.
   - Search for **Application.ReadWrite.All**, then if required, expand the **Application** dropdown.
   - Select the **checkbox** and click **Add permissions**.

5. Switch back to the **Windows Admin Center tab** and click on **Windows Admin Center** in the top-left corner to return to the home page.

   You'll notice that your **AKSHCIHOST001** VM is already under management, so at this point you're ready to deploy the AKS on Azure Stack HCI management cluster onto your Windows Server Hyper-V host.

   ![AKSHCIHOST001 under management in Windows Admin Center](/eval/media/akshcihost_in_wac.png "AKSHCIHOST001 under management in Windows Admin Center")

## Optional - enable/disable DHCP

Static IP configurations are supported for deployment of the management cluster and workload clusters. When you deployed your Azure VM, DHCP was installed and configured automatically for you, but you had the chance to control whether it was enabled or disabled on your Windows Server host OS. If you want to adjust DHCP now, make changes to the **$dhcpState** below and run the following PowerShell command as administrator:

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
2. You'll be presented with information about your akshcihost001 machine. You can explore the different options and metrics. When you're ready, on the left-hand side, click **Azure Kubernetes Service**.

   ![Ready to deploy AKS-HCI with Windows Admin Center](/eval/media/aks_extension.png "Ready to deploy AKS-HCI with Windows Admin Center")

   The terminology used refers to the **Azure Kubernetes Service Runtime on Windows Server​​** - the naming differs depending on whether you're running the installation of AKS on a Windows Server Hyper-V platform, or on the newer Azure Stack HCI 21H2 platform. The overall deployment experience is the same regardless of the underlying platform.

3. Select **Set up** to start the deployment process.
4. Review the prerequisites - your Azure VM environment will meet all the prerequisites, so you should be fine to click **Next: System checks**.
5. On the **System checks** page, enter the password for your **azureuser** account and when successfully validated, select the **Install** button to install the required PowerShell modules.
6. During the system checks stage, Windows Admin Center will begin to validate its own configuration, and the configuration of your target nodes, which in this case, is the Windows Server Hyper-V host (running in your Azure VM).

   ![System checks performed by Windows Admin Center](/eval/media/wac_system_checks.png "System checks performed by Windows Admin Center")

   Windows Admin Center validates memory, storage, networking, roles and features and more. If you've followed the guide correctly, you'll find you'll pass all the checks and can proceed.

7. Once validated, select **Next: Credential delegation**.
8. On the **Credential delegation** page, read the information about **CredSSP**, then click **Enable**. Once enabled, click **Next: Host configuration**.

   ![Enable CredSSP in Windows Admin Center](/eval/media/aks_hostconfig_credssp.png "Enable CredSSP in Windows Admin Center")

9. On the **Host configuration** page, under **Host details**, select your **V:**, and leave the other settings with their defaults.

   ![Host configuration in Windows Admin Center](/eval/media/aks_hostconfig_hostdetails.png "Host configuration in Windows Admin Center")

10. Under **VM Networking**, ensure that **InternalNAT** is selected for the **Internet-connected virtual switch**.
11. For **Enable virtual LAN identification**, leave this selected as **No**.
12. For **Cloudagent IP**, this is optional, so leave this blank.
13. For **IP address allocation method** choose either **DHCP** or **Static**, depending on the choice you made for deployment of your Azure VM. If you're not sure, you can check by [validating your DHCP config](#optional---enabledisable-dhcp).
14. If you select **Static**, you should enter the following:
    1. **Subnet Prefix**: 192.168.0.0/16
    2. **Gateway**: 192.168.0.1
    3. **DNS Servers**: 192.168.0.1
    4. **Kubernetes node IP pool start**: 192.168.0.3
    5. **Kubernetes node IP pool end**: 192.168.0.149

   ![Host configuration in Windows Admin Center](/eval/media/aks_hostconfig_vmnet.png "Host configuration in Windows Admin Center")
15. Under **Load balancer settings**, enter the range from **192.168.0.150** to **192.168.0.250** 

   ![Load balancer configuration in Windows Admin Center](/eval/media/aks_hostconfig_lb.png "Load balancer configuration in Windows Admin Center")
16. Scroll down and review the new proxy settings - these settings allow you to configure AKS on Azure Stack HCI for use in an environment that uses a proxy, including the ability to provide proxy credentials. Once you have reviewed the options, click **Next: Azure registration**.

   ![AKS on Azure Stack HCI proxy settings in Windows Admin Center](/eval/media/aks_wac_proxy.png "AKS on Azure Stack HCI proxy settings in Windows Admin Center")
17. On the Azure registration page, your Azure account should be automatically populated. Use the drop-down to select your preferred subscription. If you are prompted, sign in to Azure with your Azure credentials. Once successfully authenticated, you should see your account, then choose your subscription.

   ![AKS on Azure Stack HCI Azure Registration in Windows Admin Center](/eval/media/aks_azure_reg.png "AKS on Azure Stack HCI Azure Registration in Windows Admin Center")

   > [!NOTE]
   > No charges will be incurred for using AKS on Azure Stack HCI during the free trial period of 60 days.

18. Once you've chosen your subscription, choose an existing resource group or create a new one. Your resource group should be in the East US, Southeast Asia, or West Europe region.
19. Select **Next: Review**.
20. Review your choices and settings, then select **Apply**.
21. After a few minutes, you may be prompted to grant consent to the Windows Admin Center Azure AD application. Ensure you select **Consent on behalf of your organization**, then click **Accept**. The settings will be applied, and you should receive some notifications:

   ![Setting the AKS-HCI config in Windows Admin Center](/eval/media/aks_host_mgmtconfirm.png "Setting the AKS-HCI config in Windows Admin Center")
22. When confirmed, you can click **Next: New cluster** to start the deployment process of the management cluster.

   ![AKS on Azure Stack HCI management cluster deployment started in Windows Admin Center](/eval/media/aks_deploy_started.png "AKS on Azure Stack HCI management cluster deployment started in Windows Admin Center")

   > [!NOTE]
   > Do not close the Windows Admin Center browser at this time. Leave it open and wait for successful completion.

23. Upon completion, you should receive a notification of success. In this case, you can see deployment of the AKS on Azure Stack HCI management cluster took just over 11 minutes.

   ![AKS-HCI management cluster deployment completed in Windows Admin Center](/eval/media/aks_deploy_success.png "AKS-HCI management cluster deployment completed in Windows Admin Center")
24. Once reviewed, click **Finish**. You are then presented with a management dashboard in which you can create and manage your Kubernetes clusters.

### Updates and cleanup

For more information about updating, redeploying, or uninstalling AKS on Azure Stack HCI with Windows Admin Center, see [the documentation here](setup.md).

## Create a Kubernetes cluster (target cluster)

With the management cluster deployed successfully, you're ready to move on to deploying Kubernetes clusters that can host your workloads. We'll then briefly walk through how to scale your Kubernetes cluster and upgrade the Kubernetes version of your cluster.

There are two ways to create a Kubernetes cluster in Windows Admin Center.

### Option 1

1. From your Windows Admin Center landing page (https://akshcihost001), select **+Add**.
2. In the **Add or create resources** blade, in the **Kubernetes clusters** tile, select **Create new**.

![Create Kubernetes cluster in Windows Admin Center](/eval/media/create_cluster_method1.png "Create Kubernetes cluster in Windows Admin Center")

### Option 2

1. From your Windows Admin Center landing page (https://akshcihost001), select your **akshcihost001.akshci.local \[Gateway\]** machine.
2. Then, on the left-hand side, scroll down and under **Extensions**, click **Azure Kubernetes Service**.
3. In the central pane, select **Add cluster**.

![Create Kubernetes cluster in Windows Admin Center](/eval/media/create_cluster_method2.png "Create Kubernetes cluster in Windows Admin Center")

Whichever option you chose, you will now be at the start of the **Create kubernetes cluster** wizard.

1. First review the prerequisites. Your Azure VM environment will meet all the prerequisites, so you should be fine to click **Next: Basics**.
2. On the **Basics** page, choose whether you want to optionally integrate with Azure Arc enabled Kubernetes. You can click the link on the page to learn more about Azure Arc. If you do want to integrate, select the **Enabled** radio button, then use the drop downs to select the **subscription**, **resource group** and **region**. Alternatively, you can create a new resource group, in a specific region, exclusively for the Azure Arc integration resource.

   ![Enable Arc integration with Windows Admin Center](/eval/media/aks_basics_arc.png "Enable Arc integration with Windows Admin Center")

3. Still on the **Basics** page, under **Cluster details**, provide a Kubernetes cluster name, Azure Kubernetes Service host, which should be **AKSHCIHost001**, enter your host credentials, and then select your preferred Kubernetes version from the drop down.

   ![AKS cluster details in Windows Admin Center](/eval/media/aks_basics_cluster_details.png "AKS cluster details in Windows Admin Center")

4. Under **Primary node pool**, accept the defaults, and then click **Next: Node pools**.

   ![AKS primary node pool in Windows Admin Center](/eval/media/aks_basics_primarynp.png "AKS primary node pool in Windows Admin Center")

5. On the **Node pools** page, select **+Add node pool**.
6. In the **Add a node pool** blade, enter the following information, then click **Add**:
   1. **Node pool name**: linuxnodepool
   2. **OS type**: Linux
   3. **Node size**: Default (4 GB Memory, 4 CPU)
   4. **Node count**: 1
   5. **Max pods per node**: Leave the default
7. Optionally, repeat step 6, to add a Windows node and the following info, then click **Add**:
   1. **Node pool name**: windowsnodepool
   2. **OS type**: Windows
   3. **Node size**: Default (4 GB Memory, 4 CPU)
   4. **Node count**: 1
   5. **Max pods per node**: Leave the default

   ![AKS node pools in Windows Admin Center](/eval/media/aks_node_pools.png "AKS node pools in Windows Admin Center")

8. Once your node pools have been defined, click **Next: Authentication**.
9. For this evaluation, for **AD Authentication** select **Disabled** and then click **Next: Networking**.
10. On the **Networking** page, review the defaults. For this deployment, you'll deploy this Kubernetes cluster on the existing virtual network that was created when you installed AKS-HCI in the previous steps.

   ![AKS virtual networking in Windows Admin Center](/eval/media/aks_virtual_networking.png "AKS virtual networking in Windows Admin Center")
11. Select the **aks-default-network**, select **Calico** as the network configuration, and then click **Next: Review + Create**.
12. On the **Review + Create** page, review your chosen settings, then click **Create**.

   ![Finalize creation of AKS cluster in Windows Admin Center](/eval/media/aks_create.png "Finalize creation of AKS cluster in Windows Admin Center")
13. The creation process begins, and takes a few minutes.

   ![Start deployment of AKS cluster in Windows Admin Center](/eval/media/aks_create_start.png "Start deployment of AKS cluster in Windows Admin Center")
14. Once completed, you should see a message for successful creation, then click **Finish**.

   ![Completed deployment of AKS cluster in Windows Admin Center](/eval/media/aks_create_complete.png "Completed deployment of AKS cluster in Windows Admin Center")
15. Back in the **Azure Kubernetes Service Runtime on Windows Server**, you should now see your cluster listed.

   ![AKS cluster in Windows Admin Center](/eval/media/aks_dashboard.png "AKS cluster in Windows Admin Center")
16. On the dashboard, if you chose to integrate with Azure Arc, you should be able to click the **Azure instance** link to be taken to the Azure Arc view in the Azure portal.

   ![AKS cluster in Azure Arc](/eval/media/aks_in_arc.png "AKS cluster in Azure Arc")
17. In addition, back in Windows Admin Center, you can download your **Kubernetes cluster kubeconfig** file in order to access this Kubernetes cluster via **kubectl** later.
18. Once you have your Kubeconfig file, you can click **Finish**.

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

   ![Output of Get-AksHciCluster](/eval/media/get_akshcicluster_wac1.png "Output of Get-AksHciCluster")

3. Next, you'll scale your Kubernetes cluster to have two Linux worker nodes. You'll do this by specifying a node pool to update.

### Node Pools, taints, and max pod counts

If you're not familiar with the concept of *node pools*, a node pool is a group of nodes, or virtual machines that run your applications, within a Kubernetes cluster that have the same configuration, giving you more granular control over your clusters. You can deploy multiple Windows node pools and multiple Linux node pools of different sizes, within the same Kubernetes cluster.

Another configuration option that can be applied to a node pool is the concept of *taints*. A taint can be specified for a particular node pool at cluster and node pool creation time, and essential allow you to prevent pods being placed on specific nodes based on characteristics that you specify. You can learn more about [taints here](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

This guide doesn't require you to specify a taint, but if you do want to explore the commands for adding a taint to a node pool, read the [documentation here](use-node-pools.md#specify-a-taint-for-a-node-pool).

In addition to taints, we have recently added support for configuring the maximum number of pods that can run on a node, with the `-nodeMaxPodCount` parameter. You can specify this parameter when creating a cluster, or when creating a new node pool, and the number has to be greater than 50.

You can confirm your node pool names and details by running the following command:

```powershell
Get-AksHciNodePool -clusterName akshciclus001
```

![Output of Get-AksHciNodePool](/eval/media/get_akshcinodepool_wac.png "Output of Get-AksHciNodePool")

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

![Output of Get-AksHciCluster](/eval/media/get_akshcicluster_wac3.png "Output of Get-AksHciCluster")

To access this **akshciclus001** cluster using **kubectl** (which was installed on your host as part of the overall installation process), you'll first need the **kubeconfig file**.

To retrieve the kubeconfig file for the akshciclus001 cluster, you'll need to run the following PowerShell command as administrator:

```powershell
Get-AksHciCredential -Name akshciclus001 -Confirm:$false
dir $env:USERPROFILE\.kube
```

## Next steps

In this step, you've successfully deployed the AKS on Azure Stack HCI management cluster using Windows Admin Center, optionally integrated with Azure Arc, and subsequently, deployed and scaled a Kubernetes cluster that you can move forward with to the next stage, in which you can deploy your applications.

- [Part 3 - Explore AKS on Azure Stack HCI](3_ExploreAKSHCI.md)
