--- 
title: Overview of Azure Arc gateway for Azure Local, version 23H2 (preview)
description: Learn what is Azure Arc gateway for Azure Local, version 23H2 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 11/18/2024
ms.author: alkohli
ms.service: azure-stack-hci
monikerRange: ">=azloc-2408"
---

# About Azure Arc gateway for Azure Local, version 23H2 (preview)

Applies to: Azure Local, version 23H2, release 2408, 2408.1, 2408.2, and 2411

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

This article provides an overview of the Azure Arc gateway for Azure Local, version 23H2. The Arc gateway can be enabled on new deployments of Azure Local running software version 2408 and later. This article also describes how to create and delete the Arc gateway resource in Azure.

You can use the Arc gateway to significantly reduce the number of required endpoints needed to deploy and manage Azure Local instances. Once you create the Arc gateway, you can connect to and use it for new deployments of Azure Local.

For information on how to deploy the Azure Arc gateway for standalone servers (not Azure Local machines), see [Simplify network configuration requirements through Azure Arc gateway](/azure/azure-arc/servers/arc-gateway).

[!INCLUDE [important](../includes/hci-preview.md)]

## How it works

The Arc gateway works by introducing the following components:

- **Arc gateway resource** – An Azure resource that acts as a common entry point for Azure traffic. This gateway resource has a specific domain or URL that you can use. When you create the Arc gateway resource, this domain or URL is a part of the success response.  

- **Arc proxy** – A new component that is added to the Arc Agentry. This component runs as a service (Called  the **Azure Arc Proxy**) and works as a forward proxy for the Azure Arc agents and extensions. The gateway router doesn't need any configuration from your side. This router is part of the Arc core agentry and runs within the context of an Arc-enabled resource.

Once you integrate the Arc gateway with release 2411 of Azure Local deployments, each machine gets Arc proxy along with other Arc Agents.

When Arc gateway is used, the *http* and *https* traffic flow changes as follows:

**Traffic flow for Azure Local host operating system components**

1. OS proxy settings are used to route all HTTPS host traffic through Arc proxy.  

1. From Arc proxy, the traffic is forwarded to Arc gateway.

1. Based on the configuration in the Arc gateway, if allowed, the traffic is sent to target services. If not allowed, Arc proxy redirects this traffic to the enterprise proxy (or direct outbound if no proxy set). Arc proxy automatically determines the right path for the endpoint.

**Traffic flow for Arc appliance Arc Resource Bridge (ARB) and AKS control plane**

1. The routable IP (failover clustered IP resource as of now) is used to forward the traffic through Arc proxy running on the Azure Local host machines.

1. ARB and AKS forward proxy are configured to use the routable IP.

1. With the proxy settings in place, ARB, and AKS outbound traffic is forwarded to Arc Proxy running on one of the Azure Local machines over the routable IP.

1. Once the traffic reaches Arc proxy, the remaining flow takes the same path as described. If traffic to the target service is allowed, it is sent to Arc gateway. If not, it is sent to the enterprise proxy (or direct outbound if no proxy set). Note that for AKS specifically, this path is used for downloading docker images for Arc Agentry and Arc Extension Pods.

**Traffic flow for Arc VMs**

*Http* and *https* traffic are forwarded to the enterprise proxy. Arc proxy inside the Arc VM is not yet supported in this version.

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

You can use the Arc gateway in the following scenario for Azure Local versions 2408 and 2411:

- Enable Arc gateway during deployment of new Azure Local instances running versions 2408 and 2411.

Unsupported scenarios for Azure Local, versions 2408 and 2411 include:

- Azure Local instances updated from versions 2402 or 2405 to versions 2408 or 2411 can't take advantage of all the new endpoints supported by this Arc gateway preview. Host components, Arc extensions, ARB, and AKS required endpoints are only supported when enabling the Arc gateway as part of a new version 2408 deployment.

- Enabling Arc gateway after version 2408 or 2411 deployment cannot take advantage of all the new endpoints supported by this Arc gateway preview. Host, Arc extensions, ARB, and AKS required endpoints are only supported when enabling the Arc gateway as part of a new version 2408 or version 2411 deployment.

## Azure Local endpoints not redirected

As part of the Azure Local version 2408 preview update, the endpoints from the table are required and must be allowlisted in your proxy or firewall to deploy the Azure Local instance. These version 2408 and 2411 endpoints are not redirected via the Arc gateway:

| Endpoint # | Required endpoint | Component  |
| -- | -- | -- |
| 1 | `http://go.microsoft.com:443` | Environment Checker |
| 2 | `http://www.powershellgallery.com:443` | Environment Checker |
| 3 | `http://psg-prod-eastus.azureedge.net:443` | Environment Checker |
| 4 | `http://onegetcdn.azureedge.net:443` | Environment Checker |
| 5 | `http://login.microsoftonline.com:443` | Environment Checker |
| 6 | `http://aka.ms:443` | Environment Checker |
| 7 | `http://azurestackreleases.download.prss.microsoft.com:443` | Environment Checker |
| 8 | `http://download.microsoft.com:443` | Environment Checker |
| 9 | `http://portal.azure.com:443` | Environment Checker |
| 10 | `http://management.azure.com:443` | Environment Checker |
| 11 | `http://www.office.com:443` | Environment Checker |
| 12 | `http://gbl.his.arc.azure.com:443` | Arc agent |  
| 13 | `http://<region>.his.arc.azure.com:443` | Arc agent |
| 14 | `http://dc.services.visualstudio.com:443` | Arc agent |
| 15 | `http://<yourarcgatewayId>.gw.arc.azure.com:443` | Arc gateway |
| 16 | `http://<yourkeyvaultname>.vault.azure.net:443` | Azure Key Vault |
| 17 | `http://<yourblobstorageforcloudwitnessname>.blob.core.windows.net:443` | Cloud Witness Storage Account |
| 18 | `http://files.pythonhosted.org:443` | Microsoft On-premises Cloud/ARB/AKS |
| 19 | `http://pypi.org:443` | Microsoft On-premises Cloud/ARB/AKS |
| 20 | `http://raw.githubusercontent.com:443` | Microsoft On-premises Cloud/ARB/AKS |
| 21 | `http://pythonhosted.org:443` | Microsoft On-premises Cloud/ARB/AKS |
| 22 | `http://hciarcvmsstorage.z13.web.core.windows.net:443` | Microsoft On-premises Cloud/ARB/AKS |
| 23 | `http://ocsp.digicert.com`  | Certificate Revocation List for Arc extensions |
| 24 | `http://s.symcd.com` | Certificate Revocation List for Arc extensions |
| 25 | `http://ts-ocsp.ws.symantec.com` | Certificate Revocation List for Arc extensions |
| 26 | `http://ocsp.globalsign.com` | Certificate Revocation List for Arc extensions |
| 27 | `http://ocsp2.globalsign.com` | Certificate Revocation List for Arc extensions |
| 28 | `http://oneocsp.microsoft.com` | Certificate Revocation List for Arc extensions |
| 29 | `http://dl.delivery.mp.microsoft.com` | LCM Binaries |
| 30 | `http://*.tlu.dl.delivery.mp.microsoft.com` | LCM Binaries |
| 31 | `http://*.windowsupdate.com` | Windows Update |
| 32 | `http://*.windowsupdate.microsoft.com` | Windows Update |
| 33 | `http://*.update.microsoft.com` | Windows Update |

## Restrictions and limitations

Consider the following limitations of Arc gateway in this release:

- TLS terminating proxies aren't supported with the Arc gateway preview.
- Use of ExpressRoute, Site-to-Site VPN, or Private Endpoints in addition to the Arc gateway (preview) isn't supported.  

## Create the Arc gateway resource in Azure

You can create an Arc gateway resource using the Azure portal, Azure CLI, or Azure PowerShell.

# [Portal](#tab/portal)

1. Sign in to [Azure portal](https://ms.portal.azure.com/).
1. Go to the **Azure Arc > Azure Arc gateway** page, then select **Create**.
1. Select the subscription and resource group where you want the Arc gateway resource to be managed within Azure. An Arc gateway resource can be used by any Arc-enabled resource in the same Azure tenant.
1. For **Name**, enter the name for the Arc gateway resource.
1. For **Location**, enter the region where the Arc gateway resource should live. An Arc gateway resource can be used by any Arc-enabled resource in the same Azure tenant.
1. Select **Next**.
1. On the **Tags** page, specify one or more custom tags to support your standards.
1. Select **Review & Create**.
1. Review your details, and then select **Create**.

The gateway creation process takes nine to ten minutes to complete.


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

To detach the gateway resource from your Arc-enabled server, set the gateway resource ID to `null`. If you want to attach your Arc-enabled server to another Arc gateway resource just update the name and resource ID with the new Arc gateway information:

```azurecli
az arcgateway settings update --resource-group <Resource Group> --subscription <subscription name> --base-provider Microsoft.HybridCompute --base-resource-type machines --base-resource-name <Arc-Server’s name> --gateway-resource-id "
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