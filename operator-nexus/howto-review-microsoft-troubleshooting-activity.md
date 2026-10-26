---
title: Review Microsoft troubleshooting activity in Azure Operator Nexus
description: Learn where to find and review records of supported Microsoft troubleshooting actions on your Azure Operator Nexus instance.
author: matternst7258
ms.author: matthewernst
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 10/13/2026
---

# Review Microsoft troubleshooting activity

When Microsoft performs supported command-based troubleshooting actions on your Azure Operator Nexus instance, the commands and their output go to your configured storage account. You can review these records alongside the corresponding execution events in Azure Activity Log.

## What's recorded

Troubleshooting records contain the commands that you submitted, their output, and execution details such as the target resource, timestamps, and outcome. These records provide visibility into supported troubleshooting actions.

> [!IMPORTANT]
> Troubleshooting records can contain sensitive operational information. Restrict access to the storage container and manage retention according to your organization's policies.

## Find the records in your storage account

Records are saved to the default container configured in the Cluster's `commandOutputSettings.containerUrl`, using its associated managed identity. No additional storage account or managed identity is required for this capability. For configuration details, see [Cluster support for managed identities and user-provided resources](howto-cluster-managed-identity-user-provided-resources.md).

[!INCLUDE [command-output-access](includes/run-commands/command-output-access.md)]

1. In the Azure portal, open the storage account configured for your Cluster's command output.
1. Select **Storage browser**, then **Blob containers**.
1. Open the container specified in `commandOutputSettings.containerUrl`.
1. Find the troubleshooting record by its filename:

   ```text
   cluster-execute-<support-ticket-number>-YYYYMMDDTHHMMSSZ.json
   ```

   The filename contains the support ticket number and a UTC timestamp, with a literal `T` between the date and time and a trailing `Z`. For example: `cluster-execute-123-20261013T142345Z.json`.

1. Select the record and download it to review its JSON contents.

## Review the troubleshooting activity

Review the commands, their output, and the execution outcome in the downloaded record. Use its `correlationId` to associate it with the corresponding event in your Cluster's [Azure Activity Log](/azure/azure-monitor/platform/activity-log).

A record with a `Started` outcome might not yet contain the final results. Don't interpret it as proof that the commands didn't run. If an expected record or final result is missing, contact Microsoft support to investigate.
