---
title: #Required; page title is displayed in search results. Include the brand.
description: #Required; article description that is displayed in search results. 
author: #Required; your GitHub user alias, with correct capitalization.
ms.author: #Required; microsoft alias of author; optional team alias.
ms.service: #Required; service per approved list. slug assigned by ACOM.
ms.topic: how-to #Required; leave this attribute/value as-is.
ms.date: #Required; mm/dd/yyyy format.
ms.custom: template-how-to #Required; leave this attribute/value as-is.
---

# Update solution templates to work with new CreateUiDefinition changes

This article describes how to prepare for the upcoming Azure Stack Hub update and its changes to **CreateUiDefinition.json**. This JSON file is used to create the user experience when deploying solution templates.

## Description of issues

**CreateUiDefinition.json** will be updated to work with the UI changes in the upcoming release. The changes provide a more complete user experience when deploying a solution template. For more information about the new experience, [see the CreateUiDefinition overview](/azure-resource-manager/managed-applications/create-uidefinition-overview).

However, we are aware of an issue in which certain solution templates are unable to work with the new changes to the UI, unless the templates are updated. To ensure that there are minimal disruptions, we have outlined a series of steps you can take to make sure all your items are compatible with the latest update. The following is a side-by-side comparison between the old (right) and the new experience (left).

:::image type="content" source="media/create-ui-definition/create-ui-definition-1.png" alt-text="CreateUIDefinition1"::::::image type="content" source="media/create-ui-definition/create-ui-definition-2.png" alt-text="CreateUIDefinition part 2":::

## Validation steps

The first step is to determine which solution templates on your Azure Stack Hub marketplace need to be updated. The following JavaScript snippet can help you find the different items you may need to validate.

Please run the script in the web console in which you are logged into the admin portal. The console can usually be found in the web browser's development tools (can vary depending on browser). Once the console is open, copy and paste the script below into the console and hit Enter. The output is a list of solution templates from your Azure Stack
Hub marketplace that are not compatible with the new **CreateUiDefinition** format.

With the list of incompatible solution templates, use the following chart to determine next steps:

:::image type="content" source="media/create-ui-definition/uiflow.png" alt-text="Flow chart for UI definition":::

If your solution template is downloaded with Marketplace management, simply update the template to the latest version. Solution templates from marketplace management will be updated in the coming months, so please watch for the latest versions of your marketplace items.

However, if your solution template is not from marketplace management or it's a custom template that was created in-house, you may need to take additional steps to ensure compatibility with the upcoming create UI. The following steps would need to be completed before the new **CreateUiDefinition** experience is released (sometime in the coming
months) to ensure that your custom solution templates work with the new UX.

First, obtain the AZPKG file for the solution template. After extracting the .AZPKG file for the template, follow these steps to update your solution templates.

### Step 1: modify UIDefinition.json file

1. Change the schema to the following:

   ```json
   "$schema": "https://gallery.azure.com/schemas/2018-02-12/UIDefinition.json#",
   ```

2. Change the "create blade" section to the following:

   ```json
   "createBlade": {
         "name": "CreateUIDefinitionBlade",
         "extension": "Microsoft_Azure_CreateUIDef"
   },
   ```

### Step 2: modify CreateUiDefinition.json

1. Change the schema, handler and version to the following:

   ```json
   "$schema": "https://schema.management.azure.com/schemas/0.1.2-preview/CreateUIDefinition.MultiVm.json#",
   "handler": "Microsoft.Azure.CreateUIDef",
   "version": "0.1.2-preview",
   ```

2. Go to `https://<your portal uri>/#blade/Microsoft_Azure_CreateUIDef/SandboxBlade`, and follow the instructions to test the modified CreateUiDefinition.json content.
Address any issues reported by the sandbox blade.

### Step 3: update Manifest.json and create new AZPKG

1. Update the `version` property in the Manifest.json file to a newer version to allow for publishing the updated template. 

2. The final step is to create the new AZPKG using the [Gallery Packager tool](https://aka.ms/azsmarketplaceitem) and to run the packager command in PowerShell as follows:

   ```powershell
   AzureStackHubGallery.exe package -m <azpkg file\manifest.json> -o <outfile path>
   ```

This command creates a new AZPKG from the file that holds the different files above. This AZPKG can then be used to publish the new solution template onto the marketplace.

## Next steps

- [How to create and publish gallery item to the Azure Stack Hub marketplace](azure-stack-create-and-publish-marketplace-item.md?view=azs-2102&tabs=az)
- [Createuidefinition.json official document](/azure-resource-manager/managed-applications/create-uidefinition-overview)
