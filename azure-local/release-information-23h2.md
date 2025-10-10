---
title: Azure Local, version 23H2 and 24H2 release information
description: This article provides the release information for Azure Local, version 23H2 and version 24H2.
author: alkohli
ms.author: alkohli
ms.topic: article
ms.service: azure-local
ms.date: 10/22/2025
---

# Azure Local release information

To enhance your Azure Local (formerly known as Azure Stack HCI) experience, we periodically release feature updates that introduce new capabilities and improvements. Additionally, Azure Local provides cumulative updates that include monthly quality and security enhancements. These updates are listed for each instance, ensuring your devices remain protected and productive.

This article provides the release information for Azure Local, including the release build and OS build information.

## About Azure Local releases

> [!NOTE]
> Azure Local previously followed an annual release cadence for OS and feature updates, with versions like 23H2 and 22H2. The versioning model has now changed to align with a monthly release train, like 2507, 2506. However, references to older versioning might still appear in some documentation.

The Azure Local includes multiple release trains: 2411, 2503, 2504, 2505, and so forth. Each release train after 2411 is either a feature build or cumulative update.

- **Feature build**: The feature update build is the initial version of the software in a release train. Feature releases go beyond quality and security fixes, incorporating product enhancements, including updates for Azure Local services and agents.

- **Cumulative build**: A cumulative update build includes the incremental updates from the most recent feature build.

The following diagram illustrates the feature builds, cumulative updates, and update paths.

:::image type="content" source="./media/release-information-23h2/release-trains-supported-update-paths.png" alt-text="Screenshot of Azure Local release trains with supported update paths." lightbox="./media/release-information-23h2/release-trains-supported-update-paths.png":::

## Key considerations

- Prior to the 2504 release, only one solution version was released monthly with OS build 25398.xxxx.

- Starting with the 2504 release, Microsoft releases two solution versions each month, each aligned with a specific OS build. All future updates will continue using the OS build associated with their respective solution version. The following table provides the solution versions and their associated OS builds.

  | Solution version | OS build    | Update path              | Use case        |
  |---------------------| ------------| -------------------------| ----------------|
  | 10.2xxx or 11.25xx  | 25398.xxxx  |  2411 --> 2411.2 --> 2411.3 --> 2503 --> 2504 --> 2505 --> so forth. | Use this version to update your system through each feature and cumulative build. |
  | 12.25xx  | 26100.xxxx | 2504 --> 2505 or other. |  After 2504, use this version to install any of the subsequent releases directly within a feature release train. |

- To keep your Azure Local solution in a supported state, you have up to six months to install updates. However, before installing the feature update, make sure to install the last released cumulative update. For example, before installing the 2510 feature update, you must first install the last cumulative update, which is 2509 in this case.

- Azure Arc resource bridge requires solution updates to be applied within one year. This is critical to keep certificates valid and the Azure Local VM functionality working.

- Starting with Azure Local 2503, you can discover and import update packages for Azure Local with limited connectivity to Azure. For more information on how to import and discover update packages with limited connectivity, see [Update via PowerShell with limited connectivity](./update/import-discover-updates-offline-23h2.md).

- End of support for 23H2 (OS version 25398.xxxx):
  - Each Azure Local release is supported for 6 months, whether you're on 23H2 (11.x.x.x) or 24H2 (12.x.x.x).
  - October 2025 (version 11.2510) will be the final 23H2 release. We'll support it until April 2026.
  - If you're running the 23H2 OS without the Azure Local solution, we'll support it until April 2026.
  - Stretched clusters running the 23H2 OS will be supported until April 2026. For more information, see [Upgrade stretched clusters to 23h2](./upgrade/upgrade-stretched-cluster-to-23h2.md)

  > [!NOTE]
  > After April 2026, you won't receive monthly security and quality updates for 23H2 (OS version 25398.xxxx). Support requests will only be available for patching to a supported release.

- In Azure Local 2510 you must upgrade (23H2) 11.2510.x.x to (24H2) 12.2510.x.x before you can update to the subsequent 2511 release.

## Feature release availability timing

Feature release availability dates depend on the model and SKU of the servers in your cluster.

If your cluster supports [Solution Builder Extension software updates](./update/solution-builder-extension.md), you'll receive feature release updates (for example, 2504 or 2510). These updates are available after your hardware vendor completes their validation and confirms the release is ready. This process typically takes a few weeks following the Microsoft release and varies by hardware vendor.

> [!NOTE]
> The validation process ensures a reliable update experience for your cluster. It minimizes potential issues and reduces the overall number of updates you need to manage for Azure Local.

## Azure Local release information summary

### Supported versions of Azure Local

The following tables summarize the release information for Azure Local across all supported versions. All dates are listed in ISO 8601 format: *YYYY-MM-DD*. After you upgrade your solution, you might see 10.x versions; these versions are supported.

> [!IMPORTANT]
> The new deployments of this software use the **12.2510.x.x** build. You can also update an existing deployment from 2509 using **11.2510.x.x**.

#### [OS build 25398.xxxx](#tab/OS-build-25398-xxxx)

| Solution version | OS build | Security update | What's new | Known issues |
|------|-------|---------------|------------|--------------|
| 11.2510.x.x <br><br> Availability date: 2025-10-22 | 25398.1910 | [October OS security update](security-update/security-update.md?view=azloc-25010&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2510&preserve-view=true#features-and-improvements-in-2510) | [Known issues](./known-issues.md?view=azloc-2510&preserve-view=true) |
| 11.2509.1001.21 <br><br> Availability date: 2025-09-22 | 25398.1849 | [September OS security update](security-update/security-update.md?view=azloc-2509&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2509&preserve-view=true#features-and-improvements-in-2509) | [Known issues](./known-issues.md?view=azloc-2509&preserve-view=true) |
| 11.2508.1001.51 <br><br> Availability date: 2025-08-29 | 25398.1791 | [August OS security update](security-update/security-update.md?view=azloc-2508&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2508&preserve-view=true#features-and-improvements-in-2508) | [Known issues](./known-issues.md?view=azloc-2508&preserve-view=true) |
| 11.2507.1001.9 <br><br> 10.2507.0.6 <br></br> Availability date: 2025-07-24 | 25398.1732 | [July OS security update](security-update/security-update.md?view=azloc-2507&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2507&preserve-view=true#features-and-improvements-in-2507) | [Known issues](./known-issues.md?view=azloc-2507&preserve-view=true) |
| 11.2506.1001.28 <br><br> 10.2506.0.15 <br></br> Availability date: 2025-07-02 | 25398.1665 | [June OS security update](security-update/security-update.md?view=azloc-2506&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2506&preserve-view=true#features-and-improvements-in-2506) | [Known issues](./known-issues.md?view=azloc-2506&preserve-view=true) |
| 11.2505.1001.22 <br><br> 10.2505.0.16 <br></br> Availability date: 2025-05-28 | 25398.1611 | [May OS security update](security-update/security-update.md?view=azloc-2505&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2505&preserve-view=true#features-and-improvements-in-2505) | [Known issues](./known-issues.md?view=azloc-2505&preserve-view=true) |

#### [OS build 26100.xxxx](#tab/OS-build-26100-xxxx)

| Solution version | OS build | Security update | What's new | Known issues |
|------|-------|---------------|------------|--------------|
| 12.2510.x.x <br><br> Availability date: 2025-10-22 | 26100.6887 | [October OS security update](security-update/security-update.md?view=azloc-2510&preserve-view=true&tabs=new-deployments) | [Features and improvements](./whats-new.md?view=azloc-2510&preserve-view=true#features-and-improvements-in-2510) | [Known issues](./known-issues.md?view=azloc-2510&preserve-view=true) |
| 12.2509.1001.22 <br><br> Availability date: 2025-09-22 | 26100.6584 | [September OS security update](security-update/security-update.md?view=azloc-2509&preserve-view=true&tabs=new-deployments) | [Features and improvements](./whats-new.md?view=azloc-2509&preserve-view=true#features-and-improvements-in-2509) | [Known issues](./known-issues.md?view=azloc-2509&preserve-view=true) |
| 12.2508.1001.52 <br><br> Availability date: 2025-08-29 | 26100.4946 | [August OS security update](security-update/security-update.md?view=azloc-2508&preserve-view=true&tabs=new-deployments) | [Features and improvements](./whats-new.md?view=azloc-2508&preserve-view=true#features-and-improvements-in-2508) | [Known issues](./known-issues.md?view=azloc-2508&preserve-view=true) |
| 12.2507.1001.10 <br><br> Availability date: 2025-07-24 | 26100.4652 | [July OS security update](security-update/security-update.md?view=azloc-2507&preserve-view=true&tabs=new-deployments) | [Features and improvements](./whats-new.md?view=azloc-2507&preserve-view=true#features-and-improvements-in-2507) | [Known issues](./known-issues.md?view=azloc-2507&preserve-view=true) |
| 12.2506.1001.29 <br><br> Availability date: 2025-07-02 | 26100.4349 | [June OS security update](security-update/security-update.md?view=azloc-2506&preserve-view=true&tabs=new-deployments) | [Features and improvements](./whats-new.md?view=azloc-2506&preserve-view=true#features-and-improvements-in-2506) | [Known issues](./known-issues.md?view=azloc-2506&preserve-view=true) |
| 12.2505.1001.23 <br><br> Availability date: 2025-05-28 | 26100.4061 | [May OS security update](security-update/security-update.md?view=azloc-2505&preserve-view=true&tabs=new-deployments) | [Features and improvements](./whats-new.md?view=azloc-2505&preserve-view=true#features-and-improvements-in-2505) | [Known issues](./known-issues.md?view=azloc-2505&preserve-view=true) |

---

### Older versions of Azure Local

The following table summarizes the release information for Azure Local across older versions.

| Version | OS Build | Security update | What's new | Known issues |
|------|-------|---------------|------------|--------------|
| 12.2504.1001.20 <br><br> Availability date: 2025-04-29 | 26100.3775 | [April OS security update](security-update/security-update.md?view=azloc-2504&preserve-view=true&tabs=new-deployments) | [Features and improvements](./whats-new.md?view=azloc-2504&preserve-view=true#features-and-improvements-in-2504) | [Known issues](./known-issues.md?view=azloc-2504&preserve-view=true) |
| 11.2504.1001.19 <br><br> Availability date: 2025-04-21 | 25398.1551 | [April OS security update](security-update/security-update.md?view=azloc-2504&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2504&preserve-view=true#features-and-improvements-in-2504) | [Known issues](./known-issues.md?view=azloc-2504&preserve-view=true) |
| 10.2503.0.13 <br><br> Availability date: 2025-03-31 | 25398.1486 | [March OS security update](security-update/security-update.md?view=azloc-previous&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-previous&preserve-view=true#features-and-improvements-in-2503) | [Known issues](./known-issues.md?view=azloc-previous&preserve-view=true) |
| 10.2411.3.2 <br><br> Availability date: 2025-02-20 | 25398.1425 | [February OS security update](security-update/security-update.md?view=azloc-24113&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24113&preserve-view=true#features-and-improvements-in-24113) | [Known issues](./known-issues.md?view=azloc-24113&preserve-view=true) |
| 10.2411.2.12 <br><br> Availability date: 2025-02-10 | 25398.1369 | [January OS security update](security-update/security-update.md?view=azloc-24112&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24112&preserve-view=true#features-and-improvements-in-24112) | [Known issues](./known-issues.md?view=azloc-24112&preserve-view=true) |
| 10.2411.1.10 <br><br> Availability date: 2024-12-17 | 25398.1308 | [December OS security update](security-update/security-update.md?view=azloc-24111&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24111&preserve-view=true#features-and-improvements-in-24111) | [Known issues](./known-issues.md?view=azloc-24111&preserve-view=true) |
| 10.2411.0.24 <br><br> Availability date: 2024-11-26 | 25398.1251 | [November OS security update](security-update/security-update.md?view=azloc-2411&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2411&preserve-view=true#features-and-improvements-in-2411) | [Known issues](./known-issues.md?view=azloc-2411&preserve-view=true) |
| 10.2411.0.22 <br><br> Availability date: 2024-11-14 | 25398.1251 | [November OS security update](security-update/security-update.md?view=azloc-2411&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-2411&preserve-view=true#features-and-improvements-in-2411) | [Known issues](./known-issues.md?view=azloc-2411&preserve-view=true) |
| 10.2408.2.7 <br><br> Availability date: 2024-10-23 | 25398.1189 | [October OS Security update](security-update/security-update.md?view=azloc-24082&preserve-view=true) | [Features and improvements](./whats-new.md?view=azloc-24082&preserve-view=true#features-and-improvements-in-24082) | [Known issues](./known-issues.md?view=azloc-24082&preserve-view=true) |
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

## Next steps

- [What's new for Azure Local](./whats-new.md).
