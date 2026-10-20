---
title: Troubleshoot registration issues using Configurator app in Azure Local
description: Learn how to troubleshoot the registration failures for Azure Local when using the Configurator app.
ms.topic: how-to
ms.author: robess
author: ronmiab
ms.date: 10/15/2026
ms.subservice: hyperconverged
---


# Troubleshoot registration issues using the Configurator app for Azure Local

> Applies to: Azure Local 2508 and later

This article provides guidance on how to collect logs and troubleshoot issues experienced during the registration of Azure Local via the Configurator app.

## About troubleshooting

You might need to collect logs or diagnose problems if you encounter any issues while using the Configurator app to bootstrap Azure Local machines. You can use the following methods to troubleshoot:

- Get logs from a machine.
- Run diagnostic tests.
- Download and upload a Support package.
- Clean previous installation.

## Windows client network prerequisites

The Windows computer that runs the Configurator app connects to the Azure Local machine for every device operation. Azure sign-in and support-package upload also need internet access from that computer. Diagnostic tests run on the Azure Local machine, so they check the machine's connectivity, not the client's.

| Operation | Connects from | Destination | Protocol and port | Required when |
| --- | --- | --- | --- | --- |
| Download the app | Windows client | `aka.ms` and `azurestackreleases.download.prss.microsoft.com` | HTTPS, TCP 443 | You download the installer on this computer. |
| Connect to the machine, run diagnostics, and create or download a support package | Configurator app | Hostname or IP address of the Azure Local machine | HTTPS, TCP 9099 or 20001 | Always. The app tries both ports and uses the one where the machine's Bootstrap service responds. If you connect by hostname, the client also needs name resolution for it. |
| Run diagnostic tests | Azure Local machine | The machine's DNS, proxy, and time servers, and the endpoints in [Azure Local firewall requirements](../concepts/firewall-requirements.md) | As listed in the firewall requirements | You run diagnostic tests. |
| Sign in to Azure | Browser on the Windows client | Microsoft Entra ID: `login.microsoftonline.com` for Azure public cloud or `login.microsoftonline.us` for Azure Government, and any other sign-in services your tenant uses | HTTPS, TCP 443 | You register the machine or upload a support package. The browser returns the sign-in result to the app on the same computer. |
| Load subscriptions and resources | Configurator app and upload components | Azure Resource Manager: `management.azure.com` for Azure public cloud or `management.usgovcloudapi.net` for Azure Government | HTTPS, TCP 443 | After sign-in, and at the start of an upload. |
| Install missing upload dependencies | Windows PowerShell | Your PowerShell repository. For PowerShell Gallery, see its [required network endpoints](/powershell/gallery/how-to/getting-support/troubleshooting-cmdlets#required-network-endpoints). | HTTPS, TCP 443, TLS 1.2 or later | The NuGet provider or `Az.Accounts` module isn't installed. |
| Connect the client to Azure Arc for upload, and disconnect it afterward | Connected Machine agent | `download.microsoft.com` for the agent installer, and the [Connected Machine agent endpoints](/azure/azure-arc/servers/network-requirements) | HTTPS, TCP 443 | The client isn't already Arc-enabled. The upload creates a temporary Arc server resource for the client. |
| Send diagnostic data | Observability components on the client | Monitoring and storage endpoints for your region, listed in [Azure Local firewall requirements](../concepts/firewall-requirements.md) | HTTPS, TCP 443 | During upload. |

Configure your firewall from the linked endpoint lists, not from resolved IP addresses. The lists are maintained for each cloud and region.

The client also needs to reach certificate revocation and issuer URLs when they aren't cached. Don't turn off certificate validation to work around blocked access.

Upload also uses two endpoints on the client itself: local PowerShell sessions through WinRM on `localhost:5985`, and the Arc agent's metadata service on `localhost:40342`. Don't open these ports to other computers.

### Proxy settings on the client

The proxy settings you enter in the Configurator app apply only to the Azure Local machine. They don't change any proxy setting on the Windows client.

On the client, check each component's proxy configuration:

- The Configurator app uses [.NET's default proxy](/dotnet/api/system.net.http.httpclient.defaultproxy): the proxy environment variables if they're set, and otherwise the Windows user's proxy settings. Make sure this configuration allows connections to the Azure Local machine's address and API port.
- The browser uses its own proxy settings for Azure sign-in.
- The Connected Machine agent has its own proxy setting and doesn't use the Windows user's settings. Some extensions don't inherit the agent's proxy setting. See [Manage and maintain the Connected Machine agent proxy settings](/azure/azure-arc/servers/manage-agent-proxy-settings).
- Windows PowerShell and the observability components use the proxy settings of the account that runs the app. The app doesn't pass the machine's proxy or Arc gateway settings to the upload.

Bypass lists use different syntax in each component. For example, the .NET `NO_PROXY` variable doesn't support the `*` wildcard used in the machine's bypass list.

### Support upload requirements

- Run the app as an administrator. Use an account that can install software on the client, and an Azure account that can create and delete Arc server resources. See [Connected Machine agent prerequisites](/azure/azure-arc/servers/prerequisites#required-permissions).
- A new Windows installation might not have the NuGet provider that PowerShell needs to install `Az.Accounts`. The upload can fail when PowerShell prompts to install the provider, so install it before you upload.
- The upload components can require a different .NET runtime version than the app. A newer major version doesn't satisfy an older requirement by default, so install the required runtime alongside the existing one. See [Install .NET on Windows](/dotnet/core/install/windows) and [.NET runtime version selection](/dotnet/core/versions/selection#framework-dependent-apps-roll-forward).
- Keep the client online and the app open until upload and cleanup finish. A client that's already Arc-enabled skips the temporary Arc connection but runs the other steps.
- Upload doesn't run on a computer where the `WatchdogAgent` service is installed, even if the service is stopped. Use a different computer instead of removing existing monitoring.
- Upload uses Azure public cloud, even if you register the machine in another cloud.

## Get logs if the app is inaccessible

If you can't access the Configurator app, you can get the logs from an Azure Local machine. Logs are stored in the following location: `C:\Windows\System32\Bootstrap\Logs`. You can access the logs by connecting to the machine via Remote Desktop Protocol (RDP).

If you can access the app, follow the instructions in [Run diagnostic tests](#run-diagnostic-tests-from-the-app) to troubleshoot the issue and if needed, [Collect a support package](#collect-a-support-log-package-from-the-app).

## Run diagnostic tests from the app

To diagnose and troubleshoot any machine issues related to hardware, time server, and network, you can run the diagnostics tests. Use these steps to run the diagnostic tests from the app:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane.

1. Select **Run tests**. The diagnostic tests check the health of the machine hardware, time server, and the network connectivity. The tests also check the status of the Azure Arc agent.

   :::image type="content" source="media/troubleshoot-deployment-configurator-app/run-diagnostics-tests-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Run diagnostic tests selected."lightbox="media/troubleshoot-deployment-configurator-app/run-diagnostics-tests-1.png":::

1. After the tests are completed, the results are displayed. Here's a sample output of the diagnostic tests when there's a machine issue:

   :::image type="content" source="media/troubleshoot-deployment-configurator-app/run-diagnostics-tests-2.png" alt-text="Screenshot that shows the error output after the diagnostic tests were run."lightbox="media/troubleshoot-deployment-configurator-app/run-diagnostics-tests-2.png":::

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

   :::image type="content" source="media/troubleshoot-deployment-configurator-app/collect-support-package-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Create selected." lightbox="media/troubleshoot-deployment-configurator-app/collect-support-package-1.png":::

1. After the Support package is created, select **Download**. This action downloads two zipped packages corresponding to Support logs and Configurator logs on your local system. You can unzip the package and view the system log files.

### Upload the Support log package

Before you upload, review the [Windows client network prerequisites](#windows-client-network-prerequisites) and [support upload requirements](#support-upload-requirements). The upload runs on the Windows client, and can install dependencies and temporarily connect the client to Azure Arc.

> [!IMPORTANT]
> - Make sure to run the Configurator app as an administrator to upload the Support log package.
> - Uploading the Support log package to Microsoft can take up to 20 minutes. Make sure to leave the app open and running to complete this process.

Follow these steps to upload the Support package to Microsoft:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane. Select **Upload** to upload the Support package to Microsoft.

   :::image type="content" source="media/troubleshoot-deployment-configurator-app/upload-support-package-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Upload package selected." lightbox="media/troubleshoot-deployment-configurator-app/upload-support-package-1.png":::

1. Provide the required information in the **Upload Support package to Microsoft** dialog:

   :::image type="content" source="media/troubleshoot-deployment-configurator-app/upload-support-package-2.png" alt-text="Screenshot that shows the Upload Support Package dialog filled out." lightbox="media/troubleshoot-deployment-configurator-app/upload-support-package-2.png":::

    The fields in the dialog are prepopulated with the information you provided during [Step 1: Configure the network and connect to Azure](../deploy/deployment-without-azure-arc-gateway.md#basics-tab). You can modify the fields as needed.

1. Select **Begin upload** to upload the Support log package.
1. Authenticate in the browser with the same account that you used to sign in to register with Azure Arc. The upload process might take several minutes. Leave the app open and running until the upload is complete.

   :::image type="content" source="media/troubleshoot-deployment-configurator-app/upload-support-package-3.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Upload selected and authentication guidance." lightbox="media/troubleshoot-deployment-configurator-app/upload-support-package-3.png":::

1. After the upload is complete, you receive a confirmation message. You can also view the upload status in the app.

## Clean previous installation

If you have more than one version of the app installed, when you try to open the app, an older version of the app might open. To fix this issue, clean the previous installation. Follow these steps to clean the previous installation:

1. Uninstall the Configurator app as you would any other app on the system.
1. Delete the `C:\Users\%USERNAME%\AppData\Roaming\microsoft.-azure.-edge.-oobe.-local-ui` directory.
1. Launch the app again. The app should open without any issues.
