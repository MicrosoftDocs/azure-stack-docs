---
title: Rotate Kubernetes certificates using AKS engine on Azure Stack Hub
description: Learn how to rotate Kubernetes certificates on AKS engine clusters in Azure Stack Hub. Follow this guide for secure cluster maintenance and updates.
author: sethmanheim

ms.topic: how-to
ms.date: 07/09/2026
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 05/17/2022

# Intent: As an Azure Stack Hub user, I would like to rotate Kubernetes certificates on a Kubernetes cluster so that I can keep my cluster secure.
# Keywords: certificates AKS engine Kubernetes

---

# Rotate Kubernetes certificates using AKS engine on Azure Stack Hub

This article provides guidance on how to rotate certificates on an existing AKS Engine cluster and recommendations for using `aks-engine rotate-certs` as a tool.

## Prerequisites

This guide assumes that you already deployed a cluster by using the AKS engine and the cluster is in a healthy state.


## Planning for certificate rotation

When you use this functionality, the Kubernetes control plane is unavailable during the update, validation, and restart steps. Plan this maintenance operation accordingly. Also, plan to execute this operation in a staging environment with equal configuration to the production environment before trying it in production.

Review the following considerations before attempting this operation:

> [!NOTE]
> For AKSe version 0.75.3 and later, the commands for certificate rotation start with `aks-engine-azurestack` rather than `aks-engine`.

-  You need access to the API model (`apimodel.json`) that the commands `aks-engine deploy` or `aks-engine generate` create. By default, the process places this file into a relative directory such as `_output/<clustername>/`.
-  An `aks-engine rotate-certs` operation causes API server downtime.
-  `aks-engine rotate-certs` expects an API model that conforms to the current state of the cluster. `aks-engine rotate-certs` executes remote commands on the cluster nodes and uses the API model information to establish a secure SSH connection. `aks-engine rotate-certs` also relies on some resources to be named in accordance with the original `aks-engine` deployment. For example, VMs must follow the naming provided by `aks-engine`.
-  `aks-engine rotate-certs` relies upon a working connection to the cluster control plane during certificate rotation to:
    - Validate each step of the process.
    - Restart and recreate cluster resources such as **kube-system pods** and service account tokens.

    If you are rotating the certificates of a cluster in a VNet closed to outside access, you must run `aks-engine rotate-certs` from a host VM that has network access to the control plane, for example, a jumpbox VM that resides in the same VNet as the master VMs.

- If you are using `aks-engine rotate-certs` in production, it is recommended to stage a certificate rotation test on a cluster that was built to the same specifications. That is, the cluster is built with the same cluster configuration, the same version of the AKS engine command-line tool, and the same set of enabled addons as your production cluster before performing the certificate rotation. AKS engine supports different cluster configurations and the extent of end-to-end testing that the AKS engine team runs cannot practically cover every possible configuration. Therefore, it is recommended that you ensure in a staging environment that your specific cluster configuration works with `aks-engine rotate-certs` before attempting the operation on your production cluster.
-  `aks-engine rotate-certs` doesn't guarantee backward compatibility. If you deployed by using aks-engine version 0.60.x, prefer executing the certificate rotation process by using version 0.60.x.
-  Fetching a new set of certificates from Key Vault isn't supported at this point.
- Use a reliable network connection. `aks-engine rotate-certs` requires the execution of multiple remote commands, which are subject to potential failures, mostly if the connection to the cluster nodes isn't reliable. Running `aks-engine rotate-certs` from a VM running on the target Azure Stack stamp can reduce the occurrence of transient issues.

## Parameters

| Parameter           | Required | Description |
| --- | --- | --- |
| --api-model             | yes          | Relative path to the API model (cluster definition) that declares the expected cluster configuration.       |
| --ssh-host              | yes          | Fully qualified domain name (FQDN), or IP address, of an SSH listener that can reach all nodes in the cluster.                            |
| --linux-ssh-private-key | yes          | Path to a valid private SSH key to access the cluster's Linux nodes.                                        |
| --location              | yes          | Azure location where the cluster is deployed.                                                               |
| --subscription-id       | yes          | Azure subscription where the cluster infra is deployed.                                                     |
| --resource-group        | yes          | Azure resource group where the cluster infra is deployed.                                                   |
| --client-id             | depends      | The service principal client ID. Required if the auth-method is set to client_secret or client_certificate. |
| --client-secret         | depends      | The service principal client secret. Required if the auth-method is set to client_secret.                   |
| --azure-env             | depends      | The target cloud name. Optional if target cloud is AzureCloud.                                              |
| --certificate-profile   | no           | Relative path to a JSON file containing the new set of certificates.                                        |
| --force                 | no           | Force execution even if the API Server is not responsive.                                                       |

## Simple steps to rotate certificates

For AKS Engine versions 0.75.3 and later, after you read all the [requirements](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/rotate-certs.md#pre-requirements), run `aks-engine-azurestack rotate-certs` with the appropriate arguments (see the following section).

For AKS Engine versions 0.73.0 and earlier, after you read all the [requirements](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/rotate-certs.md#pre-requirements), run `aks-engine rotate-certs` with the appropriate arguments:

```bash  
./bin/aks-engine rotate-certs \
  --location <resource-group-location> \
  --api-model <generated-apimodel.json> \
  --linux-ssh-private-key <private-SSH-key> \
  --ssh-host <apiserver-URI> \
  --resource-group <resource-group-name> \
  --client-id <service-principal-id> \
  --client-secret <service-principal-secret> \
  --subscription-id <subscription-id> \
  --azure-env <cloud-name>
```

For example:

```bash  
./bin/aks-engine rotate-certs \
  --location "westus2" \
  --api-model "_output/my-cluster/apimodel.json" \
  --linux-ssh-private-key "~/.ssh/id_rsa" \
  --ssh-host "my-cluster.westus2.cloudapp.azure.com"\
  --resource-group "my-cluster" \
  --client-id "00001111-aaaa-2222-bbbb-3333cccc4444" \
  --client-secret "00001111-aaaa-2222-bbbb-3333cccc4444" \
  --subscription-id "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e" \
  --azure-env "AzureStackCloud" # optional if targeting AzureCloud
```

## Rotate `front-proxy` certificates

> [!NOTE]
> For AKSe version 0.75.3 and later, the commands for certificate rotation start with `aks-engine-azurestack` rather than `aks-engine`.

The AKS engine creates a separate PKI for the `front-proxy` as part of the node bootstrapping process and delivers it to all nodes through `etcd`. To effectively reuse this functionality, `rotate-certs` replaces the certificates stored in `etcd`. The `front-proxy` certificates expire after 30 years. The `aks-engine rotate-certs` command rotates the `front-proxy` certificates.
## Troubleshooting
> [!NOTE]
> For AKSe version 0.75.3 and later, the commands for certificate rotation start with `aks-engine-azurestack` rather than `aks-engine`.


If the certificate rotation process stops before completion due to a failure or transient issue, such as network connectivity, it's safe to rerun `aks-engine rotate-certs` by using the `--force` flag.

Also, `aks-engine rotate-certs` logs the output of every step in the file `/var/log/azure/rotate-certs.log` (Linux) and `c:\\k\\rotate-certs.log` (Windows).

For more information about what happens under the hood when running this operation or for further customization, see [Under The Hood](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/rotate-certs.md#under-the-hood).

## Next steps

- Read about [AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)  
