---
title: Troubleshoot registration issues using Configurator app in Azure Local
description: Learn how to troubleshoot the registration failures for Azure Local when using the Configurator app.
ms.topic: how-to
ms.author: robess
author: ronmiab
ms.date: 10/14/2026
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

The Windows computer running the Configurator app needs network access to the Azure Local machine. Azure sign-in and support-package upload also need internet access from the Windows computer.

Configure the connections for the operations that you use. The following table separates connections from the Windows client from connections made by the Azure Local machine.

| Operation | Connection origin | Destination or maintained endpoint reference | Protocol and destination port | When required |
| --- | --- | --- | --- | --- |
| Download the app | Windows client | `aka.ms`, then the Microsoft download destination, currently `azurestackreleases.download.prss.microsoft.com` | HTTPS, TCP 443 | When you download the Configurator installer. |
| Download a missing .NET runtime | Windows client or your software-distribution system | Follow the runtime download requested by the app and the maintained [Windows .NET installation guidance](/dotnet/core/install/windows). | HTTPS, TCP 443 | If the runtime required by your Configurator version isn't installed. A successful MSIX installation doesn't establish that the runtime is present. An approved offline installer avoids an internet download from the client. |
| Validate certificate chains | Windows client and its installed components | Certificate-authority CRL, OCSP and issuer URLs, and relevant trust-list services. See [Windows certificate chain retrieval](/windows/win32/api/wincrypt/nf-wincrypt-certgetcertificatechain). | HTTP, TCP 80, or HTTPS, TCP 443, as specified by the certificate chain | When signing or TLS verification needs information that isn't cached. Allow the applicable current certificate URLs; don't disable certificate validation to work around blocked connectivity. |
| Connect to the machine, run diagnostics, create a support package, or download it | Configurator app on the Windows client | Hostname or IP address of the Azure Local machine | HTTPS, TCP 9099 or 20001 | For device operations. The app probes both ports and uses a responding Bootstrap API listener. Allow that port inbound to the machine from the client. If you use a hostname, the client also needs working name resolution. |
| Run machine connectivity and time diagnostics | Bootstrap on the Azure Local machine | Configured DNS, proxy and time services, and the destinations in [Azure Local firewall requirements](../concepts/firewall-requirements.md) | As specified for each service, including HTTPS on TCP 443 and NTP on UDP 123 where applicable | The diagnostic work runs on the machine. Validate the Windows client's Azure connectivity separately. |
| Sign in to Azure | Windows client's browser and authentication library | Microsoft Entra sign-in services for the selected cloud, including `login.microsoftonline.com` for Azure public cloud or `login.microsoftonline.us` for Azure Government, and any sign-in services required by your tenant | HTTPS, TCP 443 | For interactive sign-in and token refresh. The browser must also be able to return the sign-in result to the app's local authentication listener. |
| Select Azure resources | Configurator app on the Windows client | `management.azure.com` for Azure public cloud or `management.usgovcloudapi.net` for Azure Government | HTTPS, TCP 443 | To load tenants, subscriptions, resource groups, regions and available Arc gateways after sign-in. |
| Discover the tenant for support upload | Standalone observability on the Windows client | `management.azure.com` for endpoint metadata and the selected subscription | HTTPS, TCP 443 | Before support upload. The app's standalone upload invocation uses the module's default `AzureCloud` configuration. |
| Install missing upload dependencies | Windows PowerShell on the Windows client | Configured PowerShell repository and its download services. For PSGallery, use the current [PowerShell Gallery network endpoint requirements](/powershell/gallery/how-to/getting-support/troubleshooting-cmdlets#required-network-endpoints). | HTTPS, TCP 443, with TLS 1.2 or later | If `Az.Accounts` or required provider components are missing. Cleanup also checks for `Az.Accounts`, including when the computer is already connected to Arc. |
| Install or connect the uploading client to Azure Arc | Connected Machine Agent and standalone observability on the Windows client | Windows agent installer at `download.microsoft.com`, plus the applicable [Connected Machine Agent endpoints](/azure/azure-arc/servers/network-requirements) | HTTPS, TCP 443, with any scenario-specific exceptions in the maintained requirements | When the uploading computer isn't already connected to Arc. The upload can create a temporary Arc server resource for the Windows client. |
| Create local observability PowerShell sessions | Windows PowerShell on the Windows client | The same computer's WinRM endpoint, normally `http://localhost:5985/WSMAN`; see [New-PSSession](/powershell/module/microsoft.powershell.core/new-pssession?view=powershell-5.1). | Local HTTP, TCP 5985 by default | The bundled standalone scripts create local PowerShell sessions during observability setup and event emission. This is a client-local dependency, not a requirement to expose WinRM to other computers. |
| Request the temporary Arc client's managed-identity token | Observability components on the Windows client | The local Hybrid Instance Metadata Service. See [Connected Machine Agent components](/azure/azure-arc/servers/agent-overview#agent-resources). | Local HTTP, TCP 40342 | When observability uses the connected client's Arc identity. This endpoint is local to the uploading computer; don't open it to your network as an upload prerequisite. |
| Send diagnostic data | Observability components on the Windows client | Monitoring, diagnostics and storage destinations for your cloud and region. Start with the maintained regional endpoint references in [Azure Local firewall requirements](../concepts/firewall-requirements.md). | HTTPS, TCP 443, as specified by the endpoint reference | During upload. Configuration and ingestion destinations depend on the selected region and effective observability configuration. The Arc endpoint list alone doesn't describe the entire upload path. |
| Clean up after upload | Standalone observability and Connected Machine Agent on the Windows client | Relevant Arc and Resource Manager endpoints, and repository endpoints if a required module is missing | HTTPS, TCP 443 | To remove upload components and, for a client onboarded by the upload, disconnect its temporary Arc resource. |

The maintained endpoint references describe requirements for their respective components. Apply the entries relevant to your cloud, region and scenario. Don't substitute a resolved IP address for a maintained FQDN or service-tag requirement.

### Proxy configuration scope

The proxy URL and bypass list entered in Configurator's machine settings apply to the Azure Local machine. They don't configure the Windows client's browser, HTTP requests, PowerShell, Arc agent or observability components.

On the client:

- Ensure the effective HTTP proxy or bypass policy permits the local machine's hostname or IP address and API port.
- Check browser and .NET proxy settings for Azure sign-in and Resource Manager requests. On Windows, [.NET's default HTTP proxy](/dotnet/api/system.net.http.httpclient.defaultproxy) uses proxy environment variables or, if those aren't defined, the user's proxy settings.
- Configure the Connected Machine Agent according to its [proxy guidance](/azure/azure-arc/servers/manage-agent-proxy-settings). The agent has its own configuration and doesn't use the Windows user's proxy setting by default. Some extensions don't inherit the agent's proxy configuration.
- Verify the proxy settings used by PowerShell and the observability components under the identity running the upload. The device proxy and Arc gateway fields in the app aren't passed to the standalone upload command.

Keep bypass lists separate for each component. For example, .NET `NO_PROXY` doesn't support the asterisk wildcard syntax used by the machine configuration's bypass list.

### Support upload requirements

Run the app as an administrator for upload. Use a Windows client where you have permission to install the required dependencies and observability components, and Azure permissions to create and remove the temporary Arc resource when needed. See [Connected Machine Agent prerequisites](/azure/azure-arc/servers/prerequisites#required-permissions) for the relevant Arc permissions.

Prepare the required PowerShell package-management provider components before starting a noninteractive upload. A fresh Windows installation can lack the NuGet provider needed to install `Az.Accounts`. Use the maintained [PowerShell Gallery troubleshooting and endpoint guidance](/powershell/gallery/how-to/getting-support/troubleshooting-cmdlets) when preparing these components.

Keep the client online and the app running through upload and cleanup. An already Arc-connected computer skips temporary Arc onboarding, but still runs the observability component and module checks.

The bundled standalone upload command refuses to run when the `WatchdogAgent` service is already installed, even if the service is stopped. Use another approved client for the upload instead of removing or disabling existing monitoring.

The support-upload workflow described here uses Azure public cloud. Selecting another cloud for machine registration doesn't change the upload command's cloud configuration. Don't assume that Government, disconnected, private-link-only or Arc-gateway-only upload is supported by this workflow.

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

Review the [Windows client network prerequisites](#windows-client-network-prerequisites) before starting an upload. Upload runs the standalone observability pipeline on the Windows client, where it can install dependencies and temporarily connect the client to Azure Arc.

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
