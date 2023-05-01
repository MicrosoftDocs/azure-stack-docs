---
title: Deploy virtual machines in Azure Site Recovery on Azure Stack Hub (preview)
description: Learn how to deploy virtual machines in Azure Site Recovery on Azure Stack Hub. 
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 05/01/2023
---


# Deployment overview (preview)

To enable replication of virtual machines (VMs) across two Azure Stack Hub environments, you must configure the following environments:

- The **source** environment. The Azure Stack Hub environment in which user VMs (the actual workloads you want to protect) are running.
- The **target** environment. The environment in which the Azure Site Recovery resource provider and dependencies run.

  :::image type="content" source="media/site-recovery-deploy/target-source.png" alt-text="Diagram showing target and source architecture." lightbox="media/site-recovery-deploy/target-source.png":::

The process to install Azure Site Recovery includes actions from both the Azure Stack Hub operator and the Azure Stack Hub user:

## Operators

Operators must perform the following steps:

- Source: prepare the environment.
  - Download the **Azure Site Recovery appliance on AzureStack Hub** VM image and the respective **Azure Site Recovery – extensions** in the Azure Stack Hub Marketplace Management.
  - Ensure that Azure Stack Hub users can deploy the **ASR appliance on AzureStack Hub** VM image in their respective Azure Stack Hub user subscriptions (where the VM workloads run).
- Target: prepare the environment by installing Site Recovery services and dependencies, ensuring the right quotas are assigned to the respective plans and offers where Site Recovery will be used.

## Users

Users must perform the following steps:

- Source:
  - Deploy the **ASR appliance on AzureStack Hub** VM image in the Azure Stack Hub user subscription.
  - The user must have owner rights on each Azure Stack Hub user subscription in which they protect VM workloads.
- Target:
  - Deploy the Azure Site Recovery Vault.
  - Create the protection policies and enable the protection of the workloads.

## Next steps

For more information about configuring the source and target environments, see the following articles:

- [Deploy for source environments](site-recovery-deploy-source.md)
- [Deploy for target environments](site-recovery-deploy-target.md)
