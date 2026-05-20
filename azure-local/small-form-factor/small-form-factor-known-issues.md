---
title: Known Issues for Small Form Factor Deployments of Azure Local (preview)
description: Read about the known issues and fixed issues for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: concept-article
ms.date: 05/20/2026
ms.author: sipastak
---

# Known issues for small form factor deployments of Azure Local (preview)

This article lists the known issues and limitations for small form factor deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Known issues in version 2604

The following known issues apply to Azure Local Small Form Factor deployments running version 2604.

| Feature area | Issue | Impact | Workaround |
|---|---|---|---|
| Subscription setup | New required resource providers were added since the last release. | Deployment can fail if the required providers aren't registered. | Validate your subscription against the current required provider list before deployment. |
| Subscription policy | Azure policies that restrict publicly accessible storage accounts can block deployment. | Provisioned machine creation can fail during storage account-related steps. | If you hit storage account errors, review subscription policies that restrict publicly accessible storage accounts. |
| ROE install | NUC 15 Pro doesn't show status messages on the CLI during ROE install. | This behavior can be confusing during testing because the installation might appear stalled. | When you're testing on a NUC 15 Pro, treat a blank screen with a blinking cursor as a successful in-progress state. |
| OS provisioning | During OS provisioning, the Azure portal may display the status **Action Required!** even though provisioning is progressing successfully. | Users may incorrectly assume that provisioning has failed and could file unnecessary support requests or ICMs. | No action is required. OS provisioning continues to run successfully despite the incorrect status message. Monitor the provisioning workflow until completion. |
| OS provisioning | OS provisioning can intermittently fail because the `LinuxEdgeObservability` extension times out during deployment. The extension attempts to retrieve the GCS configuration file after observability tenant registration, which can take up to eight minutes. However, the Azure Arc extension manager imposes a five-minute timeout on the enable operation. | OS provisioning may intermittently fail during deployment. | Retry the OS provisioning operation. This issue is intermittent and occurs when the observability tenant registration exceeds the extension manager timeout window. |
| Reset OS | After running `reset-os`, the provisioned machine state in the Azure portal may display as **Unknown** instead of a resetting state. | Users may be unsure whether the reset operation is progressing successfully. | This behavior is expected in version 2604. Reset status flows and reset operations are not yet fully supported in the Azure portal for small form factor deployments. The portal currently defaults unsupported states to **Unknown**. |
| Retesting | TPM slot exhaustion can happen after repeated deployments, usually after about 15 runs. | Retesting can fail when no TPM slots remain. | Manually clear the TPM in BIOS before you retest. |
