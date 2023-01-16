---
title: Introduction to Azure Stack Hub networking 
description: Learn about Azure Stack Hub networking
author: sethmanheim

ms.topic: conceptual
ms.date: 2/1/2021
ms.author: sethm
ms.reviewer: cedward
ms.lastreviewed: 12/7/2022

# Intent: As an Azure Stack user, I want an introduction to networking in Azure Stack so I can get started.
# Keyword: azure stack networking 

---

# Introduction to Azure Stack Hub networking

Azure Stack Hub provides different kinds of networking capabilities that can be used together or separately:

- **Connectivity between Azure Stack Hub resources**  
    Connect Azure resources together in a secure and private virtual network in the cloud.
- **Internet connectivity**  
    Communicate to and from Azure Stack Hub resources over the internet.
- **On-premises connectivity**  
    Connect an on-premises network to Azure Stack Hub resources through a virtual private network (VPN) over the internet, or through a dedicated connection to Azure Stack Hub. 
    > [!IMPORTANT]
    > You must create a VPN or public IP connection in order to access on-premises resources.
- **Load balancing and traffic direction**  
    Load balance traffic to servers in the same location and direct traffic to servers in different locations.
- **Security**  
    Filter network traffic between network subnets or individual VMs.
- **Routing**  
    Use default routing or fully control routing between your Azure Stack Hub and on-premises resources.
- **Manageability**  
    Monitor and manage your Azure Stack Hub networking resources.
- **Deployment and configuration tools**  
    Use a web-based portal or cross-platform command-line tools to deploy and configure network resources.

## Azure Stack Hub IPv6 support

Azure Stack Hub does not offer support for IPv6 and there are no roadmap items to provide support.

## Next steps

* [Considerations for Azure Stack Hub networking](azure-stack-network-differences.md)