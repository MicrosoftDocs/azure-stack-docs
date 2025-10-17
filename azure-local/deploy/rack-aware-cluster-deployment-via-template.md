---
title: Azure Resource Manager template deployment for Azure Local rack aware cluster (Preview)
description: Learn how to prepare and then deploy Azure Local rack aware cluster using the Azure Resource Manager template (Preview).
author: alkohli
ms.topic: how-to
ms.date: 10/16/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Deploy Azure Local rack aware cluster using Azure Resource Manager deployment template (Preview)

This article describes how to use an Azure Resource Manager (ARM) template in the Azure portal to deploy a rack aware cluster.

[!INCLUDE [important](../includes/hci-preview.md)]

> [!IMPORTANT]
> ARM template deployment of rack aware cluster is targeted for deployments-at-scale. The intended audience for this deployment is IT administrators who have experience deploying rack aware clusters. We recommend that you deploy a system via the Azure portal first, and then perform subsequent deployments via the ARM template.

## Prerequisites

- Completion of [Register your machines with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md). Make sure that:
  - All machines are running the same version of OS.
  - All the machines have the same network adapter configuration.

- Make sure to select the **create-cluster-rac-enabled** template for deployment.

## Step 1: Prepare Azure resources

Follow these steps to prepare the Azure resources you need for deployment:

[!INCLUDE [get-object-id-azure-local-resource-provider](../includes/get-object-id-azure-local-resource-provider.md)]

## Step 2: Deploy using ARM template

An ARM template is a JSON file where you define what you want to deploy to Azure. It creates and assigns all the resource permissions required for deployment.

Once all prerequisite and preparation steps are complete, you're ready to deploy using a validated ARM template and its corresponding parameters JSON file. This file contains all required values, including those generated previously.

ARM template deployment involves two modes:

- **Validate:** Confirms that all parameters are correctly configured and validates your system's readiness to deploy.
- **Deploy:** Performs the actual deployment after successful validation.

### Step 2.1: Deploy the template in Validate mode

This step ensures that all parameters are configured correctly and validates your system's readiness to deploy.

1. In the Azure portal, go to **Home** and then select **+ Create a resource**.

1. Under **Template deployment (deploy using custom templates)**, select **Create**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png" alt-text="Screenshot showing the template deployment (deploy using custom template)." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png":::

1. On the **Custom deployment** page, proceed through the tabs described in the following sections.

#### Select a template tab
  
Use the **Select a template** tab to choose the template for your deployment.
  
1. On the **Select a template** tab, under the **Start with a quickstart template or template spec** section, select the **Quickstart template** option.
  
1. From the **Quickstart template (disclaimer)** dropdown, select the **create-cluster-rac-enabled** template.
  
1. Select the **Select template** button to continue to the **Basics** tab.
  
    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/select-a-template-tab.png" alt-text="Screenshot showing template to deploy rack aware cluster." lightbox="./media/rack-aware-cluster-deployment-via-template/select-a-template-tab.png":::
  
#### Basics tab
  
Use the **Basics** tab to provide the essential information to initiate the deployment.

This section describes how to configure the **Basics** tab using the following sample rack aware cluster configuration:
  
You deploy a rack aware cluster with four machines, two in each rack:
  
- **node1** and **node2** are physically located in the same rack (**Zone1**).
- **node3** and **node4** are located in a different rack (**Zone2**).

For an example of a parameter JSON file that shows the format of various inputs, such as `ArcNodeResourceId`, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster/azuredeploy.parameters.json). For detailed descriptions of the parameters defined in this file, see [ARM template parameters reference](#arm-template-parameters-reference).

> [!IMPORTANT]
> - Ensure that all parameters in the JSON file are filled out.
> - Replace any placeholder values such as `[“”]`, with actual data. These placeholders indicate that the parameter expects an array structure.
> - If required values are missing or incorrectly formatted, the validation will fail.
  
1. On the **Basics** tab, select the required parameters from the dropdown list, or select **Edit parameters** to modify them manually.
  
    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/basics-tab.png" alt-text="Screenshot showing the Edit parameters button on the Basics tab." lightbox="./media/rack-aware-cluster-deployment-via-template/basics-tab.png":::
  
1. Configure all required parameters. Configure the following extra parameters required for rack aware cluster deployment. You can use the sample JSON snippets to deploy the cluster described in the example configuration.
    
    - **Arc node resource IDs.**
      
        ```json
        "arcNodeResourceIds": {
        "value": [
        "/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node1",
        "/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node2",
        "/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node3",
        "/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node4"
        ]
        }
        ```
  
    - **Cluster pattern and local Availability Zones.**
        Verify that the `clusterPattern` parameter is **RackAware**.
        Ensure that **node1** and **node2** are physically located in **Zone1** (same rack), and **node3** and **node4** are in **Zone2** (different rack).
  
        ```json
        "clusterPattern": {
        "value": "RackAware"
        },
        "localAvailabilityZones": {
            "value": [
            {
                "localAvailabilityZoneName": "Zone1",
                "nodes": ["node1","node2"]  
            },
            {
                "localAvailabilityZoneName": "Zone2",
                "nodes": ["node3","node4"]
            }
            ]
        },
        ```
  
    - **Cloud witness configuration.**
      rack aware cluster requires cloud witness. Enter the name of the cloud witness, which is created during the deployment process.
      
        ```json
        "witnessType": {
            "value": "Cloud"
        },
        "clusterWitnessStorageAccountName": {
            "value": "yourcloudwitness"
        },
        ```
  
    - **Network intent configuration.**
      The storage network intent must be a dedicated network intent. vlanIDs 711 and 712 are defaults and can be customized for your environment.
 
        ```json
        "networkingType": {
            "value": "switchedMultiserverDeployment"
        },
        "networkingPattern": {
            "value" : "convergedManagementCompute"
        },
        "intentList" : {
            "value": [
                {
                    "name": "ManagementCompute",
                    "trafficType": [
                        "Management",
                        "Compute"
                    ],
                    "adapter": [
                        "ethernet",
                        "ethernet 2"
                    ],
                    "overridevirtualswitchConfiguration": false,
                    "virtualswitchConfigurationoverrides": {
                        "enableIov": "",
                        "loadBalancingAlgorithm": ""
                    },
                    "overrideQosPolicy": false,
                    "qosPolicyoverrides": {
                    "priorityvalue8021Action_SMB": "",
                    "priorityvalues8021Action_Cluster": "",
                    "bandwidthPercentage_SMB": ""
                    },
                    "overrideAdapterProperty": false,
                    "adapterPropertyoverrides": {
                        "jumboPacket": "",
                        "networkDirect": "",
                        "networkDirectTechnology": ""
                    }
                },
                "name": "Storage",
                "trafficType": [
                        "Storage"
                        ],
                    "adapter": [
                        "ethernet 3",
                        "ethernet 4"
                    ],
                    "overridevirtualswitchConfiguration": false,
                    "virtualswitchConfigurationoverrides": {
                        "enableIov": "",
                        "loadBalancingAlgorithm": ""
                    },
                    "overrideQosPolicy": false,
                    "qosPolicyoverrides": {
                    "priorityvalue8021Action_SMB": "",
                    "priorityvalues8021Action_Cluster": "",
                    "bandwidthPercentage_SMB": ""
                    },
                    "overrideAdapterProperty": false,
                    "adapterPropertyoverrides": {
                        "jumboPacket": "",
                        "networkDirect": "",
                        "networkDirectTechnology": ""
                    }
                ]
        },
        "storageNetworkList": {
            "value": [
                {
                    "name": "Storage1Network",
                    "networkAdapterName": "ethernet 3",
                    "vlanId": "711"
                },
                {
                    "name": "Storage2Network",
                    "networkAdapterName": "ethernet 4",
                    "vlanId": "712"
                }
            ]
        },            
        ```
  
1. After configuring all parameters, select **Save** to save the parameters file.
  
1. Select the appropriate resource group for your environment.
  
1. Confirm that **Deployment Mode** is set to **Validate**.
  
1. Select **Review + create** to continue.
  
    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/review-and-create-button.png" alt-text="Screenshot showing Review + Create selected on Basics tab." lightbox="./media/rack-aware-cluster-deployment-via-template/review-and-create-button.png":::
  
#### Review + create tab
  
Use the **Review + create** tab to review your deployment settings and accept the legal terms before creating the resources.
  
1. On the **Review + Create** tab, review the deployment summary and legal terms.
  
1. Select **Create** to begin validation. This action creates the remaining prerequisite resources and validates the deployment. Validation takes about 10 minutes to complete.
  
    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/review-and-create-tab.png" alt-text="Screenshot showing Create selected on Review + Create tab." lightbox="./media/rack-aware-cluster-deployment-via-template/review-and-create-tab.png":::
  
1. After validation completes, continue to the **Deploy** phase to provision the full environment.
  
### Step 2.2: Deploy the template in Deploy mode

After successful validation, you're ready to proceed with the actual deployment using the validated ARM template and its corresponding parameters JSON file.

1. Once validation is complete, select **Redeploy**.

    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/deploy-template-1.png" alt-text="Screenshot showing Redeploy selected." lightbox="./media/rack-aware-cluster-deployment-via-template/deploy-template-1.png":::

1. On the **Custom deployment** screen, select **Edit parameters**. Load up the previously saved parameters and select **Save**.

1. Verify that all fields for the ARM template are filled in by the parameters JSON file.

1. Select the appropriate resource group for your environment.

1. Confirm that **Deployment Mode** is set to **Deploy**.

    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/deploy-template-2.png" alt-text="Screenshot showing deploy selected for deployment mode." lightbox="./media/rack-aware-cluster-deployment-via-template/deploy-template-2.png":::

1. Select **Review + create**.

1. Select **Create** to begin deployment. The deployment uses the existing prerequisite resources created during the [Deploy the template in Validate mode](#step-21-deploy-the-template-in-validate-mode) step.

    The Deployment screen cycles on the cluster resource during deployment.

    Once deployment initiates, there's a limited Environment Checker run, a full Environment Checker run, and cloud deployment starts.

    After a few minutes, you can monitor deployment progress in the Azure portal.

    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/deploy-template-3.png" alt-text="Screenshot showing the status of environment checker validation." lightbox="./media/rack-aware-cluster-deployment-via-template/deploy-template-3.png":::

### Monitor deployment

1. In a new browser window, navigate to the resource group for your environment. Select the cluster resource.

1. Select **Deployments**.

1. Refresh and watch the deployment progress from the first machine (also known as the seed machine and is the first machine where you deployed the cluster). Deployment takes between 2.5 and 3 hours. Several steps take 40-50 minutes or more.

1. The step in deployment that takes the longest is **Deploy Moc and ARB Stack**. This step takes 40-45 minutes.

    Once complete, the task at the top updates with status and end time.

## ARM template parameters reference

[!INCLUDE [template-parameter-table](../includes/template-parameter-table.md)]

The following table describes parameters that are specific to a rack aware cluster:

| Parameter | Description |
|--|--|
| clusterPattern | Supported cluster type for the Azure Local cluster: <br/>- **Standard**<br/>- **RackAware** |
| localAvailabilityZones | Local Availability Zone information for the Azure Local rack aware cluster. |

## Next steps

<!--Add next steps-->
