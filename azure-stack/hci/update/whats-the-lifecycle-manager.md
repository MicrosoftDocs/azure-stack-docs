---
title:  What's the Lifecycle Manager?
description: This article describes the Lifecycle Manager and the benefits it provides for an Azure Stack HCI cluster solution.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: aaronfa
ms.lastreviewed: 03/23/2023
ms.date: 03/23/2023
---

# What's the Lifecycle Manager?

> Applies to: Azure Stack HCI, Supplemental Package.

This article describes the Lifecycle Manager and the benefits it provides for an Azure Stack HCI cluster solution.

## About the Lifecycle Manager

Azure Stack HCI solutions contain many individual features and components. Staying up to date with recent security fixes and feature improvements is important for all pieces of the Azure Stack HCI solution. Depending on which services you use, you may need to follow different processes to apply updates.

In past releases of Azure Stack HCI, like 20H2 and 21H2, the operating system (OS) was the primary component being updated. In 22H2, the Supplemental Package introduces several new features and components in addition to the OS, including the Lifecycle Manager.

The Lifecycle Manager provides centralized orchestration capabilities for Azure Stack HCI solutions. It's installed as part of and enables the new deployment experience with the management of OS, solution extension, core agents, and service content. The Lifecycle Manager supports a broad scope of updates and sets the foundation for substantial future improvements.

:::image type="content" source="media/lifecycle-manager/update-your-solution.png" alt-text="Screenshot of ways to deploy and update your solution." lightbox="media/lifecycle-manager/update-your-solution.png":::

Some new agents and services can't be updated outside the Lifecycle Manager. Availability of those updates depends on the specific feature.

## Benefits of the Lifecycle Manager

The Lifecycle Manager offers many benefits for updating your solution. Some of these benefits include:

- Simplifies update management by consolidating update workflows for various components into a single experience.

- Keeps system in a well-tested and optimal configuration.

- Avoids downtime and workload impact with comprehensive health checks before and during an update.

- Improves reliability via automatic retry and remediation of known issues.

- Common back-end drives a consistent experience whether managing locally or via the Azure portal.

## Use Cases

Here of some of the primary customer uses cases for the Lifecycle Manager.

- add another benefits

- add another benefits

- add another benefits

> [!IMPORTANT]
> If you choose to upgrade an existing Azure Stack HCI solution rather than going through Deployment, you can install the Lifecycle Manager separately. For more information, see [Installing the Lifecycle Manager on an existing Azure Stack HCI Solution](lifecycle-management-placeholder.md).

## Next steps

[What's in an update](whats-in-an-update.md)?
