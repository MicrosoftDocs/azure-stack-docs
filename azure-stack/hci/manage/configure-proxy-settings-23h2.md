---
title: Configure proxy settings for Azure Stack HCI, version 23H2
description: Learn how to configure proxy settings for Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 06/04/2024
---

# Configure proxy settings for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to configure proxy settings for Azure Stack HCI, version 23H2 cloud deployment if your network uses a proxy server for internet access.

For information about firewall requirements for outbound endpoints and internal rules and ports for Azure Stack HCI, see [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

## Before you begin

Before you begin to configure proxy settings, make sure that:

- You have access to an Azure Stack HCI cluster for which you want to configure the proxy settings. You also have the local administrator credentials to access the servers in your Azure Stack HCI cluster.
- You know the proxy server name or IP address and port (optional). If you don’t have this information, contact your network administrator.

Here are some important considerations to keep in mind before you configure proxy settings:

- Understand that proxy settings are separate for different components and features of Azure Stack HCI (`WinInet`,`WinHTTP`, and `Environment Variables`). You must configure the proxy settings for all the required components and any other features that you plan on using.
- Although each component has specific command parameters and proxy bypass list string requirements, we recommend keeping the same proxy configuration across the different component and features.
- We don't support authenticated proxies using username and password due to security constraints.
- If you're using SSL inspection in your proxy, you need to bypass the required Azure Stack HCI and its components (Arc Resource Bridge, Azure Kubernetes Service (AKS), etc.) outbound URLs.
- Each of the three proxy components on the operating system has specific proxy bypass list string requirements. Don't use the same string for all three components.  

## Configure proxy settings for WinInet

You must configure the `WinInet` proxy settings before you [Register the servers with Azure Arc](../deploy/deployment-arc-register-server-permissions.md).

Install the `WinInetProxy` module to run the commands in this section. For information about the module and how to install it, see [PowerShell Gallery | WinInetProxy 0.1.0](https://www.powershellgallery.com/packages/WinInetProxy/0.1.0). For information about the `WinInetProxy` PowerShell script, see [WinInetProxy.psm1](https://www.powershellgallery.com/packages/WinInetProxy/0.1.0/Content/WinInetProxy.psm1).

If you can't install the `WinInetProxy` module to a cluster node because of no internet access, we recommend downloading the module to your management computer, and then manually transferring it to the cluster node where you want to run the module. You can also use the [**Start-BitsTransfer**](/powershell/module/bitstransfer/start-bitstransfer) PowerShell cmdlet to transfer one or more files between your management computer and a server.

To configure the proxy settings for the Azure Stack HCI operating system, run the following PowerShell command as administrator on each server in the cluster:

1. Connect to the server in your Azure Stack HCI cluster via Remote Desktop Protocol (RDP) and open a PowerShell session.
1. To configure proxy settings after you've installed the `WinInetProxy` module, run the following cmdlet:

    ```powershell
    Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer http://<Proxy_Server_Address:Proxy_Port> -ProxyBypass <URLs to bypass>
    ```

    The parameters are described in the following table:

    | Parameter | Description |
    |---|---|
    | ProxySettingsPerUser | Specifies if the proxy settings are per machine or per user: <br><br>- 0 - Proxy settings are per machine.<br>- 1 (default) - Proxy settings are per user.<br>- If no value is provided, the `ProxySettingsPerUser` environment variable is used instead, if present.|
    | ProxyServer | Specifies the proxy server endpoint in the format `http://[Proxy_Server_Address]:[Proxy_Port]`. For example, `http://proxy.contoso.com:8080`.|
    | ProxyBypass | Specifies the list of host URLs that bypass proxy server set by the `-ProxyServer` parameter. For example, you can set `-ProxyBypass “localhost”` to bypass local intranet URLs. The list must include:<br><br>- At least the IP address of each server.<br>- At least the IP address of cluster.<br>- At least the IPs you defined for your infrastructure network. Arc Resource Bridge, AKS, and future infrastructure services using these IPs require outbound connectivity.<br>- Or you can bypass the entire infrastructure subnet.<br>- NetBIOS name of each server.<br>- NetBIOS name of the cluster.<br>- Domain name or domain name with asterisk `*` wildcard for any host or subdomain. |

Here's an example of the command usage:

```powershell
Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer http://192.168.1.250:8080 -ProxyBypass "localhost;127.0.0.1;*.contoso.com;node1;node2;192.168.1.*;s-cluster"
```

### WinInet proxy bypass list string considerations

When configuring the `WinInet` proxy bypass list, keep the following points in mind:

- Parameters must be separated with comma `,` or semicolon `;`.
- CIDR notation to bypass subnets isn't supported.
- Asterisk can be used as wildcards to bypass subnets or domain names. For example, `192.168.1.*` for subnets or `*.contoso.com` for domain names.
- Proxy name must be specified with `http://` and the port. For example, `http://192.168.1.250:8080`.
- We recommend using the same bypass string when configuring `WinInet` and `WinHTTP`.
- The use of `<local>` strings isn't supported in the proxy bypass list.

### View and remove WinInet proxy configuration

- To view or verify current `WinInet` proxy configuration, at the command prompt, type:

    ```powershell
    PS C:\> Get-WinhttpProxy -Advanced

    Current WinHTTP proxy settings:

    Proxy Server(s) :  http://192.168.1.250:8080
    Bypass List     :  localhost;127.0.0.1;*. contoso.com;node1;node2;192.168.1.*;s-cluster

    PS C:\>
    ```

- To remove the `WinInet` proxy configuration for Azure Stack HCI updates and cloud witness, at the command prompt, type:

    ```powershell
    PS C:\> Set-WinInetProxy
    Start proxy Configuration
    Proxy is Per User
    AutoDetect is 0
    PACUrl is
    ProxyServer is
    ProxyBypass is
    Entered WriteProxySettingsHelper
    Entered WriteProxySettingsHelper

    Successfully set proxy
    PS C:\> Get-WinhttpProxy -Advanced
    ```

## Configure proxy settings for WinHTTP

You must configure the `WinHTTP` proxy settings before you [Register the servers with Azure Arc](../deploy/deployment-arc-register-server-permissions.md).

To configure the `WinHTTP` proxy for Azure Stack HCI updates and cloud witness, run the following PowerShell command as administrator on each server in the cluster:

```powershell
Set-winhttpproxy -proxyserver http://<Proxy_Server_Address:Proxy_Port> -BypassList <URLs to bypass>
```

The parameters are described in the following table:

| Parameter | Description |
|---|---|
| ProxyServer | Specifies the proxy server endpoint in the format `http://[Proxy_Server_Address]:[Proxy_Port]`. For example, `http://proxy.contoso.com:8080`. |
| BypassList | Specifies the list of host URLs that bypass proxy server set by the `-ProxyServer` parameter. For example, you can set `-ProxyBypass "localhost"` to bypass local intranet URLs. The list must include: <br><br> - At least the IP address of each server.<br>- At least the IP address of cluster.<br>- At least the IPs you defined for your infrastructure network. Arc Resource Bridge, AKS, and future infrastructure services using these IPs require outbound connectivity.<br>- Or you can bypass the entire infrastructure subnet.<br>- NetBIOS name of each server.<br>- NetBIOS name of the cluster.<br>- Domain name or domain name with asterisk `*` wildcard for any host or subdomain. |

Here's an example of the command usage:

```powershell
Set-winhttpproxy -proxyserver http://192.168.1.250:8080 -BypassList "localhost;127.0.0.1;*.contoso.com;node1;node2;192.168.1.*;s-cluster"
```

### WinHTTP proxy bypass list string considerations

When configuring the `WinHTTP` proxy bypass list string, keep the following points in mind:

- Parameters must be separated with comma `,` or semicolon `;`.
- CIDR notation to bypass subnets isn't supported.
- Asterisk can be used as wildcards to bypass subnets or domain names. For example, `192.168.1.*` for subnets or `*.contoso.com` for domain names.
- Proxy name must be specified with `http://` and the port. For example, `http://192.168.1.250:8080`.
- We recommend using the same bypass string when configuring `WinInet` and `WinHTTP`.
- The use of `<local>` strings isn't supported in the proxy bypass list.

### View and remove WinHTTP proxy configuration

- To view or verify current `WinHTTP` proxy configuration, at the command prompt, type:

    ```powershell
    PS C:\> Get-WinhttpProxy -Default

    Current WinHTTP proxy settings:

    Proxy Server(s) :  http://192.168.1.250:8080
    Bypass List     :  localhost;127.0.0.1;*.contoso.com;node1;node2;192.168.1.*;s-cluster

    PS C:\>
    ```

- To remove the `WinHTTP` proxy configuration for Azure Stack HCI updates and cloud witness, at the command prompt, type:

    ```powershell
    PS C:\> Reset-WinhttpProxy -Direct
    Current WinHTTP proxy settings:
    Direct access (no proxy server). 
    PS C:\>
    ```

## Configure proxy settings for Environment Variables

You must configure the proxy for Azure Resource Bridge and AKS before you [Register the servers with Azure Arc](../deploy/deployment-arc-register-server-permissions.md).

To set the proxy server Environment Variable, run the following commands as administrator on each server in the cluster:

```powershell
# If a proxy server is needed, execute these commands with the proxy URL and port.
[Environment]::SetEnvironmentVariable("HTTPS_PROXY","http://ProxyServerFQDN:port", "Machine")
$env:HTTPS_PROXY = [System.Environment]::GetEnvironmentVariable("HTTPS_PROXY","Machine")
[Environment]::SetEnvironmentVariable("HTTP_PROXY","http://ProxyServerFQDN:port", "Machine")
$env:HTTP_PROXY = [System.Environment]::GetEnvironmentVariable("HTTP_PROXY","Machine")
$no_proxy = "<bypassliststring>"
[Environment]::SetEnvironmentVariable("NO_PROXY",$no_proxy,"Machine")
$env:NO_PROXY = [System.Environment]::GetEnvironmentVariable("NO_PROXY","Machine")
```

The parameters are described in the following table:

| Parameter | Description |
|---|---|
| HTTPS_PROXY variable | Specifies the proxy server endpoint in the format `http://[Proxy_Server_Address]:[Proxy_Port]`. For example, `http://proxy.contoso.com:8080`. |
| HTTP_PROXY variable | Specifies the proxy server endpoint in the format `http://[Proxy_Server_Address]:[Proxy_Port]`. For example, `http://proxy.contoso.com:8080`. |
| NO_PROXY variable | String to bypass local intranet URLs, domains, and subnets. The list must include:<br><br>- At least the IP address of each server.<br>- At least the IP address of cluster.<br>- At least the IPs you defined for your infrastructure network. Arc Resource Bridge, AKS, and future infrastructure services using these IPs require outbound connectivity.<br>- Or you can bypass the entire infrastructure subnet.<br>- NetBIOS name of each server.<br>- NetBIOS name of the cluster.<br>- Domain name or domain name with dot `.` wildcard for any host or subdomain.<br>- `.svc` for internal Kubernetes service traffic.|

Here's an example of the command usage:

```powershell
[Environment]::SetEnvironmentVariable("HTTPS_PROXY", "http://192.168.1.250:8080", "Machine")
$env:HTTPS_PROXY = [System.Environment]::GetEnvironmentVariable("HTTPS_PROXY", "Machine")
[Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://192.168.1.250:8080", "Machine")
$env:HTTP_PROXY = [System.Environment]::GetEnvironmentVariable("HTTP_PROXY", "Machine")
$no_proxy = "localhost,127.0.0.1,.svc,192.168.1.0/24,.contoso.com,node1,node2,s-cluster"
[Environment]::SetEnvironmentVariable("NO_PROXY", $no_proxy, "Machine")
$env:NO_PROXY = [System.Environment]::GetEnvironmentVariable("NO_PROXY", "Machine")
```

### Environment Variables proxy bypass list string considerations

When configuring the Environment Variables proxy bypass list string, keep the following points in mind:

- Parameters must be separated with comma `,`.
- CIDR notation to bypass subnets must be used.
- Asterisk `*` as wildcards to bypass subnets or domain names isn't supported.
- Dots `.` Should be used as wildcards to bypass domain names or local services. For example `.contoso.com` or `.svc`.
- Proxy name must be specified with `http://` and the port for both HTTP_PROXY and HTTPS_PROXY variables. For example, `http://192.168.1.250:8080`.
- `.svc` bypass is for AKS internal services communication in Linux notation. This is required for Arc Resource Bridge and AKS.
- AKS requires to bypass the following subnets. 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16. These subnets will be added to the Environment Variables bypass list automatically if they aren't defined.
- The use of `<local>` strings isn't supported in the proxy bypass list.

### Confirm and remove the Environment Variables proxy configuration

- To confirm that Environment Variables proxy configuration is applied, run the following command:

    ```powershell
    echo "https :" $env:https_proxy "http :" $env:http_proxy "bypasslist " $env:no_proxy
    ```

- To remove the proxy configuration, run the following commands as administrator on each server in the cluster:

    ```powershell
    [Environment]::SetEnvironmentVariable("HTTPS_PROXY", $null, "Machine")
    $env:HTTPS_PROXY = [System.Environment]::GetEnvironmentVariable("HTTPS_PROXY", "Machine")
    [Environment]::SetEnvironmentVariable("HTTP_PROXY", $null, "Machine")
    $env:HTTP_PROXY = [System.Environment]::GetEnvironmentVariable("HTTP_PROXY", "Machine")
    ```

## Configure proxy settings for Arc-enabled servers agent

To configure the Azure Arc-enabled servers agent to communicate through a proxy server, run the following command:

```bash
azcmagent config set proxy.url "http://ProxyServerFQDN:port"
```

You can use an IP address or simple hostname in place of the FQDN if your network requires it. If your proxy server runs on port 80, you may omit ":80" at the end.

To check if a proxy server URL is configured in the agent settings, run the following command:

```bash
azcmagent config get proxy.url
```

To stop the agent from communicating through a proxy server, run the following command:

```bash
azcmagent config clear proxy.url
```

You do not need to restart any services when reconfiguring the proxy settings with the `azcmagent config` command.

Please review the Arc-enabled servers agent page for further details [Managing and maintaining the Connected Machine agent](/azure/azure-arc/servers/manage-agent?tabs=windows#update-or-remove-proxy-settings).

## Configure proxy settings for Azure services

If you're using or plan to use any of the following Azure services, refer to the following articles for information about how to configure proxy server settings for each Azure service:

- [Azure Kubernetes Service (AKS) hybrid](/azure/aks/hybrid/set-proxy-settings)
- [Azure Virtual Desktop](/azure/virtual-desktop/proxy-server-support)
- [Azure Monitor Agent](/azure/azure-monitor/agents/azure-monitor-agent-data-collection-endpoint?tabs=PowerShellWindows#proxy-configuration)
- [Microsoft Defender](/defender-endpoint/production-deployment#network-configuration)
- [Microsoft Monitoring Agent](/azure/azure-monitor/agents/log-analytics-agent#network-requirements) (The MMA agent will deprecate soon. We recommend using the Azure Monitor Agent.)

## Next steps

For more information, see:

- [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).