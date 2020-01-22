---
title: Deploy a template using the portal in Azure Stack Hub | Microsoft Docs
description: Learn how to use the Azure Stack Hub portal to deploy a template.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.assetid: eafa60f2-16c9-4ef1-b724-47709e9ea29e
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 05/07/2019

---

# Deploy a template using the portal in Azure Stack Hub

You can use the portal to deploy Azure Resource Manager templates to Azure Stack Hub.

## To deploy a template

1. Sign in to the portal, select **+ Create a resource**, and then select **Custom**.

   ![Create a resource in Azure Stack Hub portal](media/azure-stack-deploy-template-portal/template-deploy1.png)

1. Select **Template deployment**.

   ![Deploy template in Azure Stack Hub portal](media/azure-stack-deploy-template-portal/template-deploy2.png)

1. Select **Edit template**, and then paste your JSON template code into the code window. Select **Save**.

   ![Edit template in Azure Stack Hub portal](media/azure-stack-deploy-template-portal/template-deploy3.png)

1. Select **Edit parameters**, provide values for the parameters that are shown, and then select **OK**.

   ![Edit parameters in Azure Stack Hub portal](media/azure-stack-deploy-template-portal/template-deploy4.png)

1. Select **Subscription**. Choose the subscription you want to use, and then select **OK**.

   ![Select subscription in Azure Stack Hub portal](media/azure-stack-deploy-template-portal/template-deploy5.png)

1. Select **Resource group**. Choose an existing resource group or create a new one, and then select **OK**.

   ![Select resource group in Azure Stack Hub portal](media/azure-stack-deploy-template-portal/template-deploy6.png)

1. Select **Create**. A new tile on the dashboard tracks the progress of your template deployment.

   ![Create template in Azure Stack Hub portal](media/azure-stack-deploy-template-portal/template-deploy7.png)

## Next steps

To learn more about deploying templates, see the following article:

- [Deploy templates with PowerShell](azure-stack-deploy-template-powershell.md)
