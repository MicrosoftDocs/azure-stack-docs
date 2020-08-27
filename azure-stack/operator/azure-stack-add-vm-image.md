---
title: Add a custom VM image to Azure Stack Hub 
description: Learn how to add or remove a custom VM image to Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 08/26/2020
ms.author: sethm
ms.reviewer: kivenkat
ms.lastreviewed: 08/26/2020

# Intent: As an Azure Stack operator, I want to add a VM image to offer to my tenants.
# Keyword: add vm image azure stack

---

# Add and remove a custom VM image to Azure Stack Hub

In Azure Stack Hub, as an operator you can add your custom virtual machine (VM) image to the marketplace and make it available to your users. You can add VM images to the Azure Stack Hub Marketplace through the administrator portal or Windows PowerShell. Use either an image from global Microsoft Azure Marketplace as a base for your custom image, or create your own using Hyper-V.

## Add an image

You can find instructions for adding generalized and specialized images in the **Compute** section of the user guide. For instructions see [Move a VM to Azure Stack Hub Overview](/azure-stack/user/vm-move-overview). When creating images available for your tenants use the Azure Stack Hub administrative portal or administrator endpoints rather than the user portal or tenant directory endpoints.

You have two options for making an image available to your users:

- **Offer an image only accessible via Azure Resource Manager**  
  If you place add the image via the Azure Stack Hub administrative portal in Compute > Images, all of your tenants can access the image. However your users will need to use an Azure Resource Manager template to access it. It won't be visible in your Azure Stack Hub Marketplace.

- **Offer an image through the Azure Stack Hub Marketplace**  
    Once you have added your image through the Azure Stack Hub administrative portal, you can then create a marketplace offering. For instructions, see [Create and publish a custom Azure Stack Hub Marketplace item](azure-stack-create-and-publish-marketplace-item.md).

## Remove a platform image

You can remove a platform image using the portal or PowerShell.

### [Portal](#tab/image-rem-portal)

To remove the VM image as an Azure Stack Hub operator using the Azure Stack Hub portal, follow these steps:

1. Open the Azure Stack Hub [administrator portal](https://portal.azure.com/signin/index).

2. If the VM image has an associated Marketplace item, select **Marketplace management**, and then select the VM marketplace item you want to delete.

3. If the VM image does not have an associated Marketplace item, navigate to **All services > Compute > VM Images**, and then select the ellipsis (**...**) next to the VM image.

4. Select **Delete**.

### [PowerShell](#tab/image-rem-ps)

To remove the VM image as an Azure Stack Hub operator using PowerShell, follow these steps:

1. [Install PowerShell for Azure Stack Hub](azure-stack-powershell-install.md).

2. Sign in to Azure Stack Hub as an operator.

3. Open PowerShell with an elevated prompt, and run:

   ```powershell  
   Remove-AzsPlatformImage `
    -publisher "<Publisher>" `
    -offer "<Offer>" `
    -sku "<SKU>" `
    -version "<Version>" `
   ```

   The **Remove-AzsPlatformImage** cmdlet specifies values used by the Azure Resource Manager templates to reference the VM image. The values include:
   - **publisher**  
     For example: `Canonical`  
     The **publisher** name segment of the VM image that users use when they deploy the image. Don't include a space or other special characters in this field.  
   - **offer**  
     For example: `UbuntuServer`  
     The **offer** name segment of the VM image that users use when they deploy the VM image. Don't include a space or other special characters in this field.  
   - **sku**  
     For example: `14.04.3-LTS`  
     The **SKU** name segment of the VM image that users use when they deploy the VM image. Don't include a space or other special characters in this field.  
   - **version**  
     For example: `1.0.0`  
     The version of the VM image that users use when they deploy the VM image. This version is in the format **\#.\#.\#**. Don't include a space or other special characters in this field.  

     For more info about the **Remove-AzsPlatformImage** cmdlet, see the Microsoft PowerShell [Azure Stack Hub Operator module documentation](/powershell/azure/azure-stack/overview).
---
## Next steps

- [Create and publish a custom Azure Stack Hub Marketplace item](azure-stack-create-and-publish-marketplace-item.md)
- [Provision a virtual machine](../user/azure-stack-create-vm-template.md)
