---
title: Azure Stack HCI, version 23H2 release information
description: This article provides the release information for Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 03/15/2024
---

# Azure Stack HCI, version 23H2 release information

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

Feature updates for Azure Stack HCI are released periodically to enhance customer experience. To keep your Azure Stack HCI service in a supported state, you have up to six months to install updates, but we recommend installing updates as they are released.

Azure Stack HCI also releases monthly quality and security updates. These releases are cumulative, containing all previous updates to keep devices protected and productive.

This article presents the release information for Azure Stack HCI, version 23H2, including the release build and OS build information.  

## Azure Stack HCI, version 23H2 release information summary

The following table provides a summary of Azure Stack HCI, version 23H2 release information.

All dates are listed in ISO 8601 format: *YYYY-MM-DD*

|Release build| OS build |Baseline/Update <sup>1<sup>| What's new | Known issues |
|--|--|--|--|--|--|
| 10.2402.1.XX | 25398.762  <br><br> [OS security update]() <br><br> Availability date: 2024-03-19 | Update | [Features and improvements](./whats-new.md#features-and-improvements-in-2402) | [Known issues](./known-issues-2402-1.md) |
| 10.2311.4.XX | 25398.762  <br><br> [OS security update]() <br><br> Availability date: 2024-03-19 | Update | [Features and improvements](./whats-new.md#features-and-improvements-in-23113) | [Known issues](./known-issues-23113.md) |
| 10.2402.0.23 | 25398.709  <br><br> [KB 5034769](https://support.microsoft.com/en-us/topic/february-13-2024-security-update-kb5034769-07d43f22-f26e-42e5-999c-66dfb7af4253) <br><br> Availability date: 2024-02-13 | Baseline | [Features and improvements](./whats-new.md#features-and-improvements-in-2402) | [Known issues](./known-issues-2402.md) |
| 10.2311.3.12 | 25398.709  <br><br> [KB 5034769](https://support.microsoft.com/en-us/topic/february-13-2024-security-update-kb5034769-07d43f22-f26e-42e5-999c-66dfb7af4253) <br><br> Availability date: 2024-02-13 | Update | [Features and improvements](./whats-new.md#features-and-improvements-in-23113) | [Known issues](./known-issues-2311-3.md) |
| 10.2311.2.7 | 25398.643  <br><br> [KB 5034130](https://support.microsoft.com/topic/92a8b0fe-82f7-4c64-a9d8-7295ed6b9a06) <br><br> Availability date: 2024-01-09| Update | [Features and improvements](./whats-new.md#features-and-improvements-in-23112-ga) | [Known issues](./known-issues-2311-2.md) |
| 10.2311.0.26 | 25398.531 <br><br> [KB 5032202](https://support.microsoft.com/topic/9981de59-9fae-4118-a636-131a8dd4a013) <br><br> Availability date: 2023-11-14| Baseline | [Features and improvements](./whats-new.md#features-and-improvements-in-2311) | [Known issues](./known-issues-2311.md) |
| 10.2310.0.30 | 25398.469| Baseline | [Features and improvements](./whats-new.md#features-and-improvements-in-2311) | [Known issues](./known-issues-2310.md) |

<sup>1</sup> A **Baseline** build is the initial version of the software that you must deploy before upgrading to the next version. An **Update** build includes incremental updates from the most recent **Baseline** build. To deploy an **Update** build, it's necessary to first deploy the previous **Baseline** build.

## Next steps

- [What's new for Azure Stack HCI, version 23H2](./whats-new.md)