---
title: Back up and restore workload clusters using Velero and Azure Blob storage in Azure Kubernetes Service (AKS) on Azure Stack HCI
description: Learn how to back up and restore workload clusters using Velero and Azure Blob storage on AKS on Azure Stack HCI.
author: scooley
ms.topic: how-to
ms.date: 11/16/2021
ms.author: scooley
---

# Back up and restore workload clusters using Velero and Azure Blob storage

You can use [Velero](https://velero.io/docs) to back up and restore AKS on Azure Stack HCI workload clusters. Velero is an open-source community standard tool for backing up and restoring Kubernetes cluster objects and persistent volumes, and it supports a variety of [storage providers](https://velero.io/docs/main/supported-providers/) to store its backups.

If an workload cluster crashes and fails to recover, the infrastructure administrator can use a Velero backup to restore its contents and internal API objects to a new cluster.

This topic describes the steps required to back up and restore of AKS on Azure Stack HCI clusters using Velero and Azure blob as the storage.

## Deploy and configure Velero

Use the following steps to deploy Velero:

1. [Install the Velero CLI on your workstation](https://velero.io/docs/v1.6/basic-install/#install-the-cli).

   On Windows, you can use [Chocolatey](https://chocolatey.org/install) to install the [velero](https://chocolatey.org/packages/velero) client:

   ```powershell
   choco install velero
   ```

2. [Set up Azure storage account and blob container](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#setup-azure-storage-account-and-blob-container).

   You have the option to change the Azure subscription that was used when creating your backups to another subscription if you'd prefer to use a different one. By default, Velero stores backups in the same subscription as your VMs and disks and doesn't allow you to restore backups to a resource group in a different subscription. To enable backups and restore across subscriptions, you need to specify the subscription ID that you want to use.

   To switch to the subscription you want the backups to be created in, use [`az account`](/cli/azure/account?view=azure-cli-latest) PowerShell command.

   First, find the subscription ID by name:

   ```bash
   AZURE_BACKUP_SUBSCRIPTION_NAME=<NAME_OF_TARGET_SUBSCRIPTION>
   AZURE_BACKUP_SUBSCRIPTION_ID=$(az account list --query="[?name=='$AZURE_BACKUP_SUBSCRIPTION_NAME'].id | [0]" -o tsv)
   ```

   Second, set a subscription to be the current active subscription:

   ```bash
   az account set -s $AZURE_BACKUP_SUBSCRIPTION_ID
   ```

   Use the active subscription to create an Azure storage account and blob container. Velero requires a storage account and a blob container in which to store backups. 
     
   To create a resource group for the backups storage account, run the command below (changing the location as needed). The example shows the storage account created in a separate `Velero_Backups` resource group.
   
   ```bash
   AZURE_BACKUP_RESOURCE_GROUP=Velero_Backups
   az group create -n $AZURE_BACKUP_RESOURCE_GROUP --location WestUS
   ```

   You need to create the storage account with a globally unique ID since this is used for DNS. The sample script below generates a random name using `uuidgen`, but you can choose a name you want as long as you follow the [Azure naming rules for storage accounts](/azure/azure-resource-manager/management/resource-name-rules). The storage account is created with encryption for data at rest capabilities (Microsoft-managed keys) and is configured to allow access only through HTTPS.

   To create the storage account, run the following command.

   ```bash
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
   
   Next, create the blob container named `velero`. You can choose a different name, but it should preferably be unique to a single Kubernetes cluster. See the [FAQ][11] for more details.
   
   ```bash
   BLOB_CONTAINER=velero
   az storage container create -n $BLOB_CONTAINER --public-access off --account-name $AZURE_STORAGE_ACCOUNT_ID
   ```

3. [Set permissions for Velero](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#set-permissions-for-velero).

   **Create a service principal**

   - Obtain your Azure account subscription ID and tenant ID by running the following command:

     ```bash
     AZURE_SUBSCRIPTION_ID=`az account list --query '[?isDefault].id' -o tsv`
     AZURE_TENANT_ID=`az account list --query '[?isDefault].tenantId' -o tsv`
     ```

   - Create a service principal with `Contributor` role. This will have subscription-wide access, so you should protect this credential.

     If you use Velero to back up multiple clusters with multiple blob containers, it's recommended that you create a unique username per cluster rather than the default name `velero`.

     Create the service principal and let the CLI generate a password for you. Make sure to capture the password.

     > [!NOTE]
     > (Optional) If you're using a different subscription for backups and cluster resources, make sure to specify both subscriptions in the `az` command using `--scopes`.

       ```bash
       AZURE_CLIENT_SECRET=`az ad sp create-for-rbac --name "velero" --role "Contributor" --query 'password' -o tsv \
       --scopes  /subscriptions/$AZURE_SUBSCRIPTION_ID[ /subscriptions/$AZURE_BACKUP_SUBSCRIPTION_ID]`
       ```

       Ensure that the value for `--name` does not conflict with other service principals and app registrations.

       After creating the service principal, obtain the client ID by running the following command:

       ```bash
       AZURE_CLIENT_ID=`az ad sp list --display-name "velero" --query '[0].appId' -o tsv`
       ```

   - Next, create a file that contains all the relevant environment variables. The command looks like the following example:

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

   Install Velero, including all the prerequisites, into the cluster and then start the deployment. The deployment creates a namespace called `velero` and places a deployment named `velero` in it.

   Make sure to add `--use-restic` to enable backup of Kubernetes volumes at the filesystem level, using [Restic](https://velero.io/docs/v1.6/restic/). AKS on Azure Stack HCI does not currently support volumes snapshots.

   ```bash
   velero install \
       --provider azure \
       --plugins velero/velero-plugin-for-microsoft-azure:v1.3.0 \
       --bucket $BLOB_CONTAINER \
       --secret-file ./credentials-velero \
       --backup-location-config resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,storageAccount=$AZURE_STORAGE_ACCOUNT_ID[,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION_ID] \
       --use-restic
   ```

5. Check whether the Velero service is running properly by running the following command:

     ```
     kubectl -n velero get pods
     kubectl logs deployment/velero -n Velero
     ```

## Use Velero to back up a workload cluster

You can back up or restore all objects in your cluster, or you can filter objects by type, namespace, or label.

To run a basic on-demand backup of your cluster:

```
velero backup create <BACKUP-NAME> --default-volumes-to-restic
```

To check progress of a backup:

```
velero backup describe <BACKUP-NAME>
```

If you followed the instructions above, you can now view your backup in your Azure storage account under the blob/container that you created.

## Use Velero to restore a workload cluster

You must first create a new cluster to restore to; you cannot restore a cluster backup to an existing cluster. The restore operation allows you to restore all of the objects and persistent volumes from a previously created backup. You can restore only a filtered subset of objects and persistent volumes. 

On the destination cluster where you want to restore the backup to, run the following steps:

1. Deploy Velero (see instructions above). Use the same Azure credentials as you did for the source cluster.

2. Make sure that the Velero Backup object is created. Velero resources are synchronized with the backup files in cloud storage.

   ```
   velero backup describe <BACKUP-NAME>
   ```

3. Once you have confirmed that the right backup (`<BACKUP-NAME>`) is now present, you can restore everything with the following command:

   ```
   velero restore create --from-backup <BACKUP-NAME>
   ```

## Uninstall Velero

If you would like to completely uninstall Velero from your cluster, the following commands will remove all resources created by `velero install`:

```
kubectl delete namespace/velero clusterrolebinding/velero
kubectl delete crds -l component=velero
```

## Additional notes

- Velero on Windows: Velero does not officially support Windows. In testing, the Velero team was able to backup only stateless Windows applications. [Restic integration](https://velero.io/docs/v1.6/restic/) and backups of stateful applications or persistent volumes are not supported.

- Velero CLI help: To see all options associated with a specific command, provide the `–help` flag with that command. For example, `velero restore create --help` shows all options associated with the **create** command.

  To list all options of restore, use `velero restore --help`:

  ```
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