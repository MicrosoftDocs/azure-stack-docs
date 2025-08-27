---
title: Best Practices for Azure Local Update Management
description: Learn the best practices for managing updates in Azure Local.
author: alkohli
ms.topic: overview
ms.date: 08/26/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Best practices for managing updates in Azure Local

This article provides an overview of Azure Local update management and outlines the best practices and common pitfalls to help keep Azure Local secure, up to date, and compliant. This article is intended for IT decision-makers, infrastructure architects, and operations teams responsible for Azure Local deployments.

## Understand Azure Local update management

Azure Local supports update management through Azure Update Manager (AUM) and Azure Resource Manager (ARM) templates.

AUM provides centralized lifecycle management to apply, view, and manage updates across all Azure Local instances. ARM templates enable infrastructure-as-code for automating and scaling update configurations.

Staying current with security fixes and feature improvements is important for all Azure Local components. For an overview of Azure Local updates, see [About updates for Azure Local](./about-updates-23h2.md).

:::image type="content" source="./media/update-best-practices/updates.png" alt-text="Diagram that describes the key features of Azure Local update management." lightbox="./media/update-best-practices/updates.png":::

<!--Can we add a section listing risks or issues for not updating Azure Local. 
### Risks of outdated Azure Local-->

## Do's for Azure Local updates

Follow these practices to ensure smooth, reliable updates for Azure Local instances deployed at scale.

1. **Use Azure Update Manager.**
   AUM provides a centralized view to apply and manage updates across all Azure Local instances. In the Azure portal, go to **Azure Update Manager** > **Resources** > **Azure Local**.

1. **Use filters to identify Azure Local resources ready for updates.**
   Use filters like:
   - Update Readiness = Healthy
   - Status = updates available

1. **Batch updates for large environments.**
   Group clusters using:
   - Tags
   - Resource group
   - Subscription
   - Current version
   - Location
   
   Define a model where you are updating in chunks.  

1. **Test environment strategy.**
   Select a few test clusters that mirror your Azure Loal resources in production. Run the update flow to validate before applying to production.

1. **Production environment strategy.**
   - Create batches using filter parameters.
   - Start updating with the smallest batch during a maintenance window.
   - If successful, proceed to the next batch.
   - If issues arise:
      - Investigate root cause
      - Contact Microsoft support if needed
      - Apply learnings to the future batches

1. **Predownload update content to speed up update installation.**

   You can predownload update content using the following update workflows. However, container images for Azure Resource Bridge (ARB) and Azure Kubernetes Service (AKS)  aren't included in the static payload. They are downloaded automatically during the update process.

   - Prepare only workflow. See [Predownloads and check update readiness](./update-via-powershell-23h2#step-4-recommended-predownload-and-check-update-readiness).

   - Offline update workflow. See [Import and discover update packages with limited connectivity](./import-discover-updates-offline-23h2).

1. **Review known issues, logs, and use troubleshooting guides.**

   - Before applying updates review the known issues for the target version and apply any recommended mitigations.
   - If an update partially fails (for example, one node fails to update), Azure Update Manager will report the failure. Do not re-run the update blindly. Instead follow these steps:
      - Retrieve error logs. Use the **Update history** view in the Azure portal to check error details for each node.
      - Check offline logs. In disconnected scenarios, check event logs (for example, `ClusterAwareUpdating` log) on the affected node.
      - Use troubleshooting guides. Microsoft publishes troubleshooting guides for Azure Local updates. For example, steps to retry an update that stuck at a certain phase. Follow those guides to reset any update run state or clear maintenance mode if needed. Ensure the cluster is stable before retrying the update.

## Don’ts for Azure Local updates

Avoid the following practices when managing Azure Local updates, as they can lead to errors, downtime, or unsupported states.

1. **Don't update Azure Local machines individually.**

   Applying Windows updates manually, such as through Windows Admin Center or **Azure Update Manager** > **Resources** > **Machines** in an uncoordinated way can break cluster awareness and cause VM downtime. For example, you would violate the cluster-aware updating process and could bring down clustered VMs if you:

      - Install updates on all nodes at once
      - Update nodes without draining roles

   Best practice: Always initiate updates through AUM or the official Azure CLI or PowerShell methods that leverage the AUM workflow. These tools ensure compliance with the rolling update orchestration. Skipping AUM might also mean missing the readiness checks. In summary, don’t treat Azure Local like a standalone server. Use the recommended at-scale update mechanism to maintain high availability.

1. **Don’t modify cluster nodes outside approved configurations.**

   - Avoid making configuration changes on cluster nodes immediately before deployment or update as these can interfere with the automated templates. For example, before running Azure Local deployment or update templates, don't:
      - Change system time zones or region settings
      - Preinstall software updates on the nodes

   Such manual changes can cause template validation failures or inconsistent cluster state. A known issue is that certain updates applied out-of-band can cause deployment to error out.

   - Don’t make manually change nodes unless explicitly instructed by Microsoft support or official documentation. This ensures that ARM templates and update workflows can execute without unforeseen interference.

   Best practice: Always start updates with nodes in a baseline, unmodified state as per Azure’s prerequisites. In general, treat the Azure Local deployment process as authoritative.

## Next steps

- [Use Azure Update Manager to update Azure Local](./azure-update-manager-23h2.md).
- [Import and discover update packages with limited connectivity](./import-discover-updates-offline-23h2.md).
- [Troubleshoot updates](./update-troubleshooting-23h2.md).
