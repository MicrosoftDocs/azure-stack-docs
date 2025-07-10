--- 
title: Overview of Azure Arc gateway for Azure Local, version 23H2 (preview)
description: Learn what is Azure Arc gateway for Azure Local, version 23H2 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 05/08/2025
ms.author: alkohli
ms.service: azure-local
---

# About Azure Arc gateway for Azure Local (preview)

::: moniker range=">=azloc-24111"

> Applies to: Azure Local version 2411.1 and later

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

This article provides an overview of the Azure Arc gateway for Azure Local. The Arc gateway can be enabled on new deployments of Azure Local running software version 2408 and later. This article also describes how to create and delete the Arc gateway resource in Azure.

You can use the Arc gateway to significantly reduce the number of required endpoints needed to deploy and manage Azure Local instances. When you create the Arc gateway, you can connect to and use it for new deployments of Azure Local.

[!INCLUDE [important](../includes/hci-preview.md)]

## How it works

The Arc gateway works by introducing the following components:

- **Arc gateway resource** – An Azure resource that acts as a common entry point for Azure traffic. This gateway resource has a specific domain or URL that you can use. When you create the Arc gateway resource, this domain or URL is a part of the success response.  

- **Arc proxy** – A new component that is added to the Arc Agentry. This component runs as a service (Called  the **Azure Arc Proxy**) and works as a forward proxy for the Azure Arc agents and extensions. The gateway router doesn't need any configuration from your side. This router is part of the Arc core agentry and runs within the context of an Arc-enabled resource.

When you integrate the Arc gateway with version 2411 of Azure Local deployments, each machine gets Arc proxy along with other Arc Agents.

When Arc gateway is used, the *http* and *https* traffic flow changes as follows:

**Traffic flow for Azure Local host operating system components**

1. OS proxy settings are used to route all HTTPS host traffic through Arc proxy.  

1. From Arc proxy, the traffic is forwarded to Arc gateway.

1. Based on the configuration in the Arc gateway, if allowed, the traffic is sent to target services. If not allowed, Arc proxy redirects this traffic to the enterprise proxy (or direct outbound if no proxy set). Arc proxy automatically determines the right path for the endpoint.

**Traffic flow for Arc appliance Azure Arc resource bridge and AKS control plane**

1. Routable IP (failover clustered IP resource as of now) is used to forward the traffic through Arc proxy running on the Azure Local host machines.

1. Azure Arc resource bridge and Azure Kubernetes Service (AKS) forward proxy are configured to use routable IP.

1. With proxy settings in place, Arc resource bridge, and AKS outbound traffic is forwarded to Arc Proxy running on one of the Azure Local machines over routable IP.

1. When traffic reaches the Arc proxy, the remaining flow takes the same path as described. If traffic to the target service is allowed, it is sent to Arc gateway. If not, it's sent to the enterprise proxy (or direct outbound if no proxy set). For AKS specifically, this path is used for downloading docker images for Arc Agentry and Arc Extension Pods.

**Traffic flow for Azure Local VMs**

HTTP and HTTPS traffic are forwarded to the enterprise proxy. Arc proxy inside an Azure Local virtual machine (VM) enabled by Arc is not yet supported in this version.

Traffic flows are illustrated in the following diagram:

:::image type="content" source="./media/deployment-azure-arc-gateway-overview/arc-gateway-component-diagram.png" alt-text="Diagram of Azure Arc gateway architecture." lightbox="./media/deployment-azure-arc-gateway-overview/arc-gateway-component-diagram.png":::

<!-- ## Arc-enabled server endpoints redirected via the Arc gateway in limited Public Preview

| Endpoint | Description | When required |
|--|--|--|
| login.windows.net | Microsoft Entra ID | Always |
| pas.windows.net | Microsoft Entra ID | Always |
| *.guestconfiguration.azure.com  | Extension management and guest configuration services | Always |
| guestnotificationservice.azure.com   | Notification service for extension and connectivity scenarios  | Always |
| *.guestnotificationservice.azure.com   | Notification service for extension and connectivity scenarios  | Always |
| *.servicesbus.windows.net  | Multiple Azure Local services require access to this endpoint | Always |
| *.waconazure.com | For Windows Admin Center connectivity    | If using Windows Admin Center |
| *.blob.core.windows.net | Multiple Azure Local services require access to this endpoint  | Always |
| dc.services.visualstudio.com | Multiple Azure Local services require access to this endpoint  | Always |

The list of supported endpoints by the Arc gateway in Azure Local will increase during the Public Preview -->

## Supported and unsupported scenarios

You can use the Arc gateway in the following scenario for Azure Local versions 2411.1 or later:

- Enable Arc gateway during deployment of new Azure Local instances running versions 2411.1 or later.
- The Arc gateway resource must be created on the same subscription where you're planning to deploy your Azure Local instance.

Unsupported scenarios for Azure Local include:

- Enabling Arc gateway after deployment isn't supported.

## Azure Local endpoints not redirected

The endpoints from the table are required and must be allowlisted in your proxy or firewall to deploy the Azure Local instance:

| Endpoint # | Required endpoint | Component  |
| -- | -- | -- |
| 1 | `http://aka.ms:443` | Bootstrap |
| 2 | `http://azurestackreleases.download.prss.microsoft.com:443]` | Bootstrap |
| 3 | `http://login.microsoftonline.com:443` | Arc registration |
| 4 | `http://<region>.login.microsoft.com:443` | Arc registration |
| 5 | `http://management.azure.com:443` | Arc registration |
| 6 | `http://gbl.his.arc.azure.com:443` | Arc registration |  
| 7 | `http://<region>.his.arc.azure.com:443` | Arc registration |
| 8 | `http://dc.services.visualstudio.com:443` | Arc registration |
| 9 | `https://<region>.obo.arc.azure.com:8084` | AKS extensions |
| 10 | `http://<yourarcgatewayId>.gw.arc.azure.com:443` | Arc gateway |
| 11 | `http://<yourkeyvaultname>.vault.azure.net:443` | Azure Key Vault |
| 12 | `http://<yourblobstorageforcloudwitnessname>.blob.core.windows.net:443` | Cloud Witness Storage Account |
| 13 | `http://files.pythonhosted.org:443` | Not required starting with 2504 new deployments. Microsoft On-premises Cloud/ARB/AKS |
| 14 | `http://pypi.org:443` | Not required starting with 2504 new deployments. Microsoft On-premises Cloud/ARB/AKS |
| 15 | `http://raw.githubusercontent.com:443` | Not required starting with 2504 new deployments. Microsoft On-premises Cloud/ARB/AKS |
| 16 | `http://pythonhosted.org:443` | Not required starting with 2504 new deployments. Microsoft On-premises Cloud/ARB/AKS |
| 17 | `http://ocsp.digicert.com`  | Certificate Revocation List for Arc extensions |
| 18 | `http://s.symcd.com` | Certificate Revocation List for Arc extensions |
| 19 | `http://ts-ocsp.ws.symantec.com` | Certificate Revocation List for Arc extensions |
| 20 | `http://ocsp.globalsign.com` | Certificate Revocation List for Arc extensions |
| 21 | `http://ocsp2.globalsign.com` | Certificate Revocation List for Arc extensions |
| 22 | `http://oneocsp.microsoft.com` | Certificate Revocation List for Arc extensions |
| 23 | `http://crl.microsoft.com/pkiinfra` | Certificate Revocation List for Arc extensions |
| 24 | `http://dl.delivery.mp.microsoft.com` | Windows Update |
| 25 | `http://*.tlu.dl.delivery.mp.microsoft.com` | Windows Update |
| 26 | `http://*.windowsupdate.com` | Windows Update |
| 27 | `http://*.windowsupdate.microsoft.com` | Windows Update |
| 28 | `http://*.update.microsoft.com` | Windows Update |

## Restrictions and limitations

Consider the following limitations of Arc gateway in this release:

- Transport Layer Security (TLS) terminating proxies aren't supported with the Arc gateway preview.
- Use of ExpressRoute, Site-to-Site VPN, or Private Endpoints in addition to the Arc gateway (preview) isn't supported.  

## Create the Arc gateway resource in Azure

You can create an Arc gateway resource using the Azure portal, Azure CLI, or Azure PowerShell.

# [Portal](#tab/portal)

1. Sign in to [Azure portal](https://ms.portal.azure.com/).
1. Go to the **Azure Arc > Azure Arc gateway** page, then select **Create**.
1. Select the subscription where you're planning to deploy your Azure Local instance.
1. For **Name**, enter the name for the Arc gateway resource.
1. For **Location**, enter the region where the Arc gateway resource should live. An Arc gateway resource is used by any Arc-enabled resource in the same Azure tenant.
1. Select **Next**.
1. On the **Tags** page, specify one or more custom tags to support your standards.
1. Select **Review & Create**.
1. Review your details, and then select **Create**.

The gateway creation process takes nine to 10 minutes to complete.


# [CLI](#tab/cli)

1. Add the arc gateway extension to your Azure CLI:

    `az extension add -n arcgateway`

1. On a machine with access to Azure, run the following commands to create your Arc gateway resource:

    ```azurecli
    az arcgateway create --name [gateway name] --resource-group [resource group] --location [location]
    ```

    The gateway creation process takes 9-10 minutes to complete.

# [PowerShell](#tab/powershell)

On a machine with access to Azure, run the following PowerShell command to create your Arc gateway resource:

```azurepowershell
New-AzArcgateway 
-name <gateway name> 
-resource-group <resource group> 
-location <region> 
-subscription <subscription name or id> 
-gateway-type public  
-allowed-features *
```

The gateway creation process takes 9-10 minutes to complete.

---

## Detach or change the Arc gateway association from the machine

To detach the gateway resource from your Arc-enabled server, set the gateway resource ID to `null`. To attach your Arc-enabled server to another Arc gateway resource, update the name and resource ID with the new Arc gateway information:

```azurecli
az arcgateway settings update --resource-group <Resource Group> --subscription <subscription name> --base-provider Microsoft.HybridCompute --base-resource-type machines --base-resource-name <Arc-enabled server name> --gateway-resource-id "
```

## Delete the Arc gateway resource

Before deleting an Arc gateway resource, ensure that no machines are attached. To delete the gateway resource, run the following command:

```azurecli
az arcgateway delete --resource group <resource group name> --gateway-name <gateway resource name>
```

This operation can take a couple of minutes.  

## Next steps

- [Configure the proxy manually](deployment-azure-arc-gateway-configure-manually.md)

- [Configure the proxy via registration script](deployment-azure-arc-gateway-configure-via-script.md)

- [Use the gateway without a proxy](deployment-azure-arc-gateway-use-without-proxy.md)

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local version 2411.1 or later.

::: moniker-end