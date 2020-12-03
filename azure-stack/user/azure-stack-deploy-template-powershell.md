---
title: Deploy a template using PowerShell in Azure Stack Hub 
description: Deploy a template using PowerShell in Azure Stack Hub.
author: mattbriggs

ms.topic: article
ms.date: 12/2/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 12/2/2020

# Intent: As an Azure Stack user, I want to deploy a template using PowerShell in Azure Stack so I can manage resources efficiently. 
# Keyword: deploy template powershell

---


# Deploy a template using PowerShell in Azure Stack Hub

You can use PowerShell to deploy Azure Resource Manager templates to Azure Stack Hub. This article describes how to use PowerShell to deploy a template.

## Run PowerShell cmdlets

### [Az modules](#tab/az)

This example uses **Az** PowerShell cmdlets and a template stored on GitHub. The template creates a Windows Server 2012 R2 Datacenter virtual machine.

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
    New-AzResourceGroup -Name $RGName -Location $myLocation

    # Deploy simple IaaS template
    New-AzResourceGroupDeployment `
        -Name myDeployment$myNum `
        -ResourceGroupName $RGName `
        -TemplateUri <path>\AzureStack-QuickStart-Templates\101-vm-windows-create\azuredeploy.json `
        -AdminUsername <username> `
        -AdminPassword ("<password>" | ConvertTo-SecureString -AsPlainText -Force)
    ```

    >[!IMPORTANT]
    > Every time you run this script, increment the value of the `$myNum` parameter to prevent overwriting your deployment.

4. Open the Azure Stack Hub portal, select **Browse**, and then select  **Virtual machines** to find your new virtual machine (**myDeployment001**).

### [AzureRM modules](#tab/azurerm)

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
    New-AzureRMResourceGroup -Name $RGName -Location $myLocation

    # Deploy simple IaaS template
    New-AzureRMResourceGroupDeployment `
        -Name myDeployment$myNum `
        -ResourceGroupName $RGName `
        -TemplateUri <path>\AzureStack-QuickStart-Templates\101-vm-windows-create\azuredeploy.json `
        -AdminUsername <username> `
        -AdminPassword ("<password>" | ConvertTo-SecureString -AsPlainText -Force)
    ```

    >[!IMPORTANT]
    > Every time you run this script, increment the value of the `$myNum` parameter to prevent overwriting your deployment.

4. Open the Azure Stack Hub portal, select **Browse**, and then select  **Virtual machines** to find your new virtual machine (**myDeployment001**).

---
## Cancel a running template deployment

To cancel a running template deployment, use the `Stop-AzResourceGroupDeployment` PowerShell cmdlet.

## Next steps

- [Deploy a template with Visual Studio](azure-stack-deploy-template-visual-studio.md)
