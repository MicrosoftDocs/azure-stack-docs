---
title: Update Settings
description: Manage Update Setting for Azure Local
author: troettinger
ms.topic: overview
ms.date: 04/12/2026
ms.author: thoroet
ms.reviewer: alkohli
ms.service: azure-local
ms.subservice: hyperconverged
---

# Manage Update Settings for Azure Local

This article provides an overview of different Azure Local update settings that control how updates are applied. Default settings provide a balanced experience of udpate run time versus potential workload impact. There are controls that allow you to fine tune and optimize the update behaviour to your servicing requirements.

## Prioritization

When updating Azure Local, virtual machines will be live migrated between cluster member machines to ensure workloads will not experienceany downtime. Live migration failures are rare but can happen, for example due to VM miss configurations like having a virtual image(ISO) attached that is stored on local storage path instead of a shared location (CSV).

The default solution setting is to ensure completing the update is prioritized over workload availability when live migrations fail. 

Using the following steps, you can change this behavior so that when live migrations fail, the update will be aborted. 

   ```PowerShell
   # Prioritize workload uptime over update completion
   Enable-UpdateSetting -Name SkipForceDrain
   ```

Confirm if the setting has been enabled running this command:

   ```PowerShell
   # Confirm setting status
   Get-UpdateSetting -Name SkipForceDrain
   ```

You can switch back to the default behavior, run the following command:

   ```PowerShell
   # Rollback to default behavior
   Disable-UpdateSetting  -Name SkipForceDrain
   ```

Confirm the feature has been disabled by running the following command:

   ```PowerShell
   # Confirm setting status
   Get-UpdateSetting -Name SkipForceDrain
   ```

## Next steps

- Learn more about [Understanding update phases](./update-phases-23h2.md)

- Review [Troubleshooting updates](./update-troubleshooting-23h2.md)

::: moniker-end

::: moniker range="<=azloc-2604"

This feature is available in Azure Local 2604 and later.

::: moniker-end