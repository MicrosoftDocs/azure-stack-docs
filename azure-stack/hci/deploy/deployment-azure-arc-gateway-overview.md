--- 
title: Overview of Azure Arc gateway for Azure Stack HCI, version 23H2 clusters (preview)
description: Learn what is Azure Arc gateway for Azure Stack HCI, version 23H2 cluster running software version 2408 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 09/25/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# About Azure Arc gateway for Azure Stack HCI, version 23H2 (preview)

Applies to: Azure Stack HCI, version 23H2

This article provides an overview of the Azure Arc Gateway for Azure Stack HCI, version 23H2. The Arc gateway can be enabled on deployments of Azure Stack HCI running software version 2408 or later. The article also describes how to create and delete the Arc gateway resource in Azure.

You can use the Arc gateway to significantly reduce the number of required endpoints needed to deploy and manage Azure Stack HCI clusters. Once you have created the Arc gateway, you can connect to and use it for new or existing deployments of Azure Stack HCI.

[!INCLUDE [important](../../includes/hci-preview.md)]

> [!NOTE]
For information on how to deploy the Azure Arc Gateway for standalone servers, see [Simplify network configuration requirements through Azure Arc gateway](/azure/azure-arc/servers/arc-gateway).

## How it works

The Arc gateway works by introducing the following components:

- **Arc gateway resource** – An Azure resource that acts as a common entry point for Azure traffic. This gateway resource has a specific domain or URL that you can use. When you create the Arc Gateway resource, this domain or URL is a part of the success response.  

- **Arc proxy** – A new component that is added to the Arc Agentry. This component runs as a service (Called  the **Azure Arc Proxy**) and works as a forward proxy for the Azure Arc agents and extensions.
    The gateway router doesn't need any configuration from your side. This router is part of the Arc core agentry and runs within the context of an Arc-enabled resource.

With the Arc gateway in place, the traffic flows through these steps: **Arc agentry → Gateway router → Enterprise Proxy → Arc gateway → Target service**.  The traffic flow is illustrated in the following diagram:


  :::image type="content" source="./media/deployment-azure-arc-gateway-overview/arc-gateway-component-diagram.png" alt-text="Diagram of Azure Arc gateway 2408 components." lightbox="./media/deployment-azure-arc-gateway-overview/arc-gateway-component-diagram.png":::

  Each Azure Stack HCI cluster node has its own Arc agent with the gateway router connecting and creating the tunnel to the Arc gateway resource in Azure.

<!-- ## Arc-enabled server endpoints redirected via the Arc gateway in limited Public Preview

| Endpoint | Description | When required |
|--|--|--|
| login.windows.net | Microsoft Entra ID | Always |
| pas.windows.net | Microsoft Entra ID | Always |
| *.guestconfiguration.azure.com  | Extension management and guest configuration services | Always |
| guestnotificationservice.azure.com   | Notification service for extension and connectivity scenarios  | Always |
| *.guestnotificationservice.azure.com   | Notification service for extension and connectivity scenarios  | Always |
| *.servicesbus.windows.net  | Multiple HCI services require access to this endpoint | Always |
| *.waconazure.com | For Windows Admin Center connectivity    | If using Windows Admin Center |
| *.blob.core.windows.net | Multiple HCI services require access to this endpoint  | Always |
| dc.services.visualstudio.com | Multiple HCI services require access to this endpoint  | Always |

The list of supported endpoints by the Arc gateway in HCI will increase during the Public Preview -->

## Azure Stack HCI 2408 endpoints

As part of the Azure Stack HCI version 2408 preview update, the endpoints from the table below are required and must be whitelisted in your proxy or firewall to successfully deploy the Azure Stack HCI cluster.

| Endpoint # | Required endpoint | Component  |
| -- | -- | -- |
| 1 | http://go.microsoft.com:443 | Env Chkr |
| 2 | http://www.powershellgallery.com:443 | Env Chkr |
| 3 | http://psg-prod-eastus.azureedge.net:443 | Env Chkr |
| 4 | http://onegetcdn.azureedge.net:443 | Env Chkr |
| 5 | http://login.microsoftonline.com:443 | Env Chkr |
| 6 | http://aka.ms:443 | Env Chkr |
| 7 | http://azurestackreleases.download.prss.microsoft.com:443 | Env Chkr |
| 8 | http://download.microsoft.com:443 | Env Chkr |
| 9 | http://portal.azure.com:443 | Env Chkr |
| 10 | http://management.azure.com:443 | Env Chkr |
| 11 | http://www.office.com:443 | Env Chkr |
| 12 | http://gbl.his.arc.azure.com:443 | Arc agent |  
| 13 | http://\<region\>.his.arc.azure.com:443 | Arc agent |
| 14 | http://dc.services.visualstudio.com:443 | Arc agent |
| 15 | http://\<yourarcgatewayId\>.gw.arc.azure.com:443 | Arc gateway |
| 16 | http://\<yourkeyvaultname\>.vault.azure.net:443 | Azure Key Vault |
| 17 | http://\<yourblobstorageforcloudwitnessname\>.blob.core.windows.net:443 | Cloud Witness Storage Account |
| 18 | http://files.pythonhosted.org:443 | MOC/ARB/AKS |
| 19 | http://pypi.org:443 | MOC/ARB/AKS |
| 20 | http://raw.githubusercontent.com:443 | MOC/ARB/AKS |
| 21 | http://pythonhosted.org:443 | MOC/ARB/AKS |
| 22 | http://hciarcvmsstorage.z13.web.core.windows.net:443 | MOC/ARB/AKS |
| 23 | http://ocsp.digicert.com  | CRL for Arc extensions |
| 24 | http://s.symcd.com | CRL for Arc extensions |
| 25 | http://ts-ocsp.ws.symantec.com | CRL for Arc extensions |
| 26 | http://ocsp.globalsign.com | CRL for Arc extensions |
| 27 | http://ocsp2.globalsign.com | CRL for Arc extensions |
| 28 | http://oneocsp.microsoft.com | CRL for Arc extensions |
| 29 | http://dl.delivery.mp.microsoft.com | LCM Binaries |
| 30 | http://*.tlu.dl.delivery.mp.microsoft.com | LCM Binaries |
| 31 | http://*.windowsupdate.com | Windows Update |
| 32 | http://*.windowsupdate.microsoft.com | Windows Update |
| 33 | http://*.update.microsoft.com | Windows Update |

## Restrictions and limitations

Consider the following limitations of Arc gateway in this release:

- TLS terminating proxies aren't supported with the Arc gateway (Preview).
- Use of ExpressRoute, Site-to-Site VPN, or Private Endpoints in addition to the Arc gateway (Preview) isn't supported.  


## How to use the Arc gateway on Azure Stack HCI

After you complete the [Arc gateway Preview signup form](https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR2WRja4SbkFJm6k6LDfxchxUN1dYTlZIM1JYTVFCN0RVTjgyVEZHMkFTSC4u), start using the Arc gateway for new or existing Azure Stack HCI 2405 deployments.

## Create the Arc gateway resource in Azure

You must first create the Arc gateway resource in your Azure subscription. Do not create the Arc gateway resource from any of the HCI nodes. You can do so from any computer that has an internet connection, for example, your laptop.

To create the Arc gateway resource in Azure, follow these steps:

1. Download the [az connectedmachine.whl](https://aka.ms/ArcGatewayWhl) file extension. This file contains the az connected machine commands required to create and manage your Gateway Resource.

1. Install the [Azure Command Line Interface (CLI)](/cli/azure/install-azure-cli-windows?tabs=azure-cli).


1. Run the following command to add the extension:

    ```azurecli
    az extension add --allow-preview true --yes --source [whl file path] 
    ```

1. On a computer with access to Azure, run the following commands to create your Arc gateway resource:

    ```azurecli
    az login --use-device-code
    az account set --subscription [subscription name or id]
    az connectedmachine gateway create --name [Your Gateway Name] --resource-group [Your Resource Group] --location [Location] --gateway-type public --allowed-features *
    ```

    The gateway creation process takes about four to five minutes to complete.

<!-- 1. When the resource is successfully created, the success response includes all the URLs that need to be allowed in your proxy, including the Arc gateway URL. Make sure that all the URLs are allowed in the environment that has your Azure Arc resources. The following URLs are required:

    | URL | Purpose |
    |--|--|
    | [Your URL Prefix].gw.arc.azure.com | Gateway URL. To get this URL, run `az connectedmachine gateway list` after you create your gateway resource. |
    | management.azure.com | Azure Resource Manager (ARM) Endpoint. This URL is required for the ARM control plane. |
    | login.microsoftonline.com | Microsoft Entra ID endpoint. This URL is used to acquire identity access tokens. |
    | gbl.his.arc.azure.com <br><your_region>.his.arc.azure.com  | The cloud service endpoint to communicate with Arc agents. |
    | packages.microsoft.com | This URL is required to acquire a Linux-based Arc agentry payload. This URL is only needed to connect Linux servers to Arc. |
    | download.microsoft.com | This URL is used to download the Windows installation package. | -->

## Delete the Arc gateway resource

To delete an Arc gateway resource, you must first detach it from the servers to which it is attached.  

1. To detach the gateway resource from your Arc-enabled server, set the connection type to **direct** instead of **gateway**. Run the following command:

    ```azurecli
    azcmagent config set connection.type direct
    ```

1. To delete the gateway resource,  run the following command:

    ```azurecli
    az connectedmachine gateway delete --resource group <resource group name> --gateway-name <gateway resource name>
    ```

    This operation can take a couple of minutes.  

## Next steps

- [Connect Azure Stack HCI nodes to Arc gateway](deployment-connect-nodes-to-arc-gateway.md).