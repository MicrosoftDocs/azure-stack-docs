---
title: Troubleshoot a Log Analytics workspace warning in Azure Operator Nexus
description: Diagnose a cluster Log Analytics workspace warning and check workspace access, resource operation status, and telemetry ingestion separately.
author: matternst7258
ms.author: matthewernst
ms.service: azure-operator-nexus
ms.topic: troubleshooting
ms.custom: troubleshooting
ms.date: 11/09/2026
ai-usage: ai-generated
---

# Troubleshoot a Log Analytics workspace warning in Azure Operator Nexus

This article helps you investigate a Log Analytics workspace (LAW) warning on an Azure Operator Nexus cluster, including after a cluster management upgrade.

## Symptoms

Your cluster reports a warning about its Log Analytics workspace while its detailed status is `Running`. These signals describe different aspects of the cluster. `Running` doesn't establish that workspace access is healthy or that the warning is stale.

Check three outcomes separately: whether the warning clears, whether the resource operation completes, and whether expected cluster telemetry arrives. A cleared warning and a `Running` detailed status don't establish that an update completed. For example, `provisioningState` can still be `Accepted`.

## Prerequisites

- Ensure you have read access to the affected Operator Nexus cluster and its configured workspace and managed identity.
- Ensure you have permission to query the relevant workspace data to verify ingestion. Your own query access is separate from the cluster identity's workspace access.
- Use the Azure portal. For the optional read-only command, use Azure CLI with the [Network Cloud extension](howto-install-cli-extensions.md).
- Before a portal tag change, obtain authorization to update the cluster resource and approval under your organization's change process. Read access alone isn't sufficient. See [Required access for tags](/azure/azure-resource-manager/management/tag-resources#required-access). Don't assume that the Tag Contributor role alone permits tagging a resource through the portal.

## Capture the current status

1. In the Azure portal, open the affected Operator Nexus cluster resource. Confirm the subscription, resource group, and cluster name.
1. Record the full warning text, detailed status, provisioning state, and UTC observation time. Retain the resource JSON, including workspace settings, identity configuration, and any available validation or operation details.
1. Review the cluster's **Activity log** for the management upgrade and subsequent updates. Confirm that the subscription and resource scope match the affected cluster, and select the relevant time range. Record relevant operation and correlation IDs. Missing entries don't prove that processing stopped.

Alternatively, retrieve the full cluster response with this read-only command. Replace the placeholders with your resource details.

```azurecli
az networkcloud cluster show --subscription "<subscription-id>" --resource-group "<cluster-resource-group>" --name "<cluster-name>" --output json
```

For command details, see [az networkcloud cluster show](/cli/azure/networkcloud/cluster#az-networkcloud-cluster-show). This command reads status; it doesn't repair the warning or test ingestion.

## Check the workspace and configured identity

1. Confirm that the workspace referenced by the cluster exists and that its resource ID identifies the intended subscription, resource group, and workspace.
1. Review `analyticsOutputSettings` and the cluster's identity configuration. Identify the managed identity selected for workspace access. If the settings select a user-assigned managed identity, check that identity rather than assuming the cluster's system-assigned identity is used.
1. Check that the selected identity has the required workspace permissions. The [managed identity configuration guidance](howto-cluster-managed-identity-user-provided-resources.md) documents the `Log Analytics Contributor` role on the workspace. Have an authorized administrator correct missing access at the appropriate scope.
1. Review any available validation messages for missing resources, identity errors, access denial, or service failures. Follow [Azure prerequisites validation troubleshooting](troubleshoot-azure-prerequisites-validation.md) for the applicable error.

Validation conditions and identity settings depend on the API version and configuration. If conditions such as `AzurePrerequisitesReady` or `AzureLogAnalyticsReady` aren't returned, their absence doesn't prove that validation succeeded. Don't change API versions or identity types just to match an example.

Resolve any identified workspace or access failure before considering a tag change. A tag change doesn't grant permissions or repair an unavailable workspace.

## Check resource operation status

Review `provisioningState` separately from `detailedStatus` and the warning message. If an update is still pending, investigate its status before submitting another change. `Accepted` doesn't establish successful completion, but it doesn't by itself establish that processing is stuck or identify a cause.

If you retained an `Azure-AsyncOperation` or `Location` URL from the original operation response, use the read-only status check described in [Track asynchronous operations](howto-track-async-operations-cli.md). Use the actual returned URL; don't construct one from an example or repeat an update just to obtain it. If you don't have an operation URL, retain the resource status and available Activity log details for support.

## Attempt a portal tag change

A LAW warning has been reported to clear following a cluster tag change through the Azure portal after a cluster management upgrade. That sequence alone doesn't prove causation or establish that a tag update triggers workspace revalidation. It also doesn't establish that the resource update completed or telemetry ingestion recovered.

This attempt changes the cluster resource; it isn't a risk-free status refresh. A tag change can be associated with an update that remains pending or conflicts with another operation.

Consider this attempt only if the cluster is `Running`, no unresolved workspace or access failure was identified, and no update remains pending. If you can't establish operation completion, contact support rather than submitting another change.

> [!IMPORTANT]
> Preserve every existing tag and coordinate with anyone or any automation updating the resource. Tags can affect policy, billing, and automation. Don't overwrite an existing key or use a key that drives automation. Don't remove resource locks or bypass policy to perform this attempt.
>
> An additional write can conflict with an operation already in progress. Don't submit another tag change while an update is pending or its completion is uncertain.

1. Review the cluster's current tags and applicable [tag limits](/azure/azure-resource-manager/management/tag-resources#limitations), policies, and resource locks. If a safe tag change isn't permitted, stop and contact support.
1. With the resource owner, choose an unused, policy-permitted tag name and a nonsensitive value. Tag names are case-insensitive. Don't include credentials or personal information. If the tag limit is reached, don't delete existing tags to make room.
1. On the cluster resource's **Overview** page, select **Add tags**, or **change** to edit existing tags, as described in [Apply tags with the Azure portal](/azure/azure-resource-manager/management/tag-resources-portal). Confirm that you're editing the cluster itself, not its resource group or cluster manager.
1. Retain all existing name-value pairs and add only the agreed tag. Refresh and review the current tags before editing; if another writer changes them during the attempt, stop and reconcile with that writer before saving.
1. Select **Save**. If the save fails, capture the error and don't treat the attempt as successful. If you receive a conflict error, don't retry the write or toggle tags. Recheck the existing operation and provisioning state, and contact support if completion remains uncertain. After a successful save, reload the resource and verify that the new tag is present and all existing tags remain unchanged. A successful save doesn't establish completion of the cluster update; continue with the separate checks in the next section.

Don't substitute a one-tag `az networkcloud cluster update --tags` command: that option replaces all existing tags. The generic `az tag update --operation Merge` operation isn't established as an equivalent trigger for this warning. Don't repeatedly toggle tags to force a result.

## Verify all three outcomes

1. **Warning clearance:** Refresh the cluster resource or repeat the read-only cluster command. Record the UTC time and full warning text. A successful tag save alone doesn't establish that the warning cleared. There isn't a guaranteed warning-clearance delay for this attempt.
1. **Resource operation completion:** Check the provisioning state and any available operation status. Don't interpret `Running` or an absent LAW warning as `Succeeded`. If the update remains pending across status checks, retain its details and contact support rather than repeating tag changes. No fixed completion time is established for this attempt.
1. **Telemetry ingestion:** In the intended workspace, use your existing queries or workbooks to check for recent telemetry from the affected cluster. Select the expected data source and time range, and filter for that cluster using the identifiers available in your data. Data from another cluster or older records doesn't demonstrate current ingestion. Check collection and destination settings for the specific telemetry you expect. See [Azure Operator Nexus observability](concepts-observability.md).

If the warning clears but an update remains pending or expected telemetry is missing, continue investigating those outcomes separately. If telemetry is current but the warning persists, retain that evidence for support rather than assuming the warning is harmless.

Don't patch conditions, delete secrets, reinstall healthy extensions, or restart the cluster manager as routine fixes for this warning.

## Escalate unresolved issues

If the warning persists, an update remains pending, updates conflict, the tag update fails, or workspace access or ingestion remains unhealthy, [open an Azure support request](https://portal.azure.com/?#blade/Microsoft_Azure_Support/HelpAndSupportBlade). Provide cluster and workspace resource IDs, UTC observation times, exact warning and error messages (including conflict errors), relevant operation or correlation IDs, and before-and-after warning, provisioning state, and operation status. Describe any tag change and the cluster-specific ingestion checks you performed.

Share diagnostic details through the support request, not a public issue. Don't include workspace keys, access tokens, passwords, or other credentials.

## Related content

- [Configure cluster managed identities and user-provided resources](howto-cluster-managed-identity-user-provided-resources.md).
- [Troubleshoot Azure prerequisites validation](troubleshoot-azure-prerequisites-validation.md).
- [Track asynchronous operations](howto-track-async-operations-cli.md).
- [Understand Azure Operator Nexus observability](concepts-observability.md).
