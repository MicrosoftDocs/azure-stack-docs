---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 04/27/2022
ms.reviewer: waltero
ms.lastreviewed: 04/27/2022

---

## Expired secret for service principal (SPN) causes cluster to fail

- **Applicable**: This issue applies to all releases.
- **Cause**: When the secret expires for the SPN, the cluster will fail. This will affect all kubernetes clusters that were deployed using AKS engine. When your secret expires, your cluster **will not** be functional.
- **Remediation**: To mitigate the issue, sign in to each kubernetes node to update `/etc/kubernetes/azure.json` config file with a new SPN Application ID and an unexpired secret. You may need to contact your Azure Stack Hub cloud operator to get an SPN and a current secret. For instructions see [Use an app identity to access resources](../operator/give-app-access-to-resources.md) 
1. You can use the following commands on your Linux nodes:
    ```bash  
    sudo sed -i s/f072c125-c99c-4781-9e85-246b981cd52b/094b1318-baea-4584-bf9c-4a40501ce21b/1 /etc/kubernetes/azure.json
    ```
2. Restart the `kubelet` service with the following command:
    ```bash  
    sudo systemctl restart kubelet
    ```
- **Occurrence**: Common