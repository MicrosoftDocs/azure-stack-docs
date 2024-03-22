---
title: Azure Stack HCI, version 23H2 release information
description: This article provides the release information for Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 03/20/2024
---

# Azure Stack HCI, version 23H2 release information

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

Feature updates for Azure Stack HCI are released periodically to enhance customer experience. Azure Stack HCI also releases monthly quality and security updates. These releases are cumulative, containing all previous updates to keep devices protected and productive.

To keep your Azure Stack HCI solution in a supported state, you have up to six months to install updates, but we recommend installing updates as they're released.

This article presents the release information for Azure Stack HCI, version 23H2, including the release build and OS build information.  

## About Azure Stack HCI, version 23H2 releases

The Azure Stack HCI, version 23H2 includes multiple release trains: 2306 (limited release), 2311, and 2402. Each release train includes a baseline build and subsequent updates. 

- **Baseline build**: The baseline build is the initial version of the software on a release train. Before you upgrade to the next version on the same train, you must deploy the baseline build. 
- **Update build**: An update build includes the incremental updates from the most recent baseline build. 

The following diagram illustrates the release trains, their associated baseline builds, and update paths.

:::image type="content" source="./media/release-information-23h2/release-trains-supported-update-paths.png" alt-text="Diagram illustrating Azure Stack HCI, version 23H2 release trains with supported update paths."lightbox="./media/release-information-23h2/release-trains-supported-update-paths.png":::

#### Move to the next release train

Follow these guidelines to move to the next release train:

- Deploy the baseline build for that release train. For example, to move from the 2311 release train to the 2402 release train, you must first deploy the 2402 baseline build.
- Consider a fresh deployment with the 2402 baseline build or update the existing deployment. You can get to 2402 baseline build from either 2311.3 or 2311.4 update build.

#### Move within the same release train

Follow these guidelines to move within the same release train:

- Within your release train, you can update to the latest update build any time. For example, if you're running the 2311 baseline build, you can update to any of the 2311 update builds such as 2311.2, 2311.3, or 2311.4, and so on.

- To keep your Azure Stack HCI in a supported state, you have up to six months to install updates. For example, if you're running the 2311 baseline build, update to a later build within 6 months.

## Azure Stack HCI, version 23H2 release information summary

The following table provides a summary of Azure Stack HCI, version 23H2 release information.

All dates are listed in ISO 8601 format: *YYYY-MM-DD*

|Release build| OS build |Baseline/Update <sup>1</sup>| What's new | Known issues |
|--|--|--|--|--|
| 10.2402.1.XX | 25398.762  <br><br> [March OS security update](./security-update/hci-security-update-mar-2024.md) <br><br> Availability date: 2024-03-20 | Update | [Features and improvements](./whats-new.md#features-and-improvements-in-24021) | [Known issues](./known-issues-2402-1.md) |
| 10.2311.4.XX | 25398.762  <br><br> [March OS security update](./security-update/hci-security-update-mar-2024.md) <br><br> Availability date: 2024-03-20 | Update | [Features and improvements](./whats-new.md#features-and-improvements-in-23114) | [Known issues](./known-issues-2311-3.md) |
| 10.2402.0.23 | 25398.709  <br><br> [Feb OS security update](./security-update/hci-security-update-feb-2024.md) <br><br> Availability date: 2024-02-13 | Baseline | [Features and improvements](./whats-new.md#features-and-improvements-in-2402) | [Known issues](./known-issues-2402.md) |
| 10.2311.3.12 | 25398.709  <br><br> [Feb OS security update](./security-update/hci-security-update-feb-2024.md) <br><br> Availability date: 2024-02-13 | Update | [Features and improvements](./whats-new.md#features-and-improvements-in-23113) | [Known issues](./known-issues-2311-3.md) |
| 10.2311.2.7 | 25398.643  <br><br> [Jan OS security update](./security-update/hci-security-update-jan-2024.md) <br><br> Availability date: 2024-01-09| Update | [Features and improvements](./whats-new.md#features-and-improvements-in-23112-ga) | [Known issues](./known-issues-2311-2.md) |
| 10.2311.0.26 | 25398.531 <br><br> [Nov OS security update](./security-update/hci-security-update-nov-2023.md) <br><br> Availability date: 2023-11-14| Baseline | [Features and improvements](./whats-new.md#features-and-improvements-in-2311) | [Known issues](./known-issues-2311.md) |
| 10.2310.0.30 | 25398.469| Baseline | [Features and improvements](./whats-new.md#features-and-improvements-in-2311) | [Known issues](./known-issues-2310.md) |

<sup>1</sup> A **Baseline** build is the initial version of the software that you must deploy before upgrading to the next version. An **Update** build includes incremental updates from the most recent **Baseline** build. To deploy an **Update** build, it's necessary to first deploy the previous **Baseline** build.

## Next steps

- [What's new for Azure Stack HCI, version 23H2](./whats-new.md)