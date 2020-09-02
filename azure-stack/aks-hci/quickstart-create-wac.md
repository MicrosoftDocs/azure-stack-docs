---
title: Create a Kubernetes cluster using Windows Admin Center
description: Learn how to create a Kubernetes cluster using Windows Admin Center
author: davannaw-msft
ms.topic: quickstart
ms.date: 09/01/2020
ms.author: dawhite
---

## Creating a new Kubernetes cluster
After you have set up your Azure Kubernetes Service host, you can create a Kubernetes cluster. Make sure you have checked the [system requirements](.\system-requirements.md) page and gone through the [Setting up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center quickstart](.\quickstart-setup-wac.md) before following this quickstart. 

Let's get started: 
1. To begin creating a Kubernetes cluster in Windows Admin Center, press the **Add** button on the gateway screen.
2. In the **Add or create resources** panel, under **Kubernetes cluster (preview)**, select **Create new** to launch the Kubernetes cluster wizard. At any point during the Kubernetes cluster create process you may exit the wizard, but note that your progress won't be saved. 

> [!NOTE] 
> While the “Add” button under Kubernetes clusters is present in the public preview, it is nonfunctional. 

![Illustrates the "Add or create resources" blade in Windows Admin Center, which now includes the new tile for Kubernetes clusters.](./media/wac-add-connection.png)

3. Review the prerequisites for the system that will host the Kubernetes cluster and those for Windows Admin Center. When finished, click **Next**. 
4. On the **Basics** page, configure information about your cluster, such as Azure Arc integration, Azure Kubernetes Service host information, and primary node pool size.  Azure Kubernetes Service host information, and primary node pool size. The Azure Kubernetes Service host field requires the fully qualified domain name of the server, failover cluster, or Azure Stack HCI cluster that you want to deploy your Kubernetes cluster to. You must have completed the host setup for this system through the Azure Kubernetes Service tool. In public preview, the node count is uneditable and will default to 2, but node size can be configured for larger workloads. When complete, click **Next**.

(picture)

> [!NOTE] 
> Azure Arc integration is not required, but it is recommended. 

5. You may configure additional node pools to run your workloads on the **Node pools** page. During public preview, you may add up to one Windows node pool and one Linux node pool (in addition to the system node pool). WHen you're finished, click **Next**.
6. Specify your network configuration on the **Networking** page. If you select "Advanced," you can customize the address range used when creating a virtual network for nodes in the cluster. If you select "Basic," virtual networks for nodes in the cluster will be created with a default address range. When complete, click **Next**.

> [!NOTE] 
> The Network Settings (load balancer, network policy, and HTTP application routing) cannot be changed in public preview.

(picture)

7. On the **Integration** page, connect your cluster with additional services, such as the Kubernetes dashboard, persistent storage, and Azure Monitor. Persistent storage is the only service that is required to configure on this page. In public preview, the persistent storage location will default to the storage location selected during host set-up. This field is currently uneditable. When you're finished, click **Next**.
8. Review your selections on the **Review + create** page. When you're satisfied, click **Create** to begin deployment. Your deployment progress will be shown at the top of this page. 
9. After your deployment is complete, the **Next steps** page details how to manage your cluster. This page also contains your SSH Key and Kubernetes dashboard token. 

(picture)

> [!NOTE] 
> If you chose to disable the Kubernetes dashboard or Azure Arc integration in the previous step, some of the information and instructions on this page may not be available or functional.
> [!IMPORTANT] 
> We recommend saving your SSH Key and Kubernetes dashboard token in a secure, accessible location.

## Next steps
In this quickstart, you set up an Azure Kubernetes Service host and deployed a Kubernetes cluster. 

To learn more about Azure Kubernetes Service on Azure Stack HCI, and walk through how to deploy and manage Linux applications on Azure Kubernetes Service on Azure Stack HCI, continue to this tutorial.
