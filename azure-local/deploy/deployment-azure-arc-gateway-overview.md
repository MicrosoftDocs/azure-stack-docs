--- 
title: Overview of Azure Arc gateway for Azure Local
description: Learn what is Azure Arc gateway for Azure Local.
author: alkohli
ms.topic: how-to
ms.date: 11/26/2025
ms.author: alkohli
ms.service: azure-local
---

# About Azure Arc gateway for Azure Local

::: moniker range=">=azloc-2506"

This article provides an overview of the Azure Arc gateway for Azure Local (formerly known as Azure Stack HCI). You can enable the Arc gateway on new deployments of Azure Local running software version 2506 and later. This article also describes how to create and delete the Arc gateway resource in Azure.

Use the Arc gateway to significantly reduce the number of required endpoints needed to deploy and manage Azure Local instances. When you create the Arc gateway, connect to and use it for new deployments of Azure Local.

> [!NOTE]
> Although Arc gateway for Azure Local infrastructure and Azure Local VMs is generally available, Arc gateway for AKS on Azure Local is still in preview.

## How it works

The Arc gateway works by introducing the following components:

- **Arc gateway resource** – An Azure resource that acts as a common entry point for Azure traffic. This gateway resource has a specific domain or URL that you can use. When you create the Arc gateway resource, this domain or URL is part of the success response.  

- **Arc proxy** – A new component that is added to the Arc agentry. This component runs as a service (called the **Azure Arc Proxy**) and functions as a forward proxy for the Azure Arc agents and extensions. The gateway router doesn't need any configuration. This router is part of the Arc core agentry and runs in the context of an Arc-enabled resource.

When you integrate the Arc gateway with Azure Local deployments, each machine gets Arc proxy along with other Arc Agents.

The following diagram illustrates how traffic flows between the various components:

:::image type="content" source="./media/deployment-azure-arc-gateway-overview/arc-gateway-component-diagram.svg" alt-text="Diagram of Azure Arc gateway architecture." lightbox="./media/deployment-azure-arc-gateway-overview/arc-gateway-component-diagram.svg":::

The following sections explain how *http* and *https* traffic flow changes when you use the Arc gateway:

### Traffic flows 1-3 for Azure Local host OS

- Make sure to [Configure the proxy bypass list](./deployment-with-azure-arc-gateway.md?view=azloc-2509&tabs=script&pivots=register-proxy&preserve-view=true#step-2-set-parameters) for any endpoint that you don't want to send over Arc gateway.

- Arc gateway doesn't support HTTP traffic. Configure your proxy or firewall to allow the required HTTP endpoints for Azure Local.

- All HTTPS traffic not configured in the proxy bypass list is forwarded to Arc gateway.

- Arc proxy automatically determines the right path for the endpoint. If the Arc gateway doesn't allow the HTTPS endpoint, Arc proxy sends the HTTPS traffic to your enterprise proxy or firewall.

### Traffic flow 4 for Azure Arc resource bridge

- The Azure Arc resource bridge forward proxy is configured to use cluster IP.

- With proxy settings in place, the system forwards Arc resource bridge HTTPS traffic to Arc proxy running on one of the Azure Local machines over cluster IP.


### Traffic flow 5 for AKS clusters and pods

- When you deploy AKS clusters on Azure Local with Arc gateway, the system forwards all HTTP and HTTPS traffic from the AKS control plane VM and worker node VMs to the cluster IP as the proxy.

- If there's an existing firewall between the infrastructure subnet and the AKS subnet, allow the traffic from ports 22 and 6443.

- When you deploy AKS workloads on Azure Local with Arc gateway configured, you still need to allow access to the non-allowed endpoints on the management subnet. If you don't want the traffic routed through the management subnet, configure the non-allowed endpoints via the proxy bypass list during Azure Local deployment.

    For more information, see the [Comprehensive list of FQDN endpoints required for AKS on a separated subnet](/azure/aks/aksarc/arc-gateway-aks-arc#confirm-access-to-required-urls) when using Arc gateway.

### Traffic flow 6 for Azure Local VMs

- The system forwards all Arc HTTPS traffic to the Arc gateway configured for the Azure Local VM.
- If you want to forward all the HTTP and HTTPS traffic from the Azure Local VM to the Arc gateway, you must configure the OS WinInet and WinHTTP proxy settings to use the Arc proxy that's running on http://\<localhost\>:\<port40343\>.
- Traffic intended for endpoints not managed by the Arc gateway is routed through the enterprise proxy or firewall.

For more information about the traffic flows, see [Deep dive into Azure Arc gateway outbound traffic mode for Azure Local](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Networking/Arc-Gateway-Outbound-Connectivity/DeepDive-ArcGateway-Outbound-Traffic.md).

## Supported and unsupported scenarios

Use the Arc gateway in the following scenarios for Azure Local:

- Enable Arc gateway during deployment of new Azure Local instances running versions 2506 or later.
- The Arc gateway resource must be created on the same subscription where you're planning to deploy your Azure Local instance.

Unsupported scenarios for Azure Local include:

- You can't enable Arc gateway after deployment.

## Azure Local endpoints not redirected

> [!NOTE]
> Endpoint requirements may vary by Azure region. For region-specific endpoint lists (for example, Japan East), refer to the [AzureStack-Tools GitHub repository](https://github.com/Azure/AzureStack-Tools/tree/master/HCI) for the latest endpoint mapping.
> The table in this article represents global defaults.

The endpoints from the following table are required. Add these endpoints to the allowlist in your proxy or firewall to deploy the Azure Local instance:

| Endpoint # | Required endpoint | Component  |
|--|--|--|
| 1 | `https://aka.ms` | Bootstrap |
| 2 | `https://azurestackreleases.download.prss.microsoft.com` | Bootstrap |
| 3 | `https://login.microsoftonline.com` | Arc registration |
| 4 | `https://<region>.login.microsoft.com` | Arc registration |
| 5 | `https://management.azure.com` | Arc registration |
| 6 | `https://gbl.his.arc.azure.com` | Arc registration |  
| 7 | `https://<region>.his.arc.azure.com` | Arc registration |
| 8 | `https://<region>.obo.arc.azure.com:8084` | Only required for certain AKS workloads extensions |
| 9 | `https://<yourarcgatewayId>.gw.arc.azure.com` | Arc gateway |
| 10 | `https://<yourkeyvaultname>.vault.azure.net` | Azure Key Vault |
| 11 | `https://<yourblobstorageforcloudwitnessname>.blob.core.windows.net` | Cloud Witness Storage Account |
| 12 | `http://ocsp.digicert.com`  | Certificate Revocation List for Arc extensions |
| 13 | `http://s.symcd.com` | Certificate Revocation List for Arc extensions |
| 14 | `http://ts-ocsp.ws.symantec.com` | Certificate Revocation List for Arc extensions |
| 15 | `http://ocsp.globalsign.com` | Certificate Revocation List for Arc extensions |
| 16 | `http://ocsp2.globalsign.com` | Certificate Revocation List for Arc extensions |
| 17 | `http://oneocsp.microsoft.com` | Certificate Revocation List for Arc extensions |
| 18 | `http://crl.microsoft.com/pkiinfra` | Certificate Revocation List for Arc extensions |
| 19 | `https://dl.delivery.mp.microsoft.com` | Not required starting with 2504 new deployments. Windows Update |
| 20 | `https://*.tlu.dl.delivery.mp.microsoft.com` | Not required starting with 2506 new deployments. Windows Update |
| 21 | `https://*.windowsupdate.com` | Not required starting with 2506 new deployments. Windows Update |
| 22 | `https://*.windowsupdate.microsoft.com` | Not required starting with 2506 new deployments. Windows Update |
| 23 | `https://*.update.microsoft.com` | Not required starting with 2506 new deployments. Windows Update |

## Restrictions and limitations

Arc gateway has the following limitations in this release:

- Arc gateway doesn't support Transport Layer Security (TLS) terminating proxies.

## Create the Arc gateway resource in Azure

> [!NOTE]
> Arc gateway creation is currently impacted by temporary Azure Front Door changes. Resource creation may take up to two 2 hours and can time out, causing failures. If resource creation fails, please try Arc gateway resource creation again.

You can create an Arc gateway resource using the Azure portal, Azure CLI, or Azure PowerShell.

# [Portal](#tab/portal)

1. Sign in to [Azure portal](https://ms.portal.azure.com/).
1. Go to the **Azure Arc > Azure Arc gateway** page, and then select **Create**.
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
New-AzArcgateway -name <gateway name> -resource-group <resource group> -location <region> -subscription <subscription name or id> -gateway-type public  -allowed-features *
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

- [Register Azure Local machines with Azure Arc gateway](./deployment-with-azure-arc-gateway.md)


::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local version 2506 or later.

::: moniker-end
