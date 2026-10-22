---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 10/16/2026
ms.reviewer: ronmiab
---

> [!NOTE]
> During Azure Arc registration, select a target Azure Local solution version for the initial deployment. Specify the version by using the optional `TargetSolutionVersion` parameter, or select a version when prompted.

To use the Arc gateway feature for Azure Local systems without a proxy, only use the `ArcGatewayID` parameter.

1. Run the initialization script as follows.

   ```powershell
   Invoke-AzStackHciArcInitialization
   -TenantId $Tenant
   -SubscriptionID $Subscription
   -ResourceGroup $RG
   -Region $Region
   -Cloud "AzureCloud"
   -ArcGatewayID $ArcgwId
   # Optional: include only when using token-based authentication
   -ArmAccessToken $ArmAccessToken
   # Optional: The target Azure Local solution version for initial deployment after Azure Arc registration. If omitted, select a version from the available options.
   -TargetSolutionVersion $TargetSolutionVersion
   ```

   > [!NOTE]
   > If using `-ArmAccessToken`, convert the token to a plain text string by using: `$ArmAccessToken = [System.Net.NetworkCredential]::new("", $armTokenResponse.Token).Password`.

1. During the Arc registration process, you must authenticate with your Azure account. The console window displays a code that you must enter in the URL, in order to authenticate. Follow the instructions to complete the authentication process.

    :::image type="content" source="media/run-registration-script-with-arc-gateway/authentication-device-code.png" alt-text="Screenshot of the console window with the device code and the URL to open." lightbox="media/run-registration-script-with-arc-gateway/authentication-device-code.png":::

1. If an update is required:
   
   - The update typically takes 40-45 minutes, followed by a reboot.
   - During the update, the registration status appears as **Update: InProgress**.
   - Rerun `Invoke-AzStackHciArcInitialization` cmdlet after reboot.

   :::image type="content" source="media/run-registration-script-with-arc-gateway/operating-system-image-update-registration.png" alt-text="Screenshot of the console window with the registration in progress." lightbox="media/run-registration-script-with-arc-gateway/operating-system-image-update-registration.png":::

### Monitor and complete registration

1. If registration times out or the machine reboots, reconnect and check the registration progress by running the following commands:

   ```powershell
   $status = Get-ArcBootstrapStatus
   $status.Response.Status
   ```

1. Review the status value:
   
   - **Succeeded**: Registration completed successfully.
   - **Failed**: Rerun registration by using a new ARM token or device code flow.
   - If the issue persists, collect logs by running `Collect-ArcBootstrapSupportLogs` and share them for further troubleshooting.

1. After the reboot, rerun the `Invoke-AzStackHciArcInitialization` cmdlet to continue.