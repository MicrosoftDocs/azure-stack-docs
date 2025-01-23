--- 
title: Set up Azure Arc gateway for existing Azure Local instance running version 2405 (preview)
description: Learn how to deploy Azure Arc gateway for existing Azure Local deployments running software version 2405 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 01/16/2025
ms.author: alkohli
monikerRange: ">=azloc-2408"
ms.service: azure-local
---

# Simplify outbound network requirements for existing Azure Local instances, version 23H2 through Azure Arc gateway (preview)

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to set up an Azure Arc Gateway for existing deployments of Azure Local running software version 2405.

You can use the Arc gateway to significantly reduce the number of required endpoints needed to deploy and manage Azure Local instances. You can enable the Arc gateway for new deployments or for existing deployments. 

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

Before you start, make sure that you have:

- A completed [Arc gateway Preview signup form](https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR2WRja4SbkFJm6k6LDfxchxUN1dYTlZIM1JYTVFCN0RVTjgyVEZHMkFTSC4u).
- An Arc gateway resource in Azure. To create the resource, follow the steps in [Create the Arc gateway resource in Azure](./deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).
- An existing Azure Local instance running software version 2405 or later.
  - The machines in the system must be running the Azure Connected Machine agent version 1.40 or later.

## Enable Arc gateway for existing Azure Local deployments

The following steps are required to enable the Azure Arc gateway on existing Azure Local 2405 deployments.

0. Create the Arc gateway resource in Azure (prerequisite).
1. Associate the Arc gateway resource with your existing Azure Local instance.
2. Update Arc agent configuration on each deployed Azure Local machine to use the Arc gateway ID.
3. Await reconciliation.
4. Verify that supported endpoints are redirected through the Arc gateway.


## Step 1: Associate the Arc gateway resource with your existing Azure Local instance

Run the following az commands from a remote computer with internet access. You can use the same computer you used to create the Arc gateway resource in Azure. It isn't supported to run these commands from the Azure Local machines.

[Optional step] Download the [az connectedmachine.whl](https://aka.ms/ArcGatewayWhl) file extension if you're using a different computer than the one you used to create the Arc gateway resource in Azure. Otherwise you can omit this step.

[Optional step] Install the [Azure Command Line Interface (CLI)](/cli/azure/install-azure-cli-windows?tabs=azure-cli) if you're using a different computer than the one you used to create the Arc gateway resource in Azure. Otherwise you can omit this step.

[Optional step] Run the following command to add the az connected machine extension if you're using a different computer than the one you used to create the Arc gateway resource in Azure. Otherwise you can omit this step.

```azurecli
az extension add --allow-preview true --yes --source [whl file path] 
```

Associate each existing machine in the system with the Arc gateway resource. Run the following command:

```azurecli
az connectedmachine setting update --resource-group [res-group] --subscription [subscription name] --base-provider Microsoft.HybridCompute --base-resource-type machines --base-resource-name [Arc server resource name] --settings-resource-name default --gateway-resource-id [Full Arm resourceid]
```

## Step 2: Update the machine to use the Arc gateway resource  

Update each Azure Local machine in the system to use the Arc gateway resource. Run the following command locally on your Azure Local machines to set the Arc agents to start using the Arc gateway.

```azurecli
azcmagent config set connection.type gateway
```

## Step 3: Await reconciliation

Await reconciliation. Once your machines have been updated to use the Arc gateway, some Azure Arc endpoints that were previously allowed in your proxy or firewalls, aren't needed any longer. Wait one hour before you begin removing endpoints from your firewall or proxy.

Next step is to verify that the setup was successful.

## Step 4: Verify that setup succeeded

[!INCLUDE [hci-gateway-verify-setup-successful](../includes/hci-gateway-verify-setup-successful.md)]

## Troubleshooting  

You can audit Arc gateway traffic by viewing the gateway router logs.  

Follow these steps to view the logs:

1. Run the `azcmagent logs` command.

1. In the resulting .zip file, view the logs in the *C:\ProgramData\Microsoft\ArcGatewayRouter* folder.


## Next steps

Deploy workloads on your Azure Local instance:

- [Run Azure Virtual Machines on Azure Local](../manage/create-arc-virtual-machines.md).
- [Deploy Azure Kubernetes Service on Azure Local](/azure/aks/hybrid/aks-create-clusters-cli).
- [Deploy Azure Virtual Desktop on Azure Local](/azure/virtual-desktop/deploy-azure-virtual-desktop).