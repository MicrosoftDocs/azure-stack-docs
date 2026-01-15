---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 06/09/2025
ms.reviewer: alkohli
ms.lastreviewed: 03/20/2025
---


- **Register required resource providers.** Make sure that your Azure subscription is registered against the required resource providers. To register, you must be an owner or contributor on your subscription. You can also ask an administrator to register.

   Run the following [PowerShell commands](/azure/azure-resource-manager/management/resource-providers-and-types#azure-powershell) to register:

   ```powershell
   Register-AzResourceProvider -ProviderNamespace "Microsoft.HybridCompute" 
   Register-AzResourceProvider -ProviderNamespace "Microsoft.GuestConfiguration" 
   Register-AzResourceProvider -ProviderNamespace "Microsoft.HybridConnectivity" 
   Register-AzResourceProvider -ProviderNamespace "Microsoft.AzureStackHCI" 
   Register-AzResourceProvider -ProviderNamespace "Microsoft.Kubernetes" 
   Register-AzResourceProvider -ProviderNamespace "Microsoft.KubernetesConfiguration" 
   Register-AzResourceProvider -ProviderNamespace "Microsoft.ExtendedLocation" 
   Register-AzResourceProvider -ProviderNamespace "Microsoft.ResourceConnector" 
   Register-AzResourceProvider -ProviderNamespace "Microsoft.HybridContainerService"
   Register-AzResourceProvider -ProviderNamespace "Microsoft.Attestation"
   Register-AzResourceProvider -ProviderNamespace "Microsoft.Storage"
   Register-AzResourceProvider -ProviderNamespace "Microsoft.Insights"
   ```

    > [!NOTE]
    > - The assumption is that the person registering the Azure subscription with the resource providers is a different person than the one who is registering the Azure Local machines with Arc.
   > - `Microsoft.Insights` resource provider is required for monitoring and logging. If this RP is not registered, the diagnostic account and Key Vault audit logging fails during validation.

- **Create a resource group**. Follow the steps to [Create a resource group](/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups) where you want to register your machines. Make a note of the resource group name and the associated subscription ID.

- **Get the tenant ID**. Follow the steps in [Get the tenant ID of your Microsoft Entra tenant through the Azure portal](/azure/azure-portal/get-subscription-tenant-id):

   1. In the Azure portal, go to **Microsoft Entra ID** > **Properties**.

   1. Scroll down to the Tenant ID section and copy the **Tenant ID** value to use later.
   
- **Verify permissions**. As you register machines as Arc resources, make sure that you're either the resource group owner or have the following permissions on the resource group where the machines are provisioned:

   - `Azure Connected Machine Onboarding`.
   - `Azure Connected Machine Resource Administrator`.

   To verify that you have these roles, follow these steps in the Azure portal:
    
   1. Go to the subscription you used for the Azure Local deployment.

   1. Go to the resource group where you plan to register the machine.

   1. In the left-pane, go to **Access Control (IAM)**.

   1. In the right-pane, go to **Role assignments**. Verify that you have `Azure Connected Machine Onboarding` and `Azure Connected Machine Resource Administrator` roles assigned.

- Check your Azure policies. Make sure that:
    - The Azure policies aren't blocking the installation of extensions.
    - The Azure policies aren't blocking the creation of certain resource types in a resource group.
    - The Azure policies aren't blocking the resource deployment in certain locations.
