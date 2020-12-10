---
title: Quickstart to create an Azure Stack HCI cluster and register it with Azure
description: Learn how to deploy Azure Stack HCI, create a cluster using Windows Admin Center, and register it with Azure.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/10/2020
---

# Quickstart: Create an Azure Stack HCI cluster and register it with Azure

> Applies to: Azure Stack HCI, version 20H2

In this quickstart, you'll learn how to deploy a two-server, single-site Azure Stack HCI cluster and register it with Azure. For multisite deployments, see [Stretched clusters overview](../concepts/stretched-clusters.md).

## Before you start

Before creating a cluster, do the following:

* Purchase two servers from the [Azure Stack HCI Catalog](https://azure.microsoft.com/products/azure-stack/hci/catalog/) through your preferred Microsoft hardware partner with the Azure Stack HCI operating system pre-installed. Review the [system requirements](../concepts/system-requirements.md) to make sure the hardware you select will support the workloads you plan to run on the cluster. We recommend using a system with high-speed network adapters that use iWARP for simple configuration.
* Create a user account that’s a member of the local Administrators group on each server.
* [Get an Azure subscription](https://azure.microsoft.com/), if you don't already have one.
* [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) on a management PC and [register Windows Admin Center with Azure](../manage/register-windows-admin-center.md). Note that your management computer must be joined to the same Active Directory domain in which you'll create the cluster, or a fully trusted domain.
* Take note of the server names, domain names, IP addresses, and VLAN ID for your deployment.

## Create the cluster

Follow these steps to create a simple two-node, single-site cluster. For more details or to create a stretched cluster, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md).

1. In Windows Admin Center, under **All connections**, click **Add**.
1. In the **Add resources** panel, under **Windows Server cluster**, select **Create new**.
1. Under **Choose cluster type**, select **Azure Stack HCI**.
1. Under **Select server locations**, select **All servers in one site**.
1. Click **Create**. You will now see the Create Cluster wizard. If the **Credential Security Service Provider (CredSSP)** pop-up appears, select **Yes** to temporarily enable it. 

The Create Cluster wizard has five sections, each with several steps.

1. **Get started.** In this section, you'll check the prerequisites, add servers, join a domain, install required features and updates, and restart the servers. 
2. **Networking.** This section of the wizard verifies that the correct networking adapters are enabled and disables any you're not using. You'll select management adapters, set up a virtual switch configuration, and define your network by supplying IP addresses.
3. **Clustering.** This section validates that your servers have a consistent configuration and are suitable for clustering, and creates the actual cluster.
4. **Storage.** Next, you'll clean and check drives, validate your storage, and enable Storage Spaces Direct.
5. **SDN.** You can skip Section 5 because we won't be using Software Defined Networking (SDN) for this cluster.

If you enabled the CredSSP protocol in the wizard, you'll want to disable it on each server for security purposes.

1. In Windows Admin Center, under **All connections**, select the cluster you just created.
1. Under **Tools**, select **Servers**.
1. In the right pane, select the first server in the cluster.
1. Under **Overview**, select **Disable CredSSP**. You will see that the red **CredSSP ENABLED** banner at the top disappears.
1. Repeat steps 3 and 4 for the second server in the cluster.

## Set up a cluster witness

Setting up a witness resource is required so that if one of the servers in the cluster goes offline, it does not cause the other node to become unavailable as well. For this quickstart, we'll use an SMB file share located on another server as a witness. You may prefer to use an Azure cloud witness, provided all server nodes in the cluster have a reliable internet connection. For more information about witness options, see [Set up a cluster witness](witness.md).

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
1. Under **Cluster connections**, select the cluster.
1. Under **Tools**, select **Settings**.
1. In the right pane, select **Witness**.
1. For **Witness type**, select **File share witness**.
1. Specify a file share path such as **\\servername.domain.com\Witness$** and supply credentials if needed.
1. Click **Save**.

## Register with Azure

Azure Stack HCI requires a connection to Azure, and you'll need Azure Active Directory permissions to complete the registration. If you don't already have them, ask your Azure AD administrator to either grant permissions or delegate them to you. See [Connect Azure Stack HCI to Azure](register-with-azure.md) for more information. Once registered, the cluster connects automatically in the background.

## Next steps

In this quickstart, you created an Azure Stack HCI cluster and registered it with Azure. You are now ready to [Create volumes](../manage/create-volumes.md) and then [Create virtual machines](../manage/vm.md).