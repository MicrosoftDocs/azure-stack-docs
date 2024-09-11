--- 
title: Set up Azure Arc gateway for new Azure Stack HCI cluster running version 2405 (preview)
description: Learn how to deploy Azure Arc gateway for new Azure Stack HCI cluster deployments running software version 2405 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 06/17/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
ms.custom: devx-track-azurepowershell
---

# Simplify outbound network requirements for new Azure Stack HCI, version 23H2 clusters through Azure Arc gateway (preview)

Applies to: Azure Stack HCI, version 23H2

This article describes how to set up an Azure Arc Gateway for new deployments of Azure Stack HCI running software version 2405.

You can use the Arc gateway to significantly reduce the number of required endpoints needed to deploy and manage Azure Stack HCI clusters. You can enable the Arc gateway for new deployments or for existing deployments.

<!--This article only covers the new Azure Stack HCI deployments. For existing deployments, see [Enable Azure Arc gateway for existing Azure Stack HCI deployments](deployment-azure-arc-gateway-existing-cluster.md). To use the Arc gateway on standalone Arc for Servers scenarion, see [How to simplify network configuration requirements through Azure Arc gateway]().-->

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you start, make sure you have the following:

- A completed [Arc gateway Preview signup form](https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR2WRja4SbkFJm6k6LDfxchxUN1dYTlZIM1JYTVFCN0RVTjgyVEZHMkFTSC4u).
- An Arc gateway resource in Azure. To create the resource, follow the steps in [Create the Arc gateway resource in Azure](./deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).
- Azure Stack HCI servers that you intend to cluster.

  - These servers must be running software version 2405 or later.
  - These servers must be running the Azure Connected Machine agent version 1.40 or later.

## Enable Arc gateway for new Azure Stack HCI deployments

The following steps are required to enable the Azure Arc gateway on new Azure Stack HCI 2405 deployments.

0. Create the Arc gateway resource in Azure (prerequisite).
1. Register new Azure Stack HCI servers with Arc using the Arc gateway ID.
2. Start the Azure Stack HCI cloud deployment.
3. Verify that supported endpoints are redirected through the Arc gateway during deployment.


## Step 1: Register new Azure Stack HCI servers via the Arc gateway ID

Once the Arc gateway resource is created, start connecting the Arc agents running on your Azure Stack HCI nodes as part of agent installation.  

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

```powershell
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
Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region eastus2euap -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Force -ArcGatewayID "/subscriptions/<Subscription ID>/resourceGroups/<Resourcegroup>/providers/Microsoft.HybridCompute/gateways/<ArcGateway>"
```


## Step 2: Start the Azure Stack HCI cloud deployment

Once the Azure Stack HCI nodes are registered in Arc and all the extensions are installed, you can start the deployment from the Azure portal or via the ARM templates as documented here:

- [Deploy Azure Stack HCI via Azure portal](deploy-via-portal.md).

- [Deploy Azure Stack HCI via ARM template](deployment-azure-resource-manager-template.md).

Next step is to [Verify that the setup was successful](#step-3-verify-that-setup-succeeded).

## Step 3: Verify that setup succeeded

[!INCLUDE [hci-gateway-verify-setup-successful](../../includes/hci-gateway-verify-setup-successful.md)]


## Troubleshooting  

You can audit the Arc gateway traffic by viewing the gateway router logs.  

Follow these steps to view the logs:

1. Run the following command:
   ```azurecli
   azcmagent logs
   ```

1. In the resulting **.zip** file, view the logs in the `C:\ProgramData\Microsoft\ArcGatewayRouter` folder.


## Next steps

Deploy your Azure Stack HCI cluster:

- [Via the Azure portal](./deploy-via-portal.md).
- [Via the ARM templates](./deployment-azure-resource-manager-template.md).
