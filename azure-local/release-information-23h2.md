---
title: Azure Local, version 23H2 and 24H2 release information
description: This article provides the release information for Azure Local, version 23H2 and version 24H2.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-local
ms.date: 05/28/2025
---

# Azure Local release information

[!INCLUDE [azure-local-end-of-support-banner-23h2](./includes/azure-local-end-of-support-banner-23h2.md)]

[!INCLUDE [azure-local-banner-resource-bridge](includes/azure-local-banner-resource-bridge.md)]

To enhance your Azure Local (formerly known as Azure Stack HCI) experience, we periodically release feature updates that introduce new capabilities and improvements. Additionally, Azure Local provides cumulative updates that include monthly quality and security enhancements. These updates are listed for each instance, ensuring your devices remain protected and productive.

To keep your Azure Local solution in a supported state, you have up to six months to install updates, but we recommend installing updates as they're released.

This article provides the release information for Azure Local, including the release build and OS build information.

## About Azure Local releases

The Azure Local includes multiple release trains: 2411, 2503, 2504, 2505, and so forth. Each release train after 2411 is either a feature build or cumulative update.

- **Feature build**: The feature update build is the initial version of the software in a release train. Feature releases go beyond quality and security fixes, incorporating product enhancements, including updates for Azure Local services and agents.

- **Cumulative build**: A cumulative update build includes the incremental updates from the most recent feature build.

The following diagram illustrates the feature builds, cumulative updates, and update paths.

:::image type="content" source="./media/release-information-23h2/release-trains-supported-update-paths.png" alt-text="Diagram illustrating Azure Local release trains with supported update paths."lightbox="./media/release-information-23h2/release-trains-supported-update-paths.png":::

## Feature release availability timing

Feature release availability dates depend on the model and SKU of the servers in your cluster.

If your cluster supports [Solution Builder Extension software updates](./update/solution-builder-extension.md), you'll receive feature release updates (for example, 2504 or 2510). These updates are available after your hardware vendor completes their validation and confirms the release is ready. This process typically takes a few weeks following the Microsoft release and varies by hardware vendor.

> [!NOTE]
> The validation process ensures a reliable update experience for your cluster. It minimizes potential issues and reduces the overall number of updates you need to manage for Azure Local.

## Update paths

### Existing deployments

For existing deployments, such as the 2411 feature build, you can update to any of the 2411 cumulative update builds. This path includes the 2411.2 and 2411.3 cumulative updates, which are required to update to the 2503 feature build. The 2503 feature build is required to update to the 2504 feature build.

Here's an example:

**Update path**: 2411 --> 2411.2 --> 2411.3 --> 2503 --> 2504

### New deployments

For new deployments, install a feature build directly. For example, you can install the 2504 build which has an OS version 261000.3775 and solution version 12.2504.1001.20. After the installation, you can install the latest cumulative update build (2505) to keep your system up to date.

<!-- ### Move to the next release train

Follow these guidelines to skip releases with the same release train as you move to the next release train:

- Update the existing deployment to a build that allows you to move to the next release train. The following table provides examples of how to move between release trains:

  | Update scenario       | Update path                             |
  |-----------------------|-----------------------------------------|
  | From 2411 to 2503     | 2411 -- 2411.2 -- 2411.3 -- 2503     |
  | From 2411 to 2504     | 2411 -- 2411.2 -- 2411.3 -- 2503 -- 2504|

### Move within the same release train

Follow these guidelines to update to each release within your current release train:

- Within your release train, you can update to the latest update build anytime. For example, if you're running the 2411 feature build, you can update to any of the 2411 cumulative update builds, such as 2411.1, 2411.2, or 2411.3.

  | Timeframe for 2411 release train     | Update path       |
  |--------------------------------------|-------------------|
  | Nov 2024                             | 2411 -- 2411.1   |
  | December 2024 or later               | 2411.1 -- 2411.2 |
  | February 2025                        | 2411.2 -- 2411.3 | -->

> [!NOTE]
> To keep your Azure Local instance in a supported state, you have up to six months to install updates. For example, if you're running the 2408 feature build, update to a later build within six months.

## Azure Local release information summary

### Supported versions of Azure Local

The following tables summarize the release information for Azure Local across all supported versions. All dates are listed in ISO 8601 format: *YYYY-MM-DD*.

Starting in 2504, we offer two releases. One release provides the path to upgrade from 2503 to 2504. The other release supports a new deployment of 2504.

Starting with Azure Local 2503, you can discover and import update packages for Azure Local with limited connectivity to Azure. For more information on how to import and discover update packages with limited connectivity, see [Update via PowerShell with limited connectivity](./update/import-discover-updates-offline-23h2.md).

#### [Existing deployments](#tab/existing-deployments)

|Version| OS Build |Security update| What's new | Known issues |
|------|-------|---------------|------------|--------------|------|
| 11.2505.1001.22 <br><br> Availability date: 2025-05-28 | 25398.1611 | [May OS security update](security-update/security-update.md?view=azloc-2505&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2505&preserve-view=true#features-and-improvements-in-2505) | [Known issues](./known-issues.md?view=azloc-2505&preserve-view=true) |
| 11.2504.1001.19 <br><br> Availability date: 2025-04-21 | 25398.1551 | [April OS security update](security-update/security-update.md?view=azloc-2504&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2504&preserve-view=true#features-and-improvements-in-2504) | [Known issues](./known-issues.md?view=azloc-2504&preserve-view=true) |
| 10.2503.0.13 <br><br> Availability date: 2025-03-31 | 25398.1486 | [March OS security update](security-update/security-update.md?view=azloc-2503&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2503&preserve-view=true#features-and-improvements-in-2503) | [Known issues](./known-issues.md?view=azloc-2503&preserve-view=true) |
| 10.2411.3.2 <br><br> Availability date: 2025-02-20 | 25398.1425 | [February OS security update](security-update/security-update.md?view=azloc-24113&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24113&preserve-view=true#features-and-improvements-in-24113) | [Known issues](./known-issues.md?view=azloc-24113&preserve-view=true) |
| 10.2411.2.12 <br><br> Availability date: 2025-02-10 | 25398.1369 | [January OS security update](security-update/security-update.md?view=azloc-24112&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24112&preserve-view=true#features-and-improvements-in-24112) | [Known issues](./known-issues.md?view=azloc-24112&preserve-view=true) |
| 10.2411.1.10 <br><br> Availability date: 2024-12-17 | 25398.1308 | [December OS security update](security-update/security-update.md?view=azloc-24111&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24111&preserve-view=true#features-and-improvements-in-24111) | [Known issues](./known-issues.md?view=azloc-24111&preserve-view=true) |

#### [New deployments](#tab/new-deployments)

|Version| OS Build |Security update| What's new | Known issues |
|------|-------|---------------|------------|--------------|
| 12.2505.1001.23 <br><br> Availability date: 2025-05-28 | 26100.4061 | [May OS security update](security-update/security-update.md?view=azloc-2505&preserve-view=true&tabs=new-deployments) | [Features and improvements](./whats-new.md?view=azloc-2505&preserve-view=true#features-and-improvements-in-2505) | [Known issues](./known-issues.md?view=azloc-2505&preserve-view=true) |
| 12.2504.1001.20 <br><br> Availability date: 2025-04-29 | 26100.3775 | [April OS security update](security-update/security-update.md?view=azloc-2504&preserve-view=true&tabs=new-deployments) | [Features and improvements](./whats-new.md?view=azloc-2504&preserve-view=true#features-and-improvements-in-2504) | [Known issues](./known-issues.md?view=azloc-2504&preserve-view=true) |

---

### Older versions of Azure Local

The following table summarizes the release information for Azure Local across older versions.

|Version| OS Build |Security update| What's new | Known issues |
|------|-------|---------------|------------|--------------|
| 10.2411.0.24 <br><br> Availability date: 2024-11-26 | 25398.1251 | [November OS security update](security-update/security-update.md?view=azloc-2411&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2411&preserve-view=true#features-and-improvements-in-2411) | [Known issues](./known-issues.md?view=azloc-2411&preserve-view=true) |
| 10.2411.0.22 <br><br> Availability date: 2024-11-14 | 25398.1251 | [November OS security update](security-update/security-update.md?view=azloc-2411&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2411&preserve-view=true#features-and-improvements-in-2411) | [Known issues](./known-issues.md?view=azloc-2411&preserve-view=true) |
| 10.2408.2.7 <br><br> Availability date: 2024-10-23 | 25398.1189 | [October OS Security update](security-update/security-update.md?view=azloc-24082&preserve-view=true) |[Features and improvements](./whats-new.md?view=azloc-24082&preserve-view=true#features-and-improvements-in-24082) | [Known issues](./known-issues.md?view=azloc-24082&preserve-view=true) |
| 10.2408.1.9 <br><br> Availability date: 2024-09-25 |  25398.1128 | [September OS Security update](security-update/security-update.md?view=azloc-24081&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24081&preserve-view=true#features-and-improvements-in-24081) | [Known issues](./known-issues.md?view=azloc-24081&preserve-view=true) |
| 10.2408.0.29 <br><br> Availability date: 2024-09-05 | 25398.1085 | [August OS security update](security-update/security-update.md?view=azloc-2408&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2408&preserve-view=true#features-and-improvements-in-2408) | [Known issues](./known-issues.md?view=azloc-2408&preserve-view=true) |
| 10.2405.3.7 <br><br> Availability date: 2024-08-20 | 25398.1085 | [August OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24053) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2405.2.7 <br><br> Availability date: 2024-07-16  | 25398.1009 | [July OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24052) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2405.1.4 <br><br> Availability date: 2024-06-19 | 25398.950 | [June OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24051) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2402.4.4 <br><br> Availability date: 2024-06-19 | 25398.950 | [June OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24024) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2405.0.24  <br><br> Availability date: 2024-05-30 | 25398.887 | [May OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-2405) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2402.3.10 <br><br> Availability date: 2024-05-21 | 25398.887 | [May OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24023) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2402.2.12 <br><br> Availability date: 2024-04-16 | 25398.830 | [April OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24022) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2311.5.6 <br><br> Availability date: 2024-04-16 | 25398.830 | [April OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-23115) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2402.1.5 <br><br> Availability date: 2024-03-20 | 25398.762 | [March OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24021) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2311.4.6 <br><br> Availability date: 2024-03-20 | 25398.762 | [March OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-23114) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2402.0.23 <br><br> Availability date: 2024-02-13 | 25398.709 | [Feb OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-2402) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2311.3.12 <br><br> Availability date: 2024-02-13 | 25398.709 | [Feb OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  |  [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-23113) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2311.2.7 <br><br> Availability date: 2024-01-09 | 25398.643 | [Jan OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-23112-ga) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |

## Next steps

- [What's new for Azure Local](./whats-new.md)