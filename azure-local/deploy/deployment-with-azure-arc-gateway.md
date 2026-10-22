--- 
title: Register Azure Local with Azure Arc using Arc Gateway
description: Learn how to register Azure Local by using Azure Arc gateway Arc proxy. Both scenarios with and without proxy are configured. 
author: ronmiab
ms.topic: how-to
ms.date: 10/13/2026
ms.author: robess
ms.service: azure-local
zone_pivot_groups: register-arc-options
ms.subservice: hyperconverged
---

# Register Azure Local with Azure Arc using Arc gateway

::: moniker range=">=azloc-2506"

::: zone pivot="register-proxy"

This article details how to register Azure Local using Azure Arc gateway and with the proxy configuration enabled. Once you create an Arc gateway resource in your Azure subscription, you can enable the Arc gateway features. For an overview of the Arc gateway, see [About Azure Arc gateway for Azure Local](./deployment-azure-arc-gateway-overview.md).

[!INCLUDE [post-deployment-proxy-update](../includes/post-deployment-proxy-update.md)]

- **Configure proxy with a script**: Using this method, you can configure Arc proxy with a script. This method is useful as you don't need to configure the Arc proxy across WinInet, WinHttp, or environment variables manually.

- **Set up proxy via the Configurator app**: Using this method, you can configure the Arc proxy via a user interface. This method is useful if you prefer not to use scripts or if you want to configure the proxy settings interactively.

# [Via Arc script](#tab/script)

## Prerequisites

- You have access to Azure Local machines running release 2506 or later. Earlier versions don't support this scenario.

- You have assigned the appropriate permissions to the subscription used for registration. For more information, see [Assign required permissions for Azure Local deployment](deployment-arc-register-server-permissions.md).

- An Arc gateway resource is created in the same subscription used to deploy Azure Local. For more information, see [Create the Arc gateway resource in Azure](deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).

- You have reviewed the supported and unsupported scenarios. For more information, see [Supported and unsupported scenarios](./deployment-azure-arc-gateway-overview.md#supported-and-unsupported-scenarios).

- Required endpoints are open in your firewall. For more information, see [Azure Local endpoints not redirected](./deployment-azure-arc-gateway-overview.md#azure-local-endpoints-not-redirected).

## Step 1: Get the Arc gateway ID  

- **Get Arc gateway ID**. To create Azure Arc gateway, see [Set up an Azure Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure) and get the resource ID of the Arc gateway. This is also referred to as the `ArcGatewayID`.

   1. In the Azure portal, go to the Arc gateway resource that you created.
   1. On the **Overview** page, copy the **Resource ID**. You use this Arc gateway ID later.
   
   :::image type="content" source="media/deployment-with-azure-arc-gateway/arc-gateway-resource-id.png" alt-text="Screenshot of the Resource ID in the Overview page for Azure Arc gateway." lightbox="media/deployment-with-azure-arc-gateway/arc-gateway-resource-id.png":::

## Step 2: Review script parameters

Review the parameters used in the script:

| Parameters | Description |
|--|--|
| `TenantID` | The tenant ID used to register your machines with Azure Arc. Go to your Microsoft Entra ID and copy the tenant ID property. |
| `SubscriptionID` | The ID of the subscription used to register your machines with Azure Arc. |
| `ResourceGroup` | The resource group precreated for Arc registration of the machines. A resource group is created if one doesn't exist. |
| `Region` | The Azure region used for registration. See the [Supported regions](../concepts/system-requirements-23h2.md#azure-requirements) that can be used. |
| `ArcGatewayID` | Define the Arc gateway resource ID from Azure. |
| `ProxyServer` | Optional. Proxy Server address when required for outbound connectivity. |
| `ProxyBypass` | Optional. Define the bypass list for the proxy. Use comma to separate each item from the list. |
| `ArmAccessToken` | Required if you choose to authenticate by using an Azure Resource Manager (ARM) access token. If you omit this parameter, the script prompts for device code authentication. |
| `TargetSolutionVersion` | Optional. The target Azure Local solution version to use for the initial deployment after Azure Arc registration. If you don't specify this optional parameter, you're prompted to select a version from the list of available versions. For example: `12.2602.1002.10` |
 
## Step 3: Set parameters

Set the parameters required for the registration script.

Here's an example of how you should change these parameters for the `Invoke-AzStackHciArcInitialization` initialization script.

```PowerShell
#Define the tenant you will use to register your machine as Arc device
$Tenant = "YourTenantID"

#Define the subscription where you want to register your Azure Local machine with Arc.
$Subscription = "yourSubscriptionID" 
    
#Define the resource group where you want to register your Azure Local machine with Arc.
$RG = "yourResourceGroupName" 

#Define the region to use to register your server as Arc device
#Do not use spaces or capital letters when defining region
$Region = "eastus"

#Define the Arc gateway resource ID from Azure 
$ArcgwId = "/subscriptions/yoursubscriptionid/resourceGroups/yourResourceGroupName/providers/Microsoft.HybridCompute/gateways/yourArcGatewayName" 
    
#Define the proxy address for your Azure Local deployment to access the internet via proxy.
$ProxyServer = "http://proxyaddress:port"

#Define the bypass list for the proxy. Use comma to separate each item from the list.  
# Parameters must be separated with a comma `,`.
# Use "localhost" instead of <local> 
# Use specific IPs such as 127.0.0.1 without mask 
# Use * for subnets allowlisting. 192.168.1.* for /24 exclusions. Use 192.168.*.* for /16 exclusions. 
# Append * for domain names exclusions like *.contoso.com 
# DO NOT INCLUDE .svc on the list. The registration script takes care of Environment Variables configuration. 
# At least the IP address of each Azure Local machine.
# At least the IP address of the Azure Local cluster.
# At least the IPs you defined for your infrastructure network. Arc resource bridge, Azure Kubernetes Service (AKS), and future infrastructure services using these IPs require outbound connectivity.
# NetBIOS name of each machine.
# NetBIOS name of the Azure Local cluster.
    
$ProxyBypassList = "localhost,127.0.0.1,*.contoso.com,machine1,machine2,machine3,machine4,machine5,192.168.*.*,AzureLocal-1" 

#Optional: Define the Azure Resource Manager access token.
# Required only if you want to use token-based authentication instead of device code authentication.
$armTokenResponse = Get-AzAccessToken
    
# Convert token to string for use in initialization
# Required because Get-AzAccessToken returns SecureString
$ArmAccessToken = [System.Net.NetworkCredential]::new("", $armTokenResponse.Token).Password

#Optional: The target Azure Local solution version for initial deployment after Azure Arc registration. If omitted, select a version from the available options.
$TargetSolutionVersion = "<solution-version>" 

```

## Step 4: Run the registration script

[!INCLUDE [run-registration-script-with-arc-gateway](../includes/run-registration-script-with-arc-gateway.md)]

## Step 5: Verify the Azure Arc gateway setup is successful

Once the registration is complete, follow these steps to verify that Azure Arc gateway setup is successful.

1. Connect to the first Azure Local machine from your system.

1. Open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and which ones continue using your firewall or proxy. You can find the Arc gateway log at: *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

    :::image type="content" source="./media/deployment-with-azure-arc-gateway/arc-gateway-log.png" alt-text="Screenshot that shows the Arc gateway log using script." lightbox="./media/deployment-with-azure-arc-gateway/arc-gateway-log.png":::

2. To check the Arc agent configuration and verify that it's using the gateway, run the following command:

   ```
   C:\program files\AzureConnectedMachineAgent>.\azcmagent show
   ```

   The values displayed should be as follows:
    
   1. **Agent version** is **1.45** or later.
    
   2. **Agent Status** should show as **Connected**.
    
   3. **Using HTTPS Proxy**  shows as `http://localhost:40343`when the Arc gateway is enabled.
    
   4. **Upstream Proxy** shows your enterprise proxy server and port.
    
   5. **Azure Arc Proxy** shows as **running** when the Arc gateway is enabled.
    
      
   :::image type="content" source="./media/deployment-with-azure-arc-gateway/arc-agent-with-gateway.png" alt-text="Screenshot that shows the Arc agent with gateway using script." lightbox="./media/deployment-with-azure-arc-gateway/arc-agent-with-gateway.png":::
    
3. Additionally, to verify that the setup was done successfully, run the following command:

   ```
   C:\program files\AzureConnectedMachineAgent>.\azcmagent check
   ```
    
   The response should indicate that the **connection.type** is set to **gateway**, and the **Reachable** column should indicate **true** for all URLs.

   
   Here's an example of the Arc agent using the Arc gateway:
    
   :::image type="content" source="./media/deployment-with-azure-arc-gateway/arc-agent-with-gateway-2.png" alt-text="Screenshot that shows the Arc agent with Arc gateway using script." lightbox="./media/deployment-with-azure-arc-gateway/arc-agent-with-gateway-2.png":::
    
   You can also audit your gateway traffic by viewing the gateway router logs.  
    
   To view gateway router logs on Windows, run the `azcmagent logs` command in PowerShell. In the resulting .zip file, the logs are located in the *C:\ProgramData\Microsoft\ArcGatewayRouter* folder.

# [Via Configurator app](#tab/app)

[!INCLUDE [application-registration-start](../includes/application-registration-start.md)]

[!INCLUDE [application-arc-gateway-prerequisites](../includes/application-arc-gateway-prerequisites.md)]

[!INCLUDE [application-configure-machine](../includes/application-configure-machine.md)]

[!INCLUDE [application-arc-gateway-proxy-settings](../includes/application-arc-gateway-proxy-settings.md)]

[!INCLUDE [application-arc-registration](../includes/application-arc-registration.md)]

---

::: zone-end

::: zone pivot="register-without-proxy"

This article details how to register using Azure Arc gateway on Azure Local without the proxy configuration. You can register via the Arc script or the Configurator app. For an overview of the Arc gateway, see [About Azure Arc gateway for Azure Local](./deployment-azure-arc-gateway-overview.md).

- **Configure with a script**: Using this method, configure the registration settings via a script.

- **Set up via the Configurator app**: Configure Azure Arc gateway via a user interface. This method is useful if you prefer not to use scripts or if you want to configure the registration settings interactively.


# [Via Arc script](#tab/script)

## Prerequisites

- You have access to Azure Local machines running release 2506 or later. Earlier versions don't support this scenario.

- You have assigned the appropriate permissions to the subscription used for registration. For more information, see [Assign required permissions for Azure Local deployment](deployment-arc-register-server-permissions.md).

- An Arc gateway resource is created in the same subscription used to deploy Azure Local. For more information, see [Create the Arc gateway resource in Azure](deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).

- You have reviewed the supported and unsupported scenarios. For more information, see [Supported and unsupported scenarios](./deployment-azure-arc-gateway-overview.md#supported-and-unsupported-scenarios).

- Required endpoints are open in your firewall. For more information, see [Azure Local endpoints not redirected](./deployment-azure-arc-gateway-overview.md#azure-local-endpoints-not-redirected).

## Step 1: Get the Arc gateway ID  

- **Get Arc gateway ID**. To create Azure Arc gateway, see [Set up an Azure Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure) and get the resource ID of the Arc gateway. This is also referred to as the `ArcGatewayID`.

   1. In the Azure portal, go to the Arc gateway resource that you created.
   1. On the **Overview** page, copy the **Resource ID**. You use this Arc gateway ID later.
   
   :::image type="content" source="media/deployment-with-azure-arc-gateway/arc-gateway-resource-id.png" alt-text="Screenshot of the Resource ID in the Overview page for Azure Arc gateway." lightbox="media/deployment-with-azure-arc-gateway/arc-gateway-resource-id.png":::

## Step 2: Review script parameters

Review the parameters used in the script:

| Parameters | Description |
|--|--|
| `TenantID` | The tenant ID used to register your machines with Azure Arc. Go to your Microsoft Entra ID and copy the tenant ID property. |
| `SubscriptionID` | The ID of the subscription used to register your machines with Azure Arc. |
| `ResourceGroup` | The resource group precreated for Arc registration of the machines. A resource group is created if one doesn't exist. |
| `Region` | The Azure region used for registration. See the [Supported regions](../concepts/system-requirements-23h2.md#azure-requirements) that can be used. |
| `ArcGatewayID` | Define the Arc gateway resource ID from Azure. |
| `ArmAccessToken` | Optional. Required if you choose to authenticate by using an ARM access token. If you omit this parameter, the script prompts for device code authentication. |
| `TargetSolutionVersion` | Optional. The target Azure Local solution version to use for the initial deployment after Azure Arc registration. If you don't specify this optional parameter, you're prompted to select a version from the list of available versions. For example: `12.2602.1002.10`. |

## Step 3: Set parameters

Set the parameters required for the registration script.

Here's an example of how you should change these parameters for the `Invoke-AzStackHciArcInitialization` initialization script.

```PowerShell
#Define the tenant you will use to register your machine as Arc device
$Tenant = "YourTenantID"

#Define the subscription where you want to register your Azure Local machine with Arc.
$Subscription = "yourSubscriptionID" 
    
#Define the resource group where you want to register your Azure Local machine with Arc.
$RG = "yourResourceGroupName" 

#Define the region to use to register your server as Arc device
#Do not use spaces or capital letters when defining region
$Region = "eastus"

#Define the Arc gateway resource ID from Azure 
$ArcgwId = "/subscriptions/yoursubscriptionid/resourceGroups/yourResourceGroupName/providers/Microsoft.HybridCompute/gateways/yourArcGatewayName" 
    
#Optional: Define the Azure Resource Manager access token.
# Required only if you want to use token-based authentication instead of device code authentication.
$armTokenResponse = Get-AzAccessToken
    
# Convert token to string for use in initialization
# Required because Get-AzAccessToken returns SecureString
$ArmAccessToken = [System.Net.NetworkCredential]::new("", $armTokenResponse.Token).Password

#Optional: The target Azure Local solution version for initial deployment after Azure Arc registration. If omitted, select a version from the available options.
$TargetSolutionVersion = "<solution-version>" 

```

## Step 4: Run the registration script

[!INCLUDE [run-registration-script-with-arc-gateway](../includes/run-registration-script-with-arc-gateway.md)]

## Step 5: Verify the setup is successful

Once the registration is complete, follow these steps to verify that Azure Arc gateway setup is successful.

1. Connect to the first Azure Local machine from your system.

1. Open the Arc gateway log to monitor the endpoints that are being redirected to the Arc gateway and which ones continue using your firewall. You can find the Arc gateway log at: *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

    :::image type="content" source="./media/deployment-with-azure-arc-gateway/arc-gateway-log.png" alt-text="Screenshot that shows the Arc gateway log using script." lightbox="./media/deployment-with-azure-arc-gateway/arc-gateway-log.png":::

1. To check the Arc agent configuration and verify that it's using the gateway, run the following command:

   ```
   C:\program files\AzureConnectedMachineAgent>.\azcmagent show
   ```

   The values displayed should be as follows:
    
   1. **Agent version** is **1.45** or later.
    
   2. **Agent Status** should show as **Connected**.
    
   3. **Using HTTPS Proxy**  shows as `http://localhost:40343`when the Arc gateway is enabled.
    
   4. **Upstream Proxy** shows your enterprise proxy server and port.
    
   5. **Azure Arc Proxy** shows as **running** when the Arc gateway is enabled.

   
   The Arc agent using the Arc gateway:
    
   :::image type="content" source="./media/deployment-with-azure-arc-gateway/arc-agent-with-gateway.png" alt-text="Screenshot that shows the Arc agent with gateway using script." lightbox="./media/deployment-with-azure-arc-gateway/arc-agent-with-gateway.png":::
    
1. Additionally, to verify that the setup was done successfully, run the following command:

   ```
   C:\program files\AzureConnectedMachineAgent>.\azcmagent check
   ```
    
   The response should indicate that the **connection.type** is set to **gateway**, and the **Reachable** column should indicate **true** for all URLs.
    
    
   The Arc agent using the Arc gateway:
    
   :::image type="content" source="./media/deployment-with-azure-arc-gateway/arc-agent-with-gateway-2.png" alt-text="Screenshot that shows the Arc agent with Arc gateway using script." lightbox="./media/deployment-with-azure-arc-gateway/arc-agent-with-gateway-2.png":::
    
   You can also audit your gateway traffic by viewing the gateway router logs.  
    
   To view gateway router logs on Windows, run the `azcmagent logs` command in PowerShell. In the resulting .zip file, the logs are located in the *C:\ProgramData\Microsoft\ArcGatewayRouter* folder.

# [Via Configurator app](#tab/app)

[!INCLUDE [application-registration-start](../includes/application-registration-start.md)]

[!INCLUDE [application-arc-gateway-prerequisites](../includes/application-arc-gateway-prerequisites.md)]

[!INCLUDE [application-configure-machine](../includes/application-configure-machine.md)]

[!INCLUDE [application-arc-gateway-public-settings](../includes/application-arc-gateway-public-settings.md)]

[!INCLUDE [application-arc-registration](../includes/application-arc-registration.md)]

---

::: zone-end


## Next steps

- [Troubleshoot registration issues with Configurator app](../manage/troubleshoot-deployment-configurator-app.md).
- After your machines are registered with Azure Arc, proceed to deploy your Azure Local instance via one of the following options:
    - [Deploy via Azure portal](./deploy-via-portal.md)
    - [Deploy via Azure Resource Manager (ARM) template](./deployment-azure-resource-manager-template.md)
    
::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506 or later.

::: moniker-end