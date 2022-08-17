---
title: Deploy Azure Stack HCI version 22H2 (preview) using the deployment tool
description: Learn to deploy Azure Stack HCI version 22H2 using the deployment tool
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Deploy Azure Stack HCI version 22H2 (preview) using the deployment tool

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article describes how to deploy Azure Stack HCI, version 22H2 using a new deployment method and tool.

Azure Stack HCI, version 22H2 must be installed using the local boot from VHDX method described in this article set.

> [!IMPORTANT]
 > Please review the [Terms of Use](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) and sign up before you deploy this solution.

## Tested configurations

The following three configurations were validated for this release:

> [!IMPORTANT]
> We recommend that you use one of the validated configurations for optimum results in testing.

- A single physical server connected to a network switch.

- Two physical servers with direct (switchless) network connections to each other for storage traffic.

- Two or four physical servers deployed using a fully converged network configuration connected to redundant network switches.

The following diagram shows two physical servers with a directly connected (switchless) storage network and a single L2 switch for management and cluster traffic.

:::image type="content" source="media/deployment-tool/deployment-topology-1.png" alt-text=" Two servers with switchless storage network scenario" lightbox="media/deployment-tool/deployment-topology-1.png":::

The following diagram shows two physical servers with a directly connected (switchless) storage network and redundant L3 switches for management and cluster traffic.

:::image type="content" source="media/deployment-tool/deployment-topology-2.png" alt-text="Two physical servers with switchless storage network and redundant L3 switches scenario" lightbox="media/deployment-tool/deployment-topology-2.png":::

The following diagram shows two physical servers with all network traffic traveling over a converged set of network interfaces connected to redundant L3 switches.

:::image type="content" source="media/deployment-tool/deployment-topology-3.png" alt-text="Converged network scenario 3" lightbox="media/deployment-tool/deployment-topology-3.png":::

## Deployment process

Follow this process to deploy Azure Stack HCI version 22H2 in your environment:

- Read the [prerequisites for Azure Stack HCI version 22H2](deployment-tool-prerequisites.md).
- From a VHDX file, [install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server.
- Deploy using either a [new configuration file](deployment-tool-new-file.md) or using an [existing configuration file](deployment-tool-existing-file.md) in Windows Admin Center.
- If applicable, [deploy using PowerShell](deployment-tool-powershell.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshooting.md).
- Also see [Known issues for Azure Stack HCI version 22H2](deployment-tool-known-issues.md).
