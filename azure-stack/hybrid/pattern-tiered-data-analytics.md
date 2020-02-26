---
title: Pattern for implementing a tiered data for analytics solution using Azure and Azure Stack Hub.
description: Learn how to use Azure and Azure Stack Hub services, to implement a tiered data solution across the hybrid cloud.
author: BryanLa
ms.topic: article
ms.date: 11/05/2019
ms.author: bryanla
ms.reviewer: anajod
ms.lastreviewed: 11/05/

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Tiered data for analytics pattern

This pattern illustrates how to use Azure Stack Hub and Azure to stage, analyze, process, sanitize, and store data across multiple on-premises and cloud locations.

## Context and problem

One of the problems facing enterprise organizations in the modern technology landscape concerns secure data storage, processing and analyzing. Considerations include:
- data content
- location
- security and privacy requirements
- access permissions
- maintenance
- storage warehousing

Azure, in combination with Azure Stack Hub, addresses data concerns and offers low-cost solutions. This solution is best expressed through a distributed manufacturing or logistics company. 

The solution is based on the following scenario:
- A large multi-branch manufacturing organization.
- Rapid and secure data storage, processing, and distribution between global remote locations and its central headquarters are required. 
- Employee and machinery activity, facility information, and business reporting data that must remain secure. The data must be distributed appropriately, and meet regional compliance policy and industry regulations.

## Solution

Utilizing both on-premises and public cloud environments meets the demands of multi-facility enterprises. Azure Stack Hub offers a rapid, secure, and flexible solution for collecting, processing, storing, and distributing local and remote data. Particularly when security, confidentiality, corporate policy, and regulatory requirements may differ between locations and users. 

![tiered data for analytics solution architecture](media/pattern-tiered-data-analytics/solution-architecture.png)

## Components

This solution uses the following components:

| Layer | Component | Description |
|----------|-----------|-------------|
| Azure | Storage | An [Azure Storage](/azure/storage/) account provides a sterile data consumption endpoint. Azure Storage is Microsoft's cloud storage solution for modern data storage scenarios. Azure Storage offers a massively scalable object store for data objects and a file system service for the cloud. It also provides a messaging store for reliable messaging, and a NoSQL store. |
| Azure Stack Hub | Storage | An [Azure Stack Hub Storage](/azure-stack/user/azure-stack-storage-overview) account is used for multiple services:<br>- **Blob storage** for raw data storage. Blob storage can hold any type of text or binary data, such as a document, media file, or application installer. Every blob is organized under a container. Containers provide a useful way to assign security policies to groups of objects. A storage account may contain any number of containers, and a container can contain any number of blobs, up to the 500-TB capacity limit of the storage account.<br>- **Blob storage** for data archive. There are benefits to low-cost storage for cool data archiving. Examples of cool data include backups, media content, scientific data, compliance, and archival data. In general, any data that is accessed infrequently is considered cool storage. tiering data based on attributes like frequency of access and retention period. Customer data is infrequently accessed but requires similar latency and performance to hot data.<br>- **Queue storage** for processed data storage. Queue storage provides cloud messaging between application components. In designing applications for scale, application components are often decoupled, so they can scale independently. Queue storage delivers asynchronous messaging for communication between application components.  Whether they're running in the cloud, on the desktop, an on-premises server, or a mobile device. Queue storage also supports managing asynchronous tasks and building process work flows. |
| | Azure Functions | The [Azure Functions](/azure/azure-functions/) service is provided by the [Azure App Service on Azure Stack Hub](/azure-stack/operator/azure-stack-app-service-overview) resource provider. Azure Functions allows you to execute your code in a simple, serverless environment, to run script or code in response to a variety of events. Azure Functions scale to meet demand without having to create a VM or publish a web app, using the programming language of your choice. Functions are used by the solution for:<br>- **Data intake**<br>- **Data sterilization.** Manually triggered functions can perform scheduled data processing, clean up and archiving. Examples may include nightly customer list scrubs and monthly report processing.|

## Issues and considerations

Consider the following points when deciding how to implement this solution:

### Scalability 

Azure functions and storage solutions scale to meet data volume and processing demands. For Azure scalability information and targets, see [Azure Storage scalability documentation](/azure/storage/common/storage-scalability-targets). 

### Availability

Storage is the primary availability consideration for this pattern. Connection via fast links is required for large data volume processing and distribution. 

### Manageability

Manageability of this solution depends on authoring tools in use and engagement of source control. 

## Next steps

To learn more about topics introduced in this article:
- See the [Azure Storage](/azure/storage/) and [Azure Functions](/azure/azure-functions/) documentation. This pattern makes heavy use of Azure Storage accounts and Azure Functions, on both Azure and Azure Stack Hub.
- See [Hybrid application design considerations](overview-app-design-considerations.md) to learn more about best practices, and answer additional questions.
- See the [Azure Stack family of products and solutions](/azure-stack), to learn more about the entire portfolio of products and solutions.

When you're ready to test the solution example, continue with the [Tiered data for analytics solution deployment guide](https://aka.ms/tiereddatadeploy). The deployment guide provides step-by-step instructions for deploying and testing its components.