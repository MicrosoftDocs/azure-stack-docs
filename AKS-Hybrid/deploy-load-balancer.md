---
title: Deploy a load balancer in AKS Arc (preview)
description: Learn how to deploy a load balancer in AKS enabled by Arc.
ms.topic: how-to
ms.date: 12/13/2023
author: sethmanheim
ms.author: sethm 
ms.reviewer: rbaziwane
ms.lastreviewed: 12/12/2023

---

# Deploy a load balancer in AKS Arc (preview)

The main purpose of a load balancer is to distribute traffic across multiple nodes in a Kubernetes cluster. This can help prevent downtime and improve overall performance of applications.

AKS Arc supports three options you can use to deploy a load balancer for a Kubernetes cluster:

- Deploy a load balancer as a virtual machine.
- Deploy a load balancer using Azure Arc extensions.
- Bring your own load balancer.

## Prerequisites

- Make sure you have enough virtual IP addresses for the load balancer during the virtual network configuration step.
- Make sure you have enough memory and storage to create a new virtual machine and have virtual IP addresses to assign to application services.

> [!IMPORTANT]
> If you want to change from using your own custom load balancer to using either the standard or Arc extension load balancer options, you must redeploy a new Kubernetes cluster with the new load balancer option. If you run an upgrade, the load balancer option you defined during cluster creation remains the same after the upgrade is completed.

## Deploy a load balancer as a virtual machine

> [!WARNING]
> The standard HAProxy load balancer VM option for AKS Arc will be deprecated at the time of general availability (GA) of AKS provisioned clusters from Azure.

This option deploys a virtual machine running **HAProxy + KeepAlive** to provide load balancing services for your Kubernetes cluster.

1. To deploy a load balancer, use the flag `–load-balancer-count` to provision a new cluster with the number of load balancers required, as shown in the following example:

   ```azurecli
   az akshybrid create -n <cluster name> -g <resource group> --custom-location <custom location Id> --vnet-ids <vnet ids> --generate-ssh-keys --load-balancer-count <count>
   ```

1. Confirm that you created your Kubernetes cluster with the correct number of load balancer VMs and that services are reachable.

## Deploy a load balancer using Azure Arc extension

This option assumes you want to leverage Arc extensions to deploy MetalLB as a load balancer for your Kubernetes cluster. In this case, your cluster is created without a load balancer. Then, go to the Azure portal and install MetalLB.

To deploy a load balancer using Azure Arc extensions, set the `–load-balancer-count` flag to `0` during cluster creation:

1. Create a Kubernetes cluster and set `–load-balancer-count` to `0`:

   ```azurecli
   az akshybrid create -n <cluster name> -g <resource group> --custom-location <custom location Id> --vnet-ids <vnet ids> --generate-ssh-keys --load-balancer-count 0
   ```

1. After your Kubernetes cluster is successfully created, navigate to the **Networking** blade in the Azure portal and select **Install** as shown in this image:

   :::image type="content" source="media/deploy-load-balancer/install-extension.png" alt-text="Screenshot showing extension install screen on portal." lightbox="media/deploy-load-balancer/install-extension.png":::

## Bring your own load balancer

This option assumes you want to use a custom load balancer for your Kubernetes cluster. In this case, your cluster is deployed without a load balancer.

> [!WARNING]
> If you choose to deploy your own load balancer, the Kubernetes cluster is unreachable after installation. If you deploy any services with **type=LoadBalancer**, the services are also unreachable until you configure your load balancer.

1. Create a Kubernetes cluster and set `load-balancer-count` to `0`:

   ```azurecli
   az akshybrid create -n <cluster name> -g <resource group> --custom-location <custom location Id> --vnet-ids <vnet ids> --generate-ssh-keys --load-balancer-count 0
   ```

1. Manually deploy or configure your custom load balancer.

## Next steps

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
- [What's new in AKS on Azure Stack HCI](aks-preview-overview.md)
