---
title: Create and publish a Marketplace item in Azure Stack Hub 
description: Learn how to create and publish an Azure Stack Hub Marketplace item.
author: sethmanheim
ms.topic: how-to
ms.date: 01/17/2025
ms.author: sethm
ms.reviewer: avishwan
ms.lastreviewed: 04/26/2021

# Intent: As an Azure Stack operator, I want to create and publish a Marketplace items so my users can use them.
# Keyword: create marketplace item azure stack

---


# Create and publish a custom Azure Stack Hub Marketplace item

Every item published to the Azure Stack Hub Marketplace uses the Azure Gallery Package (.azpkg) format. The *Azure Gallery Packager* tool enables you to create a custom Azure Gallery package that you can upload to the Azure Stack Hub Marketplace, which can then be downloaded by users. The deployment process uses an Azure Resource Manager template.

## Marketplace items

The examples in this article show how to create a single VM Marketplace offer, of type Windows or Linux.

### Prerequisites

Before creating the VM marketplace item, do the following:

1. Upload the custom VM image to the Azure Stack Hub portal, following the instructions in [Add a VM image to Azure Stack Hub](azure-stack-add-vm-image.md).
2. Follow the instructions in this article to package the image (create an .azpkg) and upload it to the Azure Stack Hub Marketplace.

## Create a Marketplace item

To create a custom marketplace item, do the following:

1. Download the [Azure Gallery Packager tool](https://aka.ms/azsmarketplaceitem):

   :::image type="content" source="media/azure-stack-create-and-publish-marketplace-item/samples-tool.png" alt-text="Gallery packager":::

2. The tool includes sample packages that are in the .azpkg format, and must be extracted first. You can rename the file extensions from ".azpkg" to ".zip," or use an archiver tool of your choice:

   :::image type="content" source="media/azure-stack-create-and-publish-marketplace-item/sample-packages.png" alt-text="Samples packages":::

3. Once extracted, the .zip file contains the Linux or Windows Azure Resource Manager templates that are available. You can reuse the pre-made Resource Manager templates, and modify the respective parameters with the product details of the item that you will show on your Azure Stack Hub portal. Or, you can reuse the .azpkg file and skip the following steps to customize your own gallery package.

4. Create an Azure Resource Manager template or use our sample templates for Windows/Linux. These sample templates are provided in the packager tool .zip file you downloaded in step 1. You can either use the template and change the text fields, or you can download a pre-configured template from GitHub. For more information about Azure Resource Manager templates, see [Azure Resource Manager templates](/azure/azure-resource-manager/resource-group-authoring-templates).

5. The Gallery package should contain the following structure:

   ![Screenshot of the Gallery package structure](media/azure-stack-create-and-publish-marketplace-item/gallerypkg1.png)

6. Replace the following highlighted values (those with numbers) in the **Manifest.json** template with the value that you provided when [uploading your custom image](azure-stack-add-vm-image.md#add-a-platform-image).

   > [!NOTE]  
   > Never hard code any secrets such as product keys, password, or any customer identifiable information in the Azure Resource Manager template. Template JSON files are accessible without the need for authentication once published in the gallery. Store all secrets in [Key Vault](/azure/azure-resource-manager/resource-manager-keyvault-parameter) and call them from within the template.

   It's recommended that before publishing your own custom template, you try to publish the sample as-is and make sure it works in your environment. Once you've verified this step works, then delete the sample from gallery and make iterative changes until you are satisfied with the result.

   The following template is a sample of the Manifest.json file:

    ```json
    {
       "$schema": "https://gallery.azure.com/schemas/2015-10-01/manifest.json#",
       "name": "Test", (1)
       "publisher": "<Publisher name>", (2)
       "version": "<Version number>", (3)
       "displayName": "ms-resource:displayName", (4)
       "publisherDisplayName": "ms-resource:publisherDisplayName", (5)
       "publisherLegalName": "ms-resource:publisherDisplayName", (6)
       "summary": "ms-resource:summary",
       "longSummary": "ms-resource:longSummary",
       "description": "ms-resource:description",
       "longDescription": "ms-resource:description",
       "links": [
        { "displayName": "ms-resource:documentationLink", "uri": "http://go.microsoft.com/fwlink/?LinkId=532898" }
        ],
       "artifacts": [
          {
             "isDefault": true
          }
       ],
       "images": [{
          "context": "ibiza",
          "items": [{
             "id": "small",
             "path": "icons\\Small.png", (7)
             "type": "icon"
             },
             {
                "id": "medium",
                "path": "icons\\Medium.png",
                "type": "icon"
             },
             {
                "id": "large",
                "path": "icons\\Large.png",
                "type": "icon"
             },
             {
                "id": "wide",
                "path": "icons\\Wide.png",
                "type": "icon"
             }]
        }]
    }
    ```

    The following list explains the preceding numbered values in the example template:

    - (1) - The name of the offer.
    - (2) - The name of the publisher, without a space.
    - (3) - The version of your template, without a space.
    - (4) - The name that customers see.
    - (5) - The publisher name that customers see.
    - (6) - The publisher legal name.
    - (7) - The path and name for each icon.

7. For all fields referring to **ms-resource**, you must change the appropriate values inside the **strings/resources.json** file:

    ```json
    {
    "displayName": "<OfferName.PublisherName.Version>",
    "publisherDisplayName": "<Publisher name>",
    "summary": "Create a simple VM",
    "longSummary": "Create a simple VM and use it",
    "description": "<p>This is just a sample of the type of description you could create for your gallery item!</p><p>This is a second paragraph.</p>",
    "documentationLink": "Documentation"
    }
    ```

8. The  deployment templates file structure appears as follows:

   :::image type="content" source="media/azure-stack-create-and-publish-marketplace-item/deployment-templates.png" alt-text="Deployment templates":::

   Replace the values for the image in the **createuidefinition.json** file with the value you provided when uploading your custom image.

9. To ensure that the resource can be deployed successfully, test the template with the [Azure Stack Hub APIs](../user/azure-stack-profiles-azure-resource-manager-versions.md).

10. If your template relies on a virtual machine (VM) image, follow the instructions to [add a VM image to Azure Stack Hub](azure-stack-add-vm-image.md).

11. Save your Azure Resource Manager template in the **/Contoso.TodoList/DeploymentTemplates/** folder.

12. Choose the icons and text for your Marketplace item. Add icons to the **Icons** folder, and add text to the **resources** file in the **Strings** folder. Use the **small**, **medium**, **large**, and **wide** naming convention for icons. See the [Marketplace item UI reference](#reference-marketplace-item-ui) for a detailed description of these sizes.

    > [!NOTE]
    > All four icon sizes (small, medium, large, wide) are required for building the Marketplace item correctly.

13. For any further edits to **Manifest.json**, see [Reference: Marketplace item manifest.json](#reference-marketplace-item-manifestjson).

14. When you finish modifying your files, convert it to an .azpkg file. You perform the conversion using the **AzureGallery.exe** tool and the sample gallery package you downloaded previously. Run the following command:

    ```shell
    .\AzureStackHubGallery.exe package -m c:\<path>\<gallery package name>\manifest.json -o c:\Temp
    ```

    > [!NOTE]
    > The output path can be any path you choose, and does not have to be under the C: drive. However, the full path to both the manifest.json file, and the output package, must exist. For example, if the output path is `C:\<path>\galleryPackageName.azpkg`, the folder `C:\<path>` must exist.
    >
    >

## Publish a Marketplace item

### [Az modules](#tab/az)

1. Use PowerShell or Azure Storage Explorer to upload your Marketplace item (.azpkg) to Azure Blob storage. You can upload to local Azure Stack Hub storage or upload to Azure Storage, which is a temporary location for the package. Make sure that the blob is publicly accessible.

2. To import the gallery package into Azure Stack Hub, the first step is to remotely connect (RDP) to the client VM, in order to copy the file you just created to your Azure Stack Hub.

3. Add a context:

    ```powershell
    $ArmEndpoint = "https://adminmanagement.local.azurestack.external"
    Add-AzEnvironment -Name "AzureStackAdmin" -ArmEndpoint $ArmEndpoint
    Connect-AzAccount -EnvironmentName "AzureStackAdmin"
    ```

4. Run the following script to import the resource into your gallery:

    ```powershell
    Add-AzsGalleryItem -GalleryItemUri `
    https://sample.blob.core.windows.net/<temporary blob name>/<offerName.publisherName.version>.azpkg -Verbose
    ```

   If you run into an error when running **Add-AzsGalleryItem**, you may have two versions of the `gallery.admin` module installed. Remove all versions of the module, and install the latest version. For steps on uninstalling your PowerShell modules, see [Uninstall existing versions of the Azure Stack Hub PowerShell modules](powershell-install-az-module.md#uninstall-existing-versions-of-the-azure-stack-hub-powershell-modules).


5. Verify that you have a valid Storage account that is available to store your item. You can get the `GalleryItemURI` value from the Azure Stack Hub administrator portal. Select **Storage account -> Blob Properties -> URL**, with the extension .azpkg. The storage account is only for temporary use, in order to publish to the marketplace.

   After completing your gallery package and uploading it using **Add-AzsGalleryItem**, your custom VM should now appear on the Marketplace as well as in the **Create a resource** view. Note that the custom gallery package is not visible in **Marketplace Management**.

   [![Custom marketplace item uploaded](media/azure-stack-create-and-publish-marketplace-item/pkg6sm.png "Custom marketplace item uploaded")](media/azure-stack-create-and-publish-marketplace-item/pkg6.png#lightbox)

6. Once your item has been successfully published to the marketplace, you can delete the content from the storage account.

   All default gallery artifacts and your custom gallery artifacts are now accessible without authentication under the following URLs:

   - `https://galleryartifacts.adminhosting.[Region].[externalFQDN]/artifact/20161101/[TemplateName]/DeploymentTemplates/Template.json`
   - `https://galleryartifacts.hosting.[Region].[externalFQDN]/artifact/20161101/[TemplateName]/DeploymentTemplates/Template.json`

7. You can remove a Marketplace item by using the **Remove-AzGalleryItem** cmdlet. For example:

   ```powershell
   Remove-AzsGalleryItem -Name <Gallery package name> -Verbose
   ```

> [!Note]  
> The Marketplace UI may show an error after you remove an item. To fix the error, click **Settings** in the portal. Then, select **Discard modifications** under **Portal customization**.

### [AzureRM modules](#tab/azurerm)

1. Use PowerShell or Azure Storage Explorer to upload your Marketplace item (.azpkg) to Azure Blob storage. You can upload to local Azure Stack Hub storage or upload to Azure Storage, which is a temporary location for the package. Make sure that the blob is publicly accessible.

2. To import the gallery package into Azure Stack Hub, the first step is to remotely connect (RDP) to the client VM, in order to copy the file you just created to your Azure Stack Hub.

3. Add a context:

    ```powershell
    $ArmEndpoint = "https://adminmanagement.local.azurestack.external"
    Add-AzureRMEnvironment -Name "AzureStackAdmin" -ArmEndpoint $ArmEndpoint
    Add-AzureRMAccount -EnvironmentName "AzureStackAdmin"
    ```

4. Run the following script to import the resource into your gallery:

    ```powershell
    Add-AzsGalleryItem -GalleryItemUri `
    https://sample.blob.core.windows.net/<temporary blob name>/<offerName.publisherName.version>.azpkg -Verbose
    ```

   If you run into an error when running **Add-AzsGalleryItem**, you may have two versions of the `gallery.admin` module installed. Remove all versions of the module, and install the latest version. For steps on uninstalling your PowerShell modules, see [Uninstall existing versions of the Azure Stack Hub PowerShell modules](azure-stack-powershell-install.md#3-uninstall-existing-versions-of-the-azure-stack-hub-powershell-modules).

5. Verify that you have a valid Storage account that is available to store your item. You can get the `GalleryItemURI` value from the Azure Stack Hub administrator portal. Select **Storage account -> Blob Properties -> URL**, with the extension .azpkg. The storage account is only for temporary use, in order to publish to the marketplace.

   After completing your gallery package and uploading it using **Add-AzsGalleryItem**, your custom VM should now appear on the Marketplace as well as in the **Create a resource** view. Note that the custom gallery package is not visible in **Marketplace Management**.

   [![Custom marketplace item uploaded](media/azure-stack-create-and-publish-marketplace-item/pkg6sm.png "Custom marketplace item uploaded")](media/azure-stack-create-and-publish-marketplace-item/pkg6.png#lightbox)

6. Once your item has been successfully published to the marketplace, you can delete the content from the storage account.

   All default gallery artifacts and your custom gallery artifacts are now accessible without authentication under the following URLs:

   - `https://galleryartifacts.adminhosting.[Region].[externalFQDN]/artifact/20161101/[TemplateName]/DeploymentTemplates/Template.json`
   - `https://galleryartifacts.hosting.[Region].[externalFQDN]/artifact/20161101/[TemplateName]/DeploymentTemplates/Template.json`

7. You can remove a Marketplace item by using the **Remove-AzGalleryItem** cmdlet. For example:

   ```powershell
   Remove-AzsGalleryItem -Name <Gallery package name> -Verbose
   ```

> [!Note]  
> The Marketplace UI may show an error after you remove an item. To fix the error, click **Settings** in the portal. Then, select **Discard modifications** under **Portal customization**.

---

## Reference: Marketplace item manifest.json

### Identity information

| Name | Required | Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| Name |X |String |[A-Za-z0-9]+ | |
| Publisher |X |String |[A-Za-z0-9]+ | |
| Version |X |String |[SemVer v2](https://semver.org/) | |

### Metadata

| Name | Required | Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| DisplayName |X |String |Recommendation of 80 characters |The portal might not display your item name correctly if it's longer than 80 characters. |
| PublisherDisplayName |X |String |Recommendation of 30 characters |The portal might not display your publisher name correctly if it's longer than 30 characters. |
| PublisherLegalName |X |String |Maximum of 256 characters | |
| Summary |X |String |60 to 100 characters | |
| LongSummary |X |String |140 to 256 characters |Not yet applicable in Azure Stack Hub. |
| Description |X |[HTML](https://github.com/Azure/portaldocs/blob/master/gallery-sdk/generated/index-gallery.md#gallery-item-metadata-html-sanitization) |500 to 5,000 characters | |

### Images

The Marketplace uses the following icons:

| Name | Width | Height | Notes |
| --- | --- | --- | --- |
| Wide |255 px |115 px |Always required |
| Large |115 px |115 px |Always required |
| Medium |90 px |90 px |Always required |
| Small |40 px |40 px |Always required |
| Screenshot |533 px |324 px |Optional |

### Categories

Each Marketplace item should be tagged with a category that identifies where the item appears on the portal UI. You can choose one of the existing categories in Azure Stack Hub (**Compute**, **Data + Storage**, and so on) or choose a new one.

### Links

Each Marketplace item can include various links to additional content. The links are specified as a list of names and URIs:

| Name | Required | Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| DisplayName |X |String |Maximum of 64 characters. | |
| Uri |X |URI | | |

### Additional properties

In addition to the preceding metadata, Marketplace authors can provide custom key/value pair data in the following form:

| Name | Required | Type | Constraints | Description |
| --- | --- | --- | --- | --- |
| DisplayName |X |String |Maximum of 25 characters. | |
| Value |X |String |Maximum of 30 characters. | |

### HTML sanitization

For any field that allows HTML, the following [elements and attributes are allowed](https://github.com/Azure/portaldocs/blob/master/gallery-sdk/generated/index-gallery.md#gallery-item-metadata-html-sanitization):

`h1, h2, h3, h4, h5, p, ol, ul, li, a[target|href], br, strong, em, b, i`

## Reference: Marketplace item UI

Icons and text for Marketplace items as seen in the Azure Stack Hub portal are as follows.

### Create blade

![Create blade--Azure Stack Hub Marketplace items](media/azure-stack-create-and-publish-marketplace-item/image1.png)

### Marketplace item details blade

![Azure Stack Hub Marketplace item details blade](media/azure-stack-create-and-publish-marketplace-item/image3.png)

## Next steps

- [Azure Stack Hub Marketplace overview](azure-stack-marketplace.md)
- [Download Marketplace items](azure-stack-download-azure-marketplace-item.md)
- [Format and structure of Azure Resource Manager templates](/azure/azure-resource-manager/resource-group-authoring-templates)
