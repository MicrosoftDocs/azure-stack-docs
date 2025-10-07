---
title: Deploy Rack Aware Cluster using the Azure portal
description: Learn how to deploy a Rack Aware Cluster via the Azure portal with step-by-step guidance, including configuration, networking, and validation processes.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 10/07/2025
ms.topic: how-to
---

# Deploy Rack Aware Cluster via the Azure portal

This document describes the steps to deploy Azure Local Rack Aware Clusters using the Azure portal.

## Prerequisites

Make sure you have completed the steps in [Prepare for Rack Aware Cluster deployment](./rack-aware-cluster-deploy-prep.md).

## Deploy Rack Aware Cluster

To deploy a Rack Aware Cluster, follow the steps to [Deploy an Azure Local instance via the Azure portal](./deploy-via-portal.md). In general, the steps are similar to deploying a standard single cluster. The differences are highlighted below.

## Start the wizard and fill out the basics

The first step is [Start the wizard and fill out the basics](./deploy-via-portal.md#start-the-wizard-and-fill-out-the-basics).

1. In this step, select **Rack aware cluster** for the **Cluster options**.

1. In **+ Add machines**, select an even number of machines for the cluster. Once you add the machines, Arc extensions will automatically install on the selected machines. This operation takes several minutes. Refresh the page to view the status of the extension installation.

1. Complete the other fields and validate the selected machines as per the “Start the wizard and fill out the basics” step.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/image1.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

1. Select **Next: Configuration**.

## Specify the deployment settings

1. In this step, specify the deployment settings as per the “Specify the deployment settings” step in 6A.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/image2.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

1. Select **Next: Networking**.

## Specify network settings

1. In this step:
    1. Specify the network settings as per the [Specify network settings](./deploy-via-portal.md#specify-network-settings).
    1. Choose the only storage connectivity available option for a Rack Aware Cluster as **Network switch for storage traffic**.
    1. Choose the only networking pattern available for Rack Aware Cluster as **Group management and compute traffic**.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/image3.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

1. Select **Next: Management**.


## Specify management settings

1. In this step: 
    1. Specify the management settings as per the [Specify management settings](./deploy-via-portal.md#specify-management-settings) step.
    1. For Rack Aware Cluster, cluster witness is required. Choose **Cloud witness** and provide a name for the cloud witness.
    
    :::image type="content" source="media/rack-aware-cluster-deploy-portal/image4.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

1. Select **Next: Security**.

## Set the security level

1. In this step:
    1. Set the security level as per the [Set the security level](./deploy-via-portal.md#set-the-security-level) step.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/image5.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

1. Select **Next: Advanced**.

## Optionally change advanced settings and apply tags

1. In this step:
    1. Specify advanced settings and apply tags as per the [Optionally change advanced settings and apply tags](./deploy-via-portal.md#optionally-change-advanced-settings-and-apply-tags) step.
    1. Select the only option available for Rack Aware Cluster, which is for creating workload volumes and required infrastructure volumes (also known as Express mode).
    1. Specify the **Local availability zone** configurations. Ensure servers in the same zone are physically in the same rack, which is not validated in the deployment process in this release. It is critical to configure this correctly, otherwise, one rack failure could bring the whole cluster down.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/image6.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

1. Select **Next: Tags**. and optionally add a tag to the Azure Local
resource in Azure.

1. Select **Next: Validation**. Select **Start validation**. The validation
takes about 15 minutes to deploy one to two machines and longer for
bigger deployments. Monitor the validation progress.

Follow the “Validate and deploy the system” step in 6A.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image7.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

If the validation has errors, resolve any actionable issues, and then
select **Next: Review + create**. Review the settings that are used for
deployment and then select **Create** to deploy the system.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image8.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

The **Deployments** page then appears, which you can use to monitor the
deployment progress.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image9.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

You can monitor the deployment status just like the standard cluster.
