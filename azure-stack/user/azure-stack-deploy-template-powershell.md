---
title: Deploy a template using PowerShell in Azure Stack Hub | Microsoft Docs
description: Deploy a template using PowerShell in Azure Stack Hub.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/07/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 09/23/2019

---

# Deploy a template using Powershell in Azure Stack Hub

You can use PowerShell to deploy Azure Resource Manager templates to Azure Stack Hub. This article describes how to use PowerShell to deploy a template.

## Run AzureRM PowerShell cmdlets

This example uses **AzureRM** PowerShell cmdlets and a template stored on GitHub. The template creates a Windows Server 2012 R2 Datacenter virtual machine.

>[!NOTE]
> Before you try this example, make sure that you've [configured PowerShell](azure-stack-powershell-configure-user.md) for an Azure Stack Hub user.

1. Browse the [AzureStack-QuickStart-Templates repo](https://aka.ms/AzureStackGitHub) and find the **101-simple-windows-vm** template. Save the template to this location: `C:\templates\azuredeploy-101-simple-windows-vm.json`.
2. Open an elevated PowerShell command prompt.
3. Replace `username` and `password` in the following script with your user name and password, then run the script:

    ```powershell
    # Set deployment variables
    $myNum = "001" # Modify this per deployment
    $RGName = "myRG$myNum"
    $myLocation = "yourregion" # local for the ASDK

    # Create resource group for template deployment
    New-AzureRmResourceGroup -Name $RGName -Location $myLocation

    # Deploy simple IaaS template
    New-AzureRmResourceGroupDeployment `
        -Name myDeployment$myNum `
        -ResourceGroupName $RGName `
        -TemplateUri <path>\AzureStack-QuickStart-Templates\101-vm-windows-create\azuredeploy.json `
        -AdminUsername <username> `
        -AdminPassword ("<password>" | ConvertTo-SecureString -AsPlainText -Force)
    ```

    >[!IMPORTANT]
    > Every time you run this script, increment the value of the `$myNum` parameter to prevent overwriting your deployment.

4. Open the Azure Stack Hub portal, select **Browse**, and then select  **Virtual machines** to find your new virtual machine (**myDeployment001**).

## Cancel a running template deployment

To cancel a running template deployment, use the `Stop-AzureRmResourceGroupDeployment` PowerShell cmdlet.

## Next steps

- [Deploy a template with Visual Studio](azure-stack-deploy-template-visual-studio.md)
