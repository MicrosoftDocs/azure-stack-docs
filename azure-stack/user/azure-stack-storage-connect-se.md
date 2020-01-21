---
title: Connect Storage Explorer to an Azure Stack Hub subscription or a storage account | Microsoft Docs
description: Learn how to connect Storage Explorer to an  Azure Stack Hub subscription
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: conceptual
ms.date: 11/11/2019
ms.author: mabrigg
ms.reviewer: xiaofmao
ms.lastreviewed: 11/11/2019

---
# Connect Storage Explorer to an Azure Stack Hub subscription or a storage account

In this article, you'll learn how to connect to your Azure Stack Hub subscriptions and storage accounts using [Azure Storage Explorer](https://docs.microsoft.com/azure/vs-azure-tools-storage-manage-with-storage-explorer). Storage Explorer is a standalone app that enables you to easily work with Azure Stack Hub storage data on Windows, macOS, and Linux.

> [!NOTE]  
> There are several tools available to move data to and from Azure Stack Hub storage. For more information, see [Data transfer tools for Azure Stack Hub storage](azure-stack-storage-transfer.md).

If not yet installed, [download Storage Explorer](https://www.storageexplorer.com/) and install it.

After you connect to an Azure Stack Hub subscription or storage account, you can use the [Azure Storage Explorer articles](/azure/vs-azure-tools-storage-manage-with-storage-explorer) to work with your Azure Stack Hub data. 

## Prepare for connecting to Azure Stack Hub

You need direct access to Azure Stack Hub or a VPN connection for Storage Explorer to access the Azure Stack Hub subscription. To learn how to set up a VPN connection to Azure Stack Hub, see [Connect to Azure Stack Hub with VPN](../asdk/asdk-connect.md#connect-to-azure-stack-using-vpn).

> [!Note]  
> For the ASDK, if you're connecting to your ASDK via VPN, don't use the root certificate (CA.cer) that was created during the VPN setup process.  This is a DER-encoded certificate and it won't allow Storage Explorer to retrieve your Azure Stack Hub subscriptions. Use the following steps to export a Base-64 encoded certificate to use with Storage Explorer.

For integrated systems that are disconnected and for the ASDK, the recommendation is to use an internal enterprise Certificate Authority to export the root certificate in a Base-64 format and then import it into Azure Storage Explorer.  

### Export and then import the Azure Stack Hub certificate

Export and then import Azure Stack Hub certificate for disconnected integrated systems and for the ASDK. For connected integrated systems, the certificate is publicly signed and this step isn't necessary.

1. Open `mmc.exe` on an Azure Stack Hub host machine, or a local machine with a VPN connection to Azure Stack Hub. 

2. In **File**, select **Add/Remove Snap-in**. Select **Certificates** in Available snap-ins. 

3. Select **Computer account**, and then select **Next**. Select **Local computer**, and then select **Finish**.

4.  Under **Console Root\Certificated (Local Computer)\Trusted Root Certification Authorities\Certificates** find **AzureStackSelfSignedRootCert**.

    ![Load the Azure Stack Hub root certificate through mmc.exe](./media/azure-stack-storage-connect-se/add-certificate-azure-stack.png)

5. Right-click the certificate, select **All Tasks** > **Export**, and then follow the instructions to export the certificate with **Base-64 encoded X.509 (.CER)**.

    The exported certificate will be used in the next step.

6. Start Storage Explorer. If you see the **Connect to Azure Storage** dialog box, cancel it.

7. On the **Edit** menu, select **SSL Certificates**, and then select **Import Certificates**. Use the file picker dialog box to find and open the certificate that you exported in the previous step.

    After importing the certificate, you're prompted to restart Storage Explorer.

    ![Import the certificate into Storage Explorer](./media/azure-stack-storage-connect-se/import-azure-stack-cert-storage-explorer.png)

8. After Storage Explorer restarts, select the **Edit** menu, and check to see if **Target Azure Stack Hub APIs** is selected. If it isn't, select **Target Azure Stack Hub**, and then restart Storage Explorer for the change to take effect. This configuration is required for compatibility with your Azure Stack Hub environment.

    ![Ensure Target Azure Stack Hub is selected](./media/azure-stack-storage-connect-se/target-azure-stack.png)

## Connect to an Azure Stack Hub subscription with Azure AD

Use the following steps to connect Storage Explorer to an Azure Stack Hub subscription, which belongs to an Azure Active Directory (Azure AD) account.

1. In the left pane of Storage Explorer, select **Manage Accounts**.  
    All the Microsoft subscription that you signed in are displayed.

2. To connect to the Azure Stack Hub subscription, select **Add an account**.

    ![Add an Azure Stack Hub account](./media/azure-stack-storage-connect-se/add-azure-stack-account.png)

3. In the Connect to Azure Storage dialog box, under **Azure environment**, select **Azure**, **Azure China 21Vianet**, **Azure Germany**, **Azure US Government**, or **Add New Environment**. This depends on the Azure Stack Hub account being used. Select **Sign in** to sign in with the Azure Stack Hub account associated with at least one active Azure Stack Hub subscription.

    ![Connect to Azure storage](./media/azure-stack-storage-connect-se/azure-stack-connect-to-storage.png)

4. After you successfully sign in with an Azure Stack Hub account, the left pane is populated with the Azure Stack Hub subscriptions associated with that account. Select the Azure Stack Hub subscriptions that you want to work with, and then select **Apply**. (Selecting or clearing the **All subscriptions** check box toggles selecting all or none of the listed Azure Stack Hub subscriptions.)

    ![Select the Azure Stack Hub subscriptions after filling out the Custom Cloud Environment dialog box](./media/azure-stack-storage-connect-se/select-accounts-azure-stack.png)

    The left pane displays the storage accounts associated with the selected Azure Stack Hub subscriptions.

    ![List of storage accounts including Azure Stack Hub subscription accounts](./media/azure-stack-storage-connect-se/azure-stack-storage-account-list.png)

## Connect to an Azure Stack Hub subscription with AD FS account

> [!Note]  
> The Azure Federated Service (AD FS) sign-in experience supports Storage Explorer 1.2.0 or newer versions with Azure Stack Hub 1804 or newer update.
Use the following steps to connect Storage Explorer to an Azure Stack Hub subscription which belongs to an AD FS account.

1. Select **Manage Accounts**. The explorer lists the Microsoft subscriptions that you signed in to.
2. Select **Add an account** to connect to the Azure Stack Hub subscription.

    ![Add an account - Storage Explorer](media/azure-stack-storage-connect-se/add-an-account.png)

3. Select **Next**. In the Connect to Azure Storage dialog box, under **Azure environment**, select **Use Custom Environment**, then click **Next**.

    ![Connect to Azure Storage](media/azure-stack-storage-connect-se/connect-to-azure-storage.png)

4. Enter the required information of Azure Stack Hub custom environment. 

    | Field | Notes |
    | ---   | ---   |
    | Environment name | The field can be customized by user. |
    | Azure Resource Manager endpoint | The samples of Azure Resource Manager resource endpoints of Azure Stack Development Kit.<br>For operators: https://adminmanagement.local.azurestack.external <br> For users: https://management.local.azurestack.external |

    If you're working on Azure Stack Hub integrated system and don't know your management endpoint, contact your operator.

    ![Add an account - Custom Environments](./media/azure-stack-storage-connect-se/custom-environments.png)

5. Select **Sign in** to connect to the Azure Stack Hub account that's associated with at least one active Azure Stack Hub subscription.



6. Select the Azure Stack Hub subscriptions that you want to work with, then select **Apply**.

    ![Account management](./media/azure-stack-storage-connect-se/account-management.png)

    The left pane displays the storage accounts associated with the selected Azure Stack Hub subscriptions.

    ![List of associated subscriptions](./media/azure-stack-storage-connect-se/list-of-associated-subscriptions.png)

## Connect to an Azure Stack Hub storage account

You can also connect to an Azure Stack Hub storage account using storage account name and key pair.

1. In the left pane of Storage Explorer, select Manage Accounts. All the Microsoft accounts that you signed into are displayed.

    ![Add an account - Storage Explorer](./media/azure-stack-storage-connect-se/azure-stack-sub-add-an-account.png)

2. To connect to the Azure Stack Hub subscription, select **Add an account**.

    ![Add an account - Connect to Azure Storage](./media/azure-stack-storage-connect-se/azure-stack-use-a-storage-and-key.png)

3. In the Connect to Azure Storage dialog box, select **Use a storage account name and key**.

4. Input your account name in the **Account name** and paste the account key into the **Account key** text box. Then, select **Other (enter below)** in **Storage endpoints domain** and input the Azure Stack Hub endpoint.

    An Azure Stack Hub endpoint includes two parts: the name of a region and the Azure Stack Hub domain. In the Azure Stack Development Kit, the default endpoint is **local.azurestack.external**. Contact your cloud admin if you're not sure about your endpoint.

    ![Attach name and key](./media/azure-stack-storage-connect-se/azure-stack-attach-name-and-key.png)

5. Select **Connect**.
6. After the storage account is successfully attached, the storage account is displayed with (**External, Other**) appended to its name.

    ![VMWINDISK](./media/azure-stack-storage-connect-se/azure-stack-vmwindisk.png)

## Next steps

* [Get started with Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer)
* [Azure Stack Hub storage: differences and considerations](azure-stack-acs-differences.md)
* To learn more about Azure storage, see [Introduction to Microsoft Azure storage](/azure/storage/common/storage-introduction)
