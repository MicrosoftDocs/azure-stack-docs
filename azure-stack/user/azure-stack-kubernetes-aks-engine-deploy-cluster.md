---
title: Deploy Kubernetes cluster with AKS engine on Azure Stack Hub 
description: How to deploy a Kubernetes cluster on Azure Stack Hub from a client VM running the AKS engine. 
author: sethmanheim
ms.topic: install-set-up-deploy
ms.date: 03/06/2025
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 11/16/2021

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---
# Deploy a Kubernetes cluster with AKS engine on Azure Stack Hub

You can deploy a Kubernetes cluster on Azure Stack Hub from a client VM running AKS engine. This article describes how to write a cluster specification, deploy a cluster with the **apimodel.json** file, and check your cluster by deploying MySQL with Helm.

## Define a cluster specification

You can specify a cluster specification in a document file using the JSON format called the API model. AKS engine uses a cluster specification in the API model to create your cluster.

You can find examples of the API model for your OS and AKS engine version number for recent releases at [AKS engine and corresponding image mapping](kubernetes-aks-engine-release-notes.md#aks-engine-and-corresponding-image-mapping).

1. Find your AKS engine version number, for example, `v.0.63.0`, in the table.
2. In the [API Model samples table](kubernetes-aks-engine-release-notes.md#aks-engine-and-corresponding-image-mapping), select and open the link for your OS.
3. Select **Raw**. You can use the URL in the following instructions.

A URL to the API model might look like:

```http  
https://raw.githubusercontent.com/Azure/aks-engine-azurestack/master/examples/azure-stack/kubernetes-azurestack.json
```

For each of the following samples, replace `<URL for the API Model>` with the URL.

### Update the API model

This section describes how to create an API model for your cluster.

1. Start by using an Azure Stack Hub API Model file for Linux or Windows. From the machine, you installed AKS engine, run:

   ```bash
   curl -o kubernetes-azurestack.json <URL for the API Model>
   ```

   > [!NOTE]  
   > If you are disconnected, you can download the file and manually copy it to the disconnected machine where you plan to edit it. You can copy the file to your Linux machine using tools such as [PuTTY or WinSCP](https://www.suse.com/documentation/opensuse103/opensuse103_startup/data/sec_filetrans_winssh.html).

1. To open the API model in an editor, you can use nano:

   ```bash
   nano ./kubernetes-azurestack.json
   ```

   > [!NOTE]  
   > If you don't have nano installed, you can install nano on Ubuntu: `sudo apt-get install nano`.

1. In the **kubernetes-azurestack.json** file, find orchestratorRelease and orchestratorVersion. Select one of the supported Kubernetes versions; [you can find the version table in the release notes](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping). Specify the `orchestratorRelease` as x.xx and orchestratorVersion as x.xx.x. For a list of current versions, see [Supported AKS engine Versions](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping)

1. Find `customCloudProfile` and provide the URL to the tenant portal. For example, `https://portal.local.azurestack.external`.

1. Add `"identitySystem":"adfs"` if you're using AD FS. For example,

   ```JSON  
       "customCloudProfile": {
           "portalURL": "https://portal.local.azurestack.external",
           "identitySystem": "adfs"
       },
   ```

   > [!NOTE]  
   > If you're using Microsoft Entra ID for your identity system, you don't need to add the **identitySystem** field.

1. In `masterProfile`, set the following fields:

   | Field | Description |
   | --- | --- |
   | dnsPrefix | Enter a unique string that will serve to identify the hostname of VMs. For example, a name based on the resource group name. |
   | count |  Enter the number of masters you want for your deployment. The minimum for an HA deployment is 3, but 1 is allowed for non-HA deployments. |
   | vmSize |  Enter [a size supported by Azure Stack Hub](./azure-stack-vm-sizes.md), example `Standard_D2_v2`. |
   | distro | Enter `aks-ubuntu-18.04` or `aks-ubuntu-20.04`. |

1. In `agentPoolProfiles`, update:

   | Field | Description |
   | --- | --- |
   | count | Enter the number of agents you want for your deployment. The maximum count of nodes to use per subscription is 50. If you are deploying more than one cluster per subscription ensure that the total agent count doesn't go beyond 50. Make sure to use the configuration items specified in [the sample API model JSON file](https://aka.ms/aksengine-json-example-raw).  |
   | vmSize | Enter [a size supported by Azure Stack Hub](./azure-stack-vm-sizes.md), example `Standard_D2_v2`. |
   | distro | Enter `aks-ubuntu-18.04`, `aks-ubuntu-20.04` or `Windows`.<br>Use `Windows` for agents that will run on Windows. For example, see [kubernetes-windows.json](https://raw.githubusercontent.com/Azure/aks-engine/patch-release-v0.60.1/examples/azure-stack/kubernetes-windows.json) |

1. In `linuxProfile`, update:

   | Field | Description |
   | --- | --- |
   | adminUsername | Enter the VM admin user name. |
   | ssh | Enter the public key that will be used for SSH authentication with VMs. Use `ssh-rsa` and then the key. For instructions on creating a public key, see [Create an SSH key for Linux](create-ssh-key-on-windows.md). |

   If you're deploying to a custom virtual network, you can find instructions on finding and adding the required key and values to the appropriate arrays in the API model in [Deploy a Kubernetes cluster to a custom virtual network](kubernetes-aks-engine-custom-vnet.md).

   > [!NOTE]  
   > AKS engine for Azure Stack Hub doesn't allow you to provide your own certificates for the creation of the cluster.

1. If you're using Windows, in `windowsProfile` update the values of `adminUsername:` and `adminPassword`:

   ```json
   "windowsProfile": {
   "adminUsername": "azureuser",
   "adminPassword": "",
   "sshEnabled": true
   }
   ```

### More information about the API model

- For a complete reference of all the available options in the API model, see the [Cluster definitions](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/clusterdefinitions.md).  
- For highlights of specific options for Azure Stack Hub, see the [Azure Stack Hub cluster definition specifics](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#cluster-definition-aka-api-model).  

## Deploy a Kubernetes cluster

After you collect all the required values in your API model, you can create your cluster. At this point you should ask your Azure Stack Hub operator to:

- Verify the health of the system, suggest running `Test-AzureStack` and your OEM vendor's hardware monitoring tool.
- Verify the system capacity including resources such as memory, storage, and public IPs.
- Provide details of the quota associated with your subscription so that you can verify that there is still enough space for the number of VMs you plan to use.

Proceed to deploy a cluster:

1. Review the available parameters for AKS engine on Azure Stack Hub [CLI flags](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#cli-flags).

   | Parameter | Example | Description |
   | --- | --- | --- |
   | azure-env | AzureStackCloud | To indicate to AKS engine that your target platform is Azure Stack Hub use `AzureStackCloud`. |
   | identity-system | adfs | Optional. Specify your identity management solution if you are using Active Directory Federated Services (AD FS). |
   | location | local | The region name for your Azure Stack Hub. |
   | resource-group | kube-rg | Enter the name of a new resource group or select an existing resource group. The resource name needs to be alphanumeric and lowercase. |
   | api-model | ./kubernetes-azurestack.json | Path to the cluster configuration file, or API model. |
   | output-directory | kube-rg | Enter the name of the directory to contain the output file **apimodel.json** and other generated files. |
   | client-id | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter the service principal GUID. The Client ID identified as the Application ID when your Azure Stack Hub administrator created the service principal. |
   | client-secret | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter the service principal secret. You set up the client secret when creating your service. |
   | subscription-id | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter your Subscription ID. You must provide a subscription for the tenant. Deployment to the administrative subscription is not supported.  For more information, see [Subscribe to an offer](./azure-stack-subscribe-services.md#subscribe-to-an-offer) |

   Here is an example:

   > [!NOTE]
   > For AKSe version 0.75.3 and above, the command to deploy an AKS engine cluster is `aks-engine-azurestack deploy`.

   ```bash  
   aks-engine deploy \
   --azure-env AzureStackCloud \
   --location \
   --resource-group kube-rg \
   --api-model ./kubernetes-azurestack.json \
   --output-directory kube-rg \
   --client-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
   --client-secret xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
   --subscription-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
   --identity-system adfs # required if using AD FS
   ```

1. If for some reason the execution fails after the output directory has been created, you can correct the issue and rerun the command. If you are rerunning the deployment and used the same output directory before, AKS engine returns an error saying that the directory already exists. You can overwrite the existing directory by using the flag `--force-overwrite`.

1. Save the AKS engine cluster configuration in a secure, encrypted location.

   Locate the file **apimodel.json**. Save it to a secure location. This file is used as input in all of your other AKS engine operations.

   The generated **apimodel.json** file contains the service principal, secret, and SSH public key you use in the input API model. The file also has all the other metadata needed by AKS engine to perform all other operations. If you lose the file, AKS engine can't configure the cluster.

   The secrets are **unencrypted**. Keep the file in an encrypted, secure place.

## Verify your cluster

Check your cluster by connecting to `kubectl`, getting the info, and then getting the states of your nodes.

1. Get the `kubeconfig` file to connect to the control plane.
    - If you already have `kubectl` installed, check the `kubeconfig` file for the newly created cluster in this directory path `/kubeconfig/kubeconfig.json`. You can add the `/kubeconfig.json` to the `.kube` directory and rename it to "config" to access your new cluster.  
    If you haven't installed `kubectl`, see [Install tools](https://kubernetes.io/docs/tasks/tools/) to install the Kubernetes command-line tool. Otherwise, follow these instructions to access the cluster from one of the control plane nodes.
1. Get the public IP address of one of your control plane nodes using the Azure Stack Hub portal.

1. From a machine with access to your Azure Stack Hub instance, connect via SSH to the new control plane node using a client such as PuTTY or MobaXterm.

1. For the SSH username, use `azureuser` and the private key file of the key pair you provided for the deployment of the cluster.

1. Check that the cluster endpoints are running:

   ```bash
   kubectl cluster-info
   ```

   The output should look similar to the following:

   ```shell
   Kubernetes master is running at https://democluster01.location.domain.com
   CoreDNS is running at https://democluster01.location.domain.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
   Metrics-server is running at https://democluster01.location.domain.com/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy
   ```

1. Then, review node states:

   ```bash
   kubectl get nodes
   ```

   The output should be similar to the following:

   ```shell
   k8s-linuxpool-29969128-0   Ready      agent    9d    v1.15.5
   k8s-linuxpool-29969128-1   Ready      agent    9d    v1.15.5
   k8s-linuxpool-29969128-2   Ready      agent    9d    v1.15.5
   k8s-master-29969128-0      Ready      master   9d    v1.15.5
   k8s-master-29969128-1      Ready      master   9d    v1.15.5
   k8s-master-29969128-2      Ready      master   9d    v1.15.5
   ```

## Troubleshoot cluster deployment

If you encounter errors while deploying a Kubernetes cluster using AKS engine, you can check:

1. Are you using the correct Service Principal credentials (SPN)?
1. Does the SPN have a "Contributors" role to the Azure Stack Hub subscription?
1. Do you have a large enough quota in your Azure Stack Hub plan?
1. Is the Azure Stack Hub instance having a patch or upgrade being applied?

For more information, see the [Troubleshooting](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/howto/troubleshooting.md) article in the **Azure/aks-engine-azurestack** GitHub repo.

## Rotate your service principle secret

After the deployment of the Kubernetes cluster with AKS engine, the service principal (SPN) is used for managing interactions with the Azure Resource Manager on your Azure Stack Hub instance. At some point, the secret for this the service principal may expire. If your secret expires, you can refresh the credentials by:

- Updating each node with the new service principal secret.
- Or updating the API model credentials and running the upgrade.

### Update each node manually

1. Get a new secret for your service principal from your cloud operator. For instructions for Azure Stack Hub, see [Use an app identity to access Azure Stack Hub resources](../operator/give-app-access-to-resources.md).
1. Use the new credentials provided by your cloud operator to update **/etc/kubernetes/azure.json** on each node. After making the update, restart both `kubele` and `kube-controller-manager`.

### Update the cluster with aks-engine update

Alternatively, you can replace the credentials in **apimodel.json** and run upgrade using the updated .json file to the same or newer Kubernetes version. For instructions on upgrading the model, see [Upgrade a Kubernetes cluster on Azure Stack Hub](azure-stack-kubernetes-aks-engine-upgrade.md)

## Next steps

> [!div class="nextstepaction"]
> [Troubleshoot AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-troubleshoot.md)
