--- 
title: Set up Azure Arc gateway for existing Azure Stack HCI cluster running version 2405 (preview)
description: Learn how to deploy Azure Arc gateway for existing Azure Stack HCI deployments running software version 2405 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 06/17/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Simplify outbound network requirements for existing Azure Stack HCI, version 23H2 clusters through Azure Arc gateway (preview)

Applies to: Azure Stack HCI, version 23H2

This article describes how to set up an Azure Arc Gateway for existing deployments of Azure Stack HCI running software version 2405.

You can use the Arc gateway to significantly reduce the number of required endpoints needed to deploy and manage Azure Stack HCI clusters. You can enable the Arc gateway for new deployments or for existing deployments. 

This article only covers the existing Azure Stack HCI deployments. For new deployments, see [Enable Azure Arc gateway for existing Azure Stack HCI deployments](deployment-azure-arc-gateway-new-cluster.md). To use the Arc gateway on standalone Arc for Servers scenarion, see [How to simplify network configuration requirements through Azure Arc gateway](/azure/azure-arc/servers/arc-gateway).


[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you start, make sure you have the following:

- A completed [Arc gateway Preview signup form](https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR2WRja4SbkFJm6k6LDfxchxUN1dYTlZIM1JYTVFCN0RVTjgyVEZHMkFTSC4u).
- An Arc gateway resource in Azure. To create the resource, follow the steps in [Create the Arc gateway resource in Azure](./deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).
- An existing Azure Stack cluster running software version 2405 or later.
  - The servers in the cluster must be running the Azure Connected Machine agent version 1.40 or later.


## Enable Arc gateway for existing Azure Stack HCI deployments

The following steps are required to enable the Azure Arc gateway on existing Azure Stack HCI 2405 deployments.

  :::image type="content" source="media/deployment-azure-arc-gateway/existing-deployment-workflow.png" alt-text="Azure Arc gateway new deployment workflow." lightbox="./media/deployment-azure-arc-gateway/existing-deployment-workflow.png":::


### Step 1: Associate the Arc gateway resource with your existing Azure Stack HCI cluster

> [!NOTE]
> All servers must run the Arc-enabled Servers Agent version 1.40 or later to use the Arc gateway feature.

  :::image type="content" source="media/deployment-azure-arc-gateway/existing-deployment-workflow.png" alt-text="Azure Arc gateway existing deployment workflow." lightbox="./media/deployment-azure-arc-gateway/existing-deployment-workflow.png":::

1. Associate each existing server in the cluster with the Arc gateway resource by running the following:

    ```azurecli
    az connectedmachine setting update --resource-group [res-group] --subscription [subscription name] --base-provider Microsoft.HybridCompute --base-resource-type machines --base-resource-name [Arc server resource name] -settings-resource-name default --gateway-resource-id [Full Arm resourceid]
    ```

### Step 2: Update the machine to use the Arc gateway resource  

1. Update each server in the cluster to use the Arc gateway resource. Run the following command on your Arc-enabled server to set it to use the Arc gateway:

    ```azurecli
    azcmagent config set connection.type gateway
    ```

### Step 3: Await reconciliation

1. Await reconciliation. Once your servers have been updated to use the Arc gateway, some Azure Arc endpoints that were previously allowed in your proxy or firewalls won't be needed any longer. Wait one hour before you begin removing endpoints from your firewall or proxy.

Next step is to verify that the setup was successful.

## Step 4: Verify that setup succeeded

Once the deployment validation starts, connect to the first server node from your cluster and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and which ones keep using your firewall or proxy security solutions. You should find the Arc gateway sign in *c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log*.

  :::image type="content" source="media/deployment-azure-arc-gateway/arc-gateway-log-location.png" alt-text="Location of log file for Azure Arc gateway." lightbox="./media/deployment-azure-arc-gateway/arc-gateway-log-location.png":::

1. To check the Arc agent configuration and verify that it is using the gateway, connect to the Azure Stack HCI server node.
1. Run the following command: `"c:\program files\AzureConnectedMachineAgent>.\azcmagent show"`. The result should show the following values:

    :::image type="content" source="media/deployment-azure-arc-gateway/connected-machine-agent-with-arc-gateway-output.png" alt-text="Azure Arc gateway connected machine agent output window." lightbox="./media/deployment-azure-arc-gateway/connected-machine-agent-with-arc-gateway-output.png":::

    - **Agent Version** should show as `1.40` or later. <!--CHECK-->
    - **Agent Status** should show as `Connected`.
    - **Using HTTPS Proxy** is empty when Arc gateway isn't in use. It should show as `http://localhost:40343` when the Arc gateway is enabled.
    - **Upstream Proxy** always shows as empty for Azure Stack HCI as it uses the environment variables to configure the Arc agent.
    - **Upstream Proxy Bypass List** should show your bypass list.
    - **Azure Arc Proxy (arcproxy)** shows as `Stopped` when Arc gateway isn't in use and shows as `Running` when Arc gateway is enabled.

1. Verify that setup was successful by running the `"c:\program files\AzureConnectedMachineAgent>.\azcmagent check"` command. The result should show the following values:

    :::image type="content" source="media/deployment-azure-arc-gateway/check-connected-machine-agent-with-arc-gateway.png" alt-text="Azure Arc gateway connected machine agent output window." lightbox="./media/deployment-azure-arc-gateway/check-connected-machine-agent-with-arc-gateway.png":::

    - **connection.type** should show as `gateway`.

    - **Reachable** column should list `true` for all URLs.


## Troubleshooting  

You can audit Arc gateway traffic by viewing the gateway router logs.  

Follow these steps to view the logs:

1. Run the `azcmagent logs` command.

1. In the resulting .zip file, view the logs in the *C:\ProgramData\Microsoft\ArcGatewayRouter* folder.


## Next steps

Deploy workloads on your Azure Stack HCI cluster:

- [Run Azure Virtual Machines on Azure Stack HCI](../manage/create-arc-virtual-machines.mdvirtual-machines/overview).
- [Deploy Azure Kubernetes Service on Azure Stack HCI](/azure-stack/hci/kubernetes/overview).
- [Deploy Azure Virtual Desktop on Azure Stack HCI]().