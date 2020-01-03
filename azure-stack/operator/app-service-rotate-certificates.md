---
title: Rotate App Service on Azure Stack Hub Secrets and Certificates | Microsoft Docs
description: Learn how to rotate secrets and certificates used by Azure App Service on Azure Stack Hub
services: azure-stack
documentationcenter: ''
author: BryanLa
manager: femila
editor: ''

ms.assetid:
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 01/03/2020
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 01/03/2020
---

# Rotate App Service on Azure Stack Hub Secrets and Certificates

These instructions only apply to Azure App Service on Azure Stack Hub.  Rotation of Azure App Service on Azure Stack Hub secrets is not included in the centralized secret rotation procedure for Azure Stack Hub.  Operators can monitor the validity of secrets within the system, the date on which they were last updated and the time remaining until the secrets expire.

> [!Important]
> Operators will not receive alerts for secret expiration on the Azure Stack Hub dashboard as Azure App Service on Azure Stack Hub is not integrated with the Azure Stack Hub alerting service.  Operators must regularly monitor their secrets using the Azure App Service on Azure Stack Hub administration experience in the Azure Stack Hub Administrators portal.

This document contains the procedure for rotating the following secrets:

* Encryption Keys used within Azure App Service on Azure Stack Hub;
* Database connection credentials used by Azure App Service on Azure Stack Hub to interact with the hosting and metering databases;
* Certificates used by Azure App Service on Azure Stack Hub to secure endpoints;
* System credentials for Azure App Service on Azure Stack Hub infrastructure roles.

## Rotate Encryption Keys

To rotate the encryption keys used within Azure App Service on Azure Stack Hub complete the following steps:

1. Go to the App Service Administration experience in the Azure Stack Hub Administrators Portal.

1. Navigate to the **Secrets** menu option

1. Click the **Rotate** button in the Encryption Keys section

1. Click **OK** to start the rotation procedure.

1. The encryption keys are rotated and all role instances are updated. Operators can monitor the Status of the procedure using the **Status** button.

## Rotate Connection Strings

To update the credentials for the database connection string for the App Service hosting and metering databases, complete the following steps:

1. Go to the App Service Administration experience in the Azure Stack Hub Administrators Portal.

1. Navigate to the **Secrets** menu option

1. Click the **Rotate** button in the Connection Strings section

1. Provide the **SQL SA Username** and **Password** and click **OK** to start the rotation procedure. 

1. The credentials will be rotated throughout the Azure App Service role instances. Operators can monitor the Status of the procedure using the **Status** button.

## Rotate Certificates

To rotate the certificates used within Azure App Service on Azure Stack Hub complete the following steps:

1. Go to the App Service Administration experience in the Azure Stack Hub Administrators Portal.

1. Navigate to the **Secrets** menu option

1. Click the **Rotate** button in the Certificates section

1. Provide the **certificate file** and associated **password** for the certificates you wish to rotate and click **OK**.

1. The certificates will be rotated as required throughout the Azure App Service on Azure Stack Hub role instances.  Operators can monitor the status of the procedure using the **Status** button.

## Rotate System Credentials

To rotate the System Credentials used within Azure App Service on Azure Stack Hub complete the following steps:

1. Go to the App Service Administration experience in the Azure Stack Hub Administrators Portal.

1. Navigate to the **Secrets** menu option

1. Click the **Rotate** button in the System Credentials section

1. Select the **Scope** of the System Credential you are rotating.  Operators can choose to rotate the System Credentials for All roles or individual roles.

1. Specify the **Local Admin User Name**, new **Password** and confirm the **Password** and click **OK**

1. The credential(s) will be rotated as required throughout the corresponding Azure App Service on Azure Stack Hub role instance.  Operators can monitor the status of the procedure using the **Status** button.



