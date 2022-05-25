---
title: Updating AKS on Azure Stack HCI and Windows Server after 60-days
description: Learn how to update AKS on Azure Stack HCI and Windows Server after 60-days
author: mattbriggs
ms.topic: article
ms.date: 05/31/2022
ms.author: mabrigg 
ms.lastreviewed: 05/31/2022
ms.reviewer: X

# Intent: As an IT pro, I want to XXX so that XXX.
# Keyword: 

---

# Updating AKS on Azure Stack HCI and Windows Server after 60-days

If your Azure Kubernetes Service (AKS) on Azure Stack HCI deployment is more than 60 days old, please follow these instructions before upgrading your cluster:

## Before upgrading

### Check that your AKS on Azure Stack HCI and Windows Server cluster is not out-of-policy

If you created a management cluster but haven't deployed a workload cluster in the first 90 days, you should be blocked from creating new workload clusters or node pools because your AKS cluster is out-of-policy.

Follow [these instructions]/azure-stack/aks-hci/known-issues-upgrade#aks-on-azure-stack-hci-goes-out-of-policy-if-a-workload-cluster-hasn-t-been-created-in-60-days-) to resolve this.

### Check that the management cluster api-server is reachable

Run "*Get-AksHciCluster*" and verify that the command returns cluster information. If the command results in a certificate has expired or valid token required error message, this means that the certificate required for one of the management cluster services to communicate to the cloud agent has expired and requires renewal.

Follow [these instructions](https://github.com/Azure/aks-hci/issues/168) to resolve this.

### Check that workload cluster api-server is reachable

Run any *kubectl* commands to verify that you can access each workload cluster. If the command results in unable to connect to server error message, this means that a certificate required for one of the services to communicate to the cloud agent has expired and requires renewal.

Follow these instructions to resolve this. \<-- WE NEED A TSG for this

## Troubleshooting

### Upgrade process seems to be hanging

During the upgrade process, the node agent service could fail to start due to token expiry on restart. This would cause the upgrade to hang.

Follow [these instructions](/azure-stack/aks-hci/known-issues-upgrade#nodeagent-leaking-ports-when-unable-to-join-cloudagent-due-to-expired-token-when-cluster-not-upgraded-for-more-than-60-days-) to resolve this issue.

## Post upgrading, check that the certificate renewal pod is in running state

After upgrading or scaling up your workload cluster, the certificate renewal pod could run into a crash loop state.

Follow [these instructions](/azure-stack/aks-hci/known-issues-upgrade#certificate-renewal-pod-is-in-a-crash-loop-state-) to resolve this issue.


## Next steps

[link](content.md)