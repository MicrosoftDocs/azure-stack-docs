---
title: Deploy a Kubernetes cluster with the AKS engine on Azure Stack | Microsoft Docs
description: How to deploy a Kubernetes cluster on Azure Stack from a client VM running the AKS Engine. 
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na (Kubernetes)
ms.devlang: nav
ms.topic: article
ms.date: 08/22/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/22/2019

---

# Deploy a Kubernetes cluster with the AKS engine on Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can deploy a Kubernetes cluster on Azure Stack from a client VM running the AKS Engine. In this article, we look at writing a cluster specification, deploying a cluster with the `apimodel.json` file, and verify your cluster by deploying mysql with Helm.

## Define a cluster specification

You can specify a cluster specification in a document file using the JSON format called the [API model](https://github.com/Azure/aks-engine/blob/master/docs/topics/architecture.md#architecture-diagram). The AKS Engine uses a cluster specification in the API model to create your cluster. 

### Update the API model

This section looks at creating an API model for your cluster.

1.  Start by using an Azure Stack [example](https://github.com/Azure/aks-engine/tree/master/examples/azure-stack) API Model file and make a local copy for your deployment. From the machine, you installed AKS Engine, run:

    ```bash
    curl -o kubernetes-azurestack.json https://raw.githubusercontent.com/Azure/aks-engine/master/examples/azure-stack/kubernetes-azurestack.json
    ```

    > [!Note]  
    > If you are disconnected, you can download the file and manually copy it to the disconnected machine where you plan to edit it. You can copy the file to your Linux machine using tools such as [PuTTY or WinSCP](https://www.suse.com/documentation/opensuse103/opensuse103_startup/data/sec_filetrans_winssh.html).

2.  To open the  in an editor, you can use nano:

    ```bash
    nano ./kubernetes-azurestack.json
    ```

    > [!Note]  
    > If you don't have nano installed, you can install nano on Ubuntu: `sudo apt-get install nano`.

3.  In the kubernetes-azurestack.json file, find `orchestratorRelease`. Select one of the supported Kubernetes versions. For example, 1.11, 1.12, 1.13, 1.14. The versions are often updates. Specify the version as x.xx rather than x.xx.x. For a list of current versions, see [Supported Kubernetes Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-kubernetes-versions). You can find out the supported version by running the following AKS Engine command:

    ```bash
    aks-engine get-versions
    ```

4.  Find `portalURL` and provide the URL to the tenant portal. For example, `https://portal.local.azurestack.external`.

5.  In the array `masterProfile`, set the following fields:

    | Field | Description |
    | --- | --- |
    | dnsPrefix | Enter a unique string that will serve to identify the hostname of VMs. For example, a name based on the resource group name. |
    | count |  Enter the number of masters you want for your deployment. The minimum for an HA deployment is 3, but 1 is allowed for non-HA deployments. |
    | vmSize |  Enter [a size supported by Azure Stack](https://docs.microsoft.com/azure-stack/user/azure-stack-vm-sizes), example "Standard\_D2\_v2" |
    | distro | Enter `aks-ubuntu-16.04`. |

6.  In the array `agentPoolProfiles` update:

    | Field | Description |
    | --- | --- |
    | count | Enter the number of agents you want for your deployment |
    | vmSize | Enter [a size supported by Azure Stack](https://docs.microsoft.com/azure-stack/user/azure-stack-vm-sizes), example "Standard\_D2\_v2" |
    | distro | Enter `aks-ubuntu-16.04`. |

7.  In the array `linuxProfile` update:

    | Field | Description |
    | --- | --- |
    | adminUsername | Enter the VM admin user name |
    | ssh | Enter the public key that will be used for SSH authentication with VMs |

### More information about the API model

- For a complete reference of all the available options in the API model, refer to the [Cluster definitions](https://github.com/Azure/aks-engine/blob/master/docs/topics/clusterdefinitions.md).  
- For highlights on specific options for Azure Stack, refer to the [Azure Stack cluster definition specifics](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#cluster-definition-aka-api-model).  

## Deploy a Kubernetes cluster

After you have collected all the required values in your API model, you can create your cluster.

1.  Before running AKS Engine, check that your subscription has enough space in the quota. You may also want to wait until any Azure Stack system update has completed.

2.  Review the available parameters for AKS Engine on Azure Stack [CLI flags](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#cli-flags).

    | Parameter | Example | Description |
    | --- | --- | --- |
    | azure-env | AzureStackCloud | To indicate to AKS Engine that your target platform is Azure Stack use `AzureStackCloud`. |
    | location | local | The region name for your Azure Stack. For the ASDK the region is set to `local`. |
    | resource-group | kube-rg | Enter the name of a new resource group or select an existing resource group. The resource name needs to be alphanumeric and lowercase. |
    | api-model | ./kubernetes-azurestack.json | Path to the cluster configuration file, or API model. |
    | output-directory | kube-rg | Enter the name of the directory to your contain your the output file `apimodel.json`. |
    | client-id | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter the service principal GUID. The Client ID identified as the Application ID when your Azure Stack administrator created the service principal. |
    | client-secret | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter the service principal secret. This is the client secret you set up when creating your service. |
    | subscription-id | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter your Subscription ID. For more information see [Subscribe to an offer](https://docs.microsoft.com/azure-stack/user/azure-stack-subscribe-services#subscribe-to-an-offer) |

    Here is an example to follow:

    ```bash  
    aks-engine deploy \\
    --azure-env AzureStackCloud
    --location <for asdk is local>\\
    --resource-group kube-rg \\
    --api-model ./kubernetes-azurestack.json \\
    --output-directory kube-rg \\
    --client-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \\
    --client-secret xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \\
    --subscription-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    ```

3.  If for some reason the execution fails after the output directory has been created, you can correct the issue and rerun the command. If you are rerunning the deployment and had used the same output directory before, the AKS Engine will return an error saying that the directory already exists. You can overwrite the existing directory by using the flag: `--force-overwrite`.

4.  Save the AKS Engine cluster configuration in a secure, encrypted location.

    Locate the file `apimodel.json`. Save it to a secure location. This file will be used as input in all of your other AKS Engine operations.

    The generated `apimodel.json` contains the service principal, secret, and SSH public key you use in the input API model. It also has all the other metadata needed by the AKS Engine to perform all other operations. If you lose it, the AKS Engine won't be able configure the cluster.

    The secrets are **unencrypted**. Keep the file in an encrypted, secure place. 

## Verify your cluster

Verify your cluster by deploying mysql with Helm to check your cluster.

1. Get the public IP address of one of your master nodes using the Azure Stack portal.

2. From a machine with access to your Azure Stack instance, connect via SSH into the new master node using a client such as PuTTY or MobaXterm. 

3. For the SSH username, you use "azureuser" and the private key file of the key pair you provided for the deployment of the cluster.

4.  Run the following commands:

    ```bash
    sudo snap install helm –classic
    helm repo update
    helm init --history-max 200 --upgrade
    helm install stable/mysql
    ```

5.  To clean up the test, find the name used for the mysql deployment. In the following example, the name is `wintering-rodent`. Then delete it. 

    Run the following commands:

    ```bash
    helm ls
    NAME REVISION UPDATED STATUS CHART APP VERSION NAMESPACE
    wintering-rodent 1 Thu Oct 18 15:06:58 2018 DEPLOYED mysql-0.10.1 5.7.14 default
    helm delete wintering-rodent
    ```

    The CLI will display:
    ```bash
    release "wintering-rodent" deleted
    ```

## Next steps

> [!div class="nextstepaction"]
> [Troubleshoot the AKS Engine on Azure Stack](azure-stack-kubernetes-aks-engine-troubleshoot.md)