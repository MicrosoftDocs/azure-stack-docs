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

You can rotate your Kubernetes cluster certificates with the AKS Engine rotate-certs command. This article contains the instruction on rotating TLS CA and certificates for your AKS Engine cluster.

## Prerequesites for certificate rotation

- The **etcd** members must be in a healthy state before rotating the CA and certs. The command `etcdctl cluster-health` will show the health of all of the peers and the cluster.
- Your cluster definition file (`apimodel.json`) file reflects the current cluster configuration and contains a working ssh private key that has root access to your cluster's nodes. The cluster definition file is stored when the AKS Engine creates your cluster. The storage location is set to be at the default location at `_output/`. This is a child directory from the working parent directory.

## Preparation for certificate rotation

Before performing any of these instructions on a live cluster

1. Back up your cluster state.
2. Migrate critical workloads to another cluster.

> [!Caution]  
> Rotating certificates can break component connectivity and leave the cluster in an unrecoverable state.

## Certificate rotation

Run the following command to rotate your cluster's certificates:

```bash
aks-engine rotate-certs --azure-env AzureStackCloud
```

> [!WARNING]  
> Rotating certificates will cause cluster downtime.

The following example assumes the default `output/` directory with the resource group name being the same as the cluster's DNS prefix. This command with parameters would look like:

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
4. Rotates **etcd** CA and certificates and restart **etcd** in all of the master nodes.
5. Updates the **kubeconfig**.
6. Reboots all the VMs in the resource group.
7. Restarts all the pods to make sure they refresh their service account.

## Verification of your cluster

After the above steps, you can verify the success of the CA and certs rotation:

- The old  `kubeconfig`  should  **NOT**  be able to contact the API server, however the new `kubeconfig` should be able to talk to it.
- All nodes are expected to be `Ready`, all pods are expected to be  `Running`.
- Try to fetch the logs of  `kube-apiserver`,  `kube-scheduler`  and  `kube-controller-namager`. They should all be running correctly without printing errors, for example, `kubectl logs kube-apiserver-k8s-master-58431286-0 -n kube-system`.

## Known Limitations

The certificate rotation tool hasn't been tested with the following cluster configurations. You can expect the tool to fail.

- Private clusters
- Clusters using keyvault references in certificate profile
- Clusters using Cosmos **etcd**
- Clusters with already expired certificates an an unhealthy **etcd**

The rotation involves rebooting the nodes. ALL VMs in the resource group will restart as part of running the `rotate-certs` command. If the resource group contains any VMs that are not part of the cluster, they will be restarted as well.

The tool isn't currently idempotent. This means that if the rotation fails halfway though or is interrupted, you will most likely not be able to re-run the operation without manual intervention. There is a risk that your cluster will become unrecoverable. Before your rotate your certiicates follow the steps in [Preparation for certificate rotation](#preparation-for-certificate-rotation).

## Next steps

- Read about the [The AKS Engine on Azure Stack](azure-stack-kubernetes-aks-engine-overview.md)