---
title: Footfall detection pattern using Azure and Azure Stack Hub
description: Learn how to use Azure and Azure Stack Hub to implement an AI-based footfall detection solution for analyzing retail store traffic.
author: ronmiab 
ms.topic: article
ms.date: 05/09/2025
ms.author: robess
ms.reviewer: anajod
ms.lastreviewed: 10/31/2019

# Intent: As an Azure Stack Hub user, I want to use Azure and Azure Stack Hub to implement an AI-based footfall detection pattern for analyzing retail store traffic.
# Keyword: footfall detection pattern azure stack hub

---

# Footfall detection pattern

This pattern provides an overview for implementing an AI-based footfall detection solution for analyzing visitor traffic in retail stores. The solution generates insights from real world actions, using Azure, Azure Stack Hub, and the Custom Vision AI Dev Kit.

## Context and problem

Contoso Stores would like to gain insights on how customers are receiving their current products in relation to store layout. They're unable to place staff in every section and it's inefficient to have a team of analysts review an entire store's camera footage. In addition, none of their stores have enough bandwidth to stream video from all their cameras to the cloud for analysis.

Contoso would like to find an unobtrusive, privacy-friendly way to determine their customers' demographics, loyalty, and reactions to store displays and products.

## Solution

This retail analytics pattern uses a tiered approach to inferencing at the edge. When you use the Custom Vision AI Dev Kit, only images with human faces are sent for analysis to a private Azure Stack Hub that runs Azure Cognitive Services. Anonymized, aggregated data is sent to Azure for aggregation across all stores and visualization in Power BI. Combining the edge and public cloud lets Contoso take advantage of modern AI technology while also remaining in compliance with their corporate policies and respecting their customers' privacy.

[![Footfall detection pattern solution](media/pattern-retail-footfall-detection/solution-architecture.png)](media/pattern-retail-footfall-detection/solution-architecture.png)

Here's a summary of how the solution works:

1. The Custom Vision AI Dev Kit gets a configuration from IoT Hub, which installs the IoT Edge Runtime and an ML model.
2. If the model sees a person, it takes a picture and uploads it to Azure Stack Hub blob storage.
3. The blob service triggers an Azure Function on Azure Stack Hub.
4. The Azure Function calls a container with the Face API to get demographic and emotion data from the image.
5. The data is anonymized and sent to an Azure Event Hubs cluster.
6. The Event Hubs cluster pushes the data to Stream Analytics.
7. Stream Analytics aggregates the data and pushes it to Power BI.

## Components

This solution uses the following components:

| Layer | Component | Description |
|----------|-----------|-------------|
| In-store hardware | [Custom Vision AI Dev Kit](https://azure.github.io/Vision-AI-DevKit-Pages/) | Provides in-store filtering using a local ML model that only captures images of people for analysis. Securely provisioned and updated through IoT Hub.<br><br>|
| Azure | [Azure Event Hubs](/azure/event-hubs/) | Azure Event Hubs provides a scalable platform for ingesting anonymized data that integrates neatly with Azure Stream Analytics. |
|  | [Azure Stream Analytics](/azure/stream-analytics/) | An Azure Stream Analytics job aggregates the anonymized data and groups it into 15-second windows for visualization. |
|  | [Microsoft Power BI](https://powerbi.microsoft.com/) | Power BI provides an easy-to-use dashboard interface for viewing the output from Azure Stream Analytics. |
| Azure Stack Hub | [App Service](/azure-stack/operator/azure-stack-app-service-overview) | The App Service resource provider (RP) provides a base for edge components, including hosting and management features for web apps/APIs and Functions. |
| | Azure Kubernetes Service [(AKS) Engine](https://github.com/Azure/aks-engine) cluster | The AKS RP with AKS-Engine cluster deployed into Azure Stack Hub provides a scalable, resilient engine to run the Face API container. |
| | Azure Cognitive Services [Face API containers](/azure/cognitive-services/face/face-how-to-install-containers)| The Azure Cognitive Services RP with Face API containers provides demographic, emotion, and unique visitor detection on Contoso's private network. |
| | Blob Storage | Images captured from the AI Dev Kit are uploaded to Azure Stack Hub's blob storage. |
| | Azure Functions | An Azure Function running on Azure Stack Hub receives input from blob storage and manages the interactions with the Face API. It emits anonymized data to an Event Hubs cluster located in Azure.<br><br>|

## Issues and considerations

Consider the following points when deciding how to implement this solution:

### Scalability

To enable this solution to scale across multiple cameras and locations, you must make sure that all of the components can handle the increased load. You may need to take actions like:

- Increase the number of Stream Analytics streaming units.
- Scale out the Face API deployment.
- Increase the Event Hubs cluster throughput.
- For extreme cases, migrate from Azure Functions to a virtual machine may be necessary.

### Availability

Since this solution is tiered, it's important to think about how to deal with networking or power failures. Depending on business needs, you might want to implement a mechanism to cache images locally, then forward to Azure Stack Hub when connectivity returns.

### Manageability

This solution can span many devices and locations, which could get unwieldy. [Azure's IoT services](/azure/iot-fundamentals/) can be used to automatically bring new locations and devices online and keep them up to date.

### Security

This solution captures customer images, making security a paramount consideration. Make sure all storage accounts are secured with the proper access policies and rotate keys regularly. Ensure storage accounts and Event Hubs have retention policies that meet corporate and government privacy regulations. Also make sure to tier the user access levels. Tiering ensures that users only have access to the data they need for their role.

## Next steps

To learn more about the topics introduced in this article:

- See the [Tiered Data pattern](https://aka.ms/tiereddatadeploy), which is used by the footfall detection pattern.
- See the [Custom Vision AI Dev Kit](https://azure.github.io/Vision-AI-DevKit-Pages/) to learn more about using custom vision.

When you're ready to test the solution example, continue with the [Footfall detection deployment guide](/azure/architecture/hybrid/deployments/solution-deployment-guide-retail-footfall-detection?toc=/hybrid/app-solutions/toc.json&bc=/hybrid/breadcrumb/toc.json). The deployment guide provides step-by-step instructions for deploying and testing its components.
