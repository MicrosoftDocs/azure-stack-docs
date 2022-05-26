---
title: Updating AKS on Azure Stack HCI and Windows Server after 60-days
description: Learn how to update AKS on Azure Stack HCI and Windows Server after 60-days
author: mattbriggs
ms.topic: how-to
ms.date: 05/31/2022
ms.author: mabrigg 
ms.lastreviewed: 05/31/2022
ms.reviewer: rbaziwane

# Intent: As an IT pro, I want to update my certificates so that my Kubernetes cluster continues to operate.
# Keyword: certificates cluster 

---

# Update certificates on AKS on Azure Stack HCI and Windows Server after 60 days

If Azure Kubernetes Service (AKS) on Azure Stack HCI deployment is more than 60 days old, follow the instructions in this article before upgrading the cluster:

## Before upgrading

1. Check that AKS on Azure Stack HCI and Windows Server cluster isn't out-of-policy.

    If you created a management cluster but haven't deployed a workload cluster in the first 90 days, you should be blocked from creating new workload clusters or node pools. The AKS cluster is out-of-policy.
    
    Follow the instructions [AKS on Azure Stack HCI goes out-of-policy if a workload cluster hasn't been created in 60 days.](/azure-stack/aks-hci/known-issues-upgrade#aks-on-azure-stack-hci-goes-out-of-policy-if-a-workload-cluster-hasn-t-been-created-in-60-days-) to resolve the issue.

2. Check that you can reach the management cluster `api-server`.

    Run [`Get-AksHciCluster`](./reference/ps/get-akshcicluster.md) and verify that the command returns cluster information. If the command results an error message that says the certificate has expired or valid token required,  the certificate required for one of the management cluster services to communicate to the cloud agent has expired. You'll need to renew the certificate.

    The user is expected to relogin once the certificate expires. Execute the following command in PowerShell to relogin.
    ```powershell
    Repair-MocLogin
    ```

    For more information, see [Mocctl certificate expired if not used for more than 60 days](https://github.com/Azure/aks-hci/issues/168).

3. Check that you can reach the workload cluster `api-server`.

    Run any `kubectl` command to verify that you can access each workload cluster. If the command results in unable to connect to server error message,  a certificate required for one of the services to communicate to the cloud agent has expired and requires renewal.
    
    Follow the following instructions: `need instructions`

## Troubleshooting

The following steps may help resolve common issues with the certificates.
### Upgrade process seems to be hanging

During the upgrade process, the node agent service fails to start due to token expiry on restart. The failure may cause the upgrade to hang.

Follow the instructions [Nodeagent leaking ports when unable to join cloudagent due to expired token when cluster not upgraded for more than 60 days](/azure-stack/aks-hci/known-issues-upgrade#nodeagent-leaking-ports-when-unable-to-join-cloudagent-due-to-expired-token-when-cluster-not-upgraded-for-more-than-60-days-) to resolve the issue.

## Post upgrading, check that the certificate renewal pod is in running state

After you upgrade or scaling up the workload cluster, the certificate renewal pod may run into a crash loop state.

Follow the instructions [Certificate renewal pod is in a crash loop state](/azure-stack/aks-hci/known-issues-upgrade#certificate-renewal-pod-is-in-a-crash-loop-state-).
## Next steps

Learn about [Certificates and tokens in Azure Kubernetes Service on Azure Stack HCI and Windows Server](certificates-and-tokens.md)