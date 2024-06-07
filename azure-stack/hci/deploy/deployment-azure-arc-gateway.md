--- 
title: Set up Azure Arc gateway for Azure Stack HCI, version 2405 (preview)
description: Learn how to deploy Azure Arc gateway for Azure Stack HCI, version 2405 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 06/07/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Set up Azure Arc gateway for Azure Stack HCI, version 2405 (preview)

Applies to: Azure Stack HCI, version 2405 (preview)

This article describes how to set up an Azure Arc Gateway for Azure Stack HCI, version 2405 (preview) systems.

Starting with Azure Stack HCI, version 2405, you can participate in the Arc gateway Public Preview to evaluate how to significantly reduce the number of required endpoints to be opened for deployment of, and simplified management for, Azure Stack HCI systems.

After completing the [Limited Public Preview Signup - Arc Gateway form](https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR2WRja4SbkFJm6k6LDfxchxUN1dYTlZIM1JYTVFCN0RVTjgyVEZHMkFTSC4u), you can start using the Arc gateway for new or existing Azure Stack HCI, version 2405 deployments.

> [!IMPORTANT]
> This article covers how to set up and use Azure Arc Gateway Preview with Azure Stack HCI, version 2405 clusters. For using the Arc gateway on standalone servers, see [How to simplify network configuration requirements through Azure Arc gateway](deployment-azure-arc-gateway.md).

## Scenarios

You can use the Azure Arc gateway in the following supported scenarios:

- Use the Arc gateway before deploying new Azure Stack HCI, version 2405 clusters.

- Use the Arc gateway on existing Azure Stack HCI , version 2405 clusters.

## Architecture

The Arc gateway has the following components and works as follows:

- **Arc gateway resource** – an Azure resource that serves as a common front end for Azure traffic. This resource is used on a specific domain or URL. After you successfully create the Arc Gateway Resource, this domain/URL is included in the success response.  

- **Arc proxy** – a new component is added to the Arc Agentry. It runs as a service called  the **Azure Arc Proxy** and acts as a forward proxy used by Azure Arc agents and extensions.

- **Arc gateway router** - there is no configuration required on your part for the gateway router. This router is part of the Arc core agentry and runs within the context of an Arc-enabled resource. 

- **Arc agent** - Each Azure Stack HCI cluster node will run its own Arc agent with the Arc gateway router connecting and establishing the tunnel to the Arc gateway resource in Azure. 

When the Arc gateway is set up, traffic flows via the following hops: **Arc Agent → Gateway Router → Enterprise Proxy → Arc gateway → Azure service**, as shown below.  

  :::image type="content" source="media/deployment-azure-arc-gateway/arc-gateway-component-diagram.png" alt-text="Azure Arc gateway component diagram." lightbox="./media/deployment-azure-arc-gateway/arc-gateway-component-diagram.png":::

## Limitations

The Azure Arc gateway has limitations you should consider when planning your set up. These limitations apply to the Preview release only. These limitations may no longer apply when the Arc gateway is in general release:

- TLS terminating proxies are not supported in this release.

- Using ExpressRoute/Site-to-Site VPN or Private Endpoints with the Arc gateway is not supported in this release.  

- The Arc gateway is only supported for Arc-enabled servers.

## Option 1: Arc gateway for new deployments

This option allows you to enable the Azure Arc gateway on new Azure Stack HCI, verion 2405 systems.

  :::image type="content" source="media/deployment-azure-arc-gateway/new-deployment-workflow.png" alt-text="Azure Arc gateway new deployment workflow." lightbox="./media/deployment-azure-arc-gateway/new-deployment-workflow.png":::

### Step 1: Create the Arc gateway resource in Azure

You must first create the Arc gateway resource in your Azure subscription. You can do so from any computer that has aninternet connection.

To create the Arc gateway resource in Azure, follow these steps:

1. Install the [Azure Command Line Interface (CLI)](/cli/azure/install-azure-cli-windows?tabs=azure-cli) if you haven't already.

1. Download the [connectedmachine-0.7.0-py3-none-any.whl](https://aka.ms/ArcGatewayWhl) file. This file contains the commands required to create and manage the Arc gateway resource.

1. Run the following command to add the *connectedmachine extension:az extension*:

     ```azurecli
     add --allow-preview true --yes --source [whl file path] 
    ```

1. On any computer with access to Azure, run the following commands to create your Arc gateway resource:

    ```azurecli
    az login --use-device-code
    az account set --subscription [subscription name or id]
    az connectedmachine gateway create --name [Your Gateway Name] --resource-group [Your Resource Group] --location [Location] --gateway-type public --allowed-features *
    ```

    The gateway creation process takes about four to five minutes to complete.

1. When the resource is successfully created, the success response will include all the URLs that need to be allowed in your proxy, including the Arc gateway URL. Ensure all URLs are allowed in the environment where your Azure Arc resources are. The required URLs are listed below.

| URL | Purpose |
| -- | -- |
| [Your URL Prefix].gw.arc.azure.com | Gateway URL -This URL can be obtained by running `az connectedmachine gateway list` after you create your gateway resource. |
| management.azure.com | Azure Resource Manager Endpoint, required for ARM control channel. |
| login.microsoftonline.com | Microsoft Entra ID endpoint, for acquiring identity access tokens. |
| gbl.his.arc.azure.com | The cloud service endpoint for communicating with Arc Agents. |
| <your_region>.his.arc.azure.com | The cloud service endpoint for communicating with Arc agents. |
| packages.microsoft.com | Required to acquire a Linux-based Arc agentry payload; only needed to connect Linux servers to Azure Arc. |
| download.microsoft.com | Used to download the Windows installation package. |

### Step 2: Register new servers using the ArcGatewayID

Once the Azure Arc gateway resource is created, you are now ready to start connecting Arc agents running on your Azure Stack HCI, version 2405 cluster nodes as part of agent installation.  

You will need the **ArcGatewayID** from Azure to run the server node registration script. To obtain the **ArcGatewayID**, run the command listed above. Then run this script:

```azurecli
PS C:\temp> az connectedmachine gateway list
This command is in preview and under development. Reference and support levels at: https://aka.ms/CLI_refstatus
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
PS C:\temp>
```

Azure Stack HCI, version 2405 requires the Arc agent installation to follow a specific procedure. You first [register your servers with Azure Arc and assign permissions for deployment](deployment-arc-register-server-permissions.md?tabs=powershell).

However, for this preview, you need to invoke the initialization script by passing the  **ArcGatewayID** value.

Here is an example of how to modify the initialization script:

```azurecli
#Install required PowerShell modules in your node for registration
Install-Module Az.Accounts -RequiredVersion 2.13.2
Install-Module Az.Resources -RequiredVersion 6.12.0
Install-Module Az.ConnectedMachine -RequiredVersion 0.5.2
#Install Arc registration module from PSGallery 
Install-Module AzsHCI.ARCinstaller
#Define the subscription where you want to register your server as Arc device
$Subscription = "yoursubscriptionId"
#Define the resource group where you want to register your server as Arc device
$RG = "yourresourcegroup"
#Define the tenant you will use to register your server as Arc device
$Tenant = "yourtenantID"
#Connect to your Azure account and Subscription
Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode
#Get the Access Token and Account ID for the registration
$ARMtoken = (Get-AzAccessToken).Token
#Get the Account ID for the registration
$id = (Get-AzContext).Account.Id
#INVOKE THE HCI NODE REGISTRATION SCRIPT WITH ArcGatewayID parameter to connect the agent with the gateway as part of the installation.
Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region eastus2euap -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Force -ArcGatewayID "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx/resourceGroups/yourresourcegroup/providers/Microsoft.HybridCompute/gateways/yourArcgateway",
```

### Step 3: Start the Azure Stack HCI cloud deployment

Once the server nodes are registered in Azure Arc and all extensions are installed, you can start deployment using Azure portal or using ARM templates as listed:

- [Deploy Azure Stack HCI via Azure portal](deploy-via-portal.md).

- [Deploy Azure Stack HCI via ARM template](deployment-azure-resource-manager-template.md).

### Step 4: Verify that setup succeeded

Once deployment validation starts, connect to the first server node from your cluster and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and which ones keep using your firewall or proxy. You can find the Arc gateway log in the *c:\programdata\AzureConnectedMAchineAgent\Log* folder.

  :::image type="content" source="media/deployment-azure-arc-gateway/connected-machine-agent-output.png" alt-text="Azure Arc gateway connected machine agent output window." lightbox="./media/deployment-azure-arc-gateway/connected-machine-agent-output.png":::

1. Open the *arcproxy.log* file and check which URLs are redirected through the Arc gateway.

1. On the onboarded server, run the `azcmagent show` command. The result should show the following values:

    - **Agent Status** should show as `Connected`.

    - **Using HTTPS Proxy** should show as `http://localhost:40343`.

    - **Upstream Proxy** should show as your proxy if applicable.

1. Verify that setup was successful by running the `azcmagent check` command. The result should show the following values:

    - **connection.type** should show as `gateway`.

    - **Reachable** column should list `true` for all URLs.

## Option 2: Arc gateway for existing clusters

This option is for using Azure Arc Gateway on existing Azure Stack HCI, version 2405 systems.

> [!NOTE]
> All server must be running the Arc-enabled Servers Agent version 1.40 or above to use the Arc gateway feature.

  :::image type="content" source="media/deployment-azure-arc-gateway/existing-deployment-workflow.png" alt-text="Azure Arc gateway existing deployment workflow." lightbox="./media/deployment-azure-arc-gateway/existing-deployment-workflow.png":::

1. Associate each existing server in the cluster with the Arc gateway resource by running the following:

    ```azurecli
    az connectedmachine setting update --resource-group [res-group] --subscription [subscription name] --base-provider Microsoft.HybridCompute --base-resource-type machines --base-resource-name [Arc server resource name] -settings-resource-name default --gateway-resource-id [Full Arm resourceid]
    ```

1. Update each server in the cluster to use the Arc gateway resource. Run the following command on your Arc-enabled server to set it to use the Arc gateway:

    ```azurecli
    azcmagent config set connection.type gateway
    ```

1. Await reconciliation. Once your servers have been updated to use the Arc gateway, some Azure Arc endpoints that were previously allowed in your proxy or firewalls won't not be needed any longer. Wait one hour before you begin removing endpoints from your firewall or proxy.

### Step 2: Verify that setup succeeded

1. On the onboarded server, run the `azcmagent show` command. The result should show the following values:

    - **Agent Status** should show as `Connected`.

    - **Using HTTPS Proxy** should show as `http://localhost:40343`.

    - **Upstream Proxy** should show as your proxy if applicable.

1. Verify that setup was successful by running the `azcmagent check` command. The result should show the following values:

    - **connection.type** should show as `gateway`.

    - **Reachable** column should list `true` for all URLs.

### Step 3: (Linux only) Ensure additional scenarios use the Arc gateway  

On Linux, if using either Azure Monitor or Microsoft Defender for Endpoint, additional commands need to be executed to work with the Azure Arc gateway.  

**For Azure Monitor**

If using Azure Monitor, do the following:

Explicit proxy setting should be provided while deploying the Monitoring Agent. From Azure Cloudshell, run the following command:

```powershell
$settings = @{"proxy" = @{mode = "application"; address = "http://127.0.0.1:40343"; auth = false}} 

New-AzConnectedMachineExtension -Name AzureMonitorLinuxAgent -ExtensionType  
AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName  <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -Setting $settings
```

If you’re deploying Azure Monitor via Azure Portal, ensure you check the **Use Proxy** setting, and set the **Proxy Address** as http://127.0.0.1:40343.

**For Microsoft Defender for Endpoint**

If using Microsoft Defender for Endpoint, run the following command:

 ```azurecli
mdatp config proxy set --value http://127.0.0.1:403
```

## Cleaning up resources

To delete an Arc gateway resource, you must first detach it from the server it’s attached to.  

1. Detach the gateway resource from your Arc-enabled server by setting the connection type to **direct** instead of **gateway** - run the following command:

     ```azurecli
    azcmagent config set connection.type direct
    ```

1. Delete the gateway resource by running the following command:

     ```azurecli
    az connectedmachine gateway delete --resource group <resource group name> --gateway-name <gateway resource name>
    ```

    This operation can take a couple of minutes.  

## Troubleshooting  

You can audit Arc gateway traffic by viewing the gateway router logs.  

### To view logs on Windows  

1. Run the `azcmagent logs` command.

1. In the resulting .zip file, view the logs in the *C:\ProgramData\Microsoft\ArcGatewayRouter* folder.

### To view logs on Linux  

1. Run `sudo azcmagent logs` and share the resulting log file.

1. View the logs in the */usr/local/arcrtr/logs/* folder.

## Known issues

- It is not yet possible to use Azure CLI to run the commands listed.  

