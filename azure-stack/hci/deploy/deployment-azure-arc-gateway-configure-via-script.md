--- 
title: Configure Arc proxy via registration script for Azure gateway, version 2408 (preview)
description: Learn how to Configure Arc proxy via registration script for Azure gateway, version 2408 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 09/26/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Configure Arc proxy via registration script for Azure gateway (preview)

Applies to: Azure Stack HCI, versions 2408.1, 2408, and 23H2

After creating the Arc gateway resource in your Azure subscription, you can enable the new Arc gateway preview features. This article details how to configure the Arc proxy before Arc registration using a registration script for the Arc gateway.

Using this method, you don’t need to configure the Arc proxy across WinInet, WinHttp, or environment variables manually.

[!INCLUDE [important](../../hci/includes/hci-preview.md)]

## Prerequisites

Make sure the following prerequisites are met before proceeding:

- You’ve access to an Azure Stack HCI, version 23H2 system.

- An Arc gateway resource created in the same subscription as used to deploy Azure Stack HCI. For more information, see [Create the Arc gateway resource in Azure](deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).

> [!Warning]
> Only the standard ISO OS image available at https://aka.ms/PVenEREWEEW should be used to test the Arc gateway public preview on Azure Stack HCI, version 2408. Do not use the ISO image available in Azure portal.

## Step 1: Get the ArcGatewayID  

You need the proxy and the ArcGatewayID from Azure to run the Azure Stack HCI node registration script. To get the ArcGatewayID value, run the `az connectedmachine gateway list` command described previously. Do not run this command from any Azure Stack HCI nodes:

```azurecli
PS C:\> az connectedmachine gateway list 
This command is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus 
[ 
  { 
    "allowedFeatures": [ 
      "*" 
    ], 
    "gatewayEndpoint": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx.gw.arc.azure.com", 
    "gatewayId": "xxxxxxx-xxxx-xxx-xxxx-xxxxxxxxx", 
    "gatewayType": "Public", 
    "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx/resourceGroups/yourresourcegroup/providers/Microsoft.HybridCompute/gateways/yourArcgateway", 
    "location": "eastus", 
    "name": " yourArcgateway", 
    "provisioningState": "Succeeded", 
    "resourceGroup": "yourresourcegroup", 
    "type": "Microsoft.HybridCompute/gateways" 
  } 
] 
```

## Step 2: Register new Azure Stack HCI version 2408 nodes

You can run the initialization script by passing the `ArcGatewayID`, `Proxy server`, and `Proxy bypass list` parameters.

Here's an example of how you should change these parameters for the `Invoke-AzStackHciArcInitialization` initialization script. Once registration is completed, the Azure Stack HCI nodes are registered in Azure Arc using the Arc gateway:

```azurecli
#Install required PowerShell modules in your node for registration 
Install-Module Az.Accounts -RequiredVersion 2.13.2 
Install-Module Az.Resources -RequiredVersion 6.12.0 
Install-Module Az.ConnectedMachine -RequiredVersion 0.5.2 

#Install Arc registration script from PSGallery  
Install-Module AzsHCI.ARCinstaller 

#Define the subscription where you want to register your server as Arc device 
$Subscription = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx" 

#Define the resource group where you want to register your server as Arc device 
$RG = "yourresourcegroupname" 

#Define the tenant to use to register your server as Arc device 
$Tenant = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx" 

#Define Proxy Server if necessary 
$ProxyServer = "http://x.x.x.x:port" 

#Define the Arc gateway resource ID from Azure 
$ArcgwId = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx /resourceGroups/ yourresourcegroupname /providers/Microsoft.HybridCompute/gateways/yourarcgatewayname" 

#Define the bypass list for the proxy. Use semicolon to separate each item from the list.  
# Use "localhost" instead of <local> 
# Use specific IPs such as 127.0.0.1 without mask 
# Use * for subnets allowlisting. 192.168.1.* for /24 exclusions. Use 192.168.*.* for /16 exclusions. 
# Append * for domain names exclusions like *.contoso.com 
# DO NOT INCLUDE .svc on the list. The registration script takes care of Environment Variables configuration. 

$ProxyBypassList = "localhost;127.0.0.1;*.contoso.com;Node1;Node2;node3;node4;node5;192.168.*.*;HCI-cluster1” 

#Connect to your Azure account and Subscription 
Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode 

#Get the Access Token and Account ID for the registration 
$ARMtoken = (Get-AzAccessToken).Token 

#Get the Account ID for the registration 
$id = (Get-AzContext).Account.Id 

#Invoke the registration script with Proxy and ArcgatewayID 
Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region australiaeast -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Proxy $ProxyServer -ArcGatewayID $ArcgwId -ProxyBypass $ProxyBypassList 
```

## Step 3: Verify that the setup succeeded

Once the deployment validation starts, you can connect to the first Azure Stack HCI node from your cluster and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and  which ones continue using your firewall or proxy.

You can find the Arc gateway log at: *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png" alt-text="Screenshot that shows the Arc gateway log using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png":::

To check the Arc agent configuration and verify that it is using the gateway, run the following command: `c:\program files\AzureConnectedMachineAgent>.\azcmagent show`.

The values displayed should be as follows:

- **Agent version** is **1.45**.

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
- [Get support for Azure Stack HCI](../manage/get-support.md)
