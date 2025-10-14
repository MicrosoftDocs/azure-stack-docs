---
title: Azure Arc registration workflow for systems with OEM images 
description: Learn about the Azure Arc registration workflow for systems with OEM images.
author: alkohli
ms.topic: overview
ms.date: 10/14/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Azure Arc registration workflow for systems with OEM images

::: moniker range=">=azloc-2510"

This article describes the Azure Arc registration workflow for systems using Original Equipment Manufacturer (OEM) images. It replaces [Step 3: Run registration script](./deployment-with-azure-arc-gateway.md#step-3-run-registration-script) in [Register Azure Local with Azure Arc using Arc gateway](./deployment-with-azure-arc-gateway.md) for both with proxy and without proxy scenarios. All other instructions remain the same.

## OEM image validation during Arc registration

If you've purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the operating system (OS) is typically preinstalled. This preinstalled OS is referred to as an OEM image. These images may be outdated and might not always include the latest OS version or drivers.

Starting with Azure Local 2510, during Azure Arc registration process, if the system detects an outdated OEM image, it triggers an update before proceeding with registration.

<!--The following will go in what's new as "Key enhancements in the registration workflow"
- OS image validation. If an outdated or unsupported image is detected, the system automatically starts an update process before proceeding with the Arc registration.
- Reboot state notification. The system notifies you when a reboot is about to occur during the update phase. This notification helps inform users about the upcoming system changes.
- Timed reboot delay. A short delay (about 30 seconds) is added before rebooting, giving users time to read the warning or message on the console output.
- Enhanced status reporting: Registration cmdlet provides clearer status updates, showing sub-stages like Scan, Download, and Update to help track progress. The update stage occurs before Arc registration begins.-->

## Run registration script for systems with OEM image

Follow these steps to register Azure Local systems with Azure Arc when using preinstalled OEM images:

1. Run the Arc registration script. The script takes a few minutes to run:

    ```powershell
    Invoke-AzStackHciArcInitialization -TenantID $Tenant -SubscriptionID $Subscription -ResourceGroup $RG -Region $Region -Cloud "AzureCloud"
    ```
    
    If an OS image update is initiated during registration, the status shows as **Update: InProgress**. This status indicates the system is currently performing an update before completing registration.

1. Monitor registration progress. If registration times out or the machine reboots, reconnect and check the registration progress using the following commands:

    ```powershell
    $status = Get-ArcBootstrapStatus
    $status.Response.Status
    ```

    - If the status is **Succeeded**, the machine is successfully registered with Azure Arc following the update.
    - If the status is **Failed**, rerun the registration using a new ARM token or device code flow.
    - If the issue persists, collect logs using `Collect-ArcBootstrapSupportLogs` and share them for further troubleshooting.

1. During the Arc registration process, you must authenticate with your Azure account. The console window displays a code that you must enter in the URL, displayed in the app, in order to authenticate. Follow the instructions to complete the authentication process.

    :::image type="content" source="media/deployment-arc-registration-preinstalled-os/authentication-device-code.png" alt-text="Screenshot of the console window with the device code and the URL to open." lightbox="media/deployment-arc-registration-preinstalled-os/authentication-device-code.png":::

## Next steps

- If using Arc gateway:
    - For proxy scenarios, see [Step 4: Verify the Azure Arc gateway setup is successful](./deployment-with-azure-arc-gateway.md#step-4-verify-the-azure-arc-gateway-setup-is-successful).
    - For without proxy scenarios, see [Step 4: Verify the Azure Arc gateway setup is successful](./deployment-with-azure-arc-gateway.md#step-4-verify-the-azure-arc-gateway-setup-is-successful).
- If not using Arc gateway:
    - For proxy scenarios, see [Step 4: Verify the setup is successful](./deployment-without-azure-arc-gateway.md#step-4-verify-the-setup-is-successful).
    - For without proxy scenarios, see [Step 4: Verify the setup is successful](./deployment-without-azure-arc-gateway.md#step-4-verify-the-setup-is-successful-1).

::: moniker-end

::: moniker range="<=azloc-2509"

This feature is available only in Azure Local 2510 or later.

::: moniker-end
