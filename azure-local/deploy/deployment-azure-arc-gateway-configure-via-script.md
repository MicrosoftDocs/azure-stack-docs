--- 
title: Configure Arc proxy via registration script for Azure gateway on Azure Local, version 2408 (preview)
description: Learn how to Configure Arc proxy via registration script for Azure gateway on Azure Local, version 2408 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 04/22/2025
ms.author: alkohli
ms.service: azure-local
---

# Configure Arc proxy via registration script for Azure gateway on Azure Local (preview)

::: moniker range=">=azloc-2505"

Applies to: Azure Local 2505 and later

After creating the Arc gateway resource in your Azure subscription, you can enable the new Arc gateway preview features. This article details how to configure the Arc proxy before Arc registration using a registration script for the Arc gateway on Azure Local.

Using this method, you don't need to configure the Arc proxy across WinInet, WinHttp, or environment variables manually.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

Make sure the following prerequisites are met before proceeding:

- You've access to an Azure Local instance running release 2505 or later. Prior versions do not support this scenario.

- An Arc gateway resource created in the same subscription as used to deploy Azure Local. For more information, see [Create the Arc gateway resource in Azure](deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).

## Step 1: Get the ArcGatewayID  

You need the proxy and the ArcGatewayID from Azure to run the registration script on Azure Local machines. You can find the Arc gateway ID on the Azure portal overview page of the resource.

## Step 2: Register new machines in Azure Arc

To register version 2505 or later Azure Local machines in Azure Arc, you run the initialization script by passing the `ArcGatewayID`, `Proxy server`, and `Proxy bypass list` parameters. During the bootstrap configuration you will be required to authenticate with your credentials using the device code.

Here's an example of how you should change these parameters for the `Invoke-AzStackHciArcInitialization` initialization script. Once registration is completed, the Azure Local machines are registered in Azure Arc using the Arc gateway:

```azurecli
#Define the subscription where you want to register your server as Arc device.
$Subscription = "yoursubscription" 

#Define the resource group where you want to register your server as Arc device.
$RG = "yourresourcegroupname" 

#Define the tenant to use to register your server as Arc device. 
$Tenant = "yourtenant" 

#Define Proxy Server if necessary 
$ProxyServer = "http://x.x.x.x:port" 

#Define the Arc gateway resource ID from Azure 
$ArcgwId = "/subscriptions/yourarcgatewayid/resourceGroups/yourresourcegroupname/providers/Microsoft.HybridCompute/gateways/yourarcgatewayname" 

#Define the bypass list for the proxy. Use comma to separate each item from the list.  
# Use "localhost" instead of <local> 
# Use specific IPs such as 127.0.0.1 without mask 
# Use * for subnets allowlisting. 192.168.1.* for /24 exclusions. Use 192.168.*.* for /16 exclusions. 
# Append * for domain names exclusions like *.contoso.com 
# DO NOT INCLUDE .svc on the list. The registration script takes care of Environment Variables configuration. 

$ProxyBypassList = "localhost,127.0.0.1,*.contoso.com,machine1,machine2,machine3,machine4,machine5,192.168.*.*,AzureLocal-1" 

#Invoke the registration script with Proxy and ArcgatewayID 
Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -Region australiaeast -Cloud "AzureCloud" -Proxy $ProxyServer -ArcGatewayID $ArcgwId -ProxyBypass $ProxyBypassList 
```

## Step 3: Verify that the setup succeeded

Once the deployment validation starts, you can connect to the first machine from your system and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and which ones continue using your firewall or proxy.

You can find the Arc gateway log at: *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png" alt-text="Screenshot that shows the Arc gateway log using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png":::

To check the Arc agent configuration and verify that it is using the gateway, run the following command: `c:\program files\AzureConnectedMachineAgent>.\azcmagent show`.

The values displayed should be as follows:

- **Agent version** is **1.45** or above.

- **Agent Status** should show as **Connected**.

- **Using HTTPS Proxy**  empty when Arc gateway isn't in use. It should show as `http://localhost:40343` when the Arc gateway is enabled.

- **Upstream Proxy** shows your enterprise proxy server and port.

- **Azure Arc Proxy** shows as stopped when Arc gateway isn't in use. Running when the Arc gateway is enabled.

The Arc agent without the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway.png" alt-text="Screenshot that shows the Arc agent without gateway using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png":::

The Arc agent using the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway.png" alt-text="Screenshot that shows the Arc agent with gateway using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png":::

Additionally, to verify that the setup was done successfully, you can run the following command: `c:\program files\AzureConnectedMachineAgent>.\azcmagent check`.

The response should indicate that the **connection.type** is set to **gateway**, and the **Reachable** column should indicate **true** for all URLs.

The Arc agent without the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png" alt-text="Screenshot that shows the Arc agent without Arc gateway using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png":::

The Arc agent using the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png" alt-text="Screenshot that shows the Arc agent with Arc gateway using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png":::

You can also audit your gateway traffic by viewing the gateway router logs.  

To view gateway router logs on Windows, run the `azcmagent logs` command in PowerShell. In the resulting .zip file, the logs are located in the *C:\ProgramData\Microsoft\ArcGatewayRouter* folder.

## Next steps

- [Get support for deployment issues](../manage/get-support-for-deployment-issues.md)
- [Get support for Azure Local](../manage/get-support.md)

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local 2411.1 or later.

::: moniker-end
