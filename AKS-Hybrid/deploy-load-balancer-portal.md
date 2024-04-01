---
title: Create a MetalLB load balancer using Azure Portal
description: Learn how to create a MetalLB load balancer on your Kubernetes cluster using an Arc extension.
ms.topic: how-to
ms.date: 02/01/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: rbaziwane
ms.lastreviewed: 02/01/2024

---

# Create a MetalLB load balancer using Azure Arc

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

The main purpose of a load balancer is to distribute traffic across multiple nodes in a Kubernetes cluster. This can help prevent downtime and improve overall performance of applications. AKS enabled by Azure Arc supports creating [MetalLB](https://metallb.universe.tf/) load balancer instance on your Kubernetes cluster using the Arc Networking extension.

## Prerequisites

- A Kubernetes cluster with at least one Linux node. You can create a Kubernetes cluster on AKS using the [Azure CLI](aks-create-clusters-cli.md) or the Azure portal.
- Make sure you have enough IP addresses for the load balancer. Ensure that the IP addresses reserved for the load balancer do not conflict with the IP addresses in Arc VM logical networks and control plane IPs. For more information about IP address planning and networking in Kubernetes, see [Networking requirements for AKS on Azure Stack HCI 23H2](aks-hci-network-system-requirements.md).

## Deploy MetalLB load balancer using Azure Arc extension

> [!WARNING]
> IP address conflict checking is not currently supported. It's recommended that you perform this check when you create load balancers.

Once you successfully create your Kubernetes cluster, navigate to the **Networking** blade in the Azure portal and select **Install**:

:::image type="content" source="media/deploy-load-balancer-portal/install-extension.png" alt-text="Screenshot showing extension install screen on portal." lightbox="media/deploy-load-balancer-portal/install-extension.png":::

After the extension is successfully installed, you can create a load balancer service. Select **Add** and fill in the load balancer name and its IP range. The **Service Selector** field is optional. Then select **OK**.

:::image type="content" source="media/deploy-load-balancer-portal/create-load-balancer.png" alt-text="Screenshot showing create load balancer on portal." lightbox="media/deploy-load-balancer-portal/create-load-balancer.png":::

- The IP range should be set to available IPs depending on your environment. The IP range should be in CIDR notation; for example, **192.168.50.51/28** or **192.168.50.1-192.168.50.100**. Multiple IP ranges must be separated by commas.
- The advertise mode can be **ARP**, **BGP**, or **Both**. If using **BGP** or **Both**, BGP peers must be configured.
- **Service Selector** limits the set of services that can get an IP from the load balancer. The default option (null or empty string) means that the load balancer applies for all services. **Selector** should be in a format of a list of key-value pairs such as **a:b,c:d**, where the kv pairs are separated by a comma.

Once the load balancer is successfully created, it's shown in the list as follows. **Provisioning state** shows the operation result:

:::image type="content" source="media/deploy-load-balancer-portal/load-balancer-created.png" alt-text="Screenshot showing provisioning state on portal." lightbox="media/deploy-load-balancer-portal/load-balancer-created.png":::

### Clean up resources

To clean up resources, do the following:

- When one of the load balancers is no longer needed, select the start of the row for the load balancer and select **Delete**. Then select **Yes**.
- When the load balancer service is no longer needed, delete all existing load balancers and then select **Uninstall**. Select **Yes** to uninstall the extension.

## Next steps

- [Review AKS on Azure Stack HCI 23H2 networking concepts](aks-hci-network-system-requirements.md)
