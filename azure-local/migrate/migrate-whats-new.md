---
title: What's New for Azure Migrate on Azure Local
description: Learn about new features for Azure Migrate on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/07/2025
ms.service: azure-local
---

# What's new for VM migration on Azure Local

This article lists the various features and improvements that are available in VM migration to Azure Local.

## March 2025

This release includes the following features and improvements:

- **Critical bug fixes (released in version 2503)** – Azure Local version 2503 includes fixes for two major issues that previously impacted migrated VMs:

    - A bug that prevented cleanup of the seed ISO on generation 1 VMs, resulting in migration failure.

    - An issue where VMs failed to migrate due to a gallery image provisioning failure.

    View the full list of [Fixed issues in 2503](../known-issues.md).

- **Smarter replication experience** – Starting with this release, Azure portal automatically includes or excludes VMs from replication based on migration eligibility. This improvement reduces setup errors and simplifies replication.

- **Expanded target resource group options** – You can now create and select VM resource groups across subscriptions, not just within the Azure Local target instance's resource group, thus giving you more flexibility in how and where VMs are deployed.

    :::image type="content" source="./media/migrate-whats-new/azure-migrate-replicate.png" alt-text="Screenshot showing the Replicate screen in Azure Migrate." lightbox="azure-migrate-replicate.png":::

- **Enhanced security** – This release has backend API updates to improve the security posture of Azure Migrate to Azure Local.

- **More resilient error handling** – This release has improved handling of common failure scenarios, including:

    - Auto-cancelling Azure Arc operations that exceed expected completion times.

    - Preserving data integrity during retries of failed migrations.

- **Improved error messaging** – This release includes enhanced error messages with clearer explanations and actionable resolution steps.
