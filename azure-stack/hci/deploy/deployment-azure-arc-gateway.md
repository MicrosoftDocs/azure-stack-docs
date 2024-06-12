--- 
title: Set up Azure Arc gateway for Azure Stack HCI, version 2405 (preview)
description: Learn how to deploy Azure Arc gateway for Azure Stack HCI, version 2405 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 06/10/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Simplify Azure Stack HCI, version 23H2 outbound network requirements through Azure Arc gateway (preview)

Applies to: Azure Stack HCI, version 23H2 (preview)

This article describes how to set up an Azure Arc Gateway for software release 2405 on Azure Stack HCI, version 23H2 systems.

You can use the Arc gateway to significantly reduce the number of required endpoints needed to deploy and manage Azure Stack HCI clusters.

> [!IMPORTANT]
> This article covers how to set up and use the Arc Gateway Preview with Azure Stack HCI 2405. To use the Arc gateway on standalone Arc for Servers scenarion, see [How to simplify network configuration requirements through Azure Arc gateway](/azure/azure-arc/servers/arc-gateway).

## Supported scenarios

Use the Arc gateway for the following scenarios:

- Enable Arc gateway before you deploy new Azure Stack HCI clusters running software version 2405.

- Enable Arc gateway on existing Azure Stack HCI clusters running software version 2405.

## How it works

The Arc gateway works by introducing the following components:

- **Arc gateway resource** – An Azure resource that acts as a common entry point for Azure traffic. This gateway resource has a specific domain or URL that you can use. When you create the Arc Gateway resource, this domain or URL is a part of the success response.  

- **Arc proxy** – A new component that is added to the Arc Agentry. This component runs as a service (Called  the **Azure Arc Proxy**) and works as a forward proxy for the Azure Arc agents and extensions.
    The gateway router doesn't need any configuration from your side. This router is part of the Arc core agentry and runs within the context of an Arc-enabled resource.

With the Arc gateway in place, the traffic flows through these steps: **Arc agentry → Gateway router → Enterprise Proxy → Arc gateway → Target service**.  The traffic flow is illustrated in the following diagram:

  :::image type="content" source="media/deployment-azure-arc-gateway/arc-gateway-component-diagram.png" alt-text="Azure Arc gateway component diagram." lightbox="./media/deployment-azure-arc-gateway/arc-gateway-component-diagram.png":::

  Each Azure Stack HCI cluster node has its own Arc agent with the gateway router connecting and creating the tunnel to the Arc gateway resource in Azure.

## Restrictions and limitations

Consider the following limitations of Arc gateway in the Preview release:

- TLS terminating proxies aren't supported with the Arc gateway (Preview).

- Use of ExpressRoute, Site-to-Site VPN, or Private Endpoints in addition to the Arc gateway (Preview) isn't supported.  

- The Arc gateway is only supported for Arc-enabled Servers.

- The server must use the Arc-enabled Servers agent version 1.40 or later to use the Arc gateway feature.

## How to use the Arc gateway on Azure Stack HCI

After you complete the [Arc gateway Preview signup form](https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR2WRja4SbkFJm6k6LDfxchxUN1dYTlZIM1JYTVFCN0RVTjgyVEZHMkFTSC4u), start using the Arc gateway for new or existing Azure Stack HCI 2405 deployments.

Choose from one of the following options:

- **Option 1**: Enable Arc gateway for new Azure Stack HCI deployments.
- **Option 2**: Enable Arc gateway for existing Azure Stack HCI deployments.

## Option 1: Enable Arc gateway for new Azure Stack HCI deployments

The following steps are required to enable the Azure Arc gateway on new Azure Stack HCI 2405 deployments.

  :::image type="content" source="media/deployment-azure-arc-gateway/new-deployment-workflow.png" alt-text="Azure Arc gateway new deployment workflow." lightbox="./media/deployment-azure-arc-gateway/new-deployment-workflow.png":::

### Step 1: Create the Arc gateway resource in Azure

You must first create the Arc gateway resource in your Azure subscription. You can do so from any computer that has an internet connection, for example, your laptop.

To create the Arc gateway resource in Azure, follow these steps:

1. Download the [az connectedmachine.whl](https://aka.ms/ArcGatewayWhl) file extension. This file contains the az connected machine commands required to create and manage your Gateway Resource.

1. Install the [Azure Command Line Interface (CLI)](/cli/azure/install-azure-cli-windows?tabs=azure-cli).


1. Run the following command to add the extension:

    ```azurecli
    az extesnion add --allow-preview true --yes --source [whl file path] 
    ```

1. On a computer with access to Azure, run the following commands to create your Arc gateway resource:

    ```azurecli
    az login --use-device-code
    az account set --subscription [subscription name or id]
    az connectedmachine gateway create --name [Your Gateway Name] --resource-group [Your Resource Group] --location [Location] --gateway-type public --allowed-features *
    ```

    The gateway creation process takes about four to five minutes to complete.

1. When the resource is successfully created, the success response includes all the URLs that need to be allowed in your proxy, including the Arc gateway URL. Make sure that all the URLs are allowed in the environment that has your Azure Arc resources. The following URLs are required:

    | URL | Purpose |
    |--|--|
    | [Your URL Prefix].gw.arc.azure.com | Gateway URL. To get this URL, run `az connectedmachine gateway list` after you create your gateway resource. |
    | management.azure.com | Azure Resource Manager (ARM) Endpoint. This URL is required for the ARM control plane. |
    | login.microsoftonline.com | Microsoft Entra ID endpoint. This URL is used to acquire identity access tokens. |
    | gbl.his.arc.azure.com <br><your_region>.his.arc.azure.com  | The cloud service endpoint to communicate with Arc agents. |
    | packages.microsoft.com | This URL is required to acquire a Linux-based Arc agentry payload. This URL is only needed to connect Linux servers to Arc. |
    | download.microsoft.com | This URL is used to download the Windows installation package. |

### Step 2: Register new Azure Stack HCI servers via the Arc gateway ID

Once the Arc gateway resource is created, you're now ready to start connecting Arc agents running on your Azure Stack HCI nodes as part of agent installation.  

You need the **ArcGatewayID** from Azure to run the snode registration script. To get the **ArcGatewayID**, run the following command:

```azurecli
az connectedmachine gateway list
```

Here's an example output:

```output
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
```

Azure Stack HCI requires the Arc agent installation to follow a specific procedure. You first [register your servers with Azure Arc and assign permissions for deployment](deployment-arc-register-server-permissions.md?tabs=powershell).

However, for this Preview, you need to invoke the initialization script by passing the  **ArcGatewayID** value. Here's an example of how you should change the initialization script:

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

#Invoke the Azure Stack HCI node registration script with ArcGatewayID parameter to connect the agent with the gateway as part of the installation.
Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region eastus2euap -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Force -ArcGatewayID "/subscriptions/<Subscription ID>/resourceGroups/<Resourcegroup>/providers/Microsoft.HybridCompute/gateways/<ArcGateway>",<!--check-->
```

### Step 3: Start the Azure Stack HCI cloud deployment

Once the Azure Stack HCI nodes are registered in Arc and all the extensions are installed, you can start the deployment from the Azure portal or via the ARM templates as documented here:

- [Deploy Azure Stack HCI via Azure portal](deploy-via-portal.md).

- [Deploy Azure Stack HCI via ARM template](deployment-azure-resource-manager-template.md).

### Step 4: Verify that setup succeeded

Once the deployment validation starts, connect to the first server node from your cluster and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and which ones keep using your firewall or proxy security solutions. You should find the Arc gateway log on *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

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

1. Await reconciliation. Once your servers have been updated to use the Arc gateway, some Azure Arc endpoints that were previously allowed in your proxy or firewalls won't be needed any longer. Wait one hour before you begin removing endpoints from your firewall or proxy.

### Step 2: Verify that setup succeeded

1. On the onboarded server, run the `azcmagent show` command. The result should show the following values:

    - **Agent Status** should show as `Connected`.

    - **Using HTTPS Proxy** should show as `http://localhost:40343`.

    - **Upstream Proxy** should show as your proxy if applicable.

1. Verify that setup was successful by running the `azcmagent check` command. The result should show the following values:

    - **connection.type** should show as `gateway`.

    - **Reachable** column should list `true` for all URLs.

### Step 3: (Linux only) Ensure other scenarios use the Arc gateway  

On Linux, if using either Azure Monitor or Microsoft Defender for Endpoint, more commands should be run to work with the Azure Arc gateway.  

#### For Azure Monitor

If using Azure Monitor, follow these steps:

Explicit proxy setting should be provided while deploying the Monitoring Agent. From Azure Cloudshell, run the following command:

```powershell
$settings = @{"proxy" = @{mode = "application"; address = "http://127.0.0.1:40343"; auth = false}} 

New-AzConnectedMachineExtension -Name AzureMonitorLinuxAgent -ExtensionType  
AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName  <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -Setting $settings
```

If you’re deploying Azure Monitor via Azure portal, ensure you check the **Use Proxy** setting, and set the **Proxy Address** as `http://127.0.0.1:40343`.

#### For Microsoft Defender for Endpoint

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

- It isn't yet possible to use Azure CLI to run the commands listed.  

