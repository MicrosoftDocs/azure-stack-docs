---
title:  Azure Local security book ongoing operations
description: Ongoing operations for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Ongoing operations

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

:::image type="content" source="./media/operational-security/operational-security-layer.png" alt-text="Diagram illustrating operational security layer." lightbox="./media/operational-security/operational-security-layer.png":::

Azure Local contains many individual features and components, such as OS, agents and services, drivers, and firmware. Staying up to date with recent security fixes and feature improvements is important and essential for proper operation. The update feature in Azure Local uses an orchestrator (Lifecycle Manager) which centrally manages the deployment experience for the entire system.  

The update feature offers many benefits:

- Provides a simplified, consolidated, single update management experience.
- Provides a well-tested configuration.
- Helps avoid downtime with health checks before and during an update.
- Improves reliability with automatic retry and remediation of known issues.
- Provides a common backend experience irrespective of whether the updates are managed locally or via Azure portal.

Azure Local solutions are designed to have a predictable update experience: 

- Microsoft releases monthly patch (quality and reliability) updates, quarterly baseline (features and improvements) updates, hotfixes (for critical or security issues) as needed, and solution builder extension updates (driver, firmware, and other partner content specific to the system solution used) as needed.

- To keep your Azure Local instance in a supported state, you must install updates regularly and stay current within six months of the most recent release. We recommend installing updates as and when they are released.
 
You can update your Azure Local instance either via Azure portal using Azure Update Manager or via PowerShell command line interface. For more information on how to keep your Azure Local instance up to date, read about [updates for Azure Local](../update/about-updates-23h2.md). The Cluster-Aware Updating feature orchestrates update install on each machine in the system so that your applications continue to run during the system upgrade.  
 
To regularly update virtual machines running on your Azure Local, you can use Windows Update, Windows Server Update Services, and Azure Update Management to update VMs. 

 
## Related content

- Ongoing operations
- Ongoing compliance
