---
title: Configure group Managed Service Account with AKS on Azure Stack HCI
description: Learn how to configure group Managed Service Accounts for containers on Windows nodes
author: mattbriggs
ms.topic: how-to
ms.date: 04/16/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha
---

# Configure group Managed Service Account with AKS on Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022 Datacenter, Windows Server 2019 Datacenter

To use AD Authentication, you can configure a Windows container to run with a group Managed Service Account (gMSA) for containers with a non-domain joined host. A [group Managed Service Account](/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview) is a special type of service account introduced in Windows Server 2012 that's designed to allow multiple computers to share an identity without having to know the password. Windows containers cannot be domain joined, but many Windows applications that run in Windows containers still need AD Authentication.

> [!NOTE]
> To learn how the Kubernetes community supports using gMSA with Windows containers, see [configuring gMSA](https://kubernetes.io/docs/tasks/configure-pod-container/configure-gmsa).

## Architecture of gMSA for containers with a non-domain joined host

gMSA for containers with a non-domain joined host uses a portable user identity instead of a host identity to retrieve gMSA credentials, and therefore, manually joining Windows worker nodes to a domain is no longer necessary. The user identity is saved as a secret in Kubernetes. The diagram below shows the process for configuring gMSA for containers with a non-domain joined host:

![Diagram of group Managed Service Accounts version two](media/gmsa/gmsa-v-2.png)

gMSA for containers with a non-domain joined host provides the flexibility of creating containers with gMSA without joining the host node to the domain. Starting in Windows Server 2019, ccg.exe is supported which enables a plug-in mechanism to retrieve gMSA credentials from Active Directory. You can use that identity to start the container. For more information on ccg.exe, see the [ICcgDomainAuthCredentials interface](/windows/win32/api/ccgplugins/nn-ccgplugins-iccgdomainauthcredentials).

## Comparison of gMSA for containers with a non-domain joined host and a domain joined host

When gMSA was initially introduced, it required the container host to be domain joined, which created a lot of overhead for users to manually join Windows worker nodes to a domain. This limitation has been addressed with gMSA for containers with a non-domain joined host, so users can now use gMSA with domain-unjoined hosts. Other improvements to gMSA include the following:

- Eliminating the requirement to manually join Windows worker nodes to a domain, which caused a lot of overhead for users. For scaling scenarios, this will simplify the process.
- In rolling update scenarios, users no longer must rejoin the node to a domain.
- An easier process for managing the worker node machine accounts to retrieve gMSA service account passwords.
- A less complicated end-to-end process to configure gMSA with Kubernetes.

## Before you begin

To run a Windows container with a group managed service account, you need the following:

- An Active Directory domain with at least one domain controller running Windows Server 2012 or later. There are no forest or domain functional level requirements to use gMSAs, but the gMSA passwords can only be distributed by domain controllers running Windows Server 2012 or later. For more information, see [Active Directory requirements for gMSAs](/windows-server/security/group-managed-service-accounts/getting-started-with-group-managed-service-accounts#BKMK_gMSA_Req).
- Permission to create a gMSA account. To create a gMSA account, you'll need to be a Domain Administrator or use an account that has been given the permission to create msDS-GroupManagedServiceAccount objects.
- Access to the internet to download the [CredentialSpec](https://aka.ms/credspec) PowerShell module. If you're working in a disconnected environment, you can [save the module](/powershell/module/powershellget/save-module?preserve-view=true&view=powershell-5.1) on a computer with internet access and copy it to your development machine or container host.
- To ensure gMSA and AD authentication work, ensure that the Azure Stack HCI cluster nodes are configured to synchronize their time with a domain controller or another time source. You should also make sure Hyper-V is configured to synchronize time to any virtual machines.

## Prepare the gMSA in the domain controller

Follow the steps below to prepare the gMSA in the domain controller:
 
1. In the domain controller, [prepare Active Directory](/virtualization/windowscontainers/manage-containers/manage-serviceaccounts#one-time-preparation-of-active-directory) and [create the gMSA account](/virtualization/windowscontainers/manage-containers/manage-serviceaccounts#create-a-group-managed-service-account).
2. Create a domain user account. This user account/password will be saved as a Kubernetes secret and used to retrieve gMSA password.
3. To create a GMSA account and grant permission to read the password for the gMSA account created in Step 2, run the following [New-ADServiceAccount](/powershell/module/activedirectory/new-adserviceaccount?preserve-view=true&view=windowsserver2019-ps) PowerShell command:

   ```powershell
    New-ADServiceAccount -Name "<gmsa account name>" -DnsHostName "<gmsa account name>.<domain name>.com" -ServicePrincipalNames "host/<gmsa account name>", "host/<gmsa account name>.<domain name>.com" -PrincipalsAllowedToRetrieveManagedPassword <username you created earlier> 
   ```
   For `-PrincipalsAllowedToRetrieveManagedPassword`, specify the domain username you created earlier as shown in the example below:

   ```powershell
   New-ADServiceAccount -Name "WebApp01" -DnsHostName "WebApp01.akshcitest.com" -ServicePrincipalNames "host/WebApp01", "host/WebApp01.akshcitest.com" -PrincipalsAllowedToRetrieveManagedPassword "testgmsa"
   ```
   
## Prepare the gMSA credential spec JSON file 

To prepare the gMSA credential spec JSON file, follow the steps for [creating a credential spec](/virtualization/windowscontainers/manage-containers/manage-serviceaccounts#create-a-credential-spec).

## Configure gMSA for Windows pods and containers in the cluster

The Kubernetes community already supports domain joined Windows worker nodes for [GMSA](https://kubernetes.io/docs/tasks/configure-pod-container/configure-gmsa/). In AKS on Azure Stack HCI, even though you don't need to domain join a Windows worker node, there are other configuration steps that you can't skip. These steps include installing the webhook, the custom resource definition (CRD), and the credential spec, as well as enabling role-based access control (RBAC). The following steps use PowerShell commands that are built to help simplify the configuration process. 

Before completing the steps below, make sure the **AksHci** PowerShell module is installed and `kubectl` can connect to your cluster.

1. To install the webhook, run the following [Install-AksHciGmsaWebhook](./reference/ps/install-akshcigmsawebhook.md) PowerShell command:
   
   ```powershell
   Install-AksHciGMSAWebhook -Name <cluster name>
   ```

   To validate that the webhook pod is successfully running, run the following command:
   
   ```powershell
   kubectl get pods -n kube-system | findstr gmsa
   ```
   You should see one pod with the _gmsa-webhook_ prefix that is running. 
  
2. Create the secret object that stores the Active Directory user credential. Complete the configuration data below and save the settings into a file named secret.yaml.

   ```
   apiVersion: v1
   kind: Secret
   metadata:
      name: <secret-name>
      namespace: <secret under namespace other than the default>
   type: Opaque
   stringData:
      domain: <domain name, for example: akshcitest>
      username: <domain user who can retrieve the gMSA password>
      password: <password>
   ```
   
   Next, run the following command to create the secret object:
   ```powershell
   kubectl apply -f secret.yaml
   ```
   > [!NOTE]
   > If you create a secret under a namespace other than the default, remember to set the namespace of the deployment to the same namespace. 

3. Use the [Add-AksHciGMSACredentialSpec](./reference/ps/add-akshcigmsacredentialspec.md) PowerShell cmdlet below to create the gMSA CRD, enable role-based access control (RBAC), and then assign the role to the service accounts to use a specific gMSA credential spec file. These steps are described in more detail in this Kubernetes article on [configuring gMSA for Windows pods and containers](https://kubernetes.io/docs/tasks/configure-pod-container/configure-gmsa/). 

   Use the JSON credential spec as input for the following PowerShell command (parameters with asterisks * are mandatory): 

   ```powershell
   Add-AksHciGMSACredentialSpec -Name <cluster name>*  
     -credSpecFilePath <path to JSON credspec>* 
     -credSpecName <name for credspec as the k8s GMSACredentialSpec object>* 
     -secretName <name of secret>* 
     -secretNamespace <namespace of secret>  
     -serviceAccount <name of service account to bind to clusterrole>  
     -clusterRoleName <name of clusterrole to use the credspec>*  
     -overwrite 
   ```
   To view an example, see the following:
   ```powershell
   Add-AksHciGMSACredentialSpec -Name mynewcluster 
     -credSpecFilePath .\credspectest.json 
     -credSpecName credspec-mynewcluster 
     -secretName mysecret 
     -clusterRoleName clusterrole-mynewcluster
   ```

## Deploy the application
Create the deployment YAML file using the following example settings. The required entries include `serviceAccountName`, `gmsaCredentialSpecName`, `volumeMounts`, and `dnsconfig`.

1. Add the service account:
   ```yml
   serviceAccountName: default
      securityContext: 
        windowsOptions: 
          gmsaCredentialSpecName:
   ```
2. Add the credential spec object:
   ```yml
   securityContext: 
        windowsOptions: 
          gmsaCredentialSpecName: <cred spec name>
   ```
3. Mount the secret for the deployment:
   ```yml
   volumeMounts:
        - name: <volume name>
          mountPath: <vmount path>
          readOnly: true
      volumes:
        - name: <volume name>
          secret:
            secretName: <secret name>
            items:
              - key: username
                path: my-group/my-username
   ```
  
4. Add the IP address of the domain controller and domain name under dnsconfig: 
   ```yml
   dnsConfig: 
        nameservers:
          - <IP address for domain controller>
        searches: 
          - <domain>
   ```

## Verify the container is working with GMSA 

After you deploy the container, verify that it's working using the following steps:

1. Get your container ID for your deployment by running the following command:
   ```console
   kubectl get pods
   ```
2. Open PowerShell and run the following command:
   ```powershell
   kubectl exec -it <container id> powershell
   ```
3. Once you are in the container, run the following:

   ```
   Nltest /parentdomain 
   Nltest /sc_verify:<domain> 
   ```

   ```Output
   Connection Status = 0 0x0 NERR_Success The command completed successfully. 
   ```
   This output shows that the computer has been authenticated by a domain controller, and a secure channel exists between the client computer and the domain controller.

4. Check if the container can obtain a valid Kerberos Ticket Granting Ticket (TGT).
   ```
   klist get krbtgt
   ```
   ```output
   A ticket to krbtgt has been retrieved successfully
   ```
   
## Clean up gMSA settings in the cluster
If you need to clean up gMSA settings, use the following uninstall steps.

### Uninstall the credential spec
To uninstall, run the following [Remove-AksHcigmsaCredentialSpec](./reference/ps/remove-akshcigmsacredentialspec.md) PowerShell command:

```powershell
Remove-AksHciGMSACredentialSpec -Name <cluster name> -credSpecName <cred spec object name> -clusterRoleName <clusterrole object name> -serviceAccount <serviceaccount object name> -secretNamespace <namespace of the secret object>
```

### Uninstall webhook
To uninstall the webhook, run the following [Uninstall-AksHciGMSAWebhook](./reference/ps/uninstall-akshcigmsawebhook.md) PowerShell command:

```powershell
Uninstall-AksHciGMSAWebhook -Name <cluster name>
```

## Next steps

- [Use persistent volume on a Kubernetes cluster](persistent-volume.md).
- [Monitor AKS on Azure Stack HCI clusters](monitor-logging.md)
