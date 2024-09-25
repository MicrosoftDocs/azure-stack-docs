--- 
title: Connect the Azure Stack HCI nodes to Arc gateway (preview)
description: Learn how to connect the Azure Stack HCI nodes to Arc gateway for version version 2408 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 09/25/2024
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Connect the Azure Stack HCI nodes to Arc gateway (preview)

Applies to: Azure Stack HCI, version 23H2

This article details how to connect Azure Stack HCI, version 23H2 nodes to the Arc gateway for version 2408.

After creating the Arc gateway resource in your subscription, you have two options to enable the new version 2408 Arc gateway preview features.  

[!INCLUDE [important](../../includes/hci-preview.md)]

## Option 1: Configure manually

### Step 1: Manually configure the proxy and bypass list on each HCI node 

If you require to configure the proxy before starting the Arc registration process you should follow the instructions detailed in this article: Configure proxy settings for Azure Stack HCI, version 23H2 - Azure Stack HCI | Microsoft Learn. Ensure that you configure the proxy and the bypass list across all your HCI cluster nodes. 

### Step 2: Get your Arc gateway resource Id  

You will need the proxy and the ArcGatewayID from Azure to run the HCI nodes registration script. To get the ArcGatewayID you can run the az command described below from any computer. Do not run this command from HCI nodes.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

### Step 3: Register new Azure Stack HCI 2408 nodes in Arc using the Arc gateway ID and the proxy server  

For the HCI 2408 Arc gateway limited public preview you will need to invoke the initialization script by passing the ArcGatewayID and the Proxy server parameters. Here is an example of how you should change the Invoke-AzStackHciArcInitialization parameters on the initialization script.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

### Step 4: Start the Azure Stack HCI cloud deployment

Once the HCI nodes are registered in Azure Arc and all the extensions are installed, you can start the HCI deployment from the Azure Portal or using ARM templates documented here: 

- [Deploy an Azure Stack HCI system using the Azure portal]().

- [Azure Resource Manager template deployment for Azure Stack HCI, version 23H2](). 

 
### Step 5: Verify that the setup succeeded

Once the deployment validation starts, you can connect to the first HCI node from your cluster and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and which ones keep using your firewall or proxy security solutions. You should find the Arc gateway log on “c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log”

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

To check the Arc agent configuration and verify that it is using the gateway, run the following command: “c:\program files\AzureConnectedMachineAgent>.\azcmagent show”. The result should show the following values:

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

“Agent version” is 1.45 of above 

 “Agent Status” should show as “Connected” 

“Using HTTPS Proxy”  will be empty when Arc gateway is not in use. It should show as “http://localhost:40343” when the Arc gateway is enabled. 

 “Upstream Proxy” will show your enterprise proxy server and port 

“Azure Arc Proxy” It will show as stopped when Arc gateway is not in use. Running when the Arc gateway is enabled. 

Additionally, to verify that the setup was done successfully, you can also run the following command: “c:\program files\AzureConnectedMachineAgent>.\azcmagent check”. The response should indicate that the connection.type is set to gateway, and the “Reachable” column should indicate “true” for all URLs

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

You can also audit your Gateway’s traffic by viewing the Gateway Router’s Logs.  

View Gateway Router Logs on Windows  

Run azcmagent logs in PowerShell 

In the resulting .zip file, the logs are located in the C:\ProgramData\Microsoft\ArcGatewayRouter folder.

## Option 2: Configure Arc gateway, proxy, and proxy bypass list during Arc registration  

A new available feature in HCI 2408 is the option to simplify the proxy configuration experience. With this new method, you don’t need to configure the proxy across WinInet, WinHttp and Environment Variables manually like with the previous option.

### Step 1: Get your Arc gateway resource Id  

You will need the proxy and the ArcGatewayID from Azure to run the HCI nodes registration script. To get the ArcGatewayID you can run the az command described above. Do not run this command from HCI nodes.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

### Step 2: Register new Azure Stack HCI 2408 nodes in Arc using the Arc gateway ID, proxy server and proxy bypass list as parameters  

With HCI 2408 Arc gateway limited public preview you can directly invoke the initialization script by passing the ArcGatewayID, Proxy server and Proxy bypass list parameters. Here is an example of how you should change the Invoke-AzStackHciArcInitialization parameters on the initialization script. Once the registration is completed, the HCI nodes will be registered in Arc and using the Arc gateway. 

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

### Step 3: Verify that the setup succeeded

Once the deployment validation starts, you can connect to the first HCI node from your cluster and open the Arc gateway log to monitor which endpoints are being redirected to the Arc gateway and  which ones keep using your firewall or proxy security solutions. You should find the Arc gateway log on “c:\programdata\AzureConnectedMAchineAgent\Log\arcproxy.log”.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

To check the Arc agent configuration and verify that it is using the gateway, run the following command: “c:\program files\AzureConnectedMachineAgent>.\azcmagent show”. The result should show the following values.

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

“Agent version” is 1.45 of above 

 “Agent Status” should show as “Connected” 

“Using HTTPS Proxy”  will be empty when Arc gateway is not in use. It should show as “http://localhost:40343” when the Arc gateway is enabled. 

 “Upstream Proxy” will show your enterprise proxy server and port 

“Azure Arc Proxy” It will show as stopped when Arc gateway is not in use. Running when the Arc gateway is enabled. 

Additionally, to verify that the setup was done successfully, you can also run the following command: “c:\program files\AzureConnectedMachineAgent>.\azcmagent check”. The response should indicate that the connection.type is set to gateway, and the “Reachable” column should indicate “true” for all URLs 

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

:::image type="content" source="./media/deployment-connect-nodes-to-arc-gateway/.png" alt-text="Diagram of Azure Arc gateway version 2408 components." lightbox="./media/deployment-connect-nodes-to-arc-gateway/.png":::

You can also audit your Gateway’s traffic by viewing the Gateway Router’s Logs.  

View Gateway Router Logs on Windows  

Run azcmagent logs in PowerShell 

In the resulting .zip file, the logs are located in the C:\ProgramData\Microsoft\ArcGatewayRouter folder 



## Next steps

- [Enable the Arc gateway for new Azure Stack HCI deployments](deployment-azure-arc-gateway-new-cluster.md).