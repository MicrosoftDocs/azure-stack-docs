---
title: Azure Stack HCI version 22H2 deployment overview (preview)
description: Learn about the deployment methods for Azure Stack HCI, version 22H2 using the supplemental package (preview).
author: dansisson
ms.topic: overview
ms.date: 10/27/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Azure Stack HCI version 22H2 deployment overview (preview)

> Applies to: Azure Stack HCI, version 22H2

This set of articles describes how to deploy Azure Stack HCI, version 22H2 using a new deployment tool and methods.

You can deploy version 22H2 using a new or existing *config* file interactively or via PowerShell.

> [!IMPORTANT]
 > Please review the [Terms of Use](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) and agree to the terms before you deploy this solution.

## About deployment methods

You can deploy version 22H2 using one of the following methods:

- **Interactive**:  Deploy using a new config file interactively. The interactive flow provides a guided, step-by-step experience that helps you create a new configuration file which is then used to deploy and register the cluster. This method should be used when you deploy 22H2 for the first time and is recommended for most customers.
 
- **Existing configuration**: Deploy using this option if you already have a configuration file from a prior deployment. This option is  recommended when deploying multiple systems.  

- **PowerShell**: Deploy using this option if you already have a configuration file. This option is recommended for the partners and when deploying systems at-scale.


## Deployment sequence

Follow this process sequence to deploy Azure Stack HCI version 22H2 in your environment:

- Select one of the [validated network topologies](#validated-network-topologies) to deploy.
- Read the [prerequisites](deployment-tool-prerequisites.md) for Azure Stack HCI version 22H2.
- Follow the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server.
- Install and run the deployment tool interactively with a [new configuration file](deployment-tool-new-file.md) or using an [existing configuration file](deployment-tool-existing-file.md).
- If preferred, you can [deploy using PowerShell](deployment-tool-powershell.md).
- After deployment, [validate deployment](deployment-tool-validate.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).

## Validated network topologies

> [!IMPORTANT]
> We recommend that you use one of the validated network topologies for optimum results.

The following network topologies were tested and validated for this release:

- A single physical server connected to a network switch. This is sometimes referred to as a single-node cluster.

- Two physical servers with direct (switchless) storage network connections to an L2 switch.

- Two physical servers with direct (switchless) storage network connections to redundant L3 switches.

- Four physical servers with storage network connections to an L2-switch.

- Four physical servers with storage network connections to redundant L3 switches. 

<!---- Two physical servers deployed using a switched storage network and redundant L3 switches.

- Two physical servers deployed using a fully-converged network for compute, storage, and management and with redundant L3 switches.--->

**Configuration 1**: The following diagram shows two physical servers with a directly connected (switchless) storage network and a single L2 switch.

:::image type="content" source="media/deployment-tool/introduction/deployment-topology-1.png" alt-text="Diagram that shows a switched storage network with single switch configuration." lightbox="media/deployment-tool/introduction/deployment-topology-1.png":::

**Configuration 2**: The following diagram shows two physical servers with a directly connected (switchless) storage network and redundant L3 switches.

:::image type="content" source="media/deployment-tool/introduction/switchless-two-tor-switch.png" alt-text="Diagram that shows a switchless storage network configuration." lightbox="media/deployment-tool/introduction/switchless-two-tor-switch.png":::

<!---**Configuration 3**: The following diagram shows two physical servers with a switched storage network and redundant L3 switches.

:::image type="content" source="media/deployment-tool/deployment-topology-2.png" alt-text="Diagram that shows a switched storage network configuration." lightbox="media/deployment-tool/deployment-topology-2.png":::

**Configuration 4**: The following diagram shows two physical servers with a fully-converged network for compute, storage, and management and with redundant L3 switches.

:::image type="content" source="media/deployment-tool/switched-converged-two-tor-switch.png" alt-text="Diagram that shows a fully-converged network configuration." lightbox="media/deployment-tool/switched-converged-two-tor-switch.png":::--->

## Next steps

Read the [prerequisites](deployment-tool-prerequisites.md) for version 22H2.
