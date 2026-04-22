---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 04/20/2026
ms.reviewer: ronmiab
---

During Azure Arc registration, Azure Local verifies whether the OS image is current for its release baseline. If the image is outdated or unsupported, the system automatically detects it during initialization and provides a list of available update versions to select from. You can proactively specify a target solution version using the optional `TargetSolutionVersion` parameter.

- The update typically takes 40-45 minutes followed by a reboot.
- Rerun `Invoke-AzStackHciArcInitialization` cmdlet post reboot.
- During the update, the registration status appears as **Update: InProgress**.

   :::image type="content" source="media/azure-local-handle-os-image-update-during-arc-registration/operating-system-image-update-registration.png" alt-text="Screenshot of the console window with the registration in progress." lightbox="media/azure-local-handle-os-image-update-during-arc-registration/operating-system-image-update-registration.png":::

#### Monitor and complete registration

1. If registration times out or the machine reboots, reconnect and check the registration progress using the following commands:

   ```powershell
   $status = Get-ArcBootstrapStatus
   $status.Response.Status
   ```

1. Review the status value:
   
   - **Succeeded**: Registration completed successfully after the update.
   - **Failed**: Rerun registration using a new ARM token or device code flow.
   - If the issue persists, collect logs using `Collect-ArcBootstrapSupportLogs` and share them for further troubleshooting.

1. After the reboot, rerun the `Invoke-AzStackHciArcInitialization` cmdlet to continue.