--- 
title: Overview of Azure Arc gateway for Azure Local (Preview)
description: Learn what is Azure Arc gateway for Azure Local (Preview).
author: alkohli
ms.topic: how-to
ms.date: 09/09/2025
ms.author: alkohli
ms.service: azure-local
---

# About Azure Arc gateway for Azure Local (Preview)

::: moniker range=">=azloc-2506"

This article provides an overview of the Azure Arc gateway for Azure Local (formerly known as Azure Stack HCI) which can be enabled on new deployments of Azure Local running software version 2505 and later. This article also describes how to create and delete the Arc gateway resource in Azure.

You can use the Arc gateway to significantly reduce the number of required endpoints needed to deploy and manage Azure Local instances. When you create the Arc gateway, you can connect to and use it for new deployments of Azure Local.

## How it works

The Arc gateway works by introducing the following components:

- **Arc gateway resource** – An Azure resource that acts as a common entry point for Azure traffic. This gateway resource has a specific domain or URL that you can use. When you create the Arc gateway resource, this domain or URL is a part of the success response.  

- **Arc proxy** – A new component that is added to the Arc agentry. This component runs as a service (called the **Azure Arc Proxy**) and works as a forward proxy for the Azure Arc agents and extensions. The gateway router doesn't need any configuration from your side. This router is part of the Arc core agentry and runs within the context of an Arc-enabled resource.

When you integrate the Arc gateway with Azure Local deployments, each machine gets Arc proxy along with other Arc Agents.

When Arc gateway is used, the *http* and *https* traffic flow changes as follows:

**Traffic flow for Azure Local host operating system components**

1. OS proxy settings are used to route all HTTPS host traffic through Arc proxy.  

1. From Arc proxy, the traffic is forwarded to Arc gateway.

1. Based on the configuration in the Arc gateway, if allowed, the traffic is sent to target services. If not allowed, Arc proxy redirects this traffic to the enterprise proxy (or direct outbound if no proxy set). Arc proxy automatically determines the right path for the endpoint.

**Traffic flow for Arc appliance Azure Arc resource bridge and AKS control plane**

1. Routable IP (failover clustered IP resource as of now) is used to forward the traffic through Arc proxy running on the Azure Local host machines.

1. Azure Arc resource bridge and Azure Kubernetes Service (AKS) forward proxy are configured to use routable IP.

1. With proxy settings in place, Arc resource bridge, and AKS outbound traffic is forwarded to Arc proxy running on one of the Azure Local machines over routable IP.

1. When traffic reaches the Arc proxy, the remaining flow takes the same path as described. If traffic to the target service is allowed, it's sent to Arc gateway. If not, it's sent to the enterprise proxy (or direct outbound if no proxy set). For AKS specifically, this path is used for downloading docker images for Arc agentry and Arc Extension Pods.

**Traffic flow for Azure Local VMs**

HTTP and HTTPS traffic are forwarded to the enterprise proxy. Arc proxy inside an Azure Local virtual machine (VM) enabled by Arc isn't yet supported in this version.

Traffic flows are illustrated in the following diagram:

:::image type="content" source="./media/deployment-azure-arc-gateway-overview/arc-gateway-component-diagram.png" alt-text="Diagram of Azure Arc gateway architecture." lightbox="./media/deployment-azure-arc-gateway-overview/arc-gateway-component-diagram.png":::


## Supported and unsupported scenarios

You can use the Arc gateway in the following scenario for Azure Local:

- Enable Arc gateway during deployment of new Azure Local instances running versions 2506 or later.
- The Arc gateway resource must be created on the same subscription where you're planning to deploy your Azure Local instance.

Unsupported scenarios for Azure Local include:

- Enabling Arc gateway after deployment isn't supported.

## Azure Local endpoints not redirected

The endpoints from the table are required and must be allowlisted in your proxy or firewall to deploy the Azure Local instance:

| Endpoint # | Required endpoint | Component  |
|--| -- |--|
| 1 | `https://aka.ms` | Bootstrap |
| 2 | `https://azurestackreleases.download.prss.microsoft.com]` | Bootstrap |
| 3 | `https://login.microsoftonline.com` | Arc registration |
| 4 | `https://<region>.login.microsoft.com` | Arc registration |
| 5 | `https://management.azure.com` | Arc registration |
| 6 | `https://gbl.his.arc.azure.com` | Arc registration |  
| 7 | `https://<region>.his.arc.azure.com` | Arc registration |
| 8 | `https://<region>.obo.arc.azure.com:8084` | Only required for certain AKS workloads extensions |
| 9 | `https://<yourarcgatewayId>.gw.arc.azure.com` | Arc gateway |
| 10 | `https://<yourkeyvaultname>.vault.azure.net` | Azure Key Vault |
| 11 | `https://<yourblobstorageforcloudwitnessname>.blob.core.windows.net` | Cloud Witness Storage Account |
| 12 | `https://files.pythonhosted.org` | Not required starting with 2504 new deployments. Microsoft On-premises Cloud/ARB/AKS |
| 13 | `https://pypi.org` | Not required starting with 2504 new deployments. Microsoft On-premises Cloud/ARB/AKS |
| 14 | `https://raw.githubusercontent.com` | Not required starting with 2504 new deployments. Microsoft On-premises Cloud/ARB/AKS |
| 15 | `https://pythonhosted.org` | Not required starting with 2504 new deployments. Microsoft On-premises Cloud/ARB/AKS |
| 16 | `http://ocsp.digicert.com`  | Certificate Revocation List for Arc extensions |
| 17 | `http://s.symcd.com` | Certificate Revocation List for Arc extensions |
| 18 | `http://ts-ocsp.ws.symantec.com` | Certificate Revocation List for Arc extensions |
| 19 | `http://ocsp.globalsign.com` | Certificate Revocation List for Arc extensions |
| 20 | `http://ocsp2.globalsign.com` | Certificate Revocation List for Arc extensions |
| 21 | `http://oneocsp.microsoft.com` | Certificate Revocation List for Arc extensions |
| 22 | `http://crl.microsoft.com/pkiinfra` | Certificate Revocation List for Arc extensions |
| 23 | `https://dl.delivery.mp.microsoft.com` | Not required starting with 2504 new deployments. Windows Update |
| 24 | `https://*.tlu.dl.delivery.mp.microsoft.com` | Not required starting with 2504 new deployments. Windows Update |
| 25 | `https://*.windowsupdate.com` | Not required starting with 2504 new deployments. Windows Update |
| 26 | `https://*.windowsupdate.microsoft.com` | Not required starting with 2504 new deployments. Windows Update |
| 27 | `https://*.update.microsoft.com` | Not required starting with 2504 new deployments. Windows Update |

## Restrictions and limitations

Consider the following limitations of Arc gateway in this release:

- Transport Layer Security (TLS) terminating proxies aren't supported with the Arc gateway.
- Use of ExpressRoute, Site-to-Site VPN, or Private Endpoints in addition to the Arc gateway isn't supported.

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