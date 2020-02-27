---
title: Deployment network traffic 
titleSuffix: Azure Stack Hub
description: Learn about network traffic flow during Azure Stack Hub deployment.
author: IngridAtMicrosoft
ms.topic: article
ms.date: 12/05/2019
ms.author: inhenkel
ms.reviewer: wamota
ms.lastreviewed: 12/05/2019

# Intent: As an Azure Stack Hub operator, I want to learn about network traffic flow during Azure Stack Hub deployment.
# Keyword: network traffic azure stack hub

---


# Deployment network traffic

Understanding network traffic during Azure Stack Hub deployment will help make the deployment successful. This article walks you through the network traffic flow during the deployment process so you know what to expect.

This illustration shows all the components and connections involved in the deployment process:

![Azure Stack Hub deployment network topology](media/deployment-networking/figure1.png)

> [!NOTE]
> This article describes the requirements for a connected deployment. To learn about other deployment methods, see [Azure Stack Hub deployment connection models](azure-stack-connection-models.md).

## The Deployment VM

The Azure Stack Hub solution includes a group of servers that are used to host Azure Stack Hub components and an extra server called the Hardware Lifecycle Host (HLH). This server is used to deploy and manage the lifecycle of your solution and hosts the Deployment VM (DVM) during deployment.

Azure Stack Hub solution providers may provision additional management VMs. Confirm with the solution provider before making any changes to management VMs from a solution provider.

## Deployment requirements

Before deployment starts, there are some minimum requirements that can be validated by your OEM to ensure deployment completes successfully:

- [Certificates](azure-stack-pki-certs.md).
- [Azure subscription](azure-stack-validate-registration.md). You may need to check your subscription.
- Internet access.
- DNS.
- NTP.

> [!NOTE]
> This article focuses on the last three requirements. For more information on the first two, see the links above.

## About deployment network traffic

The DVM is configured with an IP from the BMC network and requires network access to the internet. Although not all of the BMC network components require external routing or access to the internet, some OEM-specific components using IPs from this network might also require it.

During deployment, the DVM authenticates against Azure Active Directory (Azure AD) using an Azure account from your subscription. In order to do so, the DVM requires internet access to a list of [specific ports and URLs](azure-stack-integrate-endpoints.md). The DVM will utilize a DNS server to forward DNS requests made by internal components to external URLs. The internal DNS forwards these requests to the DNS forwarder address that you provide to the OEM before deployment. The same is true for the NTP server: a reliable Time Server is required to maintain consistency and time synchronization for all Azure Stack Hub components.

The internet access required by the DVM during deployment is outbound only, no inbound calls are made during deployment. Keep in mind that it uses its IP as source and that Azure Stack Hub doesn't support proxy configurations. Therefore, if necessary, you need to provide a transparent proxy or NAT to access the internet. During deployment, some internal components will start accessing the internet through the external network using public VIPs. After deployment completes, all communication between Azure and Azure Stack Hub is made through the external network using public VIPs.

Network configurations on Azure Stack Hub switches contain access control lists (ACLs) that restrict traffic between certain network sources and destinations. The DVM is the only component with unrestricted access; even the HLH is restricted. You can ask your OEM about customization options to ease management and access from your networks. Because of these ACLs, it's important to avoid changing the DNS and NTP server addresses at deployment time. If you do so, you need to reconfigure all of the switches for the solution.

After deployment is completed, the provided DNS and NTP server addresses will continue to be used by the system's components through the SDN using the external network. For example, if you check DNS requests after deployment is completed, the source will change from the DVM IP to a public VIP.

## Next steps

[Validate Azure registration](azure-stack-validate-registration.md)
