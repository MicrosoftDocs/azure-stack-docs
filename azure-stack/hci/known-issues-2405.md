---
title: Release notes with fixed and known issues in Azure Stack HCI 2402.2 update release
description: Read about the known issues and fixed issues in Azure Stack HCI 2402.2 release.
author: alkohli
ms.topic: conceptual
ms.date: 05/21/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI 2405 release

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI 2405 release.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

> [!IMPORTANT]
> For information on supported updated paths for this release, see [Release information](./release-information-23h2.md#about-azure-stack-hci-version-23h2-releases).

For more information about the new features in this release, see [What's new in 23H2](whats-new.md).

## Issues for version 2405

This software release maps to software version number **2405.X.XX**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release noted issues carried over from previous versions.

## Fixed issues

Here are the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Active Directory<!--27022398--> |When deploying using a large Active Directory an issue has been addressed that can cause timeouts when adding users to the local administrator group | |
| Deployment<!--26376120--> |New ARM templates have been released for cluster creation that simplify the dependency resource creation. Including some fixes reported that address missing mandatory field | |
| Deployment<!--27101544--> |The secret rotation PowerShell command  “Set-AzureStackLCMUserPassword” supports a new parameter to skip the confirmation message.   ||
| Deployment<!--27837538--> |Improved the reliability of secret rotation when services not restarting in a timely manner.  | |
| Deployment<!--26737110--> |Fixed an issue in deployment when setting the diagnostic level in Azure and the device.   | |
| SBE<!--25093172--> |A new PowerShell command that can be used to update the SBE partner property values provided at deployment time.  | |
| SBE<!--27940543--> |Fixed an issue that prevents the update service to respond to requests after an SBE only update run.  | |
| Add server/Repair server<!--27101597--> | An issue has been fixed that prevents a node from joining Active Directory during an add server operation.  | |
| Networking<!--27285196--> |Improved the reliability of Network ATC when setting up the host networking configuration with certain network adapter types.  | |
| Networking<!--27395303--> |Improved reliability when detecting firmware versions for disk drives.  | |
| Updates<!--27230554--> |Improved the reliability of update notifications for health check results sent from the device to AUM (Azure Update Manager). In certain cases, the message size could have been too large and caused no results to be shown in AUM.  | |
| Updates<!--27689489--> |Fixed a file lock issue that can cause update failures for the trusted launch VM agent (IGVM).  | |
| Updates<!--27726586--> |Fixed an issue that prevented the orchestrator agent from being restarted during an update run.  | |
| Updates<!--27745420--> |Fixed a rare condition where it took a long time for the update service to discover or start an update. | |
| Updates<!--26805746--> |Fixed an issue for CAU (Cluster Aware Updating) interaction with the orchestrator when an update in progress is reported by CAU. | |
| Updates<!--26952963--> |Introducing an adjusted naming schema for updates that allows the identification of feature versus cumulative updates. | |
| Updates<!--27775374--> |Improved the reliability of reporting the cluster update progress to the orchestrator.  | |
| Azure Arc<!--27775374--> |Resolved an issue where the Azure Arc connection was lost when the Hybrid Instance Metadata service (HIMDS) restarted, breaking Azure portal functionality. The device will now automatically reinitiate the Azure Arc connection in these cases.  | |




## Known issues in this release

Here are the known issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Feature<!--26039754--> | Issue  |Workaround |


## Known issues from previous releases

Here are the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|


## Next steps

- Read the [Deployment overview](./deploy/deployment-introduction.md).
