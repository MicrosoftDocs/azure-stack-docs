---
title: Troubleshoot registration issues using Configurator app in Azure Local
description: Learn how to troubleshoot the registration failures for Azure Local when using the Configurator app.
ms.topic: how-to
ms.author: alkohli
author: alkohli
ms.date: 07/29/2025
---


# Troubleshoot registration issues using the Configurator app for Azure Local

> Applies to: Azure Local 2508 and later

This article provides guidance on how to collect logs and troubleshoot issues experienced during the registration of Azure Local via the Configurator app.

## About troubleshooting

You might need to collect logs or diagnose problems if you encounter any issues while using the Configurator app to bootstrap Azure Local machines. You can use the following methods to troubleshoot:

- Get logs from a machine.
- Run diagnostic tests.
- Collect a Support package.
- Clean previous installation.

## Get logs if the app is inaccessible

If you can't access the Configurator app, you can get the logs from an Azure Local machine. Logs are stored in the following location: `C:\Windows\System32\Bootstrap\Logs`. You can access the logs by connecting to the machine via Remote Desktop Protocol (RDP).

If you can access the app, follow the instructions in [Run diagnostic tests](#run-diagnostic-tests-from-the-app) to troubleshoot the issue and if needed, [Collect a support package](#collect-a-support-log-package-from-the-app).

## Run diagnostic tests from the app

To diagnose and troubleshoot any machine issues related to hardware, time server, and network, you can run the diagnostics tests. Use these steps to run the diagnostic tests from the app:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane.

1. Select **Run tests**. The diagnostic tests check the health of the machine hardware, time server, and the network connectivity. The tests also check the status of the Azure Arc agent.

   :::image type="content" source="media/deployment-arc-register-configurator-app/run-diagnostics-tests-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Run diagnostic tests selected."lightbox="media/deployment-arc-register-configurator-app/run-diagnostics-tests-1.png":::

1. After the tests are completed, the results are displayed. Here's a sample output of the diagnostic tests when there's a machine issue:

   :::image type="content" source="media/deployment-arc-register-configurator-app/run-diagnostics-tests-2.png" alt-text="Screenshot that shows the error output after the diagnostic tests were run."lightbox="media/deployment-arc-register-configurator-app/run-diagnostics-tests-2.png":::

Here's a table that describes the diagnostic tests:

| Test Name                        | Description                                                               |
|----------------------------------|-----------------------------------------------------------------------|
| Internet connectivity            | This test validates the internet connectivity of the machine. |
| Web proxy (if configured)        | This test validates the web proxy configuration of the machine.  |
| Time sync                        | This test validates the machine time settings and checks that the time server configured on the machine is valid and accessible.                   |
| Azure Arc agent                  | This test validates the Azure Arc agent is installed and running on the machine. |
| Environment checker              | The Environment Checker tool runs a series of tests to evaluate the deployment readiness of your environment for Azure Local deployment including those for connectivity, hardware, Active Directory, network, and Arc integration. For more information, see [Evaluate the deployment readiness of your environment for Azure Local](../manage/use-environment-checker.md#about-the-environment-checker-tool). |

## Collect a Support log package from the app

A Support package is composed of all the relevant logs that can help Microsoft Support troubleshoot any machine issues. You can generate a Support package via the app.

### Download the Support log package

Follow these steps to collect and download a Support package:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane. Select **Create** to begin support package collection. The package collection could take several minutes.

   :::image type="content" source="media/deployment-arc-register-configurator-app/collect-support-package-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Create selected." lightbox="media/deployment-arc-register-configurator-app/collect-support-package-1.png":::

1. After the Support package is created, select **Download**. This action downloads two zipped packages corresponding to Support logs and Configurator logs on your local system. You can unzip the package and view the system log files.

### Upload the Support log package

> [!IMPORTANT]
> - Make sure to run the Configurator app as an administrator to upload the Support log package.
> - Uploading the Support log package to Microsoft can take up to 20 minutes. Make sure to leave the app open and running to complete this process.

Follow these steps to upload the Support package to Microsoft:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane. Select **Upload** to upload the Support package to Microsoft.

   :::image type="content" source="media/deployment-arc-register-configurator-app/upload-support-package-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Upload package selected." lightbox="media/deployment-arc-register-configurator-app/upload-support-package-1.png":::

1. Provide the required information in the **Upload Support package to Microsoft** dialog:

   :::image type="content" source="media/deployment-arc-register-configurator-app/upload-support-package-2.png" alt-text="Screenshot that shows the Upload Support Package dialog filled out." lightbox="media/deployment-arc-register-configurator-app/upload-support-package-2.png":::

    The fields in the dialog are prepopulated with the information you provided during [Step 1: Configure the network and connect to Azure](#step-1-configure-the-network-and-connect-to-azure). You can modify the fields as needed.

1. Select **Begin upload** to upload the Support log package.
1. Authenticate in the browser with the same account that you used to sign in to register with Azure Arc. The upload process might take several minutes. Leave the app open and running until the upload is complete.

   :::image type="content" source="media/deployment-arc-register-configurator-app/upload-support-package-3.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Upload selected and authentication guidance." lightbox="media/deployment-arc-register-configurator-app/upload-support-package-3.png":::

1. After the upload is complete, you receive a confirmation message. You can also view the upload status in the app.

## Clean previous installation

If you have more than one version of the app installed, when you try to open the app, an older version of the app might open. To fix this issue, clean the previous installation. Follow these steps to clean the previous installation:

1. Uninstall the Configurator app as you would any other app on the system.
1. Delete the `C:\Users\%USERNAME%\AppData\Roaming\microsoft.-azure.-edge.-oobe.-local-ui` directory.
1. Launch the app again. The app should open without any issues.
