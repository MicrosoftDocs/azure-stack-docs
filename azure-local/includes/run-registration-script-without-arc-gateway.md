---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 10/14/2026
ms.reviewer: ronmiab
---

> [!NOTE]
> During Azure Arc registration, select a target Azure Local solution version for the initial deployment. Specify the version by using the optional `TargetSolutionVersion` parameter, or select a version when prompted.

1. Run the Arc registration script. The script takes a few minutes to run.

   ```powershell
   $params = @{
    TenantId       = $Tenant
    SubscriptionID = $Subscription
    ResourceGroup  = $RG
    Region         = $Region
    Cloud          = "AzureCloud"
   }

   # Optional
   if ($ProxyServer) {
    $params.Proxy = $ProxyServer
   }

   # Optional
   if ($ProxyBypassList) {
    $params.ProxyBypass = $ProxyBypassList
   }

   # Optional: include only when using token-based authentication
   if ($ArmAccessToken) {
    $params.ArmAccessToken = $ArmAccessToken
   }

   # Optional: The target Azure Local solution version for initial deployment after Azure Arc registration. If omitted, select a version from the available options.
   if ($TargetSolutionVersion) {
    $params.TargetSolutionVersion = $TargetSolutionVersion
   }

   Invoke-AzStackHciArcInitialization @params
   ```

   > [!NOTE]
   > If using `ArmAccessToken`, convert the token to a plain text string by using: `$ArmAccessToken = [System.Net.NetworkCredential]::new("", $armTokenResponse.Token).Password`.

   For a list of supported Azure regions, see [Azure requirements](../concepts/system-requirements-23h2.md#azure-requirements).

   <details>
   <summary>Expand this section to see an example output.</summary>

   Here's a sample output of a successful registration of your machines:

   ```output
   PS C:\Users\Administrator> Invoke-AzStackHciArcInitialization -TenantId $Tenant -SubscriptionID $Subscription -ResourceGroup $RG -Region $Region -Cloud "AzureCloud" -Proxy $ProxyServer
   >>
   Configuration saved to: C:\Users\ADMINI~1\AppData\Local\Temp\bootstrap.json
   Triggering bootstrap on the device...
   Waiting for bootstrap to complete... Current Status: InProgress
   =========SNIPPED=========SNIPPED=============
   Waiting for bootstrap to complete... Current Status: InProgress
   Waiting for bootstrap to complete... Current Status: Succeeded
   Bootstrap succeeded.
    
   Triggering bootstrap log collection as a best effort.
   Version Response                                                    
   ------- --------                                                    
   V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response
   V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response


   PS C:\Users\Administrator>
   ```
   </details>

1. During the Arc registration process, you must authenticate with your Azure account. The console window displays a code that you must enter in the URL, displayed in the app, to authenticate. Follow the instructions to complete the authentication process.

   :::image type="content" source="media/run-registration-script-without-arc-gateway/authentication-device-code.png" alt-text="Screenshot of the console window with device code and URL for authentication." lightbox="media/run-registration-script-without-arc-gateway/authentication-device-code.png":::

When the registration finishes, the Azure Local machines are registered in Azure Arc.

1. If an update is required:
   
   - The update typically takes 40-45 minutes, followed by a reboot.
   - During the update, the registration status appears as **Update: InProgress**.
   - Rerun `Invoke-AzStackHciArcInitialization` cmdlet after reboot.

   :::image type="content" source="media/run-registration-script-without-arc-gateway/operating-system-image-update-registration.png" alt-text="Screenshot of the console window with the registration in progress." lightbox="media/run-registration-script-without-arc-gateway/operating-system-image-update-registration.png":::

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