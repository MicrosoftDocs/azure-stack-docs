--- 
title: Configure Arc proxy manually for Azure gateway on Azure Local, version 2408 and 2408.1 (preview)
description: Learn how to configure Arc proxy manually for Azure gateway on Azure Local, version 2408 and 2408.1 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 04/22/2025
ms.author: alkohli
ms.service: azure-local
---

# Configure Arc proxy manually for Azure gateway on Azure Local (preview)

::: moniker range=">=azloc-24111"

Applies to: Azure Local 2411.1 and later

After creating the Arc gateway resource in your Azure subscription, you can enable the new Arc gateway preview features. This article details how to manually configure the Arc proxy before Arc registration.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

Make sure the following prerequisites are met before proceeding:

- You've access to an Azure Local instance running release 2411.1 or later. Prior versions do not support this scenario.

- An Arc gateway resource created in the same subscription as used to deploy Azure Local. For more information, see [Create the Arc gateway resource in Azure](deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).

## Step 1: Manually configure the proxy

If you need to configure the Arc proxy on your Azure Local machines before starting the Arc registration process, follow the instructions at [Configure proxy settings for Azure Local](../manage/configure-proxy-settings-23h2.md).

Ensure that you configure the proxy and the bypass list for all the machines on your system.

## Step 2: Get the ArcGatewayID  

You need the proxy and the Arc gateway ID (ArcGatewayID) from Azure to run the registration script on Azure Local machines. You can find the Arc gateway ID on the Azure portal overview page of the resource.

## Step 3: Register new machines in Azure Arc

To register new version 2408 or version 2411 machines in Azure Arc, you run the initialization script by passing the ArcGatewayID parameter and the proxy server parameters. Here's an example of how you should change the `Invoke-AzStackHciArcInitialization` parameters on the initialization script:

```azurecli
#Define the subscription where you want to register your server as Arc device. 

$Subscription = "yoursubscription" 

#Define the resource group where you want to register your server as Arc device.

$RG = "yourresourcegroupname" 

#Define the tenant you will use to register your server as Arc device. 

$Tenant = "yourtenant" 

#Define Proxy Server if necessary 

$ProxyServer = "http://x.x.x.x:port" 

#Define the Arc gateway resource ID from Azure 

$ArcgwId = "/subscriptions/yoursubscription/resourceGroups/yourresourcegroupname/providers/Microsoft.HybridCompute/gateways/yourarcgatewayname" 

#Define the bypass list for the proxy. Use comma to separate each item from the list.  
# Use "localhost" instead of <local> 
# Use specific IPs such as 127.0.0.1 without mask 
# Use * for subnets allowlisting. 192.168.1.* for /24 exclusions. Use 192.168.*.* for /16 exclusions. 
# Append * for domain names exclusions like *.contoso.com 
# DO NOT INCLUDE .svc on the list. The registration script takes care of Environment Variables configuration. 

$ProxyBypassList = "localhost,127.0.0.1,*.contoso.com,machine1,machine2,machine3,machine4,machine5,192.168.*.*,AzureLocal-1" 

#Connect to your Azure account and subscription 

Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode 

#Get the Access Token and Account ID for the registration 

$ARMtoken = (Get-AzAccessToken).Token 

#Get the Account ID for the registration 

$id = (Get-AzContext).Account.Id 

#Invoke the registration script with Proxy and ArcgatewayID 

Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region australiaeast -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Proxy $ProxyServer -ProxyBypass $ProxyBypassList  -ArcGatewayID $ArcgwId 
```

## Step 4: Start Azure Local cloud deployment

Once the Azure Local machines are registered in Azure Arc and all the extensions are installed, you can start deployment from Azure portal or using the ARM templates that are documented in these articles:

- [Deploy an Azure Local instance using the Azure portal](deploy-via-portal.md).

- [Azure Resource Manager template deployment for Azure Local](deployment-azure-resource-manager-template.md).

## Step 5: Verify that the setup succeeded

Once the deployment validation starts, you can connect to the first Azure Local machine from your system and open the Arc gateway log to monitor which endpoints are redirected to the Arc gateway and which ones continue using your firewall or proxy.

You can find the Arc gateway log at: *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png" alt-text="Screenshot that shows the Arc gateway log using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png":::

To check the Arc agent configuration and verify that it is using the Arc gateway, run the following command: `c:\program files\AzureConnectedMachineAgent>.\azcmagent show`

The result should show the following values:

- **Agent version** is **1.45** or above.

- **Agent Status** is **Connected**.

- **Using HTTPS Proxy**  is empty when Arc gateway isn't in use. It should show as `http://localhost:40343` when the Arc gateway is enabled.

- **Upstream Proxy** shows your enterprise proxy server and port.

- **Azure Arc Proxy** shows as **stopped** when Arc gateway isn't in use, and **running** when the Arc gateway is enabled.

The Arc agent without the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway.png" alt-text="Screenshot that shows the Arc agent without gateway using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway.png":::

The Arc agent using the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway.png" alt-text="Screenshot that shows the Arc agent with gateway using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway.png":::

Additionally, to verify that the setup successful, you can run the following command: `c:\program files\AzureConnectedMachineAgent>.\azcmagent check`.

The response should indicate that `connection.type` is set to `gateway`, and the **Reachable** column should indicate **true** for all URLs, as shown:

The Arc agent without the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png" alt-text="Screenshot that shows the Arc agent without gateway 2 using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png":::

The Arc agent with the Arc gateway enabled:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png" alt-text="Screenshot that shows the Arc agent with gateway 2 using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png":::

You can also audit your gateway traffic by viewing the gateway router logs.  

To view gateway router logs on Windows, run the `azcmagent logs` command in PowerShell. In the resulting .zip file, the logs are located in the *C:\ProgramData\Microsoft\ArcGatewayRouter* folder.

## Next steps

- [Get support for deployment issues](../manage/get-support-for-deployment-issues.md)
- [Get support for Azure Local](../manage/get-support.md)

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local 2411.1 or later.

::: moniker-end
