---
title: Configure proxy settings for Azure Stack HCI
description: Learn how to configure proxy settings for Azure Stack HCI.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 11/21/2023
---

# Configure proxy settings for Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to configure proxy settings for Azure Stack HCI if your network uses a proxy server for internet access.

For information about firewall requirements for outbound endpoints and internal rules and ports for Azure Stack HCI, see [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

## Before you begin

Before you begin to configure proxy settings, make sure that:

- You have access to an Azure Stack HCI cluster for which you configure the proxy settings. You also have the local administrator credentials to access the servers in your Azure Stack HCI cluster.

- You know the proxy server name or IP address and port (optional). If you don’t have this information, contact your network administrator.

Here are some other considerations to keep in mind before you configure proxy settings:

- Understand that proxy settings are separate for different components and features for Azure Stack HCI. You must configure the proxy settings for all the required components and any additional features that you plan on using.

- For a simpler administration, we recommend keeping the same proxy configuration across the different component and features.

- We don't support authenticated proxies due to security concerns associated with storing authenticated user credentials.

## Proxy requirements for Azure Stack HCI

If your network uses a proxy server for internet access, you must configure the following proxies for Azure Stack HCI:

- Proxy for Azure Stack HCI operating system. This proxy is required for a successful registration.
- Proxy for Azure Arc-enabled servers. This proxy is required for a successful registration.
- Proxy for Microsoft Update and Cluster Cloud Witness. This proxy is required only if you're using Microsoft Update and Cluster Cloud Witness.
- Proxy for Azure services. This proxy is required only if you're using any additional features, such as Azure Kubernetes Services (AKS) hybrid, Azure Arc VM management, or Azure Monitor.

The following sections describe how to configure each of these proxy settings.

## Configure proxy settings for Azure Stack HCI operating system

You must configure the proxy for the Azure Stack HCI operating system before [registering your cluster to Azure](../deploy/register-with-azure.md).

Install the `WinInetProxy` module to run the commands in this section. For information about the module and how to install it, see [PowerShell Gallery | WinInetProxy 0.1.0](https://www.powershellgallery.com/packages/WinInetProxy/0.1.0). For information about the `WinInetProxy` PowerShell script, see [WinInetProxy.psm1](https://www.powershellgallery.com/packages/WinInetProxy/0.1.0/Content/WinInetProxy.psm1).

> [!NOTE]
> If you can't install the `WinInetProxy` module to a cluster node because of no internet access, we recommend downloading the module to your management computer, and then manually transferring it to the cluster node where you want to run the module. You can also use the [Start-BitsTransfer](/powershell/module/bitstransfer/start-bitstransfer) PowerShell cmdlet to transfer one or more files between your management computer and a server.
To configure the proxy settings for the Azure Stack HCI operating system, run the following PowerShell command as administrator on each server in the cluster:

1. Connect to the server in your Azure Stack HCI cluster via Remote Desktop Protocol (RDP) and open a PowerShell session.

1. To configure proxy settings after you've installed the `WinInetProxy` module, run the following cmdlet:

    ```powershell
    Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer <Proxy_Server_Address:Proxy_Port> -ProxyBypass <URLs to bypass>
    ```

    where:

    - `ProxySettingsPerUser` specifies if the proxy settings are per machine or per user.

        - 0 - Proxy settings are per machine.
        - 1 (default) - Proxy settings are per user.
        - If no value is provided, the environment variable `ProxySettingsPerUser` is used instead, if present.

    - `ProxyServer` specifies the proxy server endpoint in the format [Proxy_Server_Address]:[Proxy_Port]. For example, `proxy.contoso.com:8080`.

    - `ProxyBypass` specifies the list of host URLs that bypass proxy server set by the `-ProxyServer` parameter. For example, you can set `-ProxyBypass <local>` to bypass local intranet URLs.

    Here's an example of the command usage:

    ```powershell
    Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer proxy.contoso.com:8080 -ProxyBypass "localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,*.contoso.com"
    ```

To remove the proxy configuration, run the PowerShell command `Set-WinInetProxy` without arguments.

## Configure proxy settings for Azure Arc-enabled servers

You must configure the proxy for Azure Arc-enabled servers before [registering your cluster to Azure](../deploy/register-with-azure.md).

To set the proxy server environment variable, run the following commands as administrator on each server in the cluster:

```powershell
# If a proxy server is needed, execute these commands with the proxy URL and port.
[Environment]::SetEnvironmentVariable("HTTPS_PROXY", "http://ProxyServerFQDN:port", "Machine")
$env:HTTPS_PROXY = [System.Environment]::GetEnvironmentVariable("HTTPS_PROXY", "Machine")
[Environment]::SetEnvironmentVariable("HTTP_PROXY", "10.10.42.200:8080/", "Machine")
$env:HTTP_PROXY = [System.Environment]::GetEnvironmentVariable("HTTP_PROXY", "Machine")
# For the changes to take effect, the agent services need to be restarted after the proxy environment variable is set.
Restart-Service -Name himds, ExtensionService, GCArcService
```

Confirm that the settings were applied by running the following command:

```powershell
echo "https :" $env:https_proxy "http :" $env:http_proxy
```

To set a no proxy environment variable, run the following commands as administrator on each server in the cluster:

```powershell
$no_proxy = "localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.contoso.com"
[Environment]::SetEnvironmentVariable("NO_PROXY", $no_proxy, "Machine")
```

To remove the proxy configuration, run the following commands as administrator on each server in the cluster:

```powershell
[Environment]::SetEnvironmentVariable("HTTPS_PROXY", $null, "Machine") 
$env:HTTPS_PROXY = [System.Environment]::GetEnvironmentVariable("HTTPS_PROXY", "Machine")
# For the changes to take effect, the agent services need to be restarted after the proxy environment variable removed. 
Restart-Service -Name himds, ExtensionService, GCArcService
```

For more information on proxy configuration for Azure Arc-enabled servers, see [Managing and maintaining the Connected Machine agent](/azure/azure-arc/servers/manage-agent?tabs=windows#update-or-remove-proxy-settings).

## Configure proxy settings for Microsoft Update and Cluster Cloud Witness

You can configure proxy settings for Microsoft Update and Cluster Cloud Witness automatically with [WinHTTP autoproxy](/windows/win32/winhttp/winhttp-autoproxy-support) or manually by using the `netsh` command-line utility.

- To manually configure proxy configuration for Microsoft Update and Cluster Cloud Witness, at the command prompt, type:

    ```cmd
    netsh winhttp set proxy Proxy_Server_Address:Proxy_Port
    ```

- To view or verify current WinHTTP proxy configuration, at the command prompt, type:

    ```cmd
    netsh winhttp show proxy
    ```

- To specify a list of host URLs that bypass proxy server, at the command prompt, type:

    ```cmd
    netsh winhttp bypass-list="<URL to bypass>"
    ```

- To configure the Internet Explorer (IE) proxy settings at the machine level instead for the current user, import `WinInet` proxy configuration into `WinHTTP`.
To do this, at the command prompt, type:

    ```cmd
    netsh winhttp import proxy source=ie
    ```

- To remove the proxy configuration for Microsoft Update and Cluster Cloud Witness, at the command prompt, type:

    ```cmd
    netsh winhttp reset proxy
    ```

## Configure proxy settings for Azure services

If you're using or plan to use any of the following Azure services, refer to the following articles for information about how to configure proxy server settings for each Azure service:

- [Azure Kubernetes Service (AKS) hybrid](/azure/aks/hybrid/set-proxy-settings)
- [Azure Arc VM management](/azure-stack/hci/manage/azure-arc-vm-management-proxy)
- [Azure Virtual Desktop](/azure/virtual-desktop/proxy-server-support)
- [Azure Monitor Agent](/azure/azure-monitor/agents/azure-monitor-agent-data-collection-endpoint?tabs=PowerShellWindows#proxy-configuration)
- [Microsoft Defender](/microsoft-365/security/defender-endpoint/production-deployment?#network-configuration)
- [Microsoft Monitoring Agent](/azure/azure-monitor/agents/log-analytics-agent#network-requirements) (The MMA agent will deprecate soon. We recommend using the Azure Monitor Agent.)
- To configure proxy settings in Windows Admin Center, go to **Settings** > **Proxy**, enter the proxy server address and any relevant bypass or authentication information, and select **Apply**.

    :::image type="content" source="./media/configure-proxy-settings/windows-admin-center-proxy.png" alt-text="Screenshot of Windows Admin Center Proxy settings pane." lightbox="./media/configure-proxy-settings/windows-admin-center-proxy.png":::

## Next steps

For more information, see also:

- [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md)