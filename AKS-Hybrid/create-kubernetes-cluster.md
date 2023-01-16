---
title: Quickstart to create a local Kubernetes cluster using Windows Admin Center
description: Learn how to create a local Kubernetes cluster using Windows Admin Center
author: sethmanheim
ms.topic: quickstart
ms.date: 10/25/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: dawhite
ms.custom: mode-portal

# Intent: As an IT Pro, I want to learn how to use Windows Admin Center to create a local Kubernetes cluster.
# Keyword: local Kubernetes cluster

---
# Quickstart: Create a local Kubernetes cluster on Azure Stack HCI and Windows Server using Windows Admin Center

> Applies to: Azure Stack HCI and Windows Server

After you have set up your Azure Kubernetes Service (AKS) host, you can use Windows Admin Center to create a local Kubernetes cluster. To use PowerShell instead, see [Create a Kubernetes cluster with PowerShell](kubernetes-walkthrough-powershell.md).

Before proceeding to the Create Kubernetes cluster wizard, make sure you have [Set up Azure Kubernetes Service](setup.md) and check the [system requirements](system-requirements.md). You can access the Create Kubernetes cluster wizard through the [Azure Kubernetes Service host dashboard](#create-a-local-kubernetes-cluster-in-the-azure-kubernetes-service-host-dashboard).

## Create a local Kubernetes cluster in the Azure Kubernetes Service host dashboard

You can create a local Kubernetes cluster through the Azure Kubernetes Service host dashboard. This dashboard can be found in the Azure Kubernetes Service tool if you're connected to the system that has an Azure Kubernetes Service host deployed on it. Follow the steps below and then proceed to the [Use the Create Kubernetes cluster wizard](#use-the-create-kubernetes-cluster-wizard) section:

1. Connect to the system where you wish to create your Kubernetes cluster and then navigate to the **Azure Kubernetes Service** tool. This system should already have an Azure Kubernetes Service host set up.

2. Select the **Add cluster** button under the **Kubernetes cluster** heading as shown in the image below:

   :::image type="content" source="media/create-kubernetes-cluster/dashboard-kubernetes-wizard.png" alt-text="Screenshot showing the Azure Kubernetes Service tool dashboard.":::

## Use the Create Kubernetes cluster wizard

This section describes how to use the Create Kubernetes cluster wizard through the Azure Kubernetes Service tool.  

1. Review the prerequisites for the system that will host the Kubernetes cluster and Windows Admin Center. When you're finished, select **Next**.

2. On the **Basics** page, configure information about your Kubernetes cluster. The Azure Kubernetes Service host field requires the fully qualified domain name of the Azure Stack HCI and Windows Server cluster that you used during the [setup process](setup.md). You must have completed the host setup for this system through the Azure Kubernetes Service tool. When you're finished, select **Next**.

    :::image type="content" source="media/create-kubernetes-cluster/basics.png" alt-text="Screenshot showing Basics cluster creation pane." lightbox="media/create-kubernetes-cluster/basics.png":::

3. Configure node pools to run your workloads on the **Node pools** page. *This step is mandatory*. You may add any number of Windows node pools and Linux node pools. If you enabled Azure Arc integration earlier in this wizard, you need to configure a Linux node pool with at least one Linux worker node. However, if you disabled Azure Arc integration earlier, then any node pool addition allows you to proceed to the next step. You can also set maximum pod counts and node taints when configuring node pools. Both of these settings are optional. For more information on the available taint settings, see [New-AksHciCluster](./reference/ps/new-akshcicluster.md#new-aks-hci-cluster-with-a-linux-node-pool-and-taints).

    ![Screenshot that illustrates the Node pools page of the Kubernetes cluster wizard where you can configure maximum pod counts and taints.](./media/create-kubernetes-cluster/node-pool-added.png)

   When you're finished, select **Next**.

4. In the **Authentication** step, select whether you'd like to enable Active Directory authentication. If you choose to enable this feature, you'll need to provide information such as your API Server service principal name, a Keytab file, and a cluster admin group or user name. When you're finished, select **Next**.

5. Specify your network configuration on the **Networking** page. You can either select an existing virtual network or create a new one by clicking on **Add network interface**. If you select the **Flannel** container network interface (CNI), keep in mind that only Windows or hybrid clusters are supported. Once **Flannel** is set, it can't be changed, and the cluster won't support any network policy. If the **Calico** CNI is selected, it isn't needed to support Calico Network Policy and Calico will be the default option for your network policy under **Security**. When complete, select **Next: Review + Create**.

    The following image illustrates the static IP configuration settings:

    [![Illustrates the Networking, static page of the Kubernetes cluster wizard.](./media/create-kubernetes-cluster/networking-static.png)](./media/create-kubernetes-cluster/networking-static.png#lightbox)

   The following image illustrates the DHCP configuration settings:

    [![Illustrates the Networking, DHCP page of the Kubernetes cluster wizard.](./media/create-kubernetes-cluster/networking-dhcp.png)](./media/create-kubernetes-cluster/networking-dhcp.png#lightbox)

6. Review your selections on the **Review + create** page. When you're satisfied, select **Create** to begin deployment. Your deployment progress will be shown at the top of this page.

7. After your deployment is complete, the **Next steps** page details how to manage your cluster. If you chose to disable the Azure Arc integration in the previous step, some of the information and instructions on this page may not be available or functional.

    [![Illustrates the successful completion of the Kubernetes cluster.](./media/create-kubernetes-cluster/deployment-complete.png)](./media/create-kubernetes-cluster/deployment-complete.png#lightbox)

## Next steps

In this quickstart, you deployed a Kubernetes cluster. To learn more about Azure Kubernetes Service on Azure Stack HCI and Windows Server and walk through how to deploy and manage Linux applications on AKS on Azure Stack HCI and Windows Server, continue to the following tutorial:

- [Tutorial: Deploy Linux applications in Azure Kubernetes Service on Azure Stack HCI and Windows Server](deploy-linux-application.md)
- [Set up multiple administrators](./set-multiple-administrators.md)
