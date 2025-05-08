---
title: Azure Local, version 23H2 release information
description: This article provides the release information for Azure Local, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-local
ms.date: 02/19/2025
---

# Azure Local release information

[!INCLUDE [applies-to](./includes/hci-applies-to-23h2.md)]

[!INCLUDE [azure-local-banner-23h2](./includes/azure-local-banner-23h2.md)]

To enhance your Azure Local experience, we periodically release feature updates that introduce new capabilities and improvements. Additionally, Azure Local provides cumulative updates that include monthly quality and security enhancements. These updates are listed for each instance, ensuring your devices remain protected and productive.

To keep your Azure Local solution in a supported state, you have up to six months to install updates, but we recommend installing updates as they're released.

This article provides the release information for Azure Local, including the release build and OS build information.  

## About Azure Local releases

The Azure Local includes multiple release trains: 2311, 2402, 2405, 2408, and 2411. Each release train includes a feature build and subsequent cumulative updates.

- **Feature build**: The feature update build is the initial version of the software in a release train. Feature releases go beyond quality and security fixes, incorporating product enhancements, including updates for Azure Local services and agents.

- **Cumulative build**: A cumulative update build includes the incremental updates from the most recent feature build.

- **Baseline release**: A version that is available to be installed directly as part of a fresh deployment. Starting with 2408.0, every release (both feature and cumulative builds) is a baseline release.

The following diagram illustrates the release trains, their associated feature builds, and update paths.

:::image type="content" source="./media/release-information-23h2/release-trains-supported-update-paths.png" alt-text="Diagram illustrating Azure Local release trains with supported update paths."lightbox="./media/release-information-23h2/release-trains-supported-update-paths.png":::

## Feature release availability timing

Feature release availability dates depend on the model and SKU of the servers in your cluster.

If your cluster supports [Solution Builder Extension software updates](./update/solution-builder-extension.md), you'll receive feature release updates (e.g., 2504 or 2510) after your hardware vendor completes their validation and confirms the release is ready. This process typically takes a few weeks following the Microsoft release and varies by hardware vendor.

> [!NOTE]
> The validation process ensures a reliable update experience for your cluster. It minimizes potential issues and reduces the overall number of updates you need to manage for Azure Local.

### Move to the next release train

Follow these guidelines to move to the next release train:

- Update the existing deployment to a build that allows you to move to the next release train. The following table provides examples of how to move between release trains:

  | Update scenario       | Timeframe           | Update path                                      |
  |-----------------------|---------------------|--------------------------------------------------|
  | From 2402 to 2405     | May 2024            | 2402 --> 2402.3 --> 2405                         |
  | From 2402 to 2405.1   | June 2024  or later | 2402 --> 2402.4 --> 2405.1                       |
  | From 2402.3 to 2408.2 | August 2024         | 2402.3 --> 2405.0 --> 2405.3 --> 2408 --> 2408.2 |

### Move within the same release train

Follow these guidelines to move within the same release train:

- Within your release train, you can update to the latest update build anytime. For example, if you're running the 2405 feature build, you can update to any of the 2405 cumulative update builds, such as 2405.1, 2405.2, or 2405.3.

- To keep your Azure Local instance in a supported state, you have up to six months to install updates. For example, if you're running the 2405 feature build, update to a later build within six months.

## Azure Local release information summary

### Supported versions of Azure Local

The following table summarizes the release information for Azure Local across all supported versions. All dates are listed in ISO 8601 format: *YYYY-MM-DD*

|Version| OS Build |Security update| What's new | Known issues |
|------|-------|---------------|------------|--------------|
| 10.2411.3.2 <br><br> Availability date: 2025-02-20 | 25398.1425 | [February OS security update](security-update/security-update.md?view=azloc-24113&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24113&preserve-view=true#features-and-improvements-in-24113) | [Known issues](./known-issues.md?view=azloc-24113&preserve-view=true) |
| 10.2411.2.12 <br><br> Availability date: 2025-02-10 | 25398.1369 | [January OS security update](security-update/security-update.md?view=azloc-24112&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24112&preserve-view=true#features-and-improvements-in-24112) | [Known issues](./known-issues.md?view=azloc-24112&preserve-view=true) |
| 10.2411.1.10 <br><br> Availability date: 2024-12-17 | 25398.1308 | [December OS security update](security-update/security-update.md?view=azloc-24111&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24111&preserve-view=true#features-and-improvements-in-24111) | [Known issues](./known-issues.md?view=azloc-24111&preserve-view=true) |
| 10.2411.0.24 <br><br> Availability date: 2024-11-26 | 25398.1251 | [November OS security update](security-update/security-update.md?view=azloc-2411&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2411&preserve-view=true#features-and-improvements-in-2411) | [Known issues](./known-issues.md?view=azloc-2411&preserve-view=true) |
| 10.2411.0.22 <br><br> Availability date: 2024-11-14 | 25398.1251 | [November OS security update](security-update/security-update.md?view=azloc-2411&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2411&preserve-view=true#features-and-improvements-in-2411) | [Known issues](./known-issues.md?view=azloc-2411&preserve-view=true) |
| 10.2408.2.7 <br><br> Availability date: 2024-10-23 | 25398.1189 | [October OS Security update](security-update/security-update.md?view=azloc-24082&preserve-view=true) |[Features and improvements](./whats-new.md?view=azloc-24082&preserve-view=true#features-and-improvements-in-24082) | [Known issues](./known-issues.md?view=azloc-24082&preserve-view=true) |
| 10.2408.1.9 <br><br> Availability date: 2024-09-25 |  25398.1128 | [September OS Security update](security-update/security-update.md?view=azloc-24081&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24081&preserve-view=true#features-and-improvements-in-24081) | [Known issues](./known-issues.md?view=azloc-24081&preserve-view=true) |
| 10.2408.0.29 <br><br> Availability date: 2024-09-05 | 25398.1085 | [August OS security update](security-update/security-update.md?view=azloc-2408&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2408&preserve-view=true#features-and-improvements-in-2408) | [Known issues](./known-issues.md?view=azloc-2408&preserve-view=true) |
| 10.2405.3.7 <br><br> Availability date: 2024-08-20 | 25398.1085 | [August OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24053) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2405.2.7 <br><br> Availability date: 2024-07-16  | 25398.1009 | [July OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24052) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2405.1.4 <br><br> Availability date: 2024-06-19 | 25398.950 | [June OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24051) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2402.4.4 <br><br> Availability date: 2024-06-19 | 25398.950 | [June OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true)  | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-24024) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |

### Older versions of Azure Local

The following table summarizes the release information for Azure Local across older versions.

|Version| OS Build |Security update| What's new | Known issues |
|------|-------|---------------|------------|--------------|
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
