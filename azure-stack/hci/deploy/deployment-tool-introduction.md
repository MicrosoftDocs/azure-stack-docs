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

This set of articles describe how to deploy Azure Stack HCI, version 22H2 using a new deployment tool.

> [!IMPORTANT]
 > Please review the [Terms of Use](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) and agree to the terms before you deploy this solution.

## Deployment process

Follow this process to deploy Azure Stack HCI version 22H2 in your environment:

- Select one of the validated configurations to deploy
- Read the [prerequisites for Azure Stack HCI version 22H2](deployment-tool-prerequisites.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- From a local VHDX file, [install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server.
- Install the deployment tool on the first server in your cluster
- Run the deployment tool in Windows Admin Center using either a [new configuration file](deployment-tool-new-file.md) or using an [existing configuration file](deployment-tool-existing-file.md).
- If preferred, you can [deploy using PowerShell](deployment-tool-powershell.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshooting.md).
- Also see [Known issues for Azure Stack HCI version 22H2](deployment-tool-known-issues.md).

## Validated configurations

The following cluster configurations were tested and validated for this release:

> [!IMPORTANT]
> We recommend that you use one of the validated cluster configurations for optimum results.

- A single physical server connected to a network switch. This is sometimes referred to as a single-node cluster.

- Two or four physical servers with direct (switchless) storage network connections to an L2 switch.

- Two or four physical servers with direct (switchless) storage network connections to redundant L3 switches.

- Two or four physical servers deployed using a switched storage network and redundant L3 switches.

- Two or four physical servers deployed using a fully-converged network for compute, storage, and management and with redundant L3 switches.

**Configuration 1**: The following diagram shows two physical servers with a directly connected (switchless) storage network and a single L2 switch.

:::image type="content" source="media/deployment-tool/deployment-topology-1.png" alt-text="Switched storage network with single switch configuration" lightbox="media/deployment-tool/deployment-topology-1.png":::

**Configuration 2**: The following diagram shows two physical servers with a directly connected (switchless) storage network and redundant L3 switches.

:::image type="content" source="media/deployment-tool/switchless-two-tor-switch.png" alt-text="Switchless storage network configuration" lightbox="media/deployment-tool/switchless-two-tor-switch.png":::

**Configuration 3**: The following diagram shows two physical servers with a switched storage network and redundant L3 switches.

:::image type="content" source="media/deployment-tool/deployment-topology-2.png" alt-text="Switched storage network configuration" lightbox="media/deployment-tool/deployment-topology-2.png":::

**Configuration 4**: The following diagram shows two physical servers with a fully-converged network for compute, storage, and management and with redundant L3 switches.

:::image type="content" source="media/deployment-tool/switched-converged-two-tor-switch.png" alt-text="Fully-converged network configuration" lightbox="media/deployment-tool/switched-converged-two-tor-switch.png":::

## Next step

Read the [prerequisites for Azure Stack HCI version 22H2](deployment-tool-prerequisites.md).