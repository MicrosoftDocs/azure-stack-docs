--- 
title: Register Azure Local using Arc gateway and with and without proxy setup.
description: Learn how to register Azure Local using Azure Arc gateway Arc proxy. Both scenarios with and without proxy are configured. 
author: alkohli
ms.topic: how-to
ms.date: 09/23/2025
ms.author: alkohli
ms.service: azure-local
zone_pivot_groups: register-arc-options
---

# Register Azure Local with Azure Arc using Arc gateway

::: moniker range=">=azloc-2506"

::: zone pivot="register-proxy"

This article details how to register Azure Local using Azure Arc gateway and with the proxy configuration enabled. Once you create an Arc gateway resource in your Azure subscription, you can enable the Arc gateway features. For an overview of the Arc gateway, see [About Azure Arc gateway for Azure Local](./deployment-azure-arc-gateway-overview.md).

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

## Step 2: Set parameters

1. Set the parameters required for the registration script.

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

    #Define the Arc gateway resource ID from Azure 
    $ArcgwId = "/subscriptions/yourarcgatewayid/resourceGroups/yourResourceGroupName/providers/Microsoft.HybridCompute/gateways/yourArcGatewayName" 
    ```

## Step 3: Run registration script

> [!NOTE]
> If your system uses an Original Equipment Manufacturer (OEM) image, follow the instructions in [Azure Arc registration workflow for systems with OEM images](./deployment-arc-registration-preinstalled-os.md).

1. Run the Arc registration script. The script takes a few minutes to run.

    ```Powershell
    #Invoke the registration script with Proxy and ArcgatewayID 
    Invoke-AzStackHciArcInitialization -TenantID $Tenant -SubscriptionID $Subscription -ResourceGroup $RG -Region $Region -Cloud "AzureCloud" -Proxy $ProxyServer -ArcGatewayID $ArcgwId -ProxyBypass $ProxyBypassList 
    ```

1. During the Arc registration process, you must authenticate with your Azure account. The console window displays a code that you must enter in the URL, displayed in the app, in order to authenticate. Follow the instructions to complete the authentication process.

    :::image type="content" source="media/deployment-with-azure-arc-gateway/authentication-device-code.png" alt-text="Screenshot of the console window with the device code and the URL to open." lightbox="media/deployment-with-azure-arc-gateway/authentication-device-code.png":::

## Step 4: Verify the Azure Arc gateway setup is successful

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

# [Via Configurator app (Preview)](#tab/app)


If you plan to deploy a few machines per site, use the Configurator app to register your Azure Local machines with Azure Arc.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure to complete the following prerequisites:

### Azure Local machine prerequisites

- Download the [Configurator App for Azure Local](https://aka.ms/ConfiguratorAppForHCI) on a client machine that is connected to the same network as the Azure Local machines.

- Note down:

   - The serial number for each machine.
   - Local administrator credentials to sign into each machine.

### Azure prerequisites

- **Get Arc gateway ID**. To create Azure Arc gateway, see [Set up an Azure Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure) and get the resource ID of the Arc gateway. This is also referred to as the `ArcGatewayID`.

   1. In the Azure portal, go to the Arc gateway resource that you created.
   1. On the **Overview** page, copy the **Resource ID**. You use this Arc gateway ID later.
   
   :::image type="content" source="media/deployment-with-azure-arc-gateway/arc-gateway-resource-id.png" alt-text="Screenshot of the Resource ID in the Overview page for Azure Arc gateway." lightbox="media/deployment-with-azure-arc-gateway/arc-gateway-resource-id.png":::

## Step 1: Configure the network and connect to Azure

[!INCLUDE [azure-local-start-configurator](../includes/azure-local-start-configurator.md)]

### Prerequisites tab

[!INCLUDE [azure-local-prerequisites-tab-configurator-app](../includes/azure-local-prerequisites-tab-configurator-app.md)]

### Basics tab

1. On the **Basics** tab, configure one network interface that is connected to the internet. Select the **Pencil icon** to modify network interface settings.

   :::image type="content" source="media/deployment-with-azure-arc-gateway/basics-tab-1.png" alt-text="Screenshot of the Basics tab in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/basics-tab-1.png":::

1. Provide the interface name, IP allocation as static or Dynamic Host Configuration Protocol (DHCP), IP address, subnet, gateway, and preferred DNS servers. Optionally, enter an alternate DNS server.

   :::image type="content" source="media/deployment-with-azure-arc-gateway/basics-tab-2.png" alt-text="Screenshot of the Basics tab with Network settings configured in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/basics-tab-2.png":::

   > [!IMPORTANT]
   > Make sure that the IPs you assign are free and not in use.  

1. To specify more details, select **Enter additional details**.

1. On the **Additional details** page, provide the following inputs and then select **Apply**.

   :::image type="content" source="media/deployment-with-azure-arc-gateway/basics-tab-additional-details-with-proxy.png" alt-text="Screenshot of the Basics tab with additional details configured in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/basics-tab-additional-details-with-proxy.png":::

   1. Select **ON** to enable **Remote desktop** protocol. Remote desktop protocol is disabled by default.

   1. Select **Proxy server** as the connectivity method. Provide the proxy URL and the bypass list. The bypass list is required and can be provided in a comma separated format.
   
      When defining your proxy bypass string, make sure you meet the following conditions:

      - Include at least the IP address of each Azure Local machine.
      - Include at least the IP address of the Azure Local cluster.
      - Include at least the IPs you defined for your infrastructure network. Arc resource bridge, Azure Kubernetes Service (AKS), and future infrastructure services using these IPs require outbound connectivity.
      - Or you can bypass the entire infrastructure subnet.
      - Provide the NetBIOS name of each machine.
      - Provide the NetBIOS name of the Azure Local cluster.
      - Domain name or domain name with asterisk * wildcard at the beginning to include any host or subdomain. For example, `192.168.1.*` for subnets or `*.contoso.com` for domain names.
      - Parameters must be separated with a comma `,`.
      - Classless Inter-Domain Routing (CIDR) notation to bypass subnets isn't supported.
      - The use of \<local\> strings isn't supported in the proxy bypass list.

   1. Select a time zone.

   1. Specify a preferred and an alternate NTP server to act as a time server or accept the **Default**. The default is `time.windows.com`.

   1. Set the hostname for your machine to what you specified during the preparation of Active Directory. Changing the hostname automatically reboots the system.

1. Select **Next** on the **Basics** tab.

### Arc agent setup tab

1. On the **Arc agent setup** tab, provide the following inputs:

   :::image type="content" source="media/deployment-with-azure-arc-gateway/arc-agent-setup-tab-1.png" alt-text="Screenshot of the Arc agent setup tab in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/arc-agent-setup-tab-1.png":::

   1. The **Cloud type** is populated automatically as `Azure`.
   
   1. Enter a **Subscription ID** to register the machine.

   1. Provide a **Resource group** name. This resource group contains the machine and system resources that you create.

   1. Specify the **Region** where you want to create the resources. The region should be the same as the region where you want to deploy the Azure Local instance.

      > [!IMPORTANT]
      > Specify the region with spaces removed. For example, specify the East US region as `EastUS`.

   1. Provide a **Tenant ID**. The tenant ID is the directory ID of your Microsoft Entra tenant. To get the tenant ID, see [Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id).

   1. Specify the Arc gateway ID. This is the resource ID of the Arc gateway that you set up. For more information, see [About Azure Arc gateways](./deployment-azure-arc-gateway-overview.md).

   > [!IMPORTANT]
   > Make sure to verify all the inputs before you proceed. Any incorrect inputs here might result in a setup failure.

1. Select **Next**.

### Review and apply tab

[!INCLUDE [azure-local-review-apply-tab-configurator-app-arc-gateway](../includes/azure-local-review-apply-tab-configurator-app-arc-gateway.md)]

## Step 2: Complete registration of machines to Azure

1. Wait for the configuration to complete. First, machine is configured with the basic details followed by registration of the machines to Azure.

1. During the Arc registration process, you must authenticate with your Azure account. The app displays a code that you must enter in the URL, displayed in the app, in order to authenticate. Follow the instructions to complete the authentication process.

   :::image type="content" source="media/deployment-with-azure-arc-gateway/setup-configuration-authentication.png" alt-text="Screenshot of the Arc agent sign in and registration dialog in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/setup-configuration-authentication.png":::

1. Once the configuration is complete, status for Arc configuration should display **Success (Open in Azure portal)**.

1. Repeat all steps on the other machines until the Arc configuration succeeds. Select the **Open in Azure portal** link.

## Step 3: Verify machines are connected to Arc

[!INCLUDE [azure-local-verify-machines](../includes/azure-local-verify-machines.md)]

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

## Step 2: Set parameters

```PowerShell
#Define the tenant you will use to register your machine as Arc device
$Tenant = "YourTenantID"

#Define the subscription where you want to register your Azure Local machine with Arc.
$Subscription = "yoursubscriptionID" 

#Define the resource group where you want to register your Azure Local machine with Arc.
$RG = "yourresourcegroupname" 

#Define the Arc gateway resource ID from Azure 
$ArcgwId = "/subscriptions/yourarcgatewayid/resourceGroups/yourresourcegroupname/providers/Microsoft.HybridCompute/gateways/yourarcgatewayname" 
```

## Step 3: Run the registration script

> [!NOTE]
> If your system uses an Original Equipment Manufacturer (OEM) image, follow the instructions in [Azure Arc registration workflow for systems with OEM images](./deployment-arc-registration-preinstalled-os.md).

To use the Arc gateway feature for Azure Local systems without a proxy, only use the `ArcGatewayID` parameter.

1. Run the initialization script as follows.

    ```azurecli
    
    #Invoke the registration script with ArcgatewayID 
    Invoke-AzStackHciArcInitialization -TenantID $Tenant -SubscriptionID $Subscription -ResourceGroup $RG -Region $Region -Cloud "AzureCloud" -ArcGatewayID $ArcgwId
    ```

1. During the Arc registration process, you must authenticate with your Azure account. The console window displays a code that you must enter in the URL, in order to authenticate. Follow the instructions to complete the authentication process.

    :::image type="content" source="media/deployment-with-azure-arc-gateway/authentication-device-code.png" alt-text="Screenshot of the console window with the device code and the URL to open." lightbox="media/deployment-with-azure-arc-gateway/authentication-device-code.png":::

## Step 4: Verify the setup is successful

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

# [Via Configurator app (Preview)](#tab/app)

If you plan to deploy a few machines per site, use the Configurator app to register your Azure Local machines with Azure Arc gateway.

[!INCLUDE [important](../includes/hci-preview.md)]


## Prerequisites

Before you begin, make sure that you complete the following prerequisites:

### Azure Local machine prerequisites

- Download the [Configurator App for Azure Local](https://aka.ms/ConfiguratorAppForHCI) on a client machine that is connected to the same network as the Azure Local machines..

- Note down:

   - The serial number for each machine.
   - Local administrator credentials to sign into each machine.

### Azure prerequisites

- **Get Arc gateway ID**. To create Azure Arc gateway, see [Set up an Azure Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure) and get the resource ID of the Arc gateway. This is also referred to as the `ArcGatewayID`.

   1. In the Azure portal, go to the Arc gateway resource that you created.
   1. On the **Overview** page, copy the **Resource ID**. You use this Arc gateway ID later.
 
   :::image type="content" source="media/deployment-with-azure-arc-gateway/arc-gateway-resource-id.png" alt-text="Screenshot of the Resource ID in the Overview page for Azure Arc gateway." lightbox="media/deployment-with-azure-arc-gateway/arc-gateway-resource-id.png":::
 
## Step 1: Configure the network and connect to Azure

[!INCLUDE [azure-local-start-configurator](../includes/azure-local-start-configurator.md)]

### Prerequisites tab

[!INCLUDE [azure-local-prerequisites-tab-configurator-app](../includes/azure-local-prerequisites-tab-configurator-app.md)]

### Basics tab

1. On the **Basics** tab, configure one network interface that is connected to the internet. Select the **Pencil icon** to modify network interface settings.

   :::image type="content" source="media/deployment-with-azure-arc-gateway/basics-tab-1.png" alt-text="Screenshot of the Basics tab in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/basics-tab-2.png":::

1. Provide the interface name, IP allocation as static or DHCP, IP address, subnet, gateway, and preferred DNS servers. Optionally, enter an alternate DNS server.

   :::image type="content" source="media/deployment-with-azure-arc-gateway/basics-tab-2.png" alt-text="Screenshot of the Basics tab with Network settings configured in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/basics-tab-1.png":::

   > [!IMPORTANT]
   > Make sure that the IPs you assign are free and not in use.  

1. To specify more details, select **Enter additional details**.

1. On the **Additional details** page, provide the following inputs and then select **Apply**.

   :::image type="content" source="media/deployment-with-azure-arc-gateway/basics-tab-additional-details-1.png" alt-text="Screenshot of the Basics tab with additional details configured in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/basics-tab-additional-details-1.png":::

   1. Select **ON** to enable **Remote desktop** protocol. Remote desktop protocol is disabled by default.

   1. Select **Public endpoint** as the connectivity method.

   1. Select a time zone.

   1. Specify a preferred and an alternate NTP server to act as a time server or accept the **Default**. The default is `time.windows.com`.

   1. Set the hostname for your machine to what you specified during the preparation of Active Directory. Changing the hostname automatically reboots the system.

1. Select **Next** on the **Basics** tab.

### Arc agent setup tab

1. On the **Arc agent setup** tab, provide the following inputs:

   :::image type="content" source="media/deployment-with-azure-arc-gateway/arc-agent-setup-tab-1.png" alt-text="Screenshot of the Arc agent setup tab in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/arc-agent-setup-tab-1.png":::

   1. The **Cloud type** is populated automatically as `Azure`.
   
   1. Enter a **Subscription ID** to register the machine.

   1. Provide a **Resource group** name. This resource group contains the machine and system resources that you create.

   1. Specify the **Region** where you want to create the resources. The region should be the same as the region where you want to deploy the Azure Local instance.

      > [!IMPORTANT]
      > Specify the region with spaces removed. For example, specify the East US region as `EastUS`.

   1. Provide a **Tenant ID**. The tenant ID is the directory ID of your Microsoft Entra tenant. To get the tenant ID, see [Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id).

   1. Specify the Arc gateway ID. This is the resource ID of the Arc gateway that you got earlier when completing the [Azure prerequisites](#azure-prerequisites-1).

   > [!IMPORTANT]
   > Make sure to verify all the inputs before you proceed. Any incorrect inputs here might result in a setup failure.

1. Select **Next**.

### Review and apply tab

[!INCLUDE [azure-local-review-apply-tab-configurator-app-arc-gateway](../includes/azure-local-review-apply-tab-configurator-app-arc-gateway.md)]

## Step 2: Complete registration of machines to Azure

1. Wait for the configuration to complete. First, machine is configured with the basic details followed by registration of the machines to Azure.

1. During the Arc registration process, you must authenticate with your Azure account. The app displays a code that you must enter in the URL, displayed in the app, in order to authenticate. Follow the instructions to complete the authentication process.

   :::image type="content" source="media/deployment-with-azure-arc-gateway/setup-configuration-authentication.png" alt-text="Screenshot of the Arc agent sign in and registration dialog in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/setup-configuration-authentication.png":::

1. Once the configuration is complete, status for Arc configuration should display **Success (Open in Azure portal)**.

1. Repeat all steps on the other machines until the Arc configuration succeeds. Select the **Open in Azure portal** link.

## Step 3: Verify machines are connected to Arc

[!INCLUDE [azure-local-verify-machines](../includes/azure-local-verify-machines.md)]

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
