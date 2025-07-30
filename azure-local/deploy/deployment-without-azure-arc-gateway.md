--- 
title: Register Azure Local with Arc.
description: Learn how to register Azure Local with Azure Arc with and without proxy setup. The proxy configuration can be done via an Arc script or via the Configurator app for Azure gateway on Azure Local. 
author: alkohli
ms.topic: how-to
ms.date: 07/28/2025
ms.author: alkohli
ms.service: azure-local
zone_pivot_groups: register-arc-options
---

# Register Azure Local with Arc

::: moniker range=">=azloc-2505"

::: zone pivot="register-proxy"

This article details how to register an Azure Local with Arc and with proxy configuration. The proxy configuration can be done via an Arc script or via the Configurator app for Azure gateway on Azure Local.

- **Configure with a script**: You can use an Arc script to configure registration settings.

- **Set up via the Configurator app (Preview)**: Using this method, you can configure Azure Local registration via a user interface. This method is useful if you prefer not to use scripts or if you want to configure the settings interactively.

# [Via Arc script](#tab/script)

## Prerequisites

Make sure the following prerequisites are met before proceeding:

- You've access to an Azure Local instance running release 2508 or later. Prior versions do not support this scenario.

> [!IMPORTANT]
> Run these steps as a local administrator on every Azure Local machine that you intend to cluster.

## Step 1: Review script parameters

1. Set the parameters. The script takes in the following parameters:

    |Parameters  |Description  |
    |------------|-------------|
    |`SubscriptionID`    |The ID of the subscription used to register your machines with Azure Arc.         |
    |`ResourceGroup`     |The resource group precreated for Arc registration of the machines. A resource group is created if one doesn't exist.         |
    |`Region`            |The Azure region used for registration. See the [Supported regions](../concepts/system-requirements-23h2.md#azure-requirements) that can be used.          |
    |`ProxyServer`       |Optional parameter. Proxy Server address when required for outbound connectivity. |

    
## Step 2: Set parameters

1. Set the parameters required for the registration script.

    Here's an example of how you should change these parameters for the `Invoke-AzStackHciArcInitialization` initialization script. Once the registration is complete, the Azure Local machines are registered in Azure Arc using the Arc gateway:

    ```powershell
    #Define the subscription where you want to register your Azure Local machine with Arc.
    $Subscription = "YourSubscriptionID"
    
    #Define the resource group where you want to register your Azure Local machine with Arc.
    $RG = "YourResourceGroupName"

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

    ```

    <details>
    <summary>Expand this section to see an example output.</summary>

    Here's a sample output of the parameters:

    ```output
    PS C:\Users\SetupUser> $Subscription = "Subscription ID"
    PS C:\Users\SetupUser> $RG = "myashcirg"
    PS C:\Users\SetupUser> $Region = "eastus"
    PS C:\Users\SetupUser> $ProxyServer = "http://192.168.10.10:8080"
    PS C:\Users\SetupUser> $ProxyBypassList = "localhost,127.0.0.1,*.contoso.com,machine1,machine2,machine3,machine4,machine5,192.168.*.*,AzureLocal-1"
    ```
    </details>

## Step 3: Run registration script

1. Run the Arc registration script. The script takes a few minutes to run.


    ```powershell
    #Invoke the registration script. Use a supported region.
    Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -Region $Region -Cloud "AzureCloud" -Proxy $ProxyServer -ProxyBypass $ProxyBypassList 
    ```

    For a list of supported Azure regions, see [Azure requirements](../concepts/system-requirements-23h2.md#azure-requirements).

    <details>
    <summary>Expand this section to see an example output.</summary>
    
    Here's a sample output of a successful registration of your machines:

    ```output
    PS C:\Users\Administrator> Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -Region $Region -Cloud "AzureCloud" -Proxy $ProxyServer
    >>
    Configuration saved to: C:\Users\ADMINI~1\AppData\Local\Temp\bootstrap.json
    Triggering bootstrap on the device...
    Waiting for bootstrap to complete... Current Status: InProgress
    =========SNIPPED=========SNIPPED=============
    Waiting for bootstrap to complete... Current Status: InProgress
    Waiting for bootstrap to complete... Current Status: Succeeded
    Bootstrap succeeded.
    
    Triggering bootstrap log collection as a best effort.
    Version Response                                                    
    ------- --------                                                    
    V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response
    V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response


    PS C:\Users\Administrator>
    ```
    </details>


1. Once the registration is complete, the Azure Local machines are registered in Azure Arc. During the bootstrap configuration, you're required to authenticate with your credentials using the device code.

## Step 4: Verify the setup is successful

After the script completes successfully on all the machines, verify that your machines are registered with Arc.

1. Go to the Azure portal.
2. Go to the resource group associated with the registration. The machines appear within the specified resource group as **Machine - Azure Arc** type resources.

   :::image type="content" source="media/deployment-arc-register-server-permissions/arc-servers-registered-1.png" alt-text="Screenshot of the Azure Local machines in the resource group after the successful registration." lightbox="./media/deployment-arc-register-server-permissions/arc-servers-registered-1.png":::

> [!NOTE]
> Once an Azure Local machine is registered with Azure Arc, the only way to undo the registration is to install the operating system again on the machine.

# [Via Configurator app (Preview)](#tab/app)

## Prerequisites

Before you begin, make sure that you complete the following prerequisites:

### Azure Local machine prerequisites

[!INCLUDE [hci-registration-azure-local-machine-prerequisites](../includes/hci-registration-azure-local-machine-prerequisites.md)]

- Download the [Configurator App for Azure Local](https://aka.ms/ConfiguratorAppForHCI).

- Note down:

   - The serial number for each machine.
   - Local administrator credentials to sign into each machine.

### Azure prerequisites

[!INCLUDE [hci-registration-azure-prerequisites](../includes/hci-registration-azure-prerequisites.md)]

   
## Step 1: Configure the network and connect to Azure

[!INCLUDE [azure-local-start-configurator](../includes/azure-local-start-configurator.md)]

### Prerequisites tab

[!INCLUDE [azure-local-prerequisites-tab-configurator-app](../includes/azure-local-prerequisites-tab-configurator-app.md)]

### Basics tab

1. On the **Basics** tab, configure one network interface that is connected to the internet. Select the **Pencil icon** to modify network interface settings.

   :::image type="content" source="media/deployment-arc-register-configurator-app/basics-tab-1.png" alt-text="Screenshot of the Basics tab in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/basics-tab-2.png":::

1. Provide the interface name, IP allocation as static or DHCP, IP address, subnet, gateway, and preferred DNS servers. Optionally, enter an alternate DNS server.

   :::image type="content" source="media/deployment-arc-register-configurator-app/basics-tab-2.png" alt-text="Screenshot of the Basics tab with Network settings configured in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/basics-tab-1.png":::

   > [!IMPORTANT]
   > Make sure that the IPs you assign are free and not in use.  

1. To specify more details, select **Enter additional details**.

1. On the **Additional details** page, provide the following inputs and then select **Apply**.

   :::image type="content" source="media/deployment-arc-register-configurator-app/basics-tab-additional-details-1.png" alt-text="Screenshot of the Basics tab with additional details configured in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/basics-tab-additional-details-1.png":::

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

   :::image type="content" source="media/deployment-without-azure-arc-gateway/arc-agent--gateway.png" alt-text="Screenshot of the Arc agent setup tab in the Configurator app for Azure Local." lightbox="media/deployment-without-azure-arc-gateway/arc-agent-setup-tab-1.png":::

   1. The **Cloud type** is populated automatically as `Azure`.
   
   1. Enter a **Subscription ID** to register the machine.

   1. Provide a **Resource group** name. This resource group contains the machine and system resources that you create.

   1. Specify the **Region** where you want to create the resources. The region should be the same as the region where you want to deploy the Azure Local instance.

      > [!IMPORTANT]
      > Specify the region with spaces removed. For example, specify the East US region as `EastUS`.

   1. Skip the **Tenant ID**.

   1. Skip the Arc gateway ID.

   > [!IMPORTANT]
   > Make sure to verify all the inputs before you proceed. Any incorrect inputs here might result in a setup failure.

1. Select **Next**.

### Review and apply tab

[!INCLUDE [azure-local-review-apply-tab-configurator-app](../includes/azure-local-review-apply-tab-configurator-app.md)]

## Step 2: Complete registration of machines to Azure

1. Wait for the configuration to complete. First, machine is configured with the basic details followed by registration of the machines to Azure.

1. During the Arc registration process, you must authenticate with your Azure account. The app displays a code that you must enter in the URL, displayed in the app, in order to authenticate. Follow the instructions to complete the authentication process.

   :::image type="content" source="media/deployment-arc-register-configurator-app/setup-configuration-authentication.png" alt-text="Screenshot of the Arc agent sign in and registration dialog in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/setup-configuration-authentication.png":::

1. Once the configuration is complete, status for Arc configuration should display **Success (Open in Azure portal)**.

1. Repeat all steps on the other machines until the Arc configuration succeeds. Select the **Open in Azure portal** link.

## Step 3: Verify machines are connected to Arc

[!INCLUDE [azure-local-verify-machines](../includes/azure-local-verify-machines.md)]

---

::: zone-end

::: zone pivot="register-without-proxy"

This article details how to register using Azure Arc gateway on Azure Local without the proxy configuration. You can register via the Arc script or the Configurator app.

- **Configure with a script**: Using this method, configure the registration settings via a script.

- **Set up via the Configurator app**: Configure Azure Arc gateway via a user interface. This method is useful if you prefer not to use scripts or if you want to configure the registration settings interactively.

# [Via Arc script](#tab/script)

## Prerequisites

Make sure the following prerequisites are met before proceeding:

- You've access to an Azure Local instance running release 2505 or later. Prior versions do not support this scenario.

> [!IMPORTANT]
> Run these steps as a local administrator on every Azure Local machine that you intend to cluster.

## Set parameters

1. Set the parameters. The script takes in the following parameters:

    |Parameters  |Description  |
    |------------|-------------|
    |`SubscriptionID`    |The ID of the subscription used to register your machines with Azure Arc.         |
    |`ResourceGroup`     |The resource group precreated for Arc registration of the machines. A resource group is created if one doesn't exist.         |
    |`Region`            |The Azure region used for registration. See the [Supported regions](../concepts/system-requirements-23h2.md#azure-requirements) that can be used.          |

    

    ```powershell
    #Define the subscription where you want to register your machine as Arc device
    $Subscription = "YourSubscriptionID"
    
    #Define the resource group where you want to register your machine as Arc device
    $RG = "YourResourceGroupName"

    #Define the region to use to register your server as Arc device
    #Do not use spaces or capital letters when defining region
    $Region = "eastus"
    
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>

    ```output
    PS C:\Users\SetupUser> $Subscription = "Subscription ID"
    PS C:\Users\SetupUser> $RG = "myashcirg"
    PS C:\Users\SetupUser> $Region = "eastus"
    ```
    </details>

1. Run the Arc registration script. The script takes a few minutes to run.

    ```powershell
    #Invoke the registration script. Use a supported region.
    Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -Region $Region -Cloud "AzureCloud"
    ```

    For a list of supported Azure regions, see [Azure requirements](../concepts/system-requirements-23h2.md#azure-requirements).

    <details>
    <summary>Expand this section to see an example output.</summary>


    ```output
    PS C:\Users\Administrator> Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -Region $Region -Cloud "AzureCloud"
    >>
    Configuration saved to: C:\Users\ADMINI~1\AppData\Local\Temp\bootstrap.json
    Triggering bootstrap on the device...
    Waiting for bootstrap to complete... Current Status: InProgress
    =========SNIPPED=========SNIPPED=============
    Waiting for bootstrap to complete... Current Status: InProgress
    Waiting for bootstrap to complete... Current Status: Succeeded
    Bootstrap succeeded.
    
    Triggering bootstrap log collection as a best effort.
    Version Response                                                    
    ------- --------                                                    
    V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response
    V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response


    PS C:\Users\Administrator>
    ```

    </details>

1. After the script completes successfully on all the machines, verify that:

    1. Your machines are registered with Arc. Go to the Azure portal and then go to the resource group associated with the registration. The machines appear within the specified resource group as **Machine - Azure Arc** type resources.

        :::image type="content" source="media/deployment-arc-register-server-permissions/arc-servers-registered-1.png" alt-text="Screenshot of the Azure Local machines in the resource group after the successful registration." lightbox="./media/deployment-arc-register-server-permissions/arc-servers-registered-1.png":::

> [!NOTE]
> Once an Azure Local machine is registered with Azure Arc, the only way to undo the registration is to install the operating system again on the machine.


## Step 3: Verify the setup is successful

Once the deployment validation starts, connect to the first Azure Local machine from your system.


# [Via Configurator app (Preview)](#tab/app)

## Prerequisites

Before you begin, make sure that you complete the following prerequisites:

### Azure Local machine prerequisites

[!INCLUDE [hci-registration-azure-local-machine-prerequisites](../includes/hci-registration-azure-local-machine-prerequisites.md)]

- Download the [Configurator App for Azure Local](https://aka.ms/ConfiguratorAppForHCI).

- Note down:

   - The serial number for each machine.
   - Local administrator credentials to sign into each machine.

### Azure prerequisites

[!INCLUDE [hci-registration-azure-prerequisites](../includes/hci-registration-azure-prerequisites.md)]
   
## Step 1: Configure the network and connect to Azure

[!INCLUDE [azure-local-start-configurator](../includes/azure-local-start-configurator.md)]

### Prerequisites tab

[!INCLUDE [azure-local-prerequisites-tab-configurator-app](../includes/azure-local-prerequisites-tab-configurator-app.md)]

### Basics tab

1. On the **Basics** tab, configure one network interface that is connected to the internet. Select the **Pencil icon** to modify network interface settings.

   :::image type="content" source="media/deployment-arc-register-configurator-app/basics-tab-1.png" alt-text="Screenshot of the Basics tab in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/basics-tab-2.png":::

1. Provide the interface name, IP allocation as static or DHCP, IP address, subnet, gateway, and preferred DNS servers. Optionally, enter an alternate DNS server.

   :::image type="content" source="media/deployment-arc-register-configurator-app/basics-tab-2.png" alt-text="Screenshot of the Basics tab with Network settings configured in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/basics-tab-1.png":::

   > [!IMPORTANT]
   > Make sure that the IPs you assign are free and not in use.  

1. To specify more details, select **Enter additional details**.

1. On the **Additional details** page, provide the following inputs and then select **Apply**.

   :::image type="content" source="media/deployment-arc-register-configurator-app/basics-tab-additional-details-1.png" alt-text="Screenshot of the Basics tab with additional details configured in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/basics-tab-additional-details-1.png":::

   1. Select **ON** to enable **Remote desktop** protocol. Remote desktop protocol is disabled by default.

   1. Select **Public endpoint** as the connectivity method. 

   1. Select a time zone.

   1. Specify a preferred and an alternate NTP server to act as a time server or accept the **Default**. The default is `time.windows.com`.

   1. Set the hostname for your machine to what you specified during the preparation of Active Directory. Changing the hostname automatically reboots the system.

1. Select **Next** on the **Basics** tab.

### Arc agent setup tab

1. On the **Arc agent setup** tab, provide the following inputs:

   :::image type="content" source="media/deployment-with-azure-arc-gateway/arc-agent-setup-tab-no-gateway.png" alt-text="Screenshot of the Arc agent setup tab in the Configurator app for Azure Local." lightbox="media/deployment-with-azure-arc-gateway/arc-agent-setup-tab-no-gateway.png":::


   1. The **Cloud type** is populated automatically as `Azure`.
   
   1. Enter a **Subscription ID** to register the machine.

   1. Provide a **Resource group** name. This resource group contains the machine and system resources that you create.

   1. Specify the **Region** where you want to create the resources. The region should be the same as the region where you want to deploy the Azure Local instance.

      > [!IMPORTANT]
      > Specify the region with spaces removed. For example, specify the East US region as `EastUS`.

   1. Skip the **Tenant ID**.

   1. Skip the Arc gateway ID.

   > [!IMPORTANT]
   > Make sure to verify all the inputs before you proceed. Any incorrect inputs here might result in a setup failure.

1. Select **Next**.

### Review and apply tab

[!INCLUDE [azure-local-review-apply-tab-configurator-app](../includes/azure-local-review-apply-tab-configurator-app.md)]

## Step 2: Complete registration of machines to Azure

1. Wait for the configuration to complete. First, machine is configured with the basic details followed by registration of the machines to Azure.

1. During the Arc registration process, you must authenticate with your Azure account. The app displays a code that you must enter in the URL, displayed in the app, in order to authenticate. Follow the instructions to complete the authentication process.

   :::image type="content" source="media/deployment-arc-register-configurator-app/setup-configuration-authentication.png" alt-text="Screenshot of the Arc agent sign in and registration dialog in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/setup-configuration-authentication.png":::

1. Once the configuration is complete, status for Arc configuration should display **Success (Open in Azure portal)**.

1. Repeat all steps on the other machines until the Arc configuration succeeds. Select the **Open in Azure portal** link.

## Step 3: Verify machines are connected to Arc

[!INCLUDE [azure-local-verify-machines](../includes/azure-local-verify-machines.md)]

---

::: zone-end


## Next steps

- [Troubleshoot registration issues with Configurator app](../manage/troubleshoot-deployment-configurator-app.md)
- [Get support for deployment issues](../manage/get-support-for-deployment-issues.md)
- [Get support for Azure Local](../manage/get-support.md)

::: moniker-end

::: moniker range="<=azloc-2504"

This feature is available only in Azure Local 2505 or later.

::: moniker-end
