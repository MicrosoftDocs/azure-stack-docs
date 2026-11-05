---
title: Troubleshoot registration issues using Configurator app in Azure Local
description: Learn how to troubleshoot the registration failures for Azure Local when using the Configurator app.
ms.topic: how-to
ms.author: robess
author: ronmiab
ms.date: 11/04/2026
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
| Connect to the machine, run diagnostics, and create, download, or upload a support package | Configurator app | Hostname or IP address of the Azure Local machine | HTTPS, TCP 9099 or 20001 | Always. The app tries both ports and uses the one where the machine's Bootstrap service responds. If you connect by hostname, the client also needs name resolution for it. An upload starts by downloading the package from the machine. |
| Run diagnostic tests | Azure Local machine | The machine's DNS, proxy, and time servers, and the endpoints in [Azure Local firewall requirements](../concepts/firewall-requirements.md) | As listed in the firewall requirements | You run diagnostic tests. |
| Sign in to Azure | Browser and Configurator app on the Windows client | Microsoft Entra ID: `login.microsoftonline.com` for Azure public cloud or `login.microsoftonline.us` for Azure Government, and any other sign-in services your tenant uses | HTTPS, TCP 443 | You register the machine or upload a support package. The browser returns the sign-in result to the app on the same computer, and the app gets its tokens from Microsoft Entra ID. |
| Load subscriptions and resources | Configurator app | Azure Resource Manager: `management.azure.com` for Azure public cloud or `management.usgovcloudapi.net` for Azure Government | HTTPS, TCP 443 | After sign-in. |
| Create and delete the temporary upload resource | Configurator app | `management.azure.com` | HTTPS, TCP 443 | During upload. |
| Get the upload credential | Configurator app | `gbl.his.arc.azure.com`, which can direct the app to another `*.his.arc.azure.com` endpoint for the region you select | HTTPS, TCP 443 | During upload. |
| Send diagnostic data | Configurator app | `gcs.prod.monitoring.core.windows.net` and the `*.prod.warm.ingest.monitor.core.windows.net` endpoint for the region you select | HTTPS, TCP 443 | During upload. |

The [Azure Arc network requirements](/azure/azure-arc/servers/network-requirements) and the regional lists in [Azure Local firewall requirements](../concepts/firewall-requirements.md) maintain these endpoints. Allow hostnames in your firewall, not resolved IP addresses. Upload doesn't need the other endpoints in those lists, because it doesn't install anything on the client.

The client also needs to reach certificate revocation and issuer URLs when they aren't cached. Don't turn off certificate validation to work around blocked access.

### Proxy settings on the client

The proxy settings you enter in the Configurator app apply only to the Azure Local machine. They don't change any proxy setting on the Windows client.

On the client, check each component's proxy configuration:

- The Configurator app uses [.NET's default proxy](/dotnet/api/system.net.http.httpclient.defaultproxy): the proxy environment variables if they're set, and otherwise the Windows user's proxy settings. The app's connections to the Azure Local machine and to Azure both use this configuration, so it must allow the machine's address and API port as well as the Azure endpoints in the table.
- The browser uses its own proxy settings for Azure sign-in.
- Upload doesn't use the machine's proxy settings or an Arc gateway, even if you enter a gateway in the upload dialog.

Bypass lists use different syntax in each component. For example, the .NET `NO_PROXY` variable doesn't support the `*` wildcard used in the machine's bypass list.

### Support upload requirements

You can upload as a standard user. Upload doesn't install anything on the client or register it with Azure Arc. The app creates a temporary Azure Arc machine resource named `configurator-upload-<ID>` in a resource group you select, uses that resource's managed identity to send the logs, and then deletes the resource.

- Select an existing resource group. The app doesn't create resource groups or role assignments.
- Use an Azure account that can list the resource group and read, create, and delete `Microsoft.HybridCompute/machines` resources in it. For example, use Contributor, or Azure Connected Machine Resource Administrator with Reader. Azure Connected Machine Onboarding isn't enough, because it can't delete the temporary resource. See [Connected Machine agent prerequisites](/azure/azure-arc/servers/prerequisites#required-permissions).
- The `Microsoft.HybridCompute` resource provider must be [registered in the subscription](/azure/azure-arc/servers/prerequisites#azure-resource-providers).
- Upload uses Azure public cloud only, even if you register the machine in another cloud. If you signed in to another cloud in the app, signing in to Azure public cloud for the upload replaces that sign-in.
- Azure Policy that applies to the resource group also applies to the temporary resource. A policy that denies Azure Arc machine resources blocks the upload. A policy that deploys extensions can report failed deployments after the resource is deleted.
- Keep the client online and the app open until upload and cleanup finish. If the app closes first, the temporary resource stays in the resource group. A later upload from the same Windows account to the same tenant tries to remove it, or you can delete the resource yourself.

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

Before you upload, review the [Windows client network prerequisites](#windows-client-network-prerequisites) and [support upload requirements](#support-upload-requirements). The upload runs on the Windows client and creates a temporary Azure Arc resource in a resource group you select.

These steps apply to the current version of the Configurator app. If the upload dialog doesn't say that it creates a temporary Azure Arc resource, you have an earlier version, which must run as an administrator and connects the client to Azure Arc. [Download the current version](https://aka.ms/ConfiguratorAppForHCI) before you upload.

> [!IMPORTANT]
> Leave the app open until the upload and cleanup finish. The upload might take several minutes, depending on the size of the package.

Follow these steps to upload the Support package to Microsoft:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane. After you create a Support package, select **Upload to Microsoft**.

   :::image type="content" source="media/troubleshoot-deployment-configurator-app/upload-support-package-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Upload package selected." lightbox="media/troubleshoot-deployment-configurator-app/upload-support-package-1.png":::

1. In the **Upload support package to Microsoft** dialog, select **Log in to Azure** and sign in with an account that has the [required permissions](#support-upload-requirements). Then select your tenant, subscription, resource group, and region.

   :::image type="content" source="media/troubleshoot-deployment-configurator-app/upload-support-package-2.png" alt-text="Screenshot that shows the Upload Support Package dialog filled out." lightbox="media/troubleshoot-deployment-configurator-app/upload-support-package-2.png":::

    If you registered the machine in Azure public cloud, the dialog starts with the settings you provided during [Step 1: Configure the network and connect to Azure](../deploy/deployment-without-azure-arc-gateway.md#basics-tab). You can modify the fields as needed.

    You can also enter the values without signing in. The app then opens the browser for sign-in after it downloads the package from the machine.

1. Select **Begin upload**. The app downloads the package from the machine, creates the temporary resource, sends the logs, and deletes the resource. If you select **Cancel**, the app removes the temporary resource before it reports that the upload is canceled.

1. After the upload and cleanup finish, you receive a confirmation message. To see the status history, expand **Upload details and history**.

## Clean previous installation

If you have more than one version of the app installed, when you try to open the app, an older version of the app might open. To fix this issue, clean the previous installation. Follow these steps to clean the previous installation:

1. Uninstall the Configurator app as you would any other app on the system.
1. Delete the `C:\Users\%USERNAME%\AppData\Roaming\microsoft.-azure.-edge.-oobe.-local-ui` directory.
1. Launch the app again. The app should open without any issues.
