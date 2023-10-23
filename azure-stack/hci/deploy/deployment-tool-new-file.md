---
title: Deploy Azure Stack HCI interactively via a new configuration file (preview)
description: Learn how to deploy Azure Stack HCI interactively using a new configuration file (preview).
author: alkohli
ms.topic: how-to
ms.date: 06/28/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Deploy Azure Stack HCI interactively (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

After you've successfully installed the operating system, you're ready to set up and run the deployment tool. This method of deployment leads you through a guided UI experience to create a configuration (answer) file interactively that is saved.

You can deploy both single server and multi-node clusters using this procedure.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install version 22H2 OS](deployment-tool-install-os.md) on each server.
- [Set up the first server](deployment-tool-set-up-first-server.md) in your Azure Stack HCI cluster.
- If deploying as a part of single server recovery, make sure to:
    - Not delete the existing Active Directly OU. If the volumes are encrypted, deletion of the existing OU causes the loss of BitLocker recovery keys.
    - Use the same parameters with which the server was imaged previously.
    - Select the **Use existing drives** option. This option unlocks the encrypted drives using the protector keys stored in your Active Directory.

## Run the deployment tool

This procedure collects deployment parameters from you interactively and saves them to a configuration file as you step through the deployment UI. You deploy single-node and multi-node clusters similarly.

If you want to use an existing configuration file you have previously created, see [Deploy using a configuration file](deployment-tool-existing-file.md).

1. Open a web browser from a computer that has network connectivity to the staging server.

1. In the URL field, enter *https://your_staging-server-IP-address*.

1. Accept the security warning displayed by your browser - this is shown because we're using a self-signed certificate.

1. Authenticate using the local administrator credentials of your staging server.

1. In the deployment UI, on the **Get started deploying Azure Stack** page, select **Create a new config file**, then select either **One server** or **Multiple servers** as applicable for your deployment.

      :::image type="content" source="media/deployment-tool/new-file/deploy-new-get-started.png" alt-text="Screenshot of the Deployment Get Started page." lightbox="media/deployment-tool/new-file/deploy-new-get-started.png":::

### Step 1: Initial configuration

1. On step **1.1 Provide registration details**, enter the following details to authenticate your cluster with Azure:

    1. Select the **Azure Cloud** to be used. In this release, only Azure public cloud is supported.

    1. Under **Authentication**, select **Copy** to copy the authentication code for your Azure cloud:
    
    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-1-authentication-code.png" alt-text="Screenshot of the Deployment step 1.1 Provide registration details - with authentication code." lightbox="media/deployment-tool/new-file/deploy-new-step-1-authentication-code.png":::
    
    c. Select **Sign in**. A new browser window opens. Enter the code that you copied earlier and then provide your Azure credentials. Multi-factor authentication (MFA) is supported.
    
    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-6c-enter-code.png" alt-text="Screenshot of the Deployment step 1.1 Provide registration details - copy authentication code page." lightbox="media/deployment-tool/new-file/deploy-new-step-6c-enter-code.png":::

    d. Go back to the deployment screen and provide the Azure registration details:
    
    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-1-registration-details.png" alt-text="Screenshot of the Deployment step 1.1 Provide registration details page." lightbox="media/deployment-tool/new-file/deploy-new-step-1-registration-details.png":::

    e. From the dropdown, select the **Microsoft Entra ID** or the tenant ID.

    f. Select the associated subscription. This subscription is used to create the cluster resource, register it with Azure Arc and set up billing.

    > [!NOTE]
    > Make sure that you are a [user access administrator](/azure/role-based-access-control/built-in-roles#user-access-administrator) on this subscription. This will allow you to manage access to Azure resources, specifically to Arc-enable each server of an Azure Stack HCI cluster.

    g. Select an existing **Azure resource group** from the dropdown to associate with the cluster resource. To create a new resource group, leave the field empty.

    h. Select an **Azure region** from the dropdown or leave the field empty to use the default.

1. On step **1.2 Configure privacy**, set the privacy settings as they apply to your organization.

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-1-privacy.png" alt-text="Screenshot of the Deployment step 1.1 Configure privacy page." lightbox="media/deployment-tool/new-file/deploy-new-step-1-privacy.png":::

1. On step **1.3 Add servers**, follow these steps:

    1. Provide the local administrator credentials. Make sure that the local administrator credentials are identical across all the servers.

    1. Enter the IP address of each server. Add the servers in the correct sequence, beginning with the first server.
    
        > [!NOTE]
        > The first server is the staging server from which you are currently running the deployment tool.

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-1-add-servers.png" alt-text="Screenshot of the Deployment step 1.2 Add servers page." lightbox="media/deployment-tool/new-file/deploy-new-step-1-add-servers.png":::

1. On step **1.4 Set cluster security**, select **Recommended security settings** to use the recommended default settings:

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-1-security-default.png" alt-text="Screenshot of the Deployment step 1.4 Set cluster security default page." lightbox="media/deployment-tool/new-file/deploy-new-step-1-security-default.png":::

    or select **Customized security settings:**

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-1-security-custom.png" alt-text="Screenshot of the Deployment step 1.4 Set cluster security custom page." lightbox="media/deployment-tool/new-file/deploy-new-step-1-security-custom.png":::

    For more information on the individual security settings, see:
    - [App control (WDAC) enforced on host](/windows/security/threat-protection/windows-defender-application-control/wdac-and-applocker-overview#windows-defender-application-control).
    - [BitLocker for OS boot volume and BitLocker for data volumes](/windows/security/information-protection/bitlocker/bitlocker-overview).
    - [SMB Signing Default instance](/troubleshoot/windows-server/networking/overview-server-message-block-signing).
    - [SMB Encryption E-W Cluster traffic](/windows-server/storage/file-server/smb-security#smb-encryption).

1. On step **1.5 Join a domain**, enter the following:
    1. Provide your **Active Directory domain** name. For example, this would be the fully qualified domain name in `Contoso.com` format.
    1. Enter the **Computer name prefix** used when you prepared the Active Directory.
    1. For **OU**, provide the full distinguished name of the organizational unit (including the domain components) that was created for the deployment. For example, the name would be `"OU=Hci001,DC=contoso,DC=com"`.
    1. Provide the **username** and the **password** for the lifecycle manager (LCM) account that was created during [Prepare the Active Directory](deployment-tool-active-directory.md) step.

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-1-join-domain-filled.png" alt-text="Screenshot of the Deployment step 1.3 Join a domain page." lightbox="media/deployment-tool/new-file/deploy-new-step-1-join-domain-filled.png":::

### Step 2: Networking

1. On step **2.1 Check network adapters**, consult with your network administrator to ensure you enter the correct network details.

    If all the network adapters do not show up and if you have not excluded those, select **Show hidden adapters**. You may also need to check the cabling and the link speeds. While the network interfaces can have identical speeds across the nodes of the cluster, any low speed switch connections could lead to a difference in the overall speed.

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-2-network-adapters.png" alt-text="Screenshot of the Deployment step 2.1 network adapters page." lightbox="media/deployment-tool/new-file/deploy-new-step-2-network-adapters.png":::

1. On step **2.2 Define network intents**, consult with your network administrator to ensure you enter the correct network details.

    When you define network intents, only the following sets of network intents are supported for this preview release:

    - one *Management + Compute* intent, one storage intent.
    - one fully converged intent that maps to *Management + Compute + Storage* intent.
    
    The networking intent should match how you've cabled your system. For this release, see the [Validated deployment network patterns](./deployment-tool-introduction.md#validated-network-topologies).

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-2-network-intents.png" alt-text="Screenshot of the Deployment step 2.2 network intents page." lightbox="media/deployment-tool/new-file/deploy-new-step-2-network-intents.png":::

1. On step **2.3 Provide storage network details**, consult with your network administrator to ensure that you enter the correct network details.

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-2-network-storage.png" alt-text="Screenshot of the Deployment step 2.3 storage network page." lightbox="media/deployment-tool/new-file/deploy-new-step-2-network-storage.png":::

1. On step **2.4 Allocate IP addresses**, enter the following input after consulting your network administrator:

    1. In this release, only the static IPs can be assigned and DHCP isn't supported.
    1. For the **Starting IP** and the **Ending IP** range, provide a minimum of 6 free, contiguous IPv4 addresses. This range excludes your host IPs. These IPs are used for infrastructure services such as clustering.
    1. Provide the **Subnet mask** and **Default gateway** for the network.
    1. Provide the IPv4 address of the **DNS servers** in your environment. DNS servers are required because they're used when your server attempts to communicate with Azure or to resolve your server by name in your network. The DNS server you configure must be able to resolve the Active Directory domain.
        
        For high availability, we recommend that you configure a preferred and an alternate DNS server.

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-2-network-ip-addresses.png" alt-text="Screenshot of the Network step 2.4 Allocate IP addresses page." lightbox="media/deployment-tool/new-file/deploy-new-step-2-network-ip-addresses.png":::

### Step 3: Cluster

For two-node clusters, you'll need to create a cluster witness. A cluster witness helps establish quorum for a two-node cluster if a node goes down. To learn about quorum, see [Understanding quorum](/windows-server/failover-clustering/manage-cluster-quorum#understanding-quorum).

You can either create a cloud witness or a file share witness:

Use a cloud witness if you have internet access and if you use an Azure Storage account to provide a vote on cluster quorum. A cloud witness uses Azure Blob Storage to read or write a blob file and then uses it to arbitrate in split-brain resolution. For more information on cloud witness, see [Deploy a cloud witness for Failover cluster](/windows-server/failover-clustering/deploy-cloud-witness).

Use a file share witness if you use a local SMB file share to provide a vote in the cluster quorum. Use a file share witness if all the servers in a cluster have spotty internet connectivity or can't use disk witness as there aren't any shared drives. For more information on file share witness, see [Deploy a file share witness for Failover cluster](/windows-server/failover-clustering/file-share-witness).

> [!NOTE]
> For single-server clusters, a witness doesn't apply, so you only need to provide a cluster name for step 3.1 below.

1. On step **3.1 Provide the cluster name**, enter the cluster name. This must be the cluster name you used when preparing Active Directory.

1. For two-node clusters, select either **Cloud witness** or **File share witness**.

1. For **Cloud witness**, do the following:
    1. Enter the Azure storage account name.
    1. Enter the Access key for the storage account.
    1. For Azure blob service endpoint type, select either **Default** or **Custom domain**.
    1. If you selected **Custom domain**, enter the domain for the blob service.
    1. When finished, select **Next: Storage**.

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-3-create-cluster-cloud-witness.png" alt-text="Screenshot of the Deployment step 3.1 create cloud witness page." lightbox="media/deployment-tool/new-file/deploy-new-step-3-create-cluster-cloud-witness.png":::

1. For **File share witness**, do the following:

   1. Enter the file share path in *//server/fileshare* format.
   1. When finished, select **Next: Storage**.

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-3-create-cluster-file-witness.png" alt-text="Screenshot of the Deployment step 3.1 create file share witness page." lightbox="media/deployment-tool/new-file/deploy-new-step-3-create-cluster-file-witness.png":::

### Step 4: Storage

- On step **4.1 Create volumes**, select the **Create workload volumes (recommended)** option to create workload volumes in addition to the infrastructure volumes used by Azure Stack HCI cluster. Choosing this option will create all the volumes with the best resiliency level.

    If you select **Create required volumes only**, you will need to create workload volumes yourselves.  

    Select the **Existing data drives** option only when you are repairing a single server.  This option unlocks the  encrypted drives using the protector keys stored in your Active Directory. 

    :::image type="content" source="media/deployment-tool/new-file/deploy-new-step-4-storage-volumes.png" alt-text="Screenshot of the Deployment step 4.1 storage volumes page." lightbox="media/deployment-tool/new-file/deploy-new-step-4-storage-volumes.png":::

    The deployment tool configures your storage according to the best practices based on the number of nodes in the cluster. The tool also configures at least one infrastructure volume that is used by the deployment orchestrator and one or multiple data volumes for your use.

    If the resiliency configuration for data volumes does not suit your applications, you can delete these volumes and create these again as per your needs.

    > [!IMPORTANT]
    > Do not delete the infrastructure volume used to store content from the Lifecycle Manager.

    Here is a table summarizing the expected resiliency configuration against the number of nodes in your cluster.

   | # Node         | Volume resiliency   | # Infrastructure volumes  | # Customer volumes  |
    |---------------|---------------------|---------------------------|---------------------|
    | Single node   | Two-way mirror      | 1                         | 1                   |
    | Two node      | Two-way mirror      | 1                         | 2                   |
    | Three node +  | Three-way mirror    | 1                         | 1 per node          |

    When finished, select **Next: Validate and Deploy** to continue.

### Step 5: Validate and Deploy

1. On step **5.1 Validate configuration**, select **Download the config file for your deployment** and then select **Validate** to start validation.

    :::image type="content" source="media/deployment-tool/new-file/deployment-step-5-validate.png" alt-text="Screenshot of the Deployment step 5.1 Validate configuration page." lightbox="media/deployment-tool/new-file/deployment-step-5-validate.png":::

1. If validation has successfully completed, you will receive confirmation. Select **Next** to continue with deployment.

    :::image type="content" source="media/deployment-tool/new-file/deployment-step-5-validate-successful.png" alt-text="Screenshot of the Deployment step 5.1 Validation successful status." lightbox="media/deployment-tool/new-file/deployment-step-5-validate-successful.png":::

    If validation fails, select **Download logs** to view validation conflict details and then select **Validate** again to rerun validation.

    :::image type="content" source="media/deployment-tool/new-file/deployment-step-5-validate-failed.png" alt-text="Screenshot of the Deployment step 5.1 Validate failed status." lightbox="media/deployment-tool/new-file/deployment-step-5-validate-failed.png":::

1. On step **5.2 Deploy the cluster**, select **Deploy**. It can take up to 1.5 hours for deployment to complete.

    > [!IMPORTANT]
    > The staging server will restart after the deployment starts.

      :::image type="content" source="media/deployment-tool/new-file/deployment-step-5-deploy-cluster.png" alt-text="Screenshot of the Deployment step 5.2 Deploy the cluster page." lightbox="media/deployment-tool/new-file/deployment-step-5-deploy-cluster.png":::

     You can monitor your deployment progress in near real time:

    :::image type="content" source="media/deployment-tool/new-file/deployment-progress.png" alt-text="Screenshot of the Monitor deployment page." lightbox="media/deployment-tool/new-file/deployment-progress.png":::

    > [!NOTE]
    > When you start the deployment, the page may not show actual progress even after the staging server has restarted. Refresh the page once using the browser refresh and then the page will automatically refresh for the remainder of the deployment.

    You can select **Download** to download deployment logs and a deployment report. Deployment logs can help you troubleshoot a failed deployment.

    :::image type="content" source="media/deployment-tool/new-file/deployment-download-config-logs-report.png" alt-text="Screenshot of the Download options that let you download config, logs, and report." lightbox="media/deployment-tool/new-file/deployment-download-config-logs-report.png":::

## Next steps

- [Validate deployment](deployment-tool-validate.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).
