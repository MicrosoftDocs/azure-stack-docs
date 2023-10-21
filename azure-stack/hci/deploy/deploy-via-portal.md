---
title: Deploy an Azure Stack HCI system using the Azure portal
description: Learn how to deploy an Azure Stack HCI system from the Azure portal
author: JasonGerend
ms.topic: how-to
ms.date: 11/11/2023
ms.author: jgerend
#CustomerIntent: As an IT Pro, I want to deploy an Azure Stack HCI system of 1-16 nodes via the Azure portal so that I can host VM and container-based workloads on it.
---

# Deploy an Azure Stack HCI, version 23H2 Preview system using the Azure portal

This article helps you deploy an Azure Stack HCI, version 23H2 Preview system using the Azure portal, assuming that you've already connected each server to Azure Arc.

To instead deploy Azure Stack HCI, version 22H2, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md).

## Prerequisites

* Azure account with an active subscription. Use the link [Create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).
* Completion of [Connect servers to Arc](connect-to-arc.md)

> [!NOTE]
> Three-node clusters with storage network adapters directly connecting all servers without a network switch aren't supported in this wizard. Support for deploying via ARM templates is in Private Preview.

## Start the wizard and fill out the basics

1. Open the Azure portal and navigate to the Azure Stack HCI service and then select **Deploy**.

   The Azure search box is an easy way to find the service.
2. Enter the subscription and resource group in which to store this system's resources.

   All resources in the Azure subscription are billed together.
3. Enter the cluster name used for this Azure Stack HCI system when Active Directory Domain Services (AD DS) was prepared for this deployment.
4. Select the Azure region to store this system's Azure resources—in this preview you must use either **EastUS** or **Western Europe**.

   We don't transfer a lot of data so it's OK if the region isn't very close.
5. Select or create an empty key vault to securely store secrets for this system, such as cryptographic keys, local admin credentials, and BitLocker recovery keys.
6. Select the server or servers you want to deploy.
7. Select **Validate**, and then **Next**.

## Specify the deployment settings

Choose whether to create a new configuration for this system or to load deployment settings from a template–either way you'll be able to review the settings before you deploy:

1. Choose the source of the deployment settings:
   * **New configuration** - Specify all of the settings to deploy this system.
   * **Template spec** - Load the settings to deploy this system from a template spec stored in your Azure subscription.
   * **Quickstart template**  - Load the settings to deploy your system from a template created by your hardware vendor or Microsoft.
2. Select **Next**.

## Specify network settings

1. For multi-node clusters, select whether to use a network switch for the storage network traffic:
    * **No switch for storage** - For two-node clusters with storage network adapters that connect the two servers directly without going through a switch.
    * **Network switch for storage traffic** - For clusters with storage network adapters connected to a network switch. This also applies to clusters that use converged network adapters that carry all traffic types including storage.
2. Choose traffic types to group together on a set of network adapters–and which types to keep physically isolated on their own adapters. The groupings are created using *intents* and the Network ATC feature:
    * **Group all traffic** - If you're using network switches for storage traffic you can group all traffic types together on a set of network adapters.
    * **Group management and compute traffic** - This groups management and compute traffic together on one set of adapters while keeping storage traffic isolated on dedicated high-speed adapters.
    * **Group compute and storage traffic** - If you're using network switches for storage traffic, you can group compute and storage traffic together on your high-speed adapters while keeping management traffic isolated on another set of adapters.

      This is commonly used for private multi-access edge compute (MEC) systems.

    * **Custom configuration** - This lets you group traffic differently, such as carrying each traffic type on its own set of adapters.

   There are three types of traffic we're configuring:
    * **Management** traffic between this system, your management PC, and Azure; also Storage Replica traffic
    * **Compute** traffic to or from VMs and containers on this system
    * **Storage** (SMB) traffic between servers in a multi-node cluster

   > [!TIP]
   > If you're deploying a single server that you plan to add servers to later, select the network traffic groupings you want for the eventual cluster. Then when you add servers they automatically get the appropriate settings.
3. For each group of traffic types, select at least one unused network adapter (but probably at least two matching adapters for redundancy). Make sure to use high-speed adapters for the group that includes storage traffic.
4. For the storage intent, enter the VLAN ID set on the network switches used for each storage network.
5. Allocate a block of static IP addresses on your management network to use for Azure Stack HCI and for services such as Azure Arc. Omit addresses already used by the servers.
6. Select **Next**.

## Specify management settings

1. Optionally enter a **custom location name** that helps users identify this system when creating resources such as VMs on it. If you leave it blank, we'll use the system name for the location name.
2. Enter an existing **storage account** or create a new account to store the cluster witness file.

    You can use the same storage account with multiple clusters; each witness uses less than a kilobyte of storage.
3. Enter the **domain** you're deploying this system into.

    This must be the same fully qualified domain name (FQDN) used when the Active Directory Domain Services (AD DS) domain was prepared for deployment.
4. Enter the **computer name prefix** used when the domain was prepared for deployment.

    This is typically the OU name.
5. Enter the **OU** created for this deployment.
   For example: ``OU=HCI01,DC=contoso,DC=com``
6. Enter the **Deployment account** credentials.

    This domain user account was created when the domain was prepared for deployment.
7. Enter the **Local administrator** credentials for the servers.

    The credentials must be identical on all servers in the system.
8. Select **Next**.

## Set the security level

1. Select the security level for your system's infrastructure:
    * **Recommended security settings** - Sets the highest security settings.
    * **Customized security settings** - Lets you turn off security settings.
2. Select **Next**.

## Optionally change advanced settings and apply tags

1. Choose whether to create volumes for workloads in addition to the required infrastructure volumes used by Azure Stack HCI. You can also create more volumes later.
    * **Create workload volumes and required infrastructure volumes (Recommended)** - Creates one thinly-provisioned volume per server for workloads to use. This is in addition to the required one infrastructure volume per server.
    * **Create required infrastructure volumes only** - Creates only the required one infrastructure volume per server.
2. Select **Next**.
3. Optionally add a tag to the Azure Stack HCI resource in Azure.

    Tags are name/value pairs you can use to categorize resources. You can then view consolidated billing for all resources with a given tag.
4. Select **Next**.

## Validate and deploy the system

1. Review the validation results, resolve any issues, and then select **Next**.
2. Review the settings that will be used for deployment and then select **Deploy** to deploy the system.