---
title: Deploy an Azure Stack HCI system using the Azure portal (preview)
description: Learn how to deploy an Azure Stack HCI system from the Azure portal (preview)
author: JasonGerend
ms.topic: how-to
ms.date: 11/11/2023
ms.author: jgerend
#CustomerIntent: As an IT Pro, I want to deploy an Azure Stack HCI system of 1-16 nodes via the Azure portal so that I can host VM and container-based workloads on it.
---

# Deploy an Azure Stack HCI, version 23H2 system using the Azure portal (preview)

This article helps you deploy an Azure Stack HCI, version 23H2 system for testing using the Azure portal.

To instead deploy Azure Stack HCI, version 22H2, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md).

## Prerequisites

* Completion of [Register your servers with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md).
<!---* Completion of [Connect servers to Arc](connect-to-arc.md)
* Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).-->
* For three-node clusters, the network adapters that carry the in-cluster storage traffic must be connected to a network switch. Deploying three-node clusters with storage network adapters that are directly connected to each server without a switch is accomplished via ARM templates and is currently in Private Preview.

## Start the wizard and fill out the basics

<!---1. Open the Azure portal and navigate to the Azure Stack HCI service (searching is an easy way) and then select **Deploy**.--->
1. Open a web browser, navigate to <https://aka.ms/IgnitePortal> and then select **Deploy cluster (preview)**.
2. Select the **Subscription** and **Resource group** in which to store this system's resources.

   All resources in the Azure subscription are billed together.
3. Enter the **Cluster name** used for this Azure Stack HCI system when Active Directory Domain Services (AD DS) was prepared for this deployment.
4. Select the **Region** to store this system's Azure resources—in this preview you must use either **(US) East US** or **(Europe) West Europe**.

   We don't transfer a lot of data so it's OK if the region isn't close.
5. Select or create an empty **Key vault** to securely store secrets for this system, such as cryptographic keys, local admin credentials, and BitLocker recovery keys.
6. Select the server or servers that make up this Azure Stack HCI system.

    :::image type="content" source="./media/deploy-via-portal/basics-tab-1.png" alt-text="Screenshot of the Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-1.png":::

7. Select **Validate**, wait for green validation checkbox to appear, and then select **Next: Configuration**.

## Specify the deployment settings

Choose whether to create a new configuration for this system or to load deployment settings from a template–either way you'll be able to review the settings before you deploy:

1. Choose the source of the deployment settings:
   * **New configuration** - Specify all of the settings to deploy this system.
   * **Template spec** - Load the settings to deploy this system from a template spec stored in your Azure subscription.
   * **Quickstart template**  - Load the settings to deploy your system from a template created by your hardware vendor or Microsoft.

    :::image type="content" source="./media/deploy-via-portal/configuration-tab-1.png" alt-text="Screenshot of the Configuration tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/configuration-tab-1.png":::
2. Select **Next: Networking**.

## Specify network settings

1. For multi-node clusters, select whether the cluster is cabled to use a network switch for the storage network traffic:
    * **No switch for storage** - For two-node clusters with storage network adapters that connect the two servers directly without going through a switch.
    * **Network switch for storage traffic** - For clusters with storage network adapters connected to a network switch. This also applies to clusters that use converged network adapters that carry all traffic types including storage.
2. Choose traffic types to group together on a set of network adapters–and which types to keep physically isolated on their own adapters.

    There are three types of traffic we're configuring:
    * **Management** traffic between this system, your management PC, and Azure; also Storage Replica traffic
    * **Compute** traffic to or from VMs and containers on this system
    * **Storage** (SMB) traffic between servers in a multi-node cluster

    Select how you intend to group the traffic:
    * **Group all traffic** - If you're using network switches for storage traffic you can group all traffic types together on a set of network adapters.
    * **Group management and compute traffic** - This groups management and compute traffic together on one set of adapters while keeping storage traffic isolated on dedicated high-speed adapters.
    * **Group compute and storage traffic** - If you're using network switches for storage traffic, you can group compute and storage traffic together on your high-speed adapters while keeping management traffic isolated on another set of adapters.

      This is commonly used for private multi-access edge compute (MEC) systems.

    * **Custom configuration** - This lets you group traffic differently, such as carrying each traffic type on its own set of adapters.

   > [!TIP]
   > If you're deploying a single server that you plan to add servers to later, select the network traffic groupings you want for the eventual cluster. Then when you add servers they automatically get the appropriate settings.
3. For each group of traffic types (known as an *intent*), select at least one unused network adapter (but probably at least two matching adapters for redundancy).

    Make sure to use high-speed adapters for the intent that includes storage traffic.
4. For the storage intent, enter the **VLAN ID** set on the network switches used for each storage network.
    :::image type="content" source="./media/deploy-via-portal/networking-tab-1.png" alt-text="Screenshot of the Networking tab with network intents in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-1.png":::

5. Allocate a block of static IP addresses on your management network to use for Azure Stack HCI and for services such as Azure Arc. Omit addresses already used by the servers.

    :::image type="content" source="./media/deploy-via-portal/networking-tab-2.png" alt-text="Screenshot of the Networking tab with IP address allocation to systems and services in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-2.png":::

6. Select **Next: Management**.

## Specify management settings

1. Optionally edit the suggested **Custom location name** that helps users identify this system when creating resources such as VMs on it.
2. Create a new **Storage account** to store the cluster witness file.
<!---2. Enter an existing **Storage account** or create a new account to store the cluster witness file.

    You can use the same storage account with multiple clusters; each witness uses less than a kilobyte of storage.
--->
3. Enter the Active Directory **Domain** you're deploying this system into.

    This must be the same fully qualified domain name (FQDN) used when the Active Directory Domain Services (AD DS) domain was prepared for deployment.
4. Enter the **Computer name prefix** used when the domain was prepared for deployment.

    This is typically the OU name.
5. Enter the **OU** created for this deployment.
   For example: ``OU=HCI01,DC=contoso,DC=com``
6. Enter the **Deployment account** credentials.

    This domain user account was created when the domain was prepared for deployment.
7. Enter the **Local administrator** credentials for the servers.

    The credentials must be identical on all servers in the system.  If the current password doesn't meet the complexity requirements, you must change it on all servers before proceeding.

    :::image type="content" source="./media/deploy-via-portal/management-tab-1.png" alt-text="Screenshot of the Management tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/management-tab-1.png":::

8. Select **Next: Security**.

## Set the security level

1. Select the security level for your system's infrastructure:
    * **Recommended security settings** - Sets the highest security settings.
    * **Customized security settings** - Lets you turn off security settings.

    :::image type="content" source="./media/deploy-via-portal/security-tab-1.png" alt-text="Screenshot of the Security tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/security-tab-1.png":::

2. Select **Next: Advanced**.

## Optionally change advanced settings and apply tags

1. Choose whether to create volumes for workloads now, saving time creating volumes and storage paths for VM images. You can create more volumes later.
    * **Create workload volumes and required infrastructure volumes (Recommended)** - Creates one thinly-provisioned volume per server for workloads to use. This is in addition to the required one infrastructure volume per server.
    * **Create required infrastructure volumes only** - Creates only the required one infrastructure volume per server.

    :::image type="content" source="./media/deploy-via-portal/advanced-tab-1.png" alt-text="Screenshot of the Advanced tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/advanced-tab-1.png":::

2. Select **Next: Tags**.
3. Optionally add a tag to the Azure Stack HCI resource in Azure.

    Tags are name/value pairs you can use to categorize resources. You can then view consolidated billing for all resources with a given tag.
4. Select **Next: Validation**.

## Validate and deploy the system

1. Review the validation results, resolve any actionable issues, and then select **Next**.

    Don't select **Try again** while validation tasks are running as doing so can provide inaccurate results in this release.
1. Review the settings that will be used for deployment and then select **Deploy** to deploy the system.

    :::image type="content" source="./media/deploy-via-portal/review-create-tab-1.png" alt-text="Screenshot of the Review + Create tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/review-create-tab-1.png":::

The **Deployments** page then appears, which you can use to monitor the deployment progress. If the progress doesn't appear, wait for a few minutes and then select **Refresh**. This page may show up as blank for an extended period of time owing to an issue in this release, but the deployment is still running if no errors show up.

Once the deployment starts, the first step in the deployment: **Begin cloud deployment** can take anywhere from 45 minutes to an hour to complete. The total deployment for a single server can take 1.5 to 2 hours and for a two server about 2.5 hours to complete.
