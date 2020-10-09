---
title: Add a custom VM image to Azure Stack Hub 
description: Learn how to add or remove a custom VM image to Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 9/8/2020
ms.author: sethm
ms.reviewer: kivenkat
ms.lastreviewed: 9/8/2020

# Intent: As an Azure Stack operator, I want to add a VM image to offer to my tenants.
# Keyword: add vm image azure stack

---

# Add and remove a custom VM image to Azure Stack Hub

In Azure Stack Hub, as an operator you can add your custom virtual machine (VM) image to the marketplace and make it available to your users. You can add VM images to the Azure Stack Hub Marketplace through the administrator portal or Windows PowerShell. Use either an image from global Microsoft Azure Marketplace as a base for your custom image, or create your own using Hyper-V.

## Add an image

You can find instructions for adding generalized and specialized images in the **Compute** section of the user guide. You will want to create a generalized image before offering the image to your users. For instructions see [Move a VM to Azure Stack Hub Overview](../user/vm-move-overview.md). When creating images available for your tenants use the Azure Stack Hub administrative portal or administrator endpoints rather than the user portal or tenant directory endpoints.

You have two options for making an image available to your users:

- **Offer an image only accessible via Azure Resource Manager**  
  If you add the image via the Azure Stack Hub administrative portal in **Compute** > **Images**, all of your tenants can access the image. However your users will need to use an Azure Resource Manager template to access it. It won't be visible in your Azure Stack Hub Marketplace.

- **Offer an image through the Azure Stack Hub Marketplace**  
    Once you have added your image through the Azure Stack Hub administrative portal, you can then create a marketplace offering. For instructions, see [Create and publish a custom Azure Stack Hub Marketplace item](azure-stack-create-and-publish-marketplace-item.md).

## Add a platform image

To add a platform image to Azure Stack Hub, use the Azure Stack Hub administrator portal or endpoint using PowerShell. You must first create a generalized VHD. For more information, see [Move a VM to Azure Stack Hub Overview](../user/vm-move-overview.md).

### [Portal](#tab/image-add-portal)

Add the VM image as an Azure Stack Hub operator using the portal.

1. Sign in to Azure Stack Hub as an operator. In the menu, select **All services** > **Compute** > **Images** > **Add**.

   ![Add a VM image](./media/azure-stack-add-vm-image/tca4.png)

2. Under **Create image**, enter the **Publisher**, **Offer**, **SKU**, **Version**, and OS disk blob URI. Then, select **Create** to begin creating the VM image.

   ![Custom image sideloading UI](./media/azure-stack-add-vm-image/tca5.png)

   When the image is successfully created, the VM image status changes to **Succeeded**.

3. When you add an image, it is only available for Azure Resource Manager-based templates and PowerShell deployments. To make an image available to your users as a marketplace item, publish the marketplace item using the steps in the article [Create and publish a Marketplace item](azure-stack-create-and-publish-marketplace-item.md). Make sure you note the **Publisher**, **Offer**, **SKU**, and **Version** values. You will need them when you edit the Resource Manager template and Manifest.json in your custom .azpkg.

### [PowerShell](#tab/image-add-ps)

 Add a VM image as an Azure Stack Hub operator using PowerShell.

1. [Install PowerShell for Azure Stack Hub](azure-stack-powershell-install.md).  

2. Sign in to Azure Stack Hub as an operator. For instructions, see [Sign in to Azure Stack Hub as an operator](azure-stack-powershell-configure-admin.md).

3. Open PowerShell with an elevated prompt, and run:

   ```powershell
    Add-AzsPlatformimage -publisher "<publisher>" `
      -offer "<Offer>" `
      -sku "<SKU>" `
      -version "<#.#.#>" `
      -OSType "<OS type>" `
      -OSUri "<OS URI>"
   ```

   The **Add-AzsPlatformimage** cmdlet specifies values used by the Azure Resource Manager templates to reference the VM image. The values include:
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
   - **osType**  
     For example: `Linux`  
     The **osType** of the image must be either **Windows** or **Linux**.  
   - **OSUri**  
     For example: `https://storageaccount.blob.core.windows.net/vhds/Ubuntu1404.vhd`  
     You can specify a blob storage URI for an `osDisk`.  

     For more information, see the PowerShell reference for the [Add-AzsPlatformimage](/powershell/module/azs.compute.admin/add-azsplatformimage) cmdlet.

4. When you add an image, it is only available for Azure Resource Manager-based templates and PowerShell deployments. To make an image available to your users as a marketplace item, publish the marketplace item using the steps in the article [Create and publish a Marketplace item](azure-stack-create-and-publish-marketplace-item.md). Make sure you note the **Publisher**, **Offer**, **SKU**, and **Version** values. You will need them when you edit the Resource Manager template and Manifest.json in your custom .azpkg.

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