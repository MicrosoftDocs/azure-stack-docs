---
title: Azure Arc-enabled VMs on Azure Stack HCI FAQs
description: Find answers to the frequently asked questions (FAQs) about Azure Arc-enabled VMs on Azure Stack HCI
author: ManikaDhiman
ms.topic: reference
ms.date: 03/23/2022
ms.author: v-mandhiman
ms.reviewer: ksurjan
---

# Azure Arc-enabled VMs on Azure Stack HCI FAQs

> Applies to: Azure Stack HCI, version 21H2

Azure Stack HCI, version 21H2 enables you to use Azure portal to provision and manage on-premises Windows and Linux virtual machines (VMs) running on Azure Stack HCI clusters.

This article answers some frequently asked questions (FAQs) about Azure Arc-enabled VMs running on Azure Stack HCI clusters.

## Can I create virtual machines on a tagged vLAN?
  
vLAN tagged VMs is currently not supported.

## Can Azure Kubernetes Service on Azure Stack HCI and Azure Arc Resource Bridge co-exist on the same Azure Stack HCI cluster?

Yes. Azure Kubernetes Service on Azure Stack HCI and VM provisioning from Azure portal can be deployed on the same Arc-enabled Azure Stack HCI cluster. This requires deploying the AKS-HCI management cluster first and then Arc Resource Bridge. In this configuration, uninstalling Azure Kubernetes Service from Azure Stack HCI cluster will also remove Arc Resource Bridge.

## Can I use SDN for Azure Stack HCI VMs created from Azure portal?
  
SDN is currently not supported for VMs created from Azure portal.

## My environment does not support dynamic DNS updates, how can I successfully deploy Arc Resource Bridge?

If you cannot enable dynamic DNS updates in your DNS environment, you must pre-create records in the Active Directory and the DNS. You can create a generic cluster service in Active Directory with the name `ca-cloudagent` (or a name of your choice), but do not exceed 32 characters in length. You also need to create an associated DNS record pointing to the FQDN of the generic cluster service with the provided `cloudservicecidr` address. More details on the steps in this process can be found in the [Failover Clustering article](/windows-server/failover-clustering/prestage-cluster-adds).

## Is there a fee to use Arc management for VMs on Azure Stack HCI cluster?

VM management for Azure Stack HCI from the Azure control plane does not have any additional fees. Some VM extensions may have a fee.

## Can I use the same name for gallery image projections & will the existing VMs use the new image?

Two images with the same name will result in errors at the time of creating them. This is true for other resources as well, such as virtual networks, virtual hard disks etc. An updated image will not change existing VMs that were using it. A copy of the VM image is created at the time VM creation.

## How can I delete a gallery image?

Gallery images and all other entities can be removed from CLI or from the Azure portal. [See examples here](azure-arc-enabled-virtual-machines.md#uninstall-azure-arc-resource-bridge).

## If I delete a gallery image would all the VMs also get deleted which are deployed?

Deleting a gallery image does not affect the VMs that were created using that gallery image. The VMs will not be able to show the image name in the VM details.

## If I re-install the Arc Resource Bridge will the VMs also be re-deployed?

If an Arc Resource Bridge is deleted, then management through the Azure control plane (portal, Az CLI etc.) will be unavailable. The VMs will remain on the cluster and are only manageable through on-premises tools (Windows Admin Center, PowerShell etc.).

Re-deploying an Arc Resource Bridge will not enable Arc management of existing VMs. However, all new VMs created using the new Resource Bridge can be managed from the Azure control plane.

## What should I do if the deployment of Arc Resource Bridge did not succeed?

Please see the [Debugging section](#debugging) for common errors. If you are re-deploying the Arc Resource Bridge, please make sure to clean up the previous deployment completely following the [Uninstall procedure](#uninstall-azure-arc-resource-bridge).

## Next steps

[VM provisioning through Azure portal on Azure Stack HCI (preview)](azure-arc-enabled-virtual-machines.md)
