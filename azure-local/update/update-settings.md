---
title: Update Settings
description: Manage update setting for Azure Local
author: troettinger
ms.topic: overview
ms.date: 04/12/2026
ms.author: thoroet
ms.reviewer: alkohli
ms.service: azure-local
ms.subservice: hyperconverged
---

# Manage update settings for Azure Local

This article provides an overview of different Azure Local update settings that control how updates are applied. The default settings provide a balanced experience of update run time versus potential workload impact. Use the available controls to fine tune and optimize the update behavior to your servicing requirements.

## Prioritization

When updating Azure Local, the process live migrates virtual machines between cluster member machines to ensure workloads don't experience any downtime. Live migration failures are rare but can happen, for example, due to VM misconfigurations like attaching a virtual image (ISO) stored on a local storage path instead of a shared location (CSV).

The default solution setting prioritizes completing the update over workload availability when live migrations fail. 

By using the following steps, you can change this behavior so that when live migrations fail, the update process aborts.

   ```PowerShell
   # Prioritize workload uptime over update completion
   Enable-UpdateSetting -Name SkipForceDrain
   ```

To confirm if the setting is enabled, run this command:

   ```PowerShell
   # Confirm setting status
   Get-UpdateSetting -Name SkipForceDrain
   ```

To switch back to the default behavior, run the following command:

   ```PowerShell
   # Rollback to default behavior
   Disable-UpdateSetting  -Name SkipForceDrain
   ```

To confirm the feature is disabled, run the following command:

   ```PowerShell
   # Confirm setting status
   Get-UpdateSetting -Name SkipForceDrain
   ```

## Next steps

- Learn more about [Understanding update phases](./update-phases-23h2.md)

- Review [Troubleshooting updates](./update-troubleshooting-23h2.md)
