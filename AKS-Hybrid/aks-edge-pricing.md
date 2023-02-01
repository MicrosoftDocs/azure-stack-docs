---
title: About AKS Edge Essentials pricing
description: AKS Edge Essentials pricing details
author: rcheeran
ms.author: rcheeran
ms.topic: overview
ms.date: 01/31/2023
ms.custom: template-overview
---

# AKS Edge Essentials pricing

AKS Edge Essentials can be licensed via one of the following options:

- Azure subscription-based model
- Volume licensing model (available from April 2023)

You can [review the details of each of the approaches](aks-edge-licensing.md). This article focuses on the Azure-subscription based approach. The AKS EE subscription-based Kubernetes offering can run on Windows Pro, Windows Enterprise, Windows IoT Enterprise, or Windows Server-based devices. You can download and install AKS Edge Essentials on your existing or new hardware that will be deployed on the edge. The pricing is based on usage and requires an Azure subscription, which you can obtain for free.

The billing unit model is based on a device, which can be a physical or virtual device on which AKS Edge Essentials is installed. After you install AKS Edge Essentials on your device and connect your cluster to Azure Arc, a pay-as-you-go rate per device per month will be applied. The snapshot of usage is reported during the following month on a date thats onr day prior to the date the Azure Arc enabled Kubernetes cluster is created.  For example, if the Azure Arc enabled Kubernetes cluster is created on March 6th with AKS Edge Essentials, the number of devices included in this cluster will be captured and submitted for billing on April 5th. If you've one device in your cluster when the usage is posted on April 5th, you'll be billed for one device usage for this Azure Arc enabled Kubernetes cluster resource by AKS Edge Essentials.

## Pricing details

AKS Edge Essentials pricing is based on the US currency list pricing with no discounts applied.
For detailed pricing information, see the AKS Edge Essentials pricing details page. The list price for AKS Edge Essentials includes the following components:

- A Microsoft-managed, lightweight, CNCF-conformant K8S and K3S distribution.
- License to use one Microsoft-managed Linux (CBL-Mariner) VM container host for use with Linux containers on AKS Edge Essentials.
- License to use one Microsoft-managed Windows VM container host for use with Windows containers on AKS Edge Essentials. Pricing does'nt include a Windows VM container host license.
- Azure Arc-enabled Kubernetes at no extra charge and the following items:
  - Inventory, grouping, and tagging in Azure.
  - Deployment of apps and configurations with GitOps: Included at no extra charge (normally, the initial six vCPUs are free, and then afterwards, the charge is per vCPU per month).
  - Azure Policy for Kubernetes: Included at no extra charge (normally, the charge per vCPU per cluster for each month).

## Next steps

- Read about [licensing options](./aks-edge-licensing.md)
- Contact product team by emailing projecthaven@microsoft.com
