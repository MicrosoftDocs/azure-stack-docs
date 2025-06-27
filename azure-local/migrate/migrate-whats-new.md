---
title: What's New for Azure Migrate on Azure Local
description: Learn about new features for Azure Migrate on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 06/27/2025
ms.service: azure-local
---

# What's new for VM migration on Azure Local

This article lists the various features and improvements that are available in VM migration to Azure Local.


## May 2025

This release includes these features and improvements:

- Improved service error messages, recommended actions, and [troubleshooting guidance](./migrate-troubleshoot.md).
- Fixed a bug that shows `Not Found` errors for missing Azure Local resources.
- Updated appliance error messages to correctly identify which migrate appliance is unresponsive.
- Enabled static IP migrations to support multiple IP pools on a single logical network.


## April 2025

This release includes these features and improvements:

- **Linux VM static IP migration support** – Azure Migrate to Azure Local migrations now support preserving static IP addresses during Linux virtual machine (VM) migrations.

- **Customizable physical sector size on migrated disks** – You can now select either 512B or 4KB physical sector sizes for migrated disks, enabling better alignment with your workload and storage configuration.

- **Critical bug fixes** – Resolved several user-reported issues, including:

    - An Azure portal issue where more than 10 VMs weren't displayed on the Replication summary page.

    - A timeout bug affecting certain migrations.

- **User experience enhancements** – Multiple UX improvements were introduced to streamline migration workflows:

    - Added a banner in the **Select VMs for replication** view that explains how to enable VMs for replication.

    - Implemented a paginated **Replication Summary** view to improve performance and searchability.

- **Documentation updates** – Updated screenshots and guidance throughout the Azure Migrate documentation to reflect the latest portal UI and feature set.

## March 2025

This release includes these features and improvements:

- **Critical bug fixes (released in version 2503)** – Azure Local version 2503 includes fixes for two major issues that previously affected migrated VMs:

    - A bug that prevented cleanup of the seed ISO on generation 1 VMs, resulting in migration failure.

    - An issue where VMs failed to migrate due to a gallery image provisioning failure.

    View the full list of [Fixed issues in 2503](../known-issues.md?view=azloc-2503&preserve-view=true#fixed-issues).

- **Smarter replication experience** – Starting with this release, Azure portal automatically includes or excludes VMs from replication based on migration eligibility. This improvement reduces setup errors and simplifies replication.

- **Expanded target resource group options** – You can now create and select VM resource groups across subscriptions, not just within the Azure Local target instance's resource group, thus giving you more flexibility in how and where VMs are deployed.

    :::image type="content" source="./media/migrate-whats-new/azure-migrate-replicate.png" alt-text="Screenshot showing the Replicate screen in Azure Migrate." lightbox="./media/migrate-whats-new/azure-migrate-replicate.png":::

- **Enhanced security** – This release has backend API updates to improve the security posture of Azure Migrate to Azure Local.

- **More resilient error handling** – This release has improved handling of common failure scenarios, including:

    - Auto-cancelling Azure Arc operations that exceed expected completion times.

    - Preserving data integrity during retries of failed migrations.

- **Improved error messaging** – This release includes enhanced error messages with clearer explanations and actionable resolution steps.
