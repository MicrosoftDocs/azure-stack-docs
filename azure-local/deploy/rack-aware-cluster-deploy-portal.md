---
title: Deploy Rack Aware Cluster using the Azure portal
description: Learn how to deploy a Rack Aware Cluster via the Azure portal with step-by-step guidance, including configuration, networking, and validation processes.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 10/03/2025
ms.topic: how-to
---

# Deploy Rack Aware Cluster via the Azure portal

After you have completed preparation in the previous chapter, follow
[<u>Deploy an Azure Local instance using the Azure portal - Azure Local
\| Microsoft
Learn</u>](https://learn.microsoft.com/en-us/azure/azure-local/deploy/deploy-via-portal)

The first step is “Start the wizard and fill out the basics” in 6A.

In this step, select **Rack aware cluster** for the **Cluster options**
field.

In **+ Add machines**, select an even number of machines for the
cluster. Once you add the machines, Arc extensions will automatically
install on the selected machines. This operation takes several minutes.
Refresh the page to view the status of the extension installation.

Complete the other fields and validate the selected machines as per the
“Start the wizard and fill out the basics” step in 6A.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image1.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

Select **Next: Configuration** and follow the “Specify the deployment
settings” step in 6A.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image2.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

Select **Next: Networking** and follow the “Specify network settings”
step in 6A.

In this step, the only storage connectivity option for a Rack Aware
Cluster is **Network switch for storage traffic**.

The only networking pattern available for Rack Aware Cluster is **Group
management and compute traffic**.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image3.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

Select **Next: Management** and follow the “Specify management settings”
step in 6A. For Rack Aware Cluster, cluster witness is required.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image4.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

Select **Next: Security** and follow the “Set the security level” step
in 6A.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image5.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

Select **Next: Advanced** and follow the “Optionally change advanced
settings and apply tags” step. For Rack Aware Cluster, the only option
is for creating workload volumes and required infrastructure volumes
(also known as Express mode).

Specify the **Local availability zone** configurations. Please ensure
servers in the same zone are physically in the same rack, which is not
validated in the deployment process in this release. It is critical to
configure this correctly, otherwise, one rack failure could bring the
whole cluster down.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image6.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

Select **Next: Tags** and optionally add a tag to the Azure Local
resource in Azure.

Select **Next: Validation**. Select **Start validation**. The validation
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

  
<span id="_Toc208936595" class="anchor"></span>Deploy Rack Aware Cluster
via ARM template

You finished the steps in “Prepare for Rack Aware Cluster deployment”.

Follow [<u>Azure Resource Manager template deployment for Azure Local,
version 23H2 - Azure Local \| Microsoft
Learn</u>](https://learn.microsoft.com/en-us/azure/azure-local/deploy/deployment-azure-resource-manager-template)
to deploy a cluster.

Starting from Step 2 in 6B, you need to select a different quickstart
template for Rack Aware Cluster.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image10.png" alt-text="A screenshot of a software update AI-generated content may be incorrect.":::

In this example, there are two machines in each rack, and a total of 4
machines in this cluster. Like a standard single rack cluster, first get
resource IDs for the Arc nodes for the cluster like the following:

"arcNodeResourceIds": {

"value": \[

“/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node1",

"/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node2",

"/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node3",

"/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node4"

\]

}

Here are the additional parameters you need to put in the template.

1.  Specify the clusterPattern as “RackAware” and do the
    localAvailabilityZone configurations, zone name and nodes list.
    Please ensure node1 and node2 in ZoneA are physically in the same
    rack, and node3 and node4 in ZoneB are in a different rack.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image11.png" alt-text="A screenshot of a computer program AI-generated content may be incorrect.":::

2.  Cloud Witness is required for Rack Aware Cluster, enter the name of
    the cloudwitness, which will be created during the deployment
    process.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image12.png" alt-text="A screen shot of a computer AI-generated content may be incorrect.":::

3.  Network intent configuration example, please note the storage
    network intent needs to be a dedicated network intent. vlanID 711
    and 712 are the default numbers you can customize for your
    environment.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image13.png" alt-text="A screenshot of a computer program AI-generated content may be incorrect.":::

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image14.png" alt-text="A screenshot of a computer program AI-generated content may be incorrect.":::

After the required parameters are all configured, you finished the
number 7 in 5B section of Deploy via ARM template [<u>Azure Resource
Manager template deployment for Azure Local, version 23H2 - Azure Local
\| Microsoft
Learn</u>](https://learn.microsoft.com/en-us/azure/azure-local/deploy/deployment-azure-resource-manager-template)
Step 2, you can follow number 8 and the rest of deployment to complete
the deployment.

:::image type="content" source="media/rack-aware-cluster-deploy-portal/image15.png" alt-text="A white background with black text AI-generated content may be incorrect.":::

If you encounter some errors in the validation phase, you can go back by
clicking “Redeploy” to edit parameters.

You can monitor the deployment status just like the standard cluster.
