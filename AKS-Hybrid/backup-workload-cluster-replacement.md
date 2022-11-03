---
title: Back up and restore target clusters using Velero
description: Learn how to back up and restore workload clusters using Velero in AKS hybrid.
author: sethmanheim
ms.topic: how-to
ms.date: 11/03/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: scooley

# Intent: As an IT Pro, I want to learn how to perform a workload cluster backup or restore so I can recover from a failure or disaster.   
# Keyword: workload cluster backup restore Velero Azure Blob MinIO

---

# Back up and restore target clusters using Velero

This article describes how to install and use Velero to back up and restore workload and target clusters using Azure Blob storage or MinIO storage for the backups.

[Velero](https://velero.io/docs) is an open-source community standard tool for backing up and restoring Kubernetes cluster objects and persistent volumes. It supports a variety of [storage providers](https://velero.io/docs/main/supported-providers/) to store its backups. If an AKS hybrid target cluster crashes and fails to recover, the infrastructure administrator can use a Velero backup to restore its contents and internal API objects to a new cluster.

You can either use Azure Blob storage or MinIO storage with Velero. Velero and Azure Blob storage will store your backups in Azure Blob. If you do not want your backups to be stored in Azure, you can use Velero and MinIO. This document will show you both methods: Velero + Azure Blob and Velero + MinIO.

> [NOTE!]
> Velero doesn't officially support Microsoft Windows. In testing, the Velero team was able to back up stateless Windows applications only. The Restic integration and backups of stateful applications or persistent volumes were not supported.

## Prerequisites

- [Install the Azure CLI](/cli/azure/install-azure-cli).
- [Install Chocolatey](https://chocolatey.org/install), which you'll' use to install the [Velero client](https://community.chocolatey.org/packages/velero), including the Velero CLI, on a Windows machine.

## Install Velero with Azure Blob storage

This section describes how to use Velero and Azure Blob storage. If you don't want to store your backups in Azure, go to [Install Velero with MiniO storage](#install-velero-with-minio-storage).

1. Open PowerShell as an administrator.

1. Log in to Azure. Run the following command to log in to Azure using Azure CLI:

   `az login --use-device-code`

1. Install the [Velero CLI](https://velero.io/docs/v1.9/basic-install/#install-the-cli) by running the following command:

   ```powershell
   choco install velero   
   ```

1. (Optional) Change to the Azure subscription you want to create your backups in.

   By default, Velero will store backups in the same Subscription as your VMs and disks and will not allow you to restore backups to a Resource Group in a different Subscription. To enable backups/restore across Subscriptions you will need to specify the Subscription ID to backup to. This step is optional and you may skip it if you are already in the subscription that you want to create your backups with.

   1. Switch to the subscription the backups should be created in.
   1. Find the Subscription ID by name.
      
      ```azurecli
      $AZURE_BACKUP_SUBSCRIPTION_NAME="<NAME_OF_TARGET_SUBSCRIPTION>"
      $AZURE_BACKUP_SUBSCRIPTION_ID=$(az account list --query="[?name=='$AZURE_BACKUP_SUBSCRIPTION_NAME'].id | [0]" -o tsv)
      ```

   1. Change the subscription:
   
      ```azurecli
      az account set -s $AZURE_BACKUP_SUBSCRIPTION_ID
      ```

### Create Azure storage account and blob container

Velero requires a storage account and blob container in which to store backups. The example below shows the storage account created in a new Velero_Backups resource group.

Because the storage account is used for DNS, it must be created with a globally unique ID. In the sample script below, we're generating a random name using `uuidgen`, but you can come up with this name in any way that you'd like, following the [Azure naming rules for storage accounts](/azure/storage/common/storage-account-overview#storage-account-name). The storage account is created with encryption at rest capabilities (Microsoft managed keys) and is configured to only allow access via HTTPS.

1. Create a resource group for the backup storage account. Change directories to your preferred location, and run the following commands:

   ```azurecli
   $AZURE_BACKUP_RESOURCE_GROUP="Velero_Backups"
   az group create -n $AZURE_BACKUP_RESOURCE_GROUP --location WestUS
   Create the storage account.
   $AZURE_STORAGE_ACCOUNT_ID="<NAME_OF_ACCOUNT_TO_ASSIGN>"

   az storage account create --name $AZURE_STORAGE_ACCOUNT_ID --resource-group $AZURE_BACKUP_RESOURCE_GROUP --sku Standard_GRS --encryption-services blob --https-only true --kind BlobStorage --access-tier Hot
   ```

1. Create the blob container named *velero*. Feel free to use a different name, preferably unique to a single Kubernetes cluster. 
   
   ```azurecli
   $BLOB_CONTAINER="velero"
   az storage container create -n $BLOB_CONTAINER --public-access off --account-name $AZURE_STORAGE_ACCOUNT_ID
   ```

### Create service principal

1. Obtain your Azure account subscription ID and tenant ID. 

   ```azurecli
   $AZURE_SUBSCRIPTION_ID=(az account list --query '[?isDefault].id' -o tsv)
   $AZURE_TENANT_ID=(az account list --query '[?isDefault].tenantId' -o tsv) 
   ```

1. Create a service principal. You have the option of creating a service principal with Contributor role or a custom role. A contributor role will have subscription-wide access, so protect this credential. If you need a less permissive role, you can use a custom role.

   **For Contributor role:**

   If you'll be using Velero to back up multiple clusters with multiple blob containers, it may be desirable to create a unique username for each cluster instead of the name ‘velero’.

   1. Create a service principal. Azure Active Directory (AAD) will generate a secret for you.

      ```azurecli
      $AZURE_CLIENT_SECRET=(az ad sp create-for-rbac --name "velero" --role "Contributor" --query 'password' -o tsv --scopes  /subscriptions/$AZURE_SUBSCRIPTION_ID)
      ```

      The secret will only be shown during this step upon service principal creation, so make sure to take note of the secret for future steps.

   1. (Optional) If you're using different subscriptions for your Velero backup files and your workload clusters, make sure to provide both subscription IDs, as in the following example:

      ```azurecli
      $AZURE_CLIENT_SECRET=(az ad sp create-for-rbac --name "velero" --role "Contributor" --query 'password' -o tsv --scopes  /subscriptions/$AZURE_SUBSCRIPTION_ID /subscriptions/$AZURE_BACKUP_SUBSCRIPTION_ID)
      ```

      > [!NOTE]
      > Ensure that the value for `--name` is unique in AAD and doesn't conflict with other service principals or app registrations.

   **For custom role:**

   If you want to assign the minimum resource provider actions, create a custom role and assign that role to the service principal.

   1. Create a file *azure-role.json* with following contents. Substitute your own custom role name and subscription ID in the file.

      ```json
      {
          "Name": <CUSTOM_ROLE_NAME>,
          "Id": null,
          "IsCustom": true,
          "Description": "Velero related permissions to perform backups, restores and deletions",
          "Actions": [
              "Microsoft.Compute/disks/read",
              "Microsoft.Compute/disks/write",
              "Microsoft.Compute/disks/endGetAccess/action",
              "Microsoft.Compute/disks/beginGetAccess/action",
              "Microsoft.Compute/snapshots/read",
              "Microsoft.Compute/snapshots/write",
              "Microsoft.Compute/snapshots/delete",
              "Microsoft.Storage/storageAccounts/listkeys/action",
              "Microsoft.Storage/storageAccounts/regeneratekey/action"
          ],
          "NotActions": [],
          "AssignableScopes": [
            "<SUBSCRIPTION_ID>"
          ]
      }
      ```

   1. Create the custom role and service principal by running this command:

      ```azurecli
      az role definition create --role-definition azure-role.json

      $AZURE_CLIENT_SECRET=(az ad sp create-for-rbac --name "velero" --role "<CUSTOM_ROLE>" --query 'password' -o tsv --scopes  /subscriptions/$AZURE_SUBSCRIPTION_ID)
      ```

      For more info about creating custom roles, see [Velero plugins for Microsoft Azure](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#specify-role).

1. After creating the service principal, obtain the service principal name, and assign that name to the client ID variable.

   ```azurecli
   $AZURE_CLIENT_ID=(az ad sp list --display-name "velero" --query '[0].appId' -o tsv)
   ```

1. The service principal will expire after a certain period of time. To find out when your service principal will expire, run the following command:

   ```azurecli
   az ad sp show --id $AZURE_CLIENT_ID
   ```

1. Create a file that contains all the variables required for the Velero installation. The command looks like the following one:

   ```
   _SUBSCRIPTION_ID=${AZURE_SUBSCRIPTION_ID}
   AZURE_TENANT_ID=${AZURE_TENANT_ID}
   AZURE_CLIENT_ID=${AZURE_CLIENT_ID}
   AZURE_CLIENT_SECRET=${AZURE_CLIENT_SECRET}
   AZURE_RESOURCE_GROUP=${AZURE_BACKUP_RESOURCE_GROUP}
   AZURE_CLOUD_NAME=AzurePublicCloud" | Out-File -FilePath ./credentials-velero.txt
   ```

   > [!IMPORTANT]
   > You should delete this file after you install Velero. The client secret is in plain text, which could pose a security risk.

   Before proceeding, verify that the file is properly formatted:
   - Remove any extra spaces or tabs.
   - Make sure the parameter names are correct.
   - The file name extension doesn't matter.

### Install and start Velero

Install Velero, including all prerequisites, on the cluster, and start the deployment. This procedure creates a namespace called *velero* and adds a deployment named *velero* to the namespace.

1. Install Velero using the `velero install` command. You'll need to make some adjustments to the example command below.

   ```powershell
   velero install --provider azure --plugins velero/velero-plugin-for-microsoft-azure:v1.5.0 --bucket $BLOB_CONTAINER --secret-file ./credentials-velero.txt --backup-location-config resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,storageAccount=$AZURE_STORAGE_ACCOUNT_ID,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION_ID --use-restic
   ```

   Before you run the command, review and adjust the following parameters as needed:

   - The command installs the Microsoft Azure plugin, which must be compatible with the Velero CLI version you're using. The example command uses Microsoft Azure plugin version 1.5.0 because we've installed the latest Velero CLI version, 1.9.0. To choose the correct version of the Microsoft Azure plugin, refer to the [compatibility matrix](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#compatibility).

   - Be sure to include `--use-restic` to enable backup of Kubernetes volumes at the file system level using Restic. Restic is used for backup of any type of Kubernetes volume. By default, Velero supports taking snapshots of persistent volumes for Amazon EBS Volumes, Azure Managed Disks, and Google Persistent Disks. In AKS-HCI, Kubernetes volumes use Cluster Shared Volume (CSV) to store data. Hence, Restic is needed for to have persistent volume snapshots. AKS-HCI currently does not support volume snapshots.

   - `subscriptionId=$AZURE_BACKUP_SUBSCRIPTION_ID` is optional. You only need to include that if Velero and the workload cluster have different subscription IDs. If not, you can remove the `subscriptionId` since the information is provided by the *credentials-velero.txt* file.

1. Check whether the Velero service is running properly by running the following commands: 

   ```powershell
   kubectl -n velero get pods
   kubectl logs deployment/velero -n velero
   ```

## Install Velero with MinIO storage

This section will show you how to use Velero with MinIO storage. If you don't want to store your backups in MinIO, go to [Set up Velero to use Azure Blob storage](#install-velero-with-azure-blob-storage).

MinIO is an object storage solution. If you do not want your backups stored in Azure Blob, you can deploy Velero with MinIO as storage.

1. Install the Velero CLI by running the following command. You'll need to [Install Chocolately](https://chocolatey.org/install) if you haven't already.

   ```powershell
   choco install velero
   ```

1. Install MinIO:

   1. Create a persistent volume to store the MinIO backup. We'll create a persistent volume from the default storage class in AKS hybrid, which already exists.  

      1. Create a YAML file named *minio-pvc-storage.yaml*, with the following contents:

         ```yml
         kind: PersistentVolumeClaim
         apiVersion: v1
         metadata: 
         name: minio-pv-claim 
         spec: 
         storageClassName: default 
         accessModes: 
            - ReadWriteOnce 
         resources: 
            requests: 
               storage: 100Gi 
         ```

      1. Create the persistent volume by running the following command:

         ```powershell
         kubectl create -f minio-pvc-storage.yaml
         ```

   1. Create a MinIO deployment:

      1. Create a YAML file named *minio-deployment.yaml*, for starting MinIO, which will use the persistent volume you just created:

         ```yml
         apiVersion: apps/v1
         kind: Deployment
         metadata:
         name: minio-deployment 
         spec: 
         selector: 
            matchLabels: 
               app: minio 
         strategy: 
            type: Recreate 
         template: 
            metadata: 
               labels: 
               app: minio 
            spec: 
               volumes: 
               - name: storage 
               persistentVolumeClaim: 
                  claimName: minio-pv-claim 
               containers: 
               - name: minio 
               image: minio/minio:latest 
               args: 
               - server 
               - /storage 
               env: 
               - name: MINIO_ACCESS_KEY 
                  value: "<you can define this>" 
               - name: MINIO_SECRET_KEY 
                  value: "<you can define this>" 
               ports: 
               - containerPort: 9000 
                  hostPort: 9000 
               volumeMounts: 
               - name: storage  
                  mountPath: "/storage" 
         ```

   1. Create your MinIO deployment by running the following command:

      ```powershell
      kubectl create -f minio-deployment.yaml
      ```

1. Create a Kubernetes service called *minio-service*.<!--Verify the service name.-->

   1. Create the YAML file *minio-service.yaml*, which will provide external IP addresses to the *minio* pod:  

      ```yml
      apiVersion: v1 
      kind: Service 
      metadata: 
      name: minio-service 
      spec: 
      type: LoadBalancer 
      ports: 
         - port: 9000 
            targetPort: 9000 
            protocol: TCP 
      selector: 
         app: minio 
      ```

   1. Create the service by running the following command:
   
      ```powershell
      kubectl create -f mino-service.yaml
      ```

1. Run `kubectl get svc` to get the minio pod's external IP address. Use this address to install Velero.<!--This instruction isn't clear. Step it out?-->

1. Check whether the minio pod is up and running using one of the following two methods:

   - Log into this IP address in a browser.<!--Test and clarify.-->
   - Use the minio client. Make sure you create a bucket in MinIO. This bucket will be used in the Velero installation.<!--Verify the spelling of the MinIO client name.-->

1. Install the minio client, which you'll use to browse through minio files. 

   1. Download the minio client by running the following command:

      ```powershell
      Invoke-WebRequest -Uri "https://dl.minio.io/client/mc/release/windows-amd64/mc.exe" -OutFile "C:\mc.exe
      ```

   1. Set the alias by running the following command: 
   
      ```powershell
      mc alias set minio http://10.10.77.6:9000 "minio_access_key" "minio_secret_key" --api s3v4
      ```

   1. Browse through the minio by running this command:
   
      ```powershell
      mc ls minio
      ```
   
   1. Create a bucket to store the Velero files that you'll use in the Velero installation by running this command:

      ```powershell
      mc mb minio/velero-backup
      ```

1. Create a MinIO credentials file:

   ```yml
   minio.credentials 
 	     [default] 
     aws_access_key_id=<minio_access_key> 
     aws_secret_access_key=<minio_secret_key> 
   ```

1. Install Velero by running the following command:  

   ```azurecli
   velero install --provider aws --bucket velero-backup --secret-file .\minio.credentials --backup-location-config region=minio,s3ForcePathStyle=true,s3Url=http://10.10.77.6:9000 --plugins velero/velero-plugin-for-aws:v1.1.0 --use-restic
   ```

   Be sure to check the following parameters:

   - The name of the bucket you created in MinIO
   - Your MinIO credentials
   - MinIO external IP address

1. To check whether the Velero service is running properly, run these commands:

   ```powershell
   kubectl -n velero get pods
   kubectl logs deployment/velero -n Velero
   ```

## Back up a cluster

You can back up or restore all objects in your cluster, or you can filter objects by type, namespace, and/or label.

### Backup examples

The following examples use the `--default-volumes-to-restic` flag, which creates a snapshot of the persistent volumes.

- For a basic on-demand backup of all namespaces your cluster, run this command:

  `velero backup create <BACKUP-NAME> --default-volumes-to-restic`

- For a basic on-demand backup of a single namespace in your cluster, run this command:

  `velero backup create <BACKUP-NAME> --include-namespaces <NAMESPACE1> --default-volumes-to-restic`

- For a basic on-demand backup of multiple selected name spaces in your cluster, run this command:

  `velero backup create <BACKUP-NAME> --include-namespaces <NAMESPACE-1>, <NAMESPACE-2> --default-volumes-to-restic` 

### Check backup progress

- To check progress of a backup, run this command:

  `velero backup describe <BACKUP-NAME>`

If you followed the instructions above, you can now view your backup in your Azure storage account under the *blob/container* that your created.

## Restore a cluster

You must create a new cluster to restore to. You cannot restore a cluster backup to an existing cluster. The restore operation allows you to restore all of the objects and persistent volumes from a previously created backup. You can also restore only a filtered subset of objects and persistent volumes.

On the cluster that you want to restore the backup to (*destination cluster*): 

1. Deploy Velero by using the instructions above.<!--Find an internal link target if possible.--> Use the same Azure credentials that you used for the source cluster.

1. Make sure the Velero backup object has been created by running `velero get backup`. Velero resources are synchronized with the backup files in cloud storage.

   `velero backup describe <BACKUP-NAME>`

1. After you confirm that the right backup (`BACKUP-NAME`) is present, you can restore all objects in the backup by running this command: 

   `velero restore create --from-backup <BACKUP-NAME>`

## Uninstall Velero

If you would like to completely uninstall Velero from your cluster, use the following commands to remove all resources created by the Velero installation: 

```azurecli
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
