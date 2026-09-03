---
title: Update your Small Form Factor Deployments of Azure Local (preview)
description: Learn how to Update your Small Form Factor Deployment of Azure Local (preview).
author: sipastak
ms.topic: how-to
ms.date: 08/17/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Update your Azure Local small form factor deployment (preview)

This article describes how to update the software on your Azure Local small form factor instance.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## How updates work in small form factor deployments

The current release of small form factor deployments has a preview for testing the update tools. To facilitate this, Microsoft published a mock release known as **Azure Linux 2608**. To test the update feature, you must have a machine running Azure Linux with K3s installed and running.

To deploy K3s and Azure Arc-enable it, use the example from the [Azure Samples repo](https://github.com/Azure-Samples).

Updates in small form factor deployments are implemented through an A/B image-based update mechanism. This mechanism downloads a full image of the update payload, prepares it as a fresh operating system, and reboots into that system. If the mechanism detects any failures, it rolls back to the previous partition:

:::image type="content" source="media/small-form-factor-update-disk-layout.png" alt-text="Diagram of the small form factor update mechanism." border="true" lightbox="media/small-form-factor-update-disk-layout.png":::

## Preserve workloads and states during an upgrade

This release's upgrade path preserves the state required for running open source K3s. For any other workloads, including Docker, AKS Azure Arc-enabled Kubernetes on bare metal, and any non-containerized applications, you need to redeploy the workloads after an image-based upgrade finishes.

Specifically, the upgrade mechanism preserves the state that's written to:

```
/etc/rancher/k3s
/var/lib/rancher/k3s
```

And any user-defined persistent partitions outside of the standard OS partition.

## How to initiate an update

You can start an update from the Azure portal by selecting **Settings** > **Updates**.

> [!NOTE]
> The system checks for available updates every six hours. If you set up this provisioned machine less than six hours ago, you might need to wait for the automated refresh to complete before the update becomes available from the portal.

Select the **Install update** button. You should see a notification that the update was **triggered successfully**. 

## Track an update

If you started an update, you can track it under **Settings** > **Operating System** to track the status of the update. 

- If the update completes successfully, you see that all of the steps are marked as **Completed**.
- If the system encounters an issue at any point in the update process, it attempts to roll back the update and marks the update as **Failed**.
- To determine if a failed update was successfully rolled back and how to move forward, see [How rollback works](#how-rollback-works).

## How rollback works

This release includes a rollback mechanism similar to the state preservation mechanism. The update automatically rolls back if it detects an issue while bringing up the open-source K3s cluster.

When a rollback occurs, the update status is reported as **Failed**. This status indicates that the update was rolled back and the system was returned to its previous state.

To test this behavior, see the sample available in the [Azure Samples repo](https://github.com/Azure-Samples). The sample simulates a failure during K3s bring-up and triggers the rollback process.
