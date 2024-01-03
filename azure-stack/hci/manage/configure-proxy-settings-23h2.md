---
title: Configure proxy settings for Azure Stack HCI, version 23H2
description: Learn how to configure proxy settings for Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 12/11/2023
---

# Configure proxy settings for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to configure proxy settings for Azure Stack HCI, version 23H2 if your network uses a proxy server for internet access.

For information about firewall requirements for outbound endpoints and internal rules and ports for Azure Stack HCI, see [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

## Before you begin

Before you configure proxy settings, make sure that:

- You know the proxy server name or IP address and port (optional). If you don’t have this information, contact your network administrator.
- You configure the proxy server before you [Register to Arc and assign permissions](../deploy/deployment-arc-register-server-permissions.md).

> [!NOTE]
> Authenticated proxies are not supported in this release.

## Configure proxy settings for Azure Stack HCI operating system

Use the following steps to configure proxy settings:

- Step 1: Configure proxy settings for the Azure Stack HCI operating system.
- Step 2: Configure proxy settings for Azure Arc-enabled servers.
- Step 3: Configure proxy settings for Winhttp.

### Step 1: Configure proxy settings for the Azure Stack HCI operating system

You must configure the proxy for Azure Stack HCI operating system before you [Register the servers with Azure Arc](../deploy/deployment-arc-register-server-permissions.md).

Install the `WinInetProxy` module to run the commands in this section. For information about the module and how to install it, see [WinInetProxy 0.1.0 in the PowerShell Gallery](https://www.powershellgallery.com/packages/WinInetProxy/0.1.0). For information about the `WinInetProxy` PowerShell script, see [WinInetProxy.psm1 in the PowerShell Gallery](https://www.powershellgallery.com/packages/WinInetProxy/0.1.0/Content/WinInetProxy.psm1).

> [!NOTE]
> If you can't install the `WinInetProxy` module to a cluster node because of no internet access, we recommend that you download the module to your management computer, and then manually transfer it to the cluster node where you want to run the module.
>
> You can also use the [Start-BitsTransfer](/powershell/module/bitstransfer/start-bitstransfer) PowerShell cmdlet to transfer one or more files between your management computer and a server.

To configure the proxy settings for the Azure Stack HCI operating system, run the following PowerShell command as administrator on each server in the cluster:

1. Connect to the server via remote desktop protocol (RDP) or remote PowerShell.

1. Run the following cmdlet to configure proxy settings after you've installed the `WinInetProxy` module:

    ```powershell
    Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer <Proxy_Server_Address:Proxy_Port> -ProxyBypass <URLs to bypass>
    ```

    where:

    - `ProxySettingsPerUser` specifies if the proxy settings are per machine or per user.

        - 0 - Proxy settings are per machine.
        - 1 (default) - Proxy settings are per user.
        - If no value is specified, use the environment variable `ProxySettingsPerUser` instead, if present.

    - `ProxyServer` specifies the proxy server endpoint in the format [Proxy_Server_Address]:[Proxy_Port]. For example, `proxy.contoso.com:8080`.

    - `ProxyBypass` specifies the list of host URLs that bypass proxy server set by the `-ProxyServer` parameter. The list must include:

        - IP address of each cluster member server.
        - Netbios name of each server.
        - Netbios cluster name.
        - *.contoso.com.

    Here's an example of the command usage:

    ```powershell
    Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer proxy.contoso.com:8080 -ProxyBypass "localhost,127.0.0.1,.svc,node1,node2,s-cluster,192.168.0.2,192.168.0.3,*.contoso.com"
    ```

To remove the proxy configuration, run the PowerShell cmdlet `Set-WinInetProxy` without arguments.

### Step 2: Configure proxy settings for Azure Arc-enabled servers

You must configure the proxy for Azure Arc-enabled servers before you register your server with Azure Arc. 

- To set the proxy server environment variable, run the following commands as administrator on each server in the cluster:

    ```powershell
    # If a proxy server is needed, run these commands with the proxy URL and port.
    [Environment]::SetEnvironmentVariable("HTTPS_PROXY", "http://ProxyServerFQDN:port", "Machine")
    $env:HTTPS_PROXY = [System.Environment]::GetEnvironmentVariable("HTTPS_PROXY", "Machine")
    [Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://ProxyServerFQDN:port", "Machine")
    $env:HTTP_PROXY = [System.Environment]::GetEnvironmentVariable("HTTP_PROXY", "Machine")
    $no_proxy = "localhost,127.0.0.1,.svc,node1,node2,scluster,192.168.0.2,192.168.0.3,*.contoso.com" 
    
    [Environment]::SetEnvironmentVariable("NO_PROXY", $no_proxy, "Machine")
    
    # For the changes to take effect, restart the agent services after the proxy environment variable is set.
    Restart-Service -Name himds, ExtensionService, GCArcService
    ```

- Confirm that the settings were applied by running the following command:

    ```powershell
    echo "https :" $env:https_proxy "http :" $env:http_proxy
    ```

    Note that `No_proxy` specifies the list of host URLs that bypass the proxy server; the list must include:
    
    - IP address of each cluster member server.
    - Netbios name of each server.
    - Netbios cluster name.
    - *.contoso.com.

- To remove the proxy configuration, run the following commands as administrator on each server in the cluster:

    ```powershell
    [Environment]::SetEnvironmentVariable("HTTPS_PROXY", $null, "Machine") 
    $env:HTTPS_PROXY = [System.Environment]::GetEnvironmentVariable("HTTPS_PROXY", "Machine")
    [Environment]::SetEnvironmentVariable("HTTP_PROXY", $null, "Machine")  
    $env:HTTPS_PROXY = [System.Environment]::GetEnvironmentVariable("HTTP_PROXY", "Machine") 
    $no_proxy = "" 
    [Environment]::SetEnvironmentVariable("NO_PROXY", $no_proxy, "Machine") 
    
    # For the changes to take effect, restart the agent services after the proxy environment variable is removed. 
    Restart-Service -Name himds, ExtensionService, GCArcService
    ```

For more information about proxy configuration for Azure Arc-enabled servers, see [Managing and maintaining the Connected Machine agent](/azure/azure-arc/servers/manage-agent?tabs=windows#update-or-remove-proxy-settings).

### Step 3: Configure proxy settings for Winhttp

You can configure proxy settings for Winhttp using the `netsh` command line utility.

- Run the following command from the command prompt to manually configure the proxy server:

    ```cmd
    netsh winhttp set proxy Proxy_Server_Address:Proxy_Port bypass-list="<URL to bypass>"
    ```

- Run the following command from the command prompt to view or verify the current WinHTTP proxy server configuration:

    ```cmd
    netsh winhttp show proxy
    ```

- Note that `No_proxy` specifies the list of host URLs that bypass the proxy server; the list must include:

  - IP address of each cluster member server.
  - Netbios name of each server.
  - Netbios cluster name.
  - *.contoso.com.

- Run the following command from the command prompt to remove the proxy server configuration for Winhttp:

    ```cmd
    netsh winhttp reset proxy
    ```

## Next steps

For more information, see:

- [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

After the proxy is configured, you can continue cluster deployment and:

- [Register the servers with Azure Arc](../deploy/deployment-arc-register-server-permissions.md).
