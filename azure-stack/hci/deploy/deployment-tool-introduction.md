---
title: Azure Stack HCI deployment overview (preview)
description: Learn about the deployment methods for Azure Stack HCI (preview).
author: alkohli
ms.topic: overview
ms.date: 05/30/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Azure Stack HCI deployment overview (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article is the first in the series of deployment articles that describe how to deploy Azure Stack HCI using a new deployment tool and methods.

You can deploy Azure Stack HCI using a new or existing *config* file interactively or via PowerShell.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About deployment methods

You can deploy Azure Stack HCI using one of the following methods:

- **Interactive**:  Deploy using a new config file interactively. The interactive flow provides a guided, step-by-step experience that helps you create a new configuration file which is then used to deploy and register the cluster. This method should be used when you deploy for the first time and is recommended for most customers.
 
- **Existing configuration**: Deploy using this option if you already have a configuration file from a prior deployment. This option is  recommended when deploying multiple systems.  

- **PowerShell**: Deploy using this option if you already have a configuration file. This option is recommended for the partners and when deploying systems at-scale.


## Deployment sequence

Follow this process sequence to deploy Azure Stack HCI in your environment:

- Select one of the [validated network topologies](#validated-network-topologies) to deploy.
- Read the [prerequisites](deployment-tool-prerequisites.md) for Azure Stack HCI.
- Follow the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install the English version of Azure Stack HCI, version 22H2](deployment-tool-install-os.md) on each server.
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

    **Configuration 1**: The following diagram shows two physical servers with a directly connected (switchless) storage network and a single TOR switch.
    
    :::image type="content" source="../plan/media/plan-deployment/two-node-switchless-single-switch.png" alt-text="Diagram that shows a switched storage network with single switch configuration." lightbox="../plan/media/plan-deployment/two-node-switchless-single-switch.png":::

- Two physical servers with direct (switchless) storage network connections to redundant L3 switches.

    **Configuration 2**: The following diagram shows two physical servers with a directly connected (switchless) storage network and redundant TOR switches.

    :::image type="content" source="../plan/media/plan-deployment/two-node-switchless-two-switches.png" alt-text="Diagram that shows a switchless storage network configuration." lightbox="../plan/media/plan-deployment/two-node-switchless-two-switches.png":::

- Four physical servers with storage network connections to an L2-switch.

    **Configuration 3**: The following diagram shows four physical servers using a non converged network and with storage network connections to L2 switches.

    :::image type="content" source="media/deployment-tool/introduction/four-node-non-converged-redundant-l2-switches-1.png" alt-text="Diagram that shows 4 nodes deployed using a non converged network with storage network connections to L2 network switch." lightbox="media/deployment-tool/introduction/four-node-non-converged-redundant-l2-switches-1.png":::

- Four physical servers deployed using a fully-converged network for compute, storage, and management and with redundant TOR switches.

    **Configuration 4**: The following diagram shows four physical servers using a fully converged network (for compute, management, and storage) and with storage network connections to redundant L3 switches.

    :::image type="content" source="media/deployment-tool/introduction/four-node-fully-converged-redundant-l3-switches-1.png" alt-text="Diagram that shows 4 nodes deployed using a fully converged network with storage network connections to redundant L3 network switches." lightbox="media/deployment-tool/introduction/four-node-fully-converged-redundant-l3-switches-1.png":::

<!---- Two physical servers deployed using a switched storage network and redundant L3 switches.

- Two physical servers deployed using a fully-converged network for compute, storage, and management and with redundant L3 switches.--->

<!---**Configuration 3**: The following diagram shows two physical servers with a switched storage network and redundant L3 switches.

:::image type="content" source="media/deployment-tool/deployment-topology-2.png" alt-text="Diagram that shows a switched storage network configuration." lightbox="media/deployment-tool/deployment-topology-2.png":::

**Configuration 4**: The following diagram shows two physical servers with a fully-converged network for compute, storage, and management and with redundant L3 switches.

:::image type="content" source="media/deployment-tool/switched-converged-two-tor-switch.png" alt-text="Diagram that shows a fully-converged network configuration." lightbox="media/deployment-tool/switched-converged-two-tor-switch.png":::--->

## Next steps

- Read the [prerequisites](deployment-tool-prerequisites.md) for Azure Stack HCI.
