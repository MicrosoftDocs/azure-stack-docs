---
title: Perform workload cluster backup or restore using Velero and Azure Blob storage on Azure Stack HCI and Windows Server
description: Learn how to back up and restore workload clusters using Velero and Azure Blob storage on AKS on Azure Stack HCI and Windows Server.
author: sethmanheim
ms.topic: how-to
ms.date: 05/16/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: scooley

# Intent: As an IT Pro, I want to learn how to perform a workload cluster backup or restore so I can recover from a failure or disaster.   
# Keyword: workload cluster backup restore Velero Azure Blob 

---

# Perform workload cluster backup or restore using Velero and Azure Blob storage

You can create a workload cluster backup or restore from a backup on Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server workload clusters using [Velero](https://velero.io/docs) and Azure Blob as the storage. Velero is an open-source community standard tool you can use to back up and restore Kubernetes cluster objects and persistent volumes. It supports several [storage providers](https://velero.io/docs/main/supported-providers/) to store backups.

If a workload cluster crashes and fails to recover, you can use a Velero backup to restore its contents and internal API objects to a new cluster.

## Deploy and configure Velero

Use the following steps to deploy and configure Velero:

1. [Install the Velero CLI on your workstation](https://velero.io/docs/v1.6/basic-install/#install-the-cli). On a Windows machine, you can use [Chocolatey](https://chocolatey.org/install) to install the [Velero client](https://chocolatey.org/packages/velero):

   ```powershell
   choco install velero
   ```

2. [Set up Azure storage account and blob container](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#setup-azure-storage-account-and-blob-container).

   You need an active Azure subscription to create an Azure storage account and the blob container as Velero requires both to store backups. If you'd prefer to use a different Azure subscription than the one used when creating your backups, you can change the Azure subscription. By default, Velero stores backups in the same subscription as your VMs and disks and doesn't allow you to restore backups to a resource group in a different subscription. To enable backups and restore across subscriptions, you need to specify the subscription ID that you want to use.

   To switch to the Azure subscription you want to create the backups on, use the [`az account`](/cli/azure/account) PowerShell command.

   First, find the name of the subscription ID:

   ```azurecli
   AZURE_BACKUP_SUBSCRIPTION_NAME=<NAME_OF_TARGET_SUBSCRIPTION>
   AZURE_BACKUP_SUBSCRIPTION_ID=$(az account list --query="[?name=='$AZURE_BACKUP_SUBSCRIPTION_NAME'].id | [0]" -o tsv)
   ```

   Second, set a subscription to be the current active subscription:

   ```azurecli
   az account set -s $AZURE_BACKUP_SUBSCRIPTION_ID
   ```
     
   Next, create a resource group for the backups storage account, run the command below (changing the location as needed). The example shows the storage account created in a separate `Velero_Backups` resource group.
   
   ```azurecli
   AZURE_BACKUP_RESOURCE_GROUP=Velero_Backups
   az group create -n $AZURE_BACKUP_RESOURCE_GROUP --location WestUS
   ```

   You need to create the storage account with a globally unique ID since this is used for DNS. The sample script below generates a random name using `uuidgen`, but you can choose any name you want as long as you follow the [Azure naming rules for storage accounts](/azure/azure-resource-manager/management/resource-name-rules). The storage account is created with encryption for data at rest capabilities (Microsoft-managed keys) and is configured to allow access only through HTTPS.

   To create the storage account, run the following command:

   ```azurecli
   AZURE_STORAGE_ACCOUNT_ID="velero$(uuidgen | cut -d '-' -f5 | tr '[A-Z]' '[a-z]')"
   az storage account create \
      --name $AZURE_STORAGE_ACCOUNT_ID \
      --resource-group $AZURE_BACKUP_RESOURCE_GROUP \
      --sku Standard_GRS \
      --encryption-services blob \
      --https-only true \
      --kind BlobStorage \
      --access-tier Hot
   ```
   
   Finally, create the blob container named `velero`. You can choose a different name, but it should preferably be unique to a single Kubernetes cluster.
   
   ```azurecli
   BLOB_CONTAINER=velero
   az storage container create -n $BLOB_CONTAINER --public-access off --account-name $AZURE_STORAGE_ACCOUNT_ID
   ```

3. [Set permissions for Velero](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#set-permissions-for-velero) and create a service principal.

   First, obtain your Azure account subscription ID and tenant ID by running the following command:

   ```azurecli
   AZURE_SUBSCRIPTION_ID=`az account list --query '[?isDefault].id' -o tsv`
   AZURE_TENANT_ID=`az account list --query '[?isDefault].tenantId' -o tsv`
   ```

   Next, create a service principal with the `Contributor` role. This role has subscription-wide access, so you should protect this credential. When you create the service principal, let the CLI generate a password for you and make sure to capture the password.

   If you use Velero to back up multiple clusters with multiple blob containers, it's recommended that you create a unique username per cluster rather than the default name `velero`.

   > [!NOTE]
   > If you're using a different subscription for backups and cluster resources, make sure to specify both subscriptions in the `az` command using `--scopes`.

   ```azurecli
   AZURE_CLIENT_SECRET=`az ad sp create-for-rbac --name "velero" --role "Contributor" --scopes /subscriptions/<subscription_id> --query 'password' -o tsv \
   --scopes  /subscriptions/$AZURE_SUBSCRIPTION_ID[ /subscriptions/$AZURE_BACKUP_SUBSCRIPTION_ID]`
   ```

   Ensure that the value for `--name` doesn't conflict with other service principals and app registrations.

   After creating the service principal, obtain the client ID by running the following command:

   ```azurecli
   AZURE_CLIENT_ID=`az ad sp list --display-name "velero" --query '[0].appId' -o tsv`
   ```

   Finally, create a file that contains all the relevant environment variables. The command looks like the following example:

      ```bash
      cat << EOF  > ./credentials-velero
      AZURE_SUBSCRIPTION_ID=${AZURE_SUBSCRIPTION_ID}
      AZURE_TENANT_ID=${AZURE_TENANT_ID}
      AZURE_CLIENT_ID=${AZURE_CLIENT_ID}
      AZURE_CLIENT_SECRET=${AZURE_CLIENT_SECRET}
      AZURE_RESOURCE_GROUP=${AZURE_RESOURCE_GROUP}
      AZURE_CLOUD_NAME=AzurePublicCloud
      EOF
      ```

4. [Install and start Velero](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#install-and-start-velero).

   Install Velero, including all the prerequisites, on the cluster, and then start the deployment. The deployment creates a namespace called `velero` and places a deployment named `velero` in it.

   To back up Kubernetes volumes at the file system level, use [Restic](https://velero.io/docs/v1.6/restic/) and make sure to add `--use-restic`. Currently, AKS on Azure Stack HCI and Windows Server doesn't support volume snapshots.

   ```powershell
   velero install \
      --provider azure \
      --plugins velero/velero-plugin-for-microsoft-azure:v1.3.0 \
      --bucket $BLOB_CONTAINER \
      --secret-file ./credentials-velero \
      --backup-location-config resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,storageAccount=$AZURE_STORAGE_ACCOUNT_ID[,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION_ID] \
      --use-restic
   ```

5. Check whether the Velero service is running properly by running the following command:

   ```powershell
   kubectl -n velero get pods
   kubectl logs deployment/velero -n velero
   ```

## Use Velero to create a workload cluster backup

You can back up or restore all objects in your cluster, or you can filter objects by type, namespace, or label.

To run a basic on-demand backup of your cluster:

```powershell
velero backup create <BACKUP-NAME> --default-volumes-to-restic
```

To check the progress of a backup:

```powershell
velero backup describe <BACKUP-NAME>
```

After following the instructions above, you can view the backup in your Azure storage account under the blob container that you created.

## Use Velero to restore a workload cluster

You must first create a new cluster to restore to since you can't restore a cluster backup to an existing cluster. The restore operation allows you to restore all of the objects and persistent volumes from a previously created backup. You can also restore only a filtered subset of objects and persistent volumes. 

On the destination cluster where you want to restore the backup, run the following steps:

1. [Deploy and configure Velero](#deploy-and-configure-velero) using the same Azure credentials as you did for the source cluster.

2. Make sure that the Velero Backup object is created by running the following command. Velero resources are synchronized with the backup files in cloud storage.

   ```powershell
   velero backup describe <BACKUP-NAME>
   ```

3. Once you've confirmed that the right backup (`<BACKUP-NAME>`) is available, you can restore everything with the following command:

   ```powershell
   velero restore create --from-backup <BACKUP-NAME>
   ```

## Uninstall Velero

If you would like to completely uninstall Velero from your cluster, the following commands will remove all resources created by `velero install`:

```powershell
kubectl delete namespace/velero clusterrolebinding/velero
kubectl delete crds -l component=velero
```

## Additional notes

- Velero on Windows: Velero doesn't officially support Windows. In testing, the Velero team was able to back up only stateless Windows applications. [Restic integration](https://velero.io/docs/v1.6/restic/) and backups of stateful applications or persistent volumes aren't supported.

- Velero CLI help: To see all options associated with a specific command, use the `--help` flag with the command. For example, `velero restore create --help` shows all options associated with the `velero restore create` command. Or, to list all options of `velero restore`, run `velero restore --help`:

  ```output
    velero restore [command]
    Available Commands:
    create      Create a restore
    delete      Delete restores
    describe    Describe restores
    get         Get restores
    logs        Get restore logs
  ```

## References

[How Velero Works](https://velero.io/docs/v1.6/how-velero-works/)
[Restic integration](https://velero.io/docs/v1.6/restic/)
