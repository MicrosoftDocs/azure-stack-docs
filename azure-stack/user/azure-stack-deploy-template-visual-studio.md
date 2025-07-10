---
title: Deploy templates with Visual Studio in Azure Stack Hub 
description: Learn how to deploy templates with Visual Studio in Azure Stack Hub.
author: sethmanheim

ms.topic: install-set-up-deploy
ms.date: 12/2/2020
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 12/2/2020

# Intent: As an Azure Stack user, I want to deploy templates in Azure Stack with Visual Studio so...... (article doesn't give any benefits)
# Keyword: deploy templates visual studio

---


# Deploy templates in Azure Stack Hub using Visual Studio

You can use Visual Studio to deploy Azure Resource Manager templates to Azure Stack Hub.

## To deploy a template

1. [Install and connect](azure-stack-install-visual-studio.md) to Azure Stack Hub with Visual Studio.
2. Open Visual Studio.
3. Select **File**, and then select **New**. In **New Project**, select **Azure Resource Group**.
4. Enter a **Name** for the new project, and then select **OK**.
5. In **Select Azure Template**, pick **Azure Stack Hub Quickstart** from the drop-down list.
6. Select **101-create-storage-account**, and then select **OK**.
7. In your new project, expand the **Templates** node in **Solution Explorer** to see the available templates.
8. In **Solution Explorer**, pick the name of your project, and then select **Deploy**. Select **New Deployment**.
9. In **Deploy to Resource Group**, use the **Subscription** drop-down list to select your Microsoft Azure Stack Hub subscription.
10. From the **Resource Group** list, choose an existing resource group or create a new one.
11. From the **Resource group location** list, choose a location, and then select **Deploy**.
12. In **Edit Parameters**, provide values for the parameters (which vary by template), and then select **Save**.

## Next steps

* [Deploy templates with the command line](azure-stack-deploy-template-command-line.md)
* [Develop templates for Azure Stack Hub](azure-stack-develop-templates.md)
