---
title: Back up and restore target clusters using Velero
description: Learn how to back up and restore workload clusters to Azure Blob storage or MinIO using Velero in AKS hybrid.
author: sethmanheim
ms.topic: how-to
ms.date: 11/10/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: scooley

# Intent: As an IT Pro, I want to learn how to perform a workload cluster backup or restore so I can recover from a failure or disaster.   
# Keyword: workload cluster backup restore Velero Azure Blob MinIO

---

# Back up and restore target clusters using Velero in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to install and use Velero to back up and restore workload and target clusters using Azure Blob storage or MinIO storage for the backups in AKS hybrid.

[!INCLUDE [aks-hybrid-description](includes/aks-hybrid-description.md)]

[Velero](https://velero.io/docs) is an open-source community standard tool for backing up and restoring Kubernetes cluster objects and persistent volumes. It supports various [storage providers](https://velero.io/docs/main/supported-providers/) to store its backups. If an AKS hybrid target cluster crashes and fails to recover, the infrastructure administrator can use a Velero backup to restore its contents and internal API objects to a new cluster.

You can either use Azure Blob storage or MinIO storage with Velero. Velero and Azure Blob storage will store your backups in Azure Blob. If you don't want your backups to be stored in Azure, you can use Velero and MinIO. This document will show you both methods: Velero + Azure Blob and Velero + MinIO.

> [NOTE!]
> Velero doesn't officially support Microsoft Windows. In testing, the Velero team was able to back up stateless Windows applications only. The Restic integration and backups of stateful applications or persistent volumes were not supported.

## Prerequisites

Complete these prerequisites before you begin your Velero deployment:

- [Install the Azure CLI](/cli/azure/install-azure-cli).
- [Install `Chocolatey`](https://chocolatey.org/install). You can use `Chocolatey` to install the [Velero client](https://community.chocolatey.org/packages/velero), which includes the Velero CLI, on a Windows machine.

## Install Velero with Azure Blob storage

This section describes how to install Velero and use Azure Blob storage for backups. If you don't want to store your backups in Azure, go to [Install Velero with MiniO storage](#install-velero-with-minio-storage).

1. Open PowerShell as an administrator.

1. Log in to Azure using the Azure CLI:

   `az login --use-device-code`

1. Install the [Velero CLI](https://velero.io/docs/v1.9/basic-install/#install-the-cli) by running the following command:

   ```powershell
   choco install velero   
   ```

1. If needed, change to the Azure subscription you want to use for the backups. You can skip this step if you're already in the subscription you want to create your backups with.

   By default, Velero stores backups in the same Azure subscription as your VMs and disks and won't allow you to restore backups to a resource group in a different subscription. To enable backups and restores across subscriptions, you'll need to specify a subscription to use for your backups. 

   Switch to the subscription the backups should be created in:

   1. Use the subscription name to find the subscription ID:

      ```azurecli
      $AZURE_BACKUP_SUBSCRIPTION_NAME="<NAME_OF_TARGET_SUBSCRIPTION>"
      $AZURE_BACKUP_SUBSCRIPTION_ID=$(az account list --query="[?name=='$AZURE_BACKUP_SUBSCRIPTION_NAME'].id | [0]" -o tsv)
      ```

   1. Then change the subscription:

      ```azurecli
      az account set -s $AZURE_BACKUP_SUBSCRIPTION_ID
      ```

1. Create an Azure storage account and blob container.

   When you use Azure Blob storage for backups, Velero requires a storage account and a blob container to store the backups. The following example shows the storage account created in a new `Velero_Backups` resource group.

   The storage account needs to be created with a globally unique ID since this is used in DNS.<!--Should this be "Azure DNS"--> The sample script uses `uuidgen` to randomly generate a unique name. You can use any method as long as the name follows [Azure naming rules for storage accounts](/azure/storage/common/storage-account-overview#storage-account-name).

   The storage account is created with encryption at rest capabilities (Microsoft managed keys)<!--managed keys reference seems like a non sequitur--> and is configured to only allow access via HTTPS connections.<!--Hyphenate "encryption-at-rest" - all or part?-->

   1. Create a resource group for the backup storage account. Change directories to your preferred location, if needed, and run the following commands:

      ```azurecli
      $AZURE_BACKUP_RESOURCE_GROUP="Velero_Backups"
      az group create -n $AZURE_BACKUP_RESOURCE_GROUP --location WestUS
      ```

   1. Create the storage account.

      ```azurecli
      $AZURE_STORAGE_ACCOUNT_ID="<NAME_OF_ACCOUNT_TO_ASSIGN>"

      az storage account create --name $AZURE_STORAGE_ACCOUNT_ID --resource-group $AZURE_BACKUP_RESOURCE_GROUP --sku Standard_GRS --encryption-services blob --https-only true --kind BlobStorage --access-tier Hot
      ```

   1. Create a blob container. The example uses a blob container named `velero`. You can use a different name, preferably unique to a single Kubernetes cluster.

      ```azurecli
      $BLOB_CONTAINER="velero"
      az storage container create -n $BLOB_CONTAINER --public-access off --account-name $AZURE_STORAGE_ACCOUNT_ID
      ```

1. Create a service principal.

   1. Get the subscription ID and tenant ID for your Azure account:

      ```azurecli
      $AZURE_SUBSCRIPTION_ID=(az account list --query '[?isDefault].id' -o tsv)
      $AZURE_TENANT_ID=(az account list --query '[?isDefault].tenantId' -o tsv) 
      ```

   1. Create a service principal.

      You can create a service principal with the Contributor role or use a custom role:

      - **Contributor role:** The Contributor role grants subscription-wide access, so be sure protect this credential if you assign that role. 
      - If you need a less permissive role, use a custom role.

      **Use Contributor role:**

      If you'll be using Velero to back up multiple clusters with multiple blob containers, you may want to create a unique username for each cluster instead of using the name `velero`.

      1. Create a service principal with the Contributor role. Azure Active Directory (Azure AD) will generate a secret for you.

         ```azurecli
         $AZURE_CLIENT_SECRET=(az ad sp create-for-rbac --name "velero" --role "Contributor" --query 'password' -o tsv --scopes  /subscriptions/$AZURE_SUBSCRIPTION_ID)
         ```

         Make sure `--name` is unique in Azure Active Directory (Azure AD) and doesn't conflict with other service principals or app registrations.

         If you're using different subscriptions for your Velero backup files and your workload clusters, provide both subscription IDs, as in the following example:

         ```azurecli
         $AZURE_CLIENT_SECRET=(az ad sp create-for-rbac --name "velero" --role "Contributor" --query 'password' -o tsv --scopes  /subscriptions/$AZURE_SUBSCRIPTION_ID /subscriptions/$AZURE_BACKUP_SUBSCRIPTION_ID)
         ```

         > [!IMPORTANT]
          > The secret is shown only during this step, when the service principal is created. Be sure to make a note of the secret for use in future steps.

      **Use a custom role:**

      If you want to enable the minimum resource provider actions, create a custom role, and assign that role to the service principal.

      1. Create a file named `azure-role.json` with following contents. Substitute your own custom role name and subscription ID.

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

      1. Create the custom role and service principal:

         ```azurecli
         az role definition create --role-definition azure-role.json

         $AZURE_CLIENT_SECRET=(az ad sp create-for-rbac --name "velero" --role "<CUSTOM_ROLE>" --query 'password' -o tsv --scopes  /subscriptions/$AZURE_SUBSCRIPTION_ID)
         ```

      For more info about creating custom roles, see [Velero plugins for Microsoft Azure](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#specify-role).<!--Links to github. Is a public source available?-->

1. Get the service principal name, and assign that name to the **AZURE_CLIENT_ID** variable:

   ```azurecli
   $AZURE_CLIENT_ID=(az ad sp list --display-name "velero" --query '[0].appId' -o tsv)
   ```

1. Service principals expire. To find out when your service principal will expire, run the following command:<!--This is a good thing to do, but it isn't critical to the procedure. Maybe make a NOTE instead of a step?--

   ```azurecli
   az ad sp show --id $AZURE_CLIENT_ID
   ```

1. Create a file that contains the variables that the Velero installation requires. The command looks like the following one:

   ```azurecli
   _SUBSCRIPTION_ID=${AZURE_SUBSCRIPTION_ID}
   AZURE_TENANT_ID=${AZURE_TENANT_ID}
   AZURE_CLIENT_ID=${AZURE_CLIENT_ID}
   AZURE_CLIENT_SECRET=${AZURE_CLIENT_SECRET}
   AZURE_RESOURCE_GROUP=${AZURE_BACKUP_RESOURCE_GROUP}
   AZURE_CLOUD_NAME=AzurePublicCloud" | Out-File -FilePath ./credentials-velero.txt
   ```

   > [!IMPORTANT]
   > Delete this file after you install Velero. The client secret is in plaintext, which can pose a security risk.

   Before proceeding, verify that the file is properly formatted. (The file name extension doesn't matter.)
   - Remove any extra spaces or tabs.
   - Make sure the variable names are correct.

1. Install and start Velero.

   Install Velero, including all prerequisites<!--Meaning of "including all prerequisites?"? Requirement?-->, on the cluster, and start the deployment. This procedure creates a namespace called `velero` and adds a deployment named `velero` to the namespace.

   1. Install Velero using the following command. You'll need to adjust the example command.<!--Velero starts automatically when it's installed?-->

      ```powershell
      velero install --provider azure --plugins velero/velero-plugin-for-microsoft-azure:v1.5.0 --bucket $BLOB_CONTAINER --secret-file ./credentials-velero.txt --backup-location-config resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,storageAccount=$AZURE_STORAGE_ACCOUNT_ID,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION_ID --use-restic
      ```

      Review and adjust the following variables as needed:

      - The command installs the Microsoft Azure plugin, which must be compatible with the Velero CLI version you're using. The example command uses Microsoft Azure plugin version 1.5.0, which is compatible with the latest Velero CLI version, 1.9.0. To find out which version of the Microsoft Azure plugin to install with your Valero CLI version, see the [compatibility matrix](https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#compatibility).

      - Be sure to include `--use-restic`, to enable backup of Kubernetes volumes at the file system level using `Restic`. `Restic` can be used to back up any type of Kubernetes volume. By default, Velero supports taking snapshots of persistent volumes for Amazon EBS Volumes, Azure Managed Disks, and Google Persistent Disks. In AKS hybrid, Kubernetes volumes use Cluster Shared Volumes (CSVs) to store data. Hence, `Restic` is needed to enable persistent volume snapshots. AKS hybrid currently doesn't support volume snapshots.

      - `subscriptionId=$AZURE_BACKUP_SUBSCRIPTION_ID` is optional. You need only include it if Velero and the workload cluster have different subscription IDs. If they use the same Azure subscription, you can remove the `subscriptionId`: the *credentials-velero.txt* file will provide that information.
   
      The Velero service starts automatically on installation.

   1. Check whether the Velero service is running properly:<!--What do you mean by "properly"? Command output would be helpful.-->

      ```powershell
      kubectl -n velero get pods
      kubectl logs deployment/velero -n velero
      ```

## Install Velero with MinIO storage

If you don't want to use Azure Blob storage for your backups, you can deploy Velero with [MinIO](https://min.io/) storage. MinIO is an object storage solution. This section describes how to install and use Valero with MinIO.

If you don't want to store your backups in MinIO, go to [Set up Velero to use Azure Blob storage](#install-velero-with-azure-blob-storage).

1. Install the Velero CLI by running the following command. (You'll need to [Install `Chocolately`](https://chocolatey.org/install) if you haven't already.)

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

         Run this command to create the file:

         ```powershell
         kubectl create -f minio-pvc-storage.yaml
         ```

      1. Create a deployment file, `minio-deployment.yaml`, for starting MinIO. The deployment will use the persistent volume you created earlier.

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

      Run the following command to create the deployment:

      ```powershell
      kubectl create -f minio-deployment.yaml
      ```

   1. Create a Kubernetes service, called `minio-service.yaml`, with the parameters in the following example. This service will provide external IP addresses to the MinIO pod.

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

      Create the service by running the following command:
   
      ```powershell
      kubectl create -f mino-service.yaml
      ```

   1. Get the MinIO pod's external IP address by running the following command. You'll use this address to install Velero.<!--Show sample data.-->

      ```powershell
      kubectl get svc
      ```

   1. To check whether MinIO is up and running, log in to the IP address in a browser, or use the MinIO client.<!--PLACEMENT? They don't install the MinIO client until the next step.--> <!--NOT NEEDED: Make sure you create a bucket in MinIO. This bucket will be used in Velero installation.-->

   1. Install the MinIO client, and browse through the MinIO files.

      1. Download the MinIO client:

         ```powershell
         Invoke-WebRequest -Uri "https://dl.minio.io/client/mc/release/windows-amd64/mc.exe" -OutFile "C:\mc.exe
         ```

      1. Set an alias:

         ```powershell
         mc alias set minio http://10.10.77.6:9000 "minio_access_key" "minio_secret_key" --api s3v4
         ```

      1. Browse through the MinIO installation:<!--Show command output.-->

         ```powershell
         mc ls minio
         ```
   
   1. Create a bucket to store Velero files. This bucket will be used in the Velero installation.

      ```powershell
      mc mb minio/velero-backup
      ```

   1. Create a MinIO credentials file with the following information:

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

   Check the bucket name, your MinIO credentials, and the MinIO external IP address before you run this command.

1. To check whether the Velero service is running properly, run these commands:

   ```powershell<!--Command output? What are they looking for? Could link to source for log info if needed.-->
   kubectl -n velero get pods
   kubectl logs deployment/velero -n Velero
   ```

## Back up a cluster

You can back up or restore all objects in your cluster, or you can filter objects by type, namespace, and/or label.

### Backup examples<!--I don't like this heading.-->

Use the Velero `backup create` command to create backups to your chosen storage. The following examples use the `--default-volumes-to-restic` flag, which creates a snapshot of the persistent volumes.

- Create a basic on-demand backup of all namespaces in your cluster:<!--Can "basic" be removed throughout examples?-->

  `velero backup create <BACKUP-NAME> --default-volumes-to-restic`

- Create a basic on-demand backup of a single namespace in your cluster:

  `velero backup create <BACKUP-NAME> --include-namespaces <NAMESPACE1> --default-volumes-to-restic`

- Create a basic on-demand backup of multiple selected namespaces in your cluster:

  `velero backup create <BACKUP-NAME> --include-namespaces <NAMESPACE-1>, <NAMESPACE-2> --default-volumes-to-restic`

<!--Add a link to other backup options?-->

### Check backup progress

- To check progress of a backup, run this command:

  `velero backup describe <BACKUP-NAME>`

If you're using Azure Blob storage for your backups, you can view your backup in your Azure storage account under the `blob/container` that you created.

<!--What if they're using MinIO?-->

## Restore a cluster

To restore a cluster, you must create a new cluster to restore the old cluster to. You can't restore a cluster backup to an existing cluster.

The restore operation allows you to restore all of the objects and persistent volumes from a previously created backup. You can also restore only a filtered subset of objects and persistent volumes.

On the cluster that you want to restore the backup to (`destination cluster`: 

1. Deploy Velero by using the instructions above. Use the same Azure credentials that you used for the source cluster.

1. Make sure the Velero backup object was created by running the following command. <!--HOW DOES THIS RELATE TO THE STEP? --Velero resources are synchronized with the backup files in cloud storage.-->

   `velero backup describe <BACKUP-NAME>`

   <!--Command output would be helpful. Or tell them what they are looking for. The command lists the backups that have been stored?-->

1. After you confirm that the right backup (`BACKUP-NAME`) is present, restore all objects in the backup:

   `velero restore create --from-backup <BACKUP-NAME>`

## Uninstall Velero

To uninstall Velero from your cluster, and remove all resources created by the Velero installation, run the following commands:

```azurecli
kubectl delete namespace/velero clusterrolebinding/velero 
kubectl delete crds -l component=velero
```

## Additional notes

<!--Let's integrate these two points in the topic and eliminate the "Additional notes" catchall.-->
- Velero on Windows: Velero doesn't officially support Windows. During testing, the Velero team was able to back up only stateless Windows applications. [`Restic` integration](https://velero.io/docs/v1.6/restic/), and backups of stateful applications or persistent volumes, aren't supported.<!--This should be in the overview?-->

- Velero CLI help: To see all options associated with a specific command, use the `--help` flag with the command. For example, `velero restore create --help` shows all options associated with the `velero restore create` command. Or, to list all options of `velero restore`, run `velero restore --help`:<!--The list of commands is useful. Is the help output the best presentation?-->

  ```output
    velero restore [command]
    Available Commands:
    create      Create a restore
    delete      Delete restores
    describe    Describe restores
    get         Get restores
    logs        Get restore logs
  ```
