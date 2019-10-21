---
title: How to set up a multiple site-to-site VPN tunnel | Microsoft Docs
description: Learn how to How to set up a multiple site-to-site VPN tunnel.
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: how-to
ms.date: 09/19/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 09/19/2019

# keywords:  X
# Intent: As an Azure Stack Operator, I want < what? > so that < why? >
---

# How to set up a multiple site-to-site VPN tunnel

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

This article shows you how to use an Azure Stack Resource Manager template to deploy the solution. The solution creates multiple resource groups with associated virtual networks and how to connect these systems.

## Create multiple VPN tunnels

![](./media/azure-stack-network-howto-vpn-tunnel/image1.png)

-  Deploy a 3 tier application, Web, App, and DB.

-  Deploy the first two templates on separate Azure Stack instances

-  'WebTier' will be deployed on PPE1 and 'AppTier' will be deployed on PPE2

-  Connect the WebTier and AppTier with an IKE tunnel

-  Connect the AppTier to an on-premises system that you will call the DBTier

## Steps to deploy multiple VPNs

This is a multiple step process. For this solution, you're going to be using the Azure Stack portal. However, you can use PowerShell, Azure CLI, or other infrastructure-as-code tool chains to capture the outputs and use then as inputs.

![alt text](./media/azure-stack-network-howto-vpn-tunnel/image2.png)

## Walkthrough

### Deploy 'WebTier' to Azure Stack instances PPE1

1.  Open the portal and create a resource.

2.  Select Template Deployment.

    ![](./media/azure-stack-network-howto-vpn-tunnel/image3.png)

3.  Copy and paste the content of the azuredeploy.json into the template window. You will see the resources contained within the template, select **save**.

    ![](./media/azure-stack-network-howto-vpn-tunnel/image4.png)

4.  Enter a Resource Group name and ensure the parameters are correct.

    > [Note]  
    > The WebTier address space will be **10.10.0.0/16** and you can see resource group location is **PPE1**

    ![](./media/azure-stack-network-howto-vpn-tunnel/image5.png)

### Deploy app tier to Azure Stack instances west us2

Same process as the 'WebTier' but different parameters as shown here:

> [!Note]  
> The AppTier address space will be **10.20.0.0/16** and you can see resource group location is **WestUS2**.

![](./media/azure-stack-network-howto-vpn-tunnel/image6.png)

### Review the deployments for web tier and app tier and capture outputs

1.  Review the deployment completed successfully. Select Outputs.

    ![](./media/azure-stack-network-howto-vpn-tunnel/image7.png)

3.  Copy the first 4 values into your Notepad app.

    ![](./media/azure-stack-network-howto-vpn-tunnel/image8.png)

5.  Repeat for 'AppTier' deployment.

![](./media/azure-stack-network-howto-vpn-tunnel/image9.png)

![](./media/azure-stack-network-howto-vpn-tunnel/image10.png)

### Create tunnel from web tier to app tier

1.  Create a resource.

2.  Select template deployment.

3.  Paste the contents from **azuredeploy.tunnel.ike.json**.

4.  Select edit parameters.

![](./media/azure-stack-network-howto-vpn-tunnel/image11.png)

### Create tunnel from app tier to web tier

1.  Create a resource.

2.  Select template deployment.

3.  Paste the contents from **azuredeploy.tunnel.ike.json**.

4.  Select edit parameters.

![](./media/azure-stack-network-howto-vpn-tunnel/image12.png)

### Viewing tunnel deployment

If you view the output from the custom script extension, you can see the tunnel being created and it should show the status. You will generally see one showing **connecting** waiting for the other side to be ready and the other side will show **connected** once deployed.

![](./media/azure-stack-network-howto-vpn-tunnel/image13.png)

![](./media/azure-stack-network-howto-vpn-tunnel/image14.png)

![](./media/azure-stack-network-howto-vpn-tunnel/image15.png)

### Troubleshooting on the RRAS VM

1.  Change the RDP rule from **Deny** to **Allow**.

2.  RDP to the system with the credentials you set during deployment.

3.  Open PowerShell with an elevated prompt, and run `get-VPNS2SInterface`.

    ![](./media/azure-stack-network-howto-vpn-tunnel/image16.png)

5.  Use the **RemoteAccess** cmdlets to manage the system.

    ![](./media/azure-stack-network-howto-vpn-tunnel/image17.png)

### Install RRAS on a on premises VM DB tier

1.  This is a Windows 2016 image.

2.  If you copy the Add-Site2SiteIKE.ps1 script and run it locally, it will install the WindowsFeature and RemoteAccess.

    > [!Note]
    > Depending on your environment you may need to reboot your system.

For reference here is the on-premises machine network configuration.

![](./media/azure-stack-network-howto-vpn-tunnel/image18.png)

3.  Run the script adding the `Output` parameters you captured from the AppTier template deployment.

    ![](./media/azure-stack-network-howto-vpn-tunnel/image19.png)

5.  The tunnel is now configured and waiting for the AppTier connection.

### Configure app tier to DB tier

1.  Create a resource.

2.  Select template deployment.

3.  Paste the contents from **azuredeploy.tunnel.ike.json**.

4.  Select edit parameters.

    ![](./media/azure-stack-network-howto-vpn-tunnel/image20.png)

6.  You can see you have the AppTier Selected and the remote internal network 10.99.0.1.

### Confirm tunnel between app tier and DB tier

1.  To check the tunnel without logging into the VM you can run a custom script extension.

2.  Go to the RRAS vm, AppTier in this case.

3.  Select extensions and run custom script extension.

4.  Browse to the scripts directory and select **Get-VPNS2SInterfaceStatus.ps1**.

    ![](./media/azure-stack-network-howto-vpn-tunnel/image21.png)

6.  If you enable RDP and sign in and run get-vpns2sinterface, you can see the tunnel is connected.

    **DBTier**

    ![](./media/azure-stack-network-howto-vpn-tunnel/image22.png)

    **AppTier**

    ![](./media/azure-stack-network-howto-vpn-tunnel/image23.png)

    > [!Note]  
    > You can test RDP both ways.

    > [!Note]  
    > To implement this solution on-premises you will need to deploy routes to the Azure Stack remote network into you switching infrastructure or at a minimum on specific VMs

### Deploying a GRE tunnel

For this template, this walkthrough has used the IKE template. However, you can also deploy a GRE tunnel. This tunnel offers greater throughput.

The process is the almost identical. However when you deploy the tunnel template onto the existing infrastructure, you need to use the outputs from the other system for the first three inputs. You will need to know the **LOCALTUNNELGATEWAY** for the resource group you are deploying into rather than the resource group you are trying to connect to.

![](./media/azure-stack-network-howto-vpn-tunnel/image24.png)

## Next steps

[Differences and considerations for Azure Stack networking](azure-stack-network-differences.md)  
