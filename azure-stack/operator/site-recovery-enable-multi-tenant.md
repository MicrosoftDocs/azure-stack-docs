---
title: Enable multitenant scenarios for Azure Site Recovery on Azure Stack Hub
description: Learn how to Enable multiple tenants for Azure Site Recovery on Azure Stack Hub.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 05/01/2024
ms.reviewer: rtiberiu
ms.lastreviewed: 05/01/2024

---

# Enable multitenant scenarios for Azure Site Recovery

On target Azure Stack Hub, the Azure Site Recovery service has a Microsoft Entra ID application requirement which is used to access resources, in the target subscription, to replicate and failover VMs. The steps in this article are focused only on the Target Azure Stack Hub, when Azure Site Recovery is used in multitenant type deployments.

This required application is created in the Azure Stack Hub home Microsoft Entra ID tenant. When Azure Stack Hub is used in a multitenant scenario (that is, multiple Microsoft Entra ID tenants on the same Azure Stack Hub stamp that is used as the Site Recovery target), and the target subscription uses a Microsoft Entra ID tenant other than the home tenant, the Site Recovery service principal must create a service principal in the target tenant. The service principal isn't created automatically for any Microsoft Entra ID tenant except the home directory (and in the home directory, it's done automatically). The Azure Stack Hub Operator must run this command on each respective Microsoft Entra ID tenant, or provide this command to each of their Microsoft Entra ID tenant admins, in order for them to run it in their respective Microsoft Entra ID tenant.

## Process overview

The overall process follows these steps:

1. Identify the Azure Site Recovery application ID.
1. Enable multitenancy for the Site Recovery application.
1. Create the service principal in each Microsoft Entra ID tenant.
1. Register the namespace `Microsoft.DataReplication` in each user subscription for the EntraID tenants.

## Identify the Azure Site Recovery application ID

The first step is to identify the application ID used by Azure Site Recovery. This ID is automatically configured in the home directory. There are several ways to retrieve the app ID.

### Identify the AppID directly

1. Go to the Azure portal, select the Azure Stack Hub home directory, and navigate to **AAD - Application registration**.
1. In **All applications**, search for **Azure Stack - Site Recovery**:

   :::image type="content" source="media/site-recovery-enable-multi-tenant/all-applications.png" alt-text="Screenshot of portal page showing all applications." lightbox="media/site-recovery-enable-multi-tenant/all-applications.png":::

1. The application ID is shown in the **Overview** page.

   :::image type="content" source="media/site-recovery-enable-multi-tenant/application-id.png" alt-text="Screenshot of portal page showing application ID." lightbox="media/site-recovery-enable-multi-tenant/application-id.png":::

   > [!NOTE]
   > If you have multiple Azure Stack Hub stamps in same Microsoft Entra ID tenant, each stamp has an application ID with the same name. You must find the one in which the **Application ID URL** ends with the stamp's deployment ID. Alternatively, you can check the **Manifest** for the **createDateTime** tab, which needs to be the same as the Site Recovery installation time of the respective deployment.

### Retrieve the application ID from the home directory

In the user portal, in the home directory of Azure Stack Hub, check any subscription in which you registered the **Microsoft.DataReplication** namespace. In the **access control (IAM)** section of this subscription, find an application named **Azure Stack - Site Recovery**. You can select the application to see its **APP ID**. This delegation is done automatically for the home directory:

:::image type="content" source="media/site-recovery-enable-multi-tenant/subscription-properties.png" alt-text="Screenshot of portal page showing subscription properties." lightbox="media/site-recovery-enable-multi-tenant/subscription-properties.png":::

## Make the Site Recovery application multitenant

In the Azure portal, navigate to Microsoft Entra ID of the Azure Stack Hub home directory, and find the **Application registration**. In **All applications**, search for **Azure Stack - Site Recovery** or the **APP ID** identified in the previous step. Select the application and go to the **Authentication** section. Select **Accounts in any organizational directory (Any Azure AD directory - Multitenant)**, then select **Save**.

:::image type="content" source="media/site-recovery-enable-multi-tenant/authentication.png" alt-text="Screenshot of portal page showing authentication." lightbox="media/site-recovery-enable-multi-tenant/authentication.png":::

## Create a service principal

> [!NOTE]
> Perform this step for each guest directory of Azure Stack Hub in which you plan to deploy Azure Site Recovery.

The process to create a service principal uses the guest tenant ID (for each respective guest directory in which you plan to activate Azure Site Recovery) and the application ID identified previously.

1. Sign in to Azure:

    ```azurecli
    az login -t <guest-tenant-id> 
    ```

1. Run the following command to create a service principal:

   ```azurecli
    az ad sp create --id <application-id>
    ```

   :::image type="content" source="media/site-recovery-enable-multi-tenant/service-principal-output.png" alt-text="Screenshot showing service principal creation output." lightbox="media/site-recovery-enable-multi-tenant/service-principal-output.png":::

## Register provider

The next step is to register the namespace **Microsoft.DataReplication** to each Azure Stack Hub user-subscription you want to use as Azure Site Recovery target subscription.

> [!NOTE]
> If you tried to register this namespace following the previous steps, it likely failed with a **Deployment failed** message. In that case, follow the previous steps, and then try to re-register the namespace. This should complete successfully once you complete these steps.

In the Azure Stack Hub portal, in the subscription blade, find **Microsoft.DataReplication** in the **Resource provider** section, and select **Register**.

## Next steps

[Azure Site Recovery overview](azure-site-recovery-overview.md)
[Protect Virtual Machines](protect-virtual-machines.md)
