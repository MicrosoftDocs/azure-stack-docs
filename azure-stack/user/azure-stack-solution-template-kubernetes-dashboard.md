--- 
title: Access the Kubernetes Dashboard in Azure Stack Hub  
description: Learn how to access the Kubernetes Dashboard in Azure Stack Hub.
author: sethmanheim  
ms.topic: how-to
ms.date: 01/23/2025
ms.author: sethm
ms.lastreviewed: 06/18/2019
ms.custom: sfi-image-nochange

# Intent: As an Azure Stack user, I want to access the Kubernetes dashboard from Azure Stack for basic management operations.
# Keyword: azure stack kubernetes dashboard

---
 
# Access the Kubernetes Dashboard in Azure Stack Hub

> [!NOTE]
> Only use the Kubernetes Azure Stack Marketplace item to deploy clusters as a proof-of-concept. For supported Kubernetes clusters on Azure Stack, use [the AKS engine](azure-stack-kubernetes-aks-engine-overview.md).

Kubernetes includes a web dashboard that you can use for basic management operations. This dashboard lets you view basic health status and metrics for your applications, create and deploy services, and edit existing applications. This article shows you how to set up the Kubernetes dashboard on Azure Stack Hub.

## Prerequisites for Kubernetes Dashboard

- Azure Stack Hub Kubernetes cluster: a Kubernetes cluster deployed to Azure Stack Hub. For more information, see [Deploy Kubernetes](azure-stack-solution-template-kubernetes-deploy.md).
- SSH client: an SSH client to security connect to your control plane node in the cluster. If you use Windows, you can use [Putty](https://www.ssh.com/ssh/putty/download). You need the private key that you used when you deployed your Kubernetes cluster.
- FTP (PSCP): an FTP client that supports SSH and the SSH File Transfer Protocol to transfer the certificates from the control plane node to your Azure Stack Hub management machine. You can use [FileZilla](https://filezilla-project.org/download.php?type=client). You need the private key that you used when you deployed your Kubernetes cluster.

## Overview of steps to enable dashboard

1. Export the Kubernetes certificates from the control plane node in the cluster.
1. Import the certificates to your Azure Stack Hub management machine.
1. Open the Kubernetes web dashboard.

## Export certificate from the master

You can retrieve the URL for the dashboard from the control plane node in your cluster.

1. Get the public IP address and username for your main cluster from the Azure Stack Hub dashboard. To get this information:

   - Sign in to the Azure Stack Hub portal at `https://portal.local.azurestack.external/`.
   - Select **All services** > **All resources**. Find the master in your cluster resource group. The master is named `k8s-master-<sequence-of-numbers>`.

1. Open the control plane node in the portal. Copy the **Public IP** address. Select **Connect** to get your user name in the **Login using VM local account** box. This is the same user name you set when you created your cluster. Use the public IP address rather than the private IP address listed in the connect blade.
1. Open an SSH client to connect to the main cluster. If you use Windows, you can use [Putty](https://www.ssh.com/ssh/putty/download) to create the connection. You use the public IP address for the control plane node, the username, and add the private key you used when you created the cluster.
1. When the terminal connects, type `kubectl` to open the Kubernetes command-line client.
1. Run the following command:

   ```bash
   kubectl cluster-info 
   ```

   Find the URL for the dashboard. For example:  `https://k8-1258.local.cloudapp.azurestack.external/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy`

1. Extract the self-signed certificate and convert it to the PFX format. Run the following command:

   ```bash
   sudo su 
   openssl pkcs12 -export -out /etc/kubernetes/certs/client.pfx -inkey /etc/kubernetes/certs/client.key  -in /etc/kubernetes/certs/client.crt -certfile /etc/kubernetes/certs/ca.crt 
   ```

1. Get the list of secrets in the **kube-system** namespace. Run the following command:

   ```bash
   kubectl -n kube-system get secrets
   ```

   Make note of the kubernetes-dashboard-token-\<XXXXX> value.

1. Get the token and save it. Update the `kubernetes-dashboard-token-<####>` with the secret value from the previous step:

   ```bash
   kubectl -n kube-system describe secret kubernetes-dashboard-token-<####>| awk '$1=="token:"{print $2}' 
   ```

## Import the certificate

1. Open Filezilla and connect to the control plane node. You need the following information:

   - Control plane node public IP
   - Username
   - Private secret
   - Use **SFTP - SSH File Transfer Protocol**

1. Copy `/etc/kubernetes/certs/client.pfx` and  `/etc/kubernetes/certs/ca.crt` to your Azure Stack Hub management machine.
1. Make a note of the file locations. Update the script with the locations, and then open PowerShell with an elevated prompt. Run the updated script:

   ```powershell
   Import-Certificate -Filepath "ca.crt" -CertStoreLocation cert:\LocalMachine\Root 
   $pfxpwd = Get-Credential -UserName 'Enter password below' -Message 'Enter password below' 
   Import-PfxCertificate -Filepath "client.pfx" -CertStoreLocation cert:\CurrentUser\My -Password $pfxpwd.Password 
   ```

## Open the Kubernetes dashboard

1. Disable the pop-up blocker on your web browser.
1. Point your browser to the URL noted when you ran the command `kubectl cluster-info`; for example, `https://azurestackdomainnamefork8sdashboard/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy`.
1. Select the client certificate.
1. Enter the token.
1. Reconnect to the bash command line on the control plane node and give permissions to `kubernetes-dashboard`. Run the following command:

   ```bash
   kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard 
   ```

   The script gives `kubernetes-dashboard` cloud administrator privileges. For more information, see [For RBAC-enabled clusters](/azure/aks/kubernetes-dashboard).

You can now use the dashboard. For more information about the Kubernetes dashboard, see [Kubernetes Web UI Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).

![Azure Stack Hub Kubernetes Dashboard](media/azure-stack-solution-template-kubernetes-dashboard/azure-stack-kub-dashboard.png)

## Troubleshooting

### Custom Virtual Networks

If you encounter connectivity issues accessing the Kubernetes dashboard after you deploy Kubernetes to a [custom virtual network](./kubernetes-aks-engine-custom-vnet.md), ensure that target subnets are linked to the route table and network security group resources that were created by the AKS engine.

Make sure that the network security group rules allow communication between the control plane nodes and the Kubernetes dashboard pod IP. You can validate this permission by using the `ping` command from a control plane node.

## Next steps

- [Deploy Kubernetes to Azure Stack Hub](azure-stack-solution-template-kubernetes-deploy.md)  
- [Add a Kubernetes cluster to the Marketplace (for the Azure Stack Hub operator)](../operator/azure-stack-solution-template-kubernetes-cluster-add.md)
- [Kubernetes on Azure](/azure/container-service/kubernetes/container-service-kubernetes-walkthrough)
