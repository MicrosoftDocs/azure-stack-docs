---
title: Rotate certificates for a Kubernetes cluster on Azure Stack | Microsoft Docs
description: Description
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

# Rotate certificates for a Kubernetes cluster on Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can rotate your Kubernetes cluster certificates with the AKS Engine rotate-certs command. This article has the steps for rotating TLS CA and certificates for your AKS Engine cluster. Before you start, make sure your cluster definition file matches your configuration, you have a back up of your state, and you can migrate critical apps to another cluster. Then, rotate the certificates. After your rotation, your cluster should be run without displaying errors. Make sure all of the nodes are ready, and all pods are running. Finally, the article looks at some known limitations, such as scenarios the tool hasn't been tested with and not being idempotent.

## Preparation for certificate rotation

Check that your environment meets the following:

- The **etcd** members must be in a healthy state before rotating the CA and certs. The command `etcdctl cluster-health` will show the health of all the peers and the cluster.
- Your cluster definition file (`apimodel.json`) reflects the current cluster configuration. The file has a working SSH private key that has root access to your cluster's nodes. The AKS Engine stores the file when it creates your cluster. The storage location is set to be at the default location at `_output/`. This is a child directory from the working parent directory.

Before running the steps in these instructions on a live cluster:

1. Back up your cluster state.
2. Migrate critical apps to another cluster.

> [!Caution]  
> Rotating certificates can break component connectivity and leave the cluster in an unrecoverable state.

## Certificate rotation

Run the following command to rotate your cluster's certificates:

```bash
aks-engine rotate-certs --azure-env AzureStackCloud
```

> [!WARNING]  
> Rotating certificates will cause cluster downtime.

The following example assumes the default `output/` directory uses the same name as the cluster's DNS prefix. This command with parameters would look like:

```bash
CLUSTER="<CLUSTER_DNS_PREFIX>" && bin/aks-engine rotate-certs --api-model _output/${CLUSTER}/apimodel.json \
--client-id "<YOUR_CLIENT_ID>" --client-secret "<YOUR_CLIENT_SECRET>" --location <CLUSTER_LOCATION> \
--apiserver ${CLUSTER}.<CLUSTER_LOCATION>.cloudapp.azure.com --ssh _output/${CLUSTER}-ssh \
--subscription-id "<YOUR_SUBSCRIPTION_ID>" -g ${CLUSTER} -o _output/${CLUSTER} \
--azure-env AzureStackCloud
```

When you run rotate-certs, the AKS Engine:

1. Generates new certificates.
2. Rotates **apiserver** certificates.
3. Rotates the **kubelet** certificates.
4. Rotates **etcd** CA and certificates and restart **etcd** in all the master nodes.
5. Updates the **kubeconfig**.
6. Reboots all the VMs in the resource group.
7. Restarts all the pods to make sure they refresh their service account.

## Verification of your cluster

After the above steps, you can check the success of the CA and certs rotation:

- The old  `kubeconfig`  should  **not**  be able to contact the API server. But, the new `kubeconfig` should be able to talk to contact the API server.
- All nodes are expected to be `Ready`, all pods are expected to be  `Running`.
- Try to fetch the logs of  `kube-apiserver`,  `kube-scheduler`  and  `kube-controller-namager`. They should all be run without displaying errors, for example, `kubectl logs kube-apiserver-k8s-master-58431286-0 -n kube-system`.

## Known Limitations

The certificate rotation tool hasn't been tested with the following cluster configurations. You can expect the tool to fail.

- Private clusters
- Clusters using keyvault references in certificate profile
- Clusters using Cosmos **etcd**
- Clusters with already expired certificates an unhealthy **etcd**

The rotation involves rebooting the nodes. ALL VMs in the resource group will restart as part of running the `rotate-certs` command. If the resource group has any VMs that aren’t part of the cluster, they will be restarted as well.

The tool isn't currently idempotent. This means that if the rotation fails halfway though, or is interrupted, you won’t be able to rerun the operation without manual intervention. There is a risk that your cluster will become unrecoverable. Before your rotate your certificates follow the steps in [Preparation for certificate rotation](#preparation-for-certificate-rotation).

## Next steps

- Read about the [The AKS Engine on Azure Stack](azure-stack-kubernetes-aks-engine-overview.md)