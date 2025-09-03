---
title: Best Practices for managing Azure Local Update Management
description: Learn the best practices for managing Azure Local environments.
author: alkohli
ms.topic: overview
ms.date: 09/03/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Best practices for managing Azure Local environments

This article provides an overview of Azure Local update management, including best practices and common pitfalls to help keep Azure Local secure, up to date, and compliant. It is intended for IT decision-makers, infrastructure architects, and operations teams responsible for Azure Local deployments.

## Understand Azure Local update management

Staying current with security fixes and feature improvements is important for all Azure Local components. For an overview of Azure Local updates, see [About updates for Azure Local](./about-updates-23h2.md).

Azure Local supports update management through Azure Update Manager (AUM). AUM provides centralized lifecycle management to apply, view, and manage updates across all Azure Local instances.

:::image type="content" source="./media/update-best-practices/updates.png" alt-text="Diagram that describes the key features of Azure Local update management." lightbox="./media/update-best-practices/updates.png":::

## Do's for Azure Local updates

Follow these practices to ensure smooth, reliable updates for Azure Local instances deployed at scale.

1. **Use Azure Update Manager.**

   AUM provides a centralized view to apply and manage updates across all Azure Local instances. In the Azure portal, go to **Azure Update Manager** > **Resources** > **Azure Local**.

   :::image type="content" source="./media/update-best-practices/azure-update-manager.png" alt-text="Screenshot of the Azure Update Manager displaying the Azure Local systems ready for updates. ." lightbox="./media/update-best-practices/azure-update-manager.png":::

   - **Use filters to identify Azure Local resources ready for updates.**

      Use filters like:
      - Update Readiness = Healthy
      - Status = Updates available

   - **Batch updates for large environments.**

      Group clusters using:
      - Tags
      - Resource group
      - Subscription
      - Current version
      - Location
   
      Define a model where you are updating in chunks.  

   - **Test environment strategy.**

      Select a few test clusters that mirror your Azure Loal resources in production. Run the update flow to validate before applying to production.

   - **Production environment strategy.**

      - Create batches using filter parameters.
      - Start updating with the smallest batch during a maintenance window.
      - If successful, proceed to the next batch.
      - If issues arise:
         - Investigate root cause
         - Contact Microsoft support if needed
         - Apply learnings to the future batches

1. **Predownload update content to speed up update installation.**

   You can predownload update content using the following update workflows. However, components required for Azure Resource Bridge (ARB) and Azure Kubernetes Service (AKS) aren't included in the static payload. They are downloaded automatically during the update process.

   - Prepare only workflow. See [Predownloads and check update readiness](./update-via-powershell-23h2.md#step-4-recommended-predownload-and-check-update-readiness).

   - Limited connectivity update workflow. See [Import and discover update packages with limited connectivity](./import-discover-updates-offline-23h2.md).

1. **Review known issues, logs, and use troubleshooting guides.**

   - Before applying updates review the known issues for the target version and apply any recommended mitigations.
   - If an update partially fails (for example, one node fails to update), Azure Update Manager will report the failure. Do not re-run the update blindly. Instead follow these steps:
      - Retrieve error logs. Use the **Update history** view in the Azure portal to check error details for each node.
      - Check offline logs. In disconnected scenarios, check event logs (for example, `ClusterAwareUpdating` log) on the affected node.
      - Use troubleshooting guides. Microsoft publishes troubleshooting guides for Azure Local updates. For example, steps to retry an update that stuck at a certain phase. Follow those guides to reset any update run state or clear maintenance mode if needed. Ensure the cluster is stable before retrying the update. For more information, see [Troubleshoot solution updates for Azure Local](./update-troubleshooting-23h2.md).

## Don’ts for Azure Local updates

Avoid the following practices when managing Azure Local updates, as they can lead to errors, downtime, or unsupported states.

1. **Avoid manual updates on Azure Local machines.**

   Updating Azure Local machines manually and outside of the coordinated update workflow can break cluster awareness and cause downtime. For example, applying updates to all nodes simultaneously or skipping role draining can violate cluster-aware updating process and bring down clustered VMs.

   **Best practice:** Always initiate updates through AUM, which ensures rolling updates, readiness checks, and high-availability. In summary, treat Azure Local as a clustered system and not as standalone servers.

1. **Don’t modify cluster nodes outside approved configurations.**

   Avoid making configuration changes on cluster nodes immediately before deployment or update as these can interfere with the automated templates. For example, before running Azure Local deployment or update templates, don't:

      - Change system time zones or region settings
      - Preinstall software updates on the nodes

   Such manual changes can cause template validation failures or inconsistent cluster state. A known issue is that certain updates applied out-of-band can cause deployment to error out.

## Next steps

- [Use Azure Update Manager to update Azure Local](./azure-update-manager-23h2.md).
- [Import and discover update packages with limited connectivity](./import-discover-updates-offline-23h2.md).
- [Troubleshoot updates](./update-troubleshooting-23h2.md).
