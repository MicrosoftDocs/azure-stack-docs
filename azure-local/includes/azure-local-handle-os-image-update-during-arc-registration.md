---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 02/11/2026
ms.reviewer: alkohli
---

During Azure Arc registration, Azure Local verifies whether the OS image is current for its release baseline. If the image is outdated or unsupported, the system automatically updates it during registration. You can optionally specify a target solution version using the `TargetSolutionVersion` parameter.

- The update typically takes 40-45 minutes.
- A system reboot is required.
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