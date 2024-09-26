--- 
title: Connect Azure Stack HCI version 23H2 nodes to Arc gateway, version 2408 (preview)
description: Learn how to connect the Azure Stack HCI version 23H2 nodes to Arc gateway version 2408 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 09/26/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Connect Azure Stack HCI nodes to Arc gateway (preview)

Applies to: Azure Stack HCI, versions 2408.1, 2408, and 23H2

This article details how to connect Azure Stack HCI, versions 2408.1 and 2408 node Arc agents to Arc gateway.

After creating the Arc gateway resource in your subscription, you have two options to enable the new Arc gateway preview features.  

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Make sure the following prerequisites are met before proceeding:

- You’ve access to an Azure Stack HCI, version 23H2 system.

- An Arc gateway resource created in the same subscription as used to deploy Azure Stack HCI. For more information, see [Create the Arc gateway resource in Azure](deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).

> [!Warning]
> Only the standard ISO OS image available at https://aka.ms/PVenEREWEEW should be used to test the Arc gateway public preview on Azure Stack HCI, version 2408. Do not use the ISO image available in Azure portal.

## Option 1: Configure the proxy manually

This option entails manually configuring the Arc proxy before Arc registration.

### Step 1: Manually configure the proxy on each node

If you need to configure the Arc proxy on your Azure Stack HCI nodes before starting the Arc registration process, follow the instructions at [Configure proxy settings for Azure Stack HCI, version 23H2](../manage/configure-proxy-settings-23h2.md).

Ensure that you configure the proxy and the bypass list for all your Azure Stack HCI cluster nodes.

### Step 2: Get the ArcGatewayID  

You will need the proxy and the Arc gateway ID (ArcGatewayID) from Azure to run the Azure Stack HCI node registration script. To get the ArcGatewayID, run the following `az connectedmachine gateway list` command from any computer that is not an Azure Stack HCI node.

Here is an example:

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

### Step 3: Register new nodes in Azure Arc

You run the initialization script by passing the ArcGatewayID parameter and the proxy server parameters. Here is an example of how you should change the `Invoke-AzStackHciArcInitialization` parameters on the initialization script:

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

#Define the tenant you will use to register your server as Arc device 

$Tenant = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx" 

#Define Proxy Server if necessary 

$ProxyServer = "http://x.x.x.x:port" 

#Define the Arc gateway resource ID from Azure 

$ArcgwId = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx /resourceGroups/ yourresourcegroupname /providers/Microsoft.HybridCompute/gateways/yourarcgatewayname" 

#Connect to your Azure account and Subscription 

Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode 

#Get the Access Token and Account ID for the registration 

$ARMtoken = (Get-AzAccessToken).Token 

#Get the Account ID for the registration 

$id = (Get-AzContext).Account.Id 

#Invoke the registration script with Proxy and ArcgatewayID 

Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region australiaeast -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Proxy $ProxyServer -ArcGatewayID $ArcgwId 
```

### Step 4: Start Azure Stack HCI cloud deployment

Once the Azure Stack HCI nodes are registered in Azure Arc and all the extensions are installed, you can start deployment from Azure portal or using the ARM templates documented in these articles:

- [Deploy an Azure Stack HCI system using the Azure portal](deploy-via-portal.md).

- [Azure Resource Manager template deployment for Azure Stack HCI, version 23H2](deployment-azure-resource-manager-template.md).

### Step 5: Verify that the set up succeeded

Once the deployment validation starts, you can connect to the first Azure Stack HCI node from your cluster and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and which ones continue using your firewall or proxy security solutions.

You can find the Arc gateway log at: *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png" alt-text="Output showing Arc gateway log using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png":::

To check the Arc agent configuration and verify that it is using the Arc gateway, run the following command: `c:\program files\AzureConnectedMachineAgent>.\azcmagent show`

The result should show the following values:

- **Agent version** is **1.45**.

- **Agent Status** should show as **Connected**.

- **Using HTTPS Proxy**  will be empty when Arc gateway is not in use. It should show as `http://localhost:40343` when the Arc gateway is enabled.

- **Upstream Proxy** will show your enterprise proxy server and port.

- **Azure Arc Proxy** It will show as **stopped** when Arc gateway is not in use, and **running** when the Arc gateway is enabled.

The Arc agent without the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway.png" alt-text="Output showing Arc agent without gateway using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway.png":::

The Arc agent using the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway.png" alt-text="Output showing Arc agent with gateway using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway.png":::

Additionally, to verify that the setup successful, you can run the following command: `c:\program files\AzureConnectedMachineAgent>.\azcmagent check`.

The response should indicate that `connection.type` is set to `gateway`, and the **Reachable** column should indicate **true** for all URLs, as shown:

The Arc agent without the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png" alt-text="Output showing Arc agent without gateway 2 using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png":::

The Arc agent with the Arc gateway enabled:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png" alt-text="Output showing Arc agent with gateway 2 using manual method." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png":::

You can also audit your gateway traffic by viewing the gateway router logs.  

To view gateway router logs on Windows, run the `azcmagent logs` command in PowerShell. In the resulting .zip file, the logs are located in the *C:\ProgramData\Microsoft\ArcGatewayRouter* folder.

## Option 2: Configure the proxy using Arc registration script

With this method, you don’t need to configure the proxy across WinInet, WinHttp, and Environment Variables manually like with option 1.

### Step 1: Get the ArcGatewayID  

You will need the proxy and the ArcGatewayID from Azure to run the Azure Stack HCI node registration script. To get the ArcGatewayID value, run the `az connectedmachine gateway list` command described previously. Do not run this command from any Azure Stack HCI nodes:

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

### Step 2: Register new Azure Stack HCI version 2408 nodes

You can run the initialization script by passing the the `ArcGatewayID`, `Proxy server`, and `Proxy bypass list` parameters.

Here is an example of how you should change these parameters for the `Invoke-AzStackHciArcInitialization` initialization script. Once registration is completed, the Azure Stack HCI nodes will be registered in Azure Arc using the Arc gateway:

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

#Define the tenant you will use to register your server as Arc device 
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

### Step 3: Verify that the set up succeeded

Once the deployment validation starts, you can connect to the first Azure Stack HCI node from your cluster and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and  which ones continue using your firewall or proxy security solutions.

You can find the Arc gateway log at: *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png" alt-text="Output showing the Arc gateway log using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-gateway-log.png":::

To check the Arc agent configuration and verify that it is using the gateway, run the following command: `c:\program files\AzureConnectedMachineAgent>.\azcmagent show`.

The values displayed should be as follows:

- **Agent version** is **1.45**.

- **Agent Status** should show as **Connected**.

- **Using HTTPS Proxy**  will be empty when Arc gateway is not in use. It should show as `http://localhost:40343` when the Arc gateway is enabled.

- **Upstream Proxy** will show your enterprise proxy server and port.

- **Azure Arc Proxy** It will show as stopped when Arc gateway is not in use. Running when the Arc gateway is enabled.

The Arc agent without the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway.png" alt-text="Output showing Arc agent without gateway using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png":::

The Arc agent using the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway.png" alt-text="Output showing Arc agent with gateway using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png":::

Additionally, to verify that the setup was done successfully, you can run the following command: `c:\program files\AzureConnectedMachineAgent>.\azcmagent check`.

The response should indicate that the **connection.type** is set to **gateway**, and the **Reachable** column should indicate **true** for all URLs.

The Arc agent without the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png" alt-text="Output showing Arc agent without Arc gateway using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-without-gateway-2.png":::

The Arc agent using the Arc gateway:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png" alt-text="Output showing Arc agent with Arc gateway using script." lightbox="./media/deployment-connect-nodes-to-arc-gateway/arc-agent-with-gateway-2.png":::

You can also audit your gateway traffic by viewing the gateway router logs.  

To view gateway router logs on Windows, run the `azcmagent logs` command in PowerShell. In the resulting .zip file, the logs are located in the *C:\ProgramData\Microsoft\ArcGatewayRouter* folder.

## Option 3: Using Arc gateway on environments that do not have proxy

To use the Arc gateway feature for Azure Stack HCI systems without a proxy, ensure you use the `ProxyBypassList` parameter to specify traffic that shouldn't route through the Arc Gateway. Create the bypass list according to this article.

Run the initialization script as follows. All other instructions remain the same as Option 2: Configure the proxy using Arc registration script.

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

#Define the tenant you will use to register your server as Arc device

$Tenant = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
 
#Define the Arc gateway resource ID from Azure

$ArcgwId = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx /resourceGroups/ yourresourcegroupname /providers/Microsoft.HybridCompute/gateways/yourarcgatewayname"

#Define the bypass list for the proxy. Use semicolon to separate each item from the list.

# Use “localhost” instead of <local>

# Use specific IPs such as 127.0.0.1 without mask

# Use * for subnets whitelisting. 192.168.1.* for /24 exclusions. Use 192.168.*.
* for /16 exclusions.

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

Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup
$RG -TenantID $Tenant -Region australiaeast -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -ArcGatewayID $ArcgwId -ProxyBypass
$ProxyBypassList
```

## Next steps

- [Get support for Azure Stack HCI deployment issues](../manage/get-support-for-deployment-issues.md)
