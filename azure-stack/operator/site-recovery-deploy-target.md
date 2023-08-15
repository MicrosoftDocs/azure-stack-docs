---
title: Deploy virtual machines to target environments in Azure Site Recovery on Azure Stack Hub (preview)
description: Learn how to deploy virtual machines to targets in Azure Site Recovery on Azure Stack Hub. 
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 03/10/2023
---


# Deploy for target environments (preview)

This article describes the actions that are required to complete the installation of the target environment.

> [!IMPORTANT]
> Azure Site Recovery on Azure Stack Hub requires the Azure Stack Hub 2301 update build number to be at least 1.2301.2.58.

## Prerequisites

In the target environment, Azure Site Recovery requires the Azure Stack Hub operator to install the **Azure Site Recovery - dependency service**. Once this service is installed, you can install the Azure Site Recovery service itself.

> [!NOTE]
> With Microsoft.SiteRecovery-1.2301.2216.2287, Azure Site Recovery on Azure Stack Hub does not require Event Hubs as a dependency.

For the installation of these services, you must obtain 2 public key infrastructure (PKI) SSL certificates. The Subject Alternative Name (SAN) must adhere to the naming pattern described in [PKI certificate requirements](azure-stack-pki-certs.md). The following 2 certificates are required:

1. For Azure Site Recovery dependency service: `*.servicebus.<region>.<fqdn>`.
1. For Azure Site Recovery service: `rp.asr.<region>.<fqdn> or *.asr.<region>.<fqdn>`.

:::image type="content" source="media/site-recovery-deploy-target/certificates.png" alt-text="Screenshot of certificates selection picker." lightbox="media/site-recovery-deploy-target/certificates.png":::

Once these 2 certificates are ready, installation on the target requires that you download each of these images from Marketplace Management, and start each respective installation.

## Download and install packages

Before installing or updating a resource provider, you must download the required packages to the Azure Stack Hub Marketplace Management. The
download process varies, depending on whether your Azure Stack Hub instance is connected to the Internet, or disconnected.

> [!NOTE]
> The download process can take 30 minutes to 2 hours, depending on the network latency and existing packages on your Azure Stack Hub instance.

First, install the **Azure Site Recovery - dependency service** - there is no special configuration required.

### Disconnected scenario

For a disconnected or partially connected scenario, download the packages to your local machine, then import them into your Azure Stack
Hub Marketplace:

1. Follow the instructions in [Download Marketplace items - Disconnected or partially connected scenario](/azure-stack/operator/azure-stack-download-azure-marketplace-item?pivots=state-disconnected). Download and run the Marketplace Syndication tool, which enables you to download resource provider packages.
1. After the **Azure Marketplace Items** syndication tool window opens, find and select the name of the resource provider to download the required packages to your local machine.
1. Once the download finishes, import the packages to your Azure Stack Hub instance and publish to the Marketplace.

### Connected scenario

For a connected scenario, download the items from Azure Marketplace directly to the Azure Stack Hub Marketplace:

1. Sign in to the Azure Stack Hub administrator portal.
1. Select **Marketplace Management** on the left-hand side.
1. Select **Resource providers**.
1. Select + **Add from Azure**.
1. Search for **Azure Site Recovery – dependency service** and the **Azure Site recovery** resource provider using the search bar.

   :::image type="content" source="media/site-recovery-deploy-target/target-add-from-azure.png" alt-text="Screenshot of target's add from Azure screen." lightbox="media/site-recovery-deploy-target/target-add-from-azure.png":::

1. Download both resource providers.
1. Once both resource providers are downloaded, select each of them and start the installation of the prerequisites, and then the resource provider itself. You are asked for the certificates you generated in the prerequisites section.

   :::image type="content" source="media/site-recovery-deploy-target/install-prerequisites.png" alt-text="Screenshot of portal install prerequisites screen." lightbox="media/site-recovery-deploy-target/install-prerequisites.png":::

1. The installation of each resource provider (**Azure Site Recovery - dependency service** and **Azure Site Recovery**) usually takes 1.5 hours to complete.

   :::image type="content" source="media/site-recovery-deploy-target/resource-providers-installed.png" alt-text="Screenshot of installed resource providers from portal." lightbox="media/site-recovery-deploy-target/resource-providers-installed.png":::

## Create plans and offers

Once Azure Site Recovery on Azure Stack Hub and its dependencies are installed, the next step is to ensure that users have the correct offers assigned to their respective Azure Stack Hub user subscriptions.

The process is similar to [Create an offer in Azure Stack Hub](azure-stack-create-offer.md), and you must add the respective **Microsoft.DataReplication** service to the plan you intend to use. This can be either a plan to a new offer, or used as an add-on to an
existing offer:

:::image type="content" source="media/site-recovery-deploy-target/add-new-plan.png" alt-text="Screenshot showing new plans added." lightbox="media/site-recovery-deploy-target/add-new-plan.png":::

The **Microsoft.DataReplication** service does not enforce any quotas. Instead, you can rely on the existing quotas (for VM, Compute,
Storage, and so on) to ensure that users can create whatever resources they are allowed to create, conforming with the capacity planning in
place.

## Azure Stack Hub user subscription

After the installation of the Azure Site Recovery resource provider and the assignment of the correct plans to the Azure Stack Hub user subscriptions, the owner of this user subscription must do the following:

- Make sure the subscription has the following namespaces registered: **Microsoft.DataReplication, Microsoft.Compute, Microsoft.Storage, Microsoft.Network, Microsoft.KeyVault**.

  :::image type="content" source="media/site-recovery-deploy-target/resource-providers.png" alt-text="Screenshot showing registered resource providers." lightbox="media/site-recovery-deploy-target/resource-providers.png":::

- Once these are configured, the users of this subscription are ready to create an Azure Site Recovery Vault and start protecting workloads.

## Create the Site Recovery Vault

In the target environment, in the Azure Stack Hub user subscription in which you plan to protect workloads, the user must create a Site Recovery Vault. A vault is a storage entity in the Azure Stack Hub target environment that contains data. The data are typically copies of data, or configuration information for VMs.

To create a new vault, open the Azure Stack Hub user portal, select **Create new resource**, and then select the Azure Site Recovery items in
the **Compute** category:

:::image type="content" source="media/site-recovery-deploy-target/create-a-resource.png" alt-text="Screenshot of create a resource screen." lightbox="media/site-recovery-deploy-target/create-a-resource.png":::

Provide a resource group and a name for the new recovery vault. Once created, you can open the vault to access the properties required in the Site Recovery VM appliance. In the recovery vault, you can either select **Protect Workload** or on the left-hand side, select the **Replicated items** blade.

:::image type="content" source="media/site-recovery-deploy-target/vault-dashboard.png" alt-text="Screenshot showing vault options." lightbox="media/site-recovery-deploy-target/vault-dashboard.png":::

In the **Replicated items** blade, you can select **Set up a new replication appliance**. This provides a registration key that you can use to configure the Site Recovery VM appliance (in the source environment):

:::image type="content" source="media/site-recovery-deploy-target/new-appliance.png" alt-text="Screenshot showing new appliance setup on portal." lightbox="media/site-recovery-deploy-target/new-appliance.png":::

With this key you are ready to start the deployment source environment and configure the Azure Site Recovery VM appliance.

## Next steps

- Azure Site Recovery overview
