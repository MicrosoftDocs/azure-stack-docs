---
title: Deploy an AI-based footfall detection solution using Azure and Azure Stack
description: Learn how to deploy a footfall detection solution using Azure and Azure Stack. This solution is used for analyzing visitor traffic in retail stores.
author: BryanLa
ms.service: azure-stack
ms.topic: article
ms.date: 10/31/2019
ms.author: bryanla
ms.reviewer: anajod
ms.lastreviewed: 10/31/2019
---

# Deploy an AI-based footfall detection solution using Azure and Azure Stack

This article describes how to deploy a solution that generates insights from real world actions by using Azure, Azure Stack, and the Custom Vision AI Dev Kit.

In this solution, you learn how to:

> [!div class="checklist"]
> - Deploy Cloud Native Application Bundles (CNAB) at the edge. 
> - Deploy an application that spans cloud boundaries.
> - Use the Custom Vision AI Dev Kit for inference at the edge.

> [!Tip]  
> ![hybrid-pillars.png](./media/solution-deployment-guide-cross-cloud-scaling/hybrid-pillars.png)  
> Microsoft Azure Stack is an extension of Azure. Azure Stack brings the agility and innovation of cloud computing to your on-premises environment, enabling the only hybrid cloud that allows you to build and deploy hybrid apps anywhere.  
> 
> The article [Design Considerations for Hybrid Applications](overview-app-design-considerations.md) reviews pillars of software quality (placement, scalability, availability, resiliency, manageability, and security) for designing, deploying, and operating hybrid applications. The design considerations assist in optimizing hybrid app design, minimizing challenges in production environments.

## Prerequisites 

Before getting started with this deployment guide, make sure you:

- Review the [Footfall detection solution overview](solution-overview-retail-footfall-detection.md) 
- Obtain user access to an Azure Stack Development Kit (ASDK) or Azure Stack Integrated System instance, with:
  - The [Azure App Service on Azure Stack resource provider](../operator/azure-stack-app-service-overview.md) installed. You will need operator access to your Azure Stack instance, or work with your administrator to install.
  - A subscription to an offer that provides App Service and Storage quota. You will need operator access to create an offer.
- Obtain access to an Azure subscription
  - If you don't have an Azure subscription, sign up for a [free trial account](https://azure.microsoft.com/free/) before you begin.
- Create two service principals in your directory:
  - One configured for use with Azure resources, with access at the Azure subscription scope. 
  - One configured for use with Azure Stack resources, with access at the Azure Stack subscription scope. 
  - To learn more about creating service principals and authorizing access, see [Use an app identity to access resources](../operator/azure-stack-create-service-principals.md). If you prefer to use Azure CLI, see [Create an Azure service principal with Azure CLI](https://docs.microsoft.com/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest).
- Deploy Azure Cognitive Services in Azure, or Azure Stack.
  - First, [learn more about Cognitive Services](https://azure.microsoft.com/services/cognitive-services/).
  - Then visit [Deploy Azure Cognitive Services to Azure Stack](../user/azure-stack-solution-template-cognitive-services.md) to deploy Cognitive Services on Azure Stack. You’ll need to sign up for a private preview.
- Clone or download an unconfigured Azure Custom Vision AI Dev Kit. For details, see the [Vision AI DevKit](https://azure.github.io/Vision-AI-DevKit-Pages/).
- Sign up for a Power BI account.
- Install the following development resources:
  - [Azure CLI 2.0](../user/azure-stack-version-profiles-azurecli2.md)
  - [Docker CE](https://hub.docker.com/search/?type=edition&offering=community)
  - [Porter](https://porter.sh/).
  - [Visual Studio Code](https://code.visualstudio.com/)
  - [Azure IoT Tools for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools)
  - [Python extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
  - [Python](https://www.python.org/)

## Deploy the hybrid cloud application

First you use the Porter CLI to generate a credential set, then deploy the cloud application. Porter will generate a set of credentials that will automate deployment of the application. 

1. Before starting, verify that you have the following items:

  - The service principal for accessing Azure resources, including the service principal ID, key, and tenant DNS.
  - The subscription ID for your Azure subscription.
  - The service principal for accessing Azure Stack resources, including the service principal ID, key, and tenant DNS.
  - The subscription ID for your Azure Stack subscription.
  - Face API Endpoint
  - Face API Key

1. Clone or download the solution sample code from https://github.com/azure-samples/azure-intelligent-edge-patterns. 
1. Run the Porter credential generation process and follow the prompts:

   ```
   porter creds generate --tag intelligentedge/footfall-cloud-deployment:0.1.0
   ```

1. Porter also requires a set of unsecure parameters to run. Create a text file and enter the following name/value pairs. Ask your Azure Stack administrator if you need assistance with any of the required values.

   >[!NOTE] 
   > The `resource suffix` value is used to ensure that your deployment’s resources have unique names across Azure. It must be a unique string of letters and numbers, no longer than 8 characters.

    ```
    azure_stack_tenant_arm="Your Azure Stack tenant endpoint"
    azure_stack_storage_suffix="Your Azure Stack storage suffix"
    azure_stack_keyvault_suffix="Your Azure Stack keyVault suffix"
    resource_suffix="A unique string to identify your deployment"
    azure_location="A valid Azure region"
    azure_stack_location="Your Azure Stack location identifier"
    powerbi_display_name="Your first and last name"
    powerbi_principal_name="Your Power BI account email address"
    ```
   Save the text file and make a note of its path.

1. You’re now ready to deploy the hybrid cloud application using Porter. Run the deployment command and watch as resources are deployed to Azure and Azure Stack:

    ```
    porter install footfall-cloud –tag intelligentedge/footfall-cloud-deployment:0.1.0 –creds footfall-cloud-deployment –param-file "path-to-cloud-parameters-file.txt"
    ```

1. Once deployment is complete, make note of the camera’s connection string, image storage account connection string, and the resource group names.

## Prepare the Custom Vision AI Dev Kit

Set up the Custom Vision AI Dev Kit as shown in the [Vision AI DevKit quick start](https://azure.github.io/Vision-AI-DevKit-Pages/docs/quick_start/). You also set up and test your camera, using the connection string provided in the previous step.

## Deploy the camera application

Use the Porter CLI to generate a credential set, then deploy the camera application.

1. Porter will generate a set of credentials that will automate deployment of the application. You need:
    
  - The service principal for accessing Azure resources, including the service principal ID, key, and tenant DNS.
  - The subscription ID for your Azure subscription.
  - The image storage account connection string provided when you deployed the cloud application.

1. Run the credential generation process and follow the prompts:

    ```
    porter creds generate --tag intelligentedge/footfall-camera-deployment:0.1.0
    ```

1. Porter also requires a set of insecure parameters to run. Create a text file and enter the following text. Ask your Azure Stack administrator if you don’t know some of the required values.

    >[!NOTE] The `deployment suffix` value is used to ensure that your deployment’s resources have unique names across Azure. It must be a unique string of letters and numbers, no longer than 8 characters.

    ```
    iot_hub_name="Name of the IoT Hub deployed"
    deployment_suffix="Unique string here"
    ```

    Save the text file and make a note of its path.

4. You’re now ready to deploy the camera application using Porter. Run the deployment command and watch as the IoT Edge deployment is created.

    ```
    porter install footfall-camera –tag intelligentedge/footfall-camera-deployment:0.1.0 –creds footfall-camera-deployment –param-file "path-to-camera-parameters-file.txt"
    ```

5. Verify that the camera’s deployment is complete by viewing the camera feed at [https://camera-ip:3000/](https://camera-ip:3000/). This may take up to ten minutes.

## Configure Azure Stream Analytics

Now that data is flowing to Azure Stream Analytics from the camera, we need to manually authorize it to communicate with Power BI.

1.  From the Azure portal open **All Resources**, and the *process-footfall\[yoursuffix\]* job.

2.  In the **Job Topology** section of the Stream Analytics job pane, select the **Outputs** option.

3.  Select the **traffic-output** output sink.

4.  Select Renew Authorization and log in to your Power BI account.
    
    ![renew authorization prompt](./media/solution-deployment-guide-retail-footfall-detection/image2.png)

5.  Save the output settings.

6.  Go to the **Overview** pane and select **Start** to start sending data to Power BI.

7.  Select **Now** for job output start time and select **Start**. You can view the job status in the notification bar.

## Create a Power BI Dashboard

1.  Once the job succeeds, navigate to [Power BI](https://powerbi.com/) and sign in with your work or school account. If the Stream Analytics job query is outputting results, the *footfall-dataset* dataset you created exists under the **Datasets** tab.

2.  From your Power BI workspace, select **+ Create** to create a new dashboard named *Footfall Analysis.*

3.  At the top of the window, select **Add tile**. Then select **Custom Streaming Data** and **Next**. Choose the **footfall-dataset** under **Your Datasets**. Select **Card** from the **Visualization type** dropdown, and add **age** to **Fields**. Select **Next** to enter a name for the tile, and then select **Apply** to create the tile.

4.  You can add more fields and cards as desired.

## Test Your Solution

Observe how the data in the cards you created in Power BI changes as different people walk in front of the camera. Inferences may take up to 20 seconds to appear once recorded.

## Remove Your Solution

If you’d like to remove your solution, run the following commands using Porter, using the same parameter files that you created for deployment: 

```
porter uninstall footfall-cloud –tag intelligentedge/footfall-cloud-deployment:0.1.0 –creds footfall-cloud-deployment –param-file "path-to-cloud-parameters-file.txt"

porter uninstall footfall-camera –tag intelligentedge/footfall-camera-deployment:0.1.0 –creds footfall-camera-deployment –param-file "path-to-camera-parameters-file.txt"
```
## Next steps

- Learn more about hybrid cloud applications, see [Hybrid Cloud Solutions.](https://aka.ms/azsdevtutorials)
- Review and propose improvements to [the code for this sample on GitHub](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/footfall-analysis).
