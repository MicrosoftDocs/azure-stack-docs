---
title: Use Active Directory credentials in AKS for Azure Stack HCI
description: Use Active Directory Authentication to securely connect to the API server with SSO credentials
author: v-susbo
ms.topic: how-to
ms.date: 11/19/2020
ms.author: v-susbo
ms.reviewer: 
---

# Use Active Directory credentials in Azure Kubernetes Service for Azure Stack HCI

> Applies to: AKS on Azure Stack HCI, AKS runtime on Windows Server 2019 Datacenter

Without Active Directory Authentication, users must rely on certificate-based kubeconfig when connecting to the API server via the kubectl command line tool. The kubeconfig file contains secrets, such as private keys and certificates, that need to be carefully distributed, which presents significant security risks.

As an alternate to using kubeconfig, a secure way is to use Active Directory (AD) credentials to connect to the api-server. AD integration with AKS-HCI lets a user on a Windows domain joined machine connect to the api-server (via kubectl) using their SSO credentials. This removes the need to manage and distribute kubeconfigs that contain private keys and certificates. Additionally, the entire connection experience is seamless and the user is not prompted login again.

AD connectivity also requires kubeconfig to connect to the api-server, however, AD kubeconfig doesn’t contain any secrets and can be freely distributed. The certificate-based kubeconfig can be used for backup purposes, such as troubleshooting if there are any issues with connecting with AD credentials.

**Note**: We currently support AD Authentication only for the target clusters.

## Before you begin
There are three steps to set up AD Authentication:
1. Create the AD account for the api-server and generate the *keytab* file.
2. Use the *keytab* file to install the AD Authentication feature.
3. Set up the client machine so that it has the required binaries to use the AD Authentication feature.

Make sure you have sufficient privileges to create AD user in your domain server (if you have one). If you don’t already have a Domain Controller, you can use the following information to join your client machine to our test domain.

On the domain, bAKSDom.nttest.microsoft.com, do the following:
1.	On your client machine, go to **Settings**->**Account**->**Access Work or School**->**Connect**.
2.	Click **Join this device to a local Active Directory domain**.
3.	Enter “BAKSDOM.nttest.microsoft.com” in the **Domain name** and click **Next**.
4.	Enter “bugbash” as the user name and “Sec!ADSSO1” as the password. Click **OK**.
5.	Restart the client machine and log on with BAKSDOM\bugbash account.

## Step 1: Create the AD account and generate a keytab file

YOu can skip this step if the keytab file corresponding to the api-server AD account is already available.

### Create the AD account for the api-server

**Note**: There needs to be one account for each target cluster.

1. If you have access to your domain controller, log on to your domain server and run the New-ADUser command.
2. If you use the provided test domain and your client machine is not a Server SKU, you need to log on to your client machine and enable the optional feature, RSAT for Windows 10. 
    * You can download the RSAT for Windows 10 package at [Microsoft](https://www.microsoft.com/en-us/download/details.aspx?id=45520). Select the package related to your current build, such as WindowsTH-RSAT_WS_1803-x64.msu.
    * Or, if your client machine is newer than Windows 10 October 2018 Update, you have an option to go to **Manage optional features** in **Settings** and click **Add a feature** to see the list of available RSAT tools. 
    * Select and install **RSAT: Server Manager** and **RSAT: Active Directory Domain Services and Lightweight Directory Services Tools**.
    * Once you complete the installation, New-ADUser command will be available in your Powershell window.

 ```powershell
   New-ADUser -Name "<apiserver>" 
        -ServicePrincipalNames "<K8s/apiserver>" 
        -AccountPassword (ConvertTo-SecureString "<password>" -AsPlainText -Force) 
        -KerberosEncryptionType <AES128,AES256>
        -Enabled 1
   ```

“<apiserver>” is the name of the AD account for your api-server
“<K8s/apiserver>” is the a service principal name corresponding to the api-server AD account
“<password>” is the password in plain text
The encryption type can be either AES128 bit or AES 256 bit.

**Example**:
New-ADUser -Name "apiserver_acct" -ServicePrincipalNames "k8s/apiserver" -AccountPassword (ConvertTo-SecureString "p@$$w0rd" -AsPlainText -Force) -KerberosEncryptionType AES256 -Enabled 1

You can verify the SPN for the created user account with the following command:
setspn -l baksdom\apiserver_acct

### Generate the keytab file

You should create one keytab file for each target cluster. Here's an example for using ktpass to generate the keytab file.
If you user your own domain, run this command on the domain controller. If you're using the provided test domain, you need to log on to the domain-joined client machine and copy ktpass.exe from (\\baksdc1\adsso).
    Net use  \\baksdc1\adsso
    Xcopy  \\baksdc1\adsso\ktpass.exe 

**Example**:
ktpass /out <current.keytab> /princ <service/principal@CONTOSO.COM> /mapuser <Domain\account> /crypto all /pass <password> /ptype <KRB5_NT_PRINCIPAL>

- <current.keytab> is file name of the keytab file, make sure you always name your keytab file as current.keytab
- Replace principal with principal created in the previous step and @CONTOSO.COM with your domain name, keep the rest as-is and make sure the FQDN domain name is all caps
- Replace account with the name of the api-server account created in the previous step
- Password is same password that was used to create the AD account

**Example**:
ktpass /out current.keytab /princ k8s/apiserver@BAKSDOM.NTTEST.MICROSOFT.COM /mapuser baksdom\apiserver_acct /crypto all /pass p@$$w0rd /ptype KRB5_NT_PRINCIPAL

## Step 2: Install the AD Authentication feature

1. Create the target cluster using the -enableADAuth option.
    * Deploy AKSHCI clusters with instructions at [Cosine MsK8s - Deploying Kubernetes Clusters](https://osgwiki.com/wiki/Cosine_MsK8s_-_Deploying_Kubernetes_Clusters).
    * Create a target cluster with 
    Note: if the target cluster is not created with the -enableADAuth option, installation of AD Authentication feature will fail.

    **Example**:
    ```powershell
       New-AksHciCluster -clusterName mynewcluster1 -kubernetesVersion v1.18.8 -controlPlaneNodeCount 1 -linuxNodeCount 1 -windowsNodeCount 0 -controlPlaneVmSize Standard_A2_v2 -loadBalancerVmSize Standard_A2_v2 -linuxNodeVmSize Standard_K8S3_v1 -windowsNodeVmSize Standard_K8S3_v1 -enableADAuth
       ```

2. You have two options to install the AD Authentication feature. **Option 1**: If the cluster machine is domain-joined to the domain of the admin user, type the following:
    ```powershell
     Install-AksHciAdAuth -clusterName <mynewcluster> -keytab <.\current.keytab> -SPN <service/principal@CONTOSO.COM> -adminUser <CONTOSO\Bob>
   ```
    * <mynewcluster> is the name of the target cluster created in your previous step
    * <adminUser> is the user name to be given cluster-admin permissions, replace CONTOSO with the name of your domain. The machine must be domain-joined.
    * The name or AD group of the admin user

    **Example**:
    Install-AksHciAdAuth -clusterName mynewcluster1 -keytab .\current.keytab -SPN k8s/apiserver@BAKSDOM.NTTEST.MICROSOFT.COM  -adminUser BAKSDOM\abby
   
    **Option 2**: If your cluster machine is not domain-joined, do the following:
    ```powershell
     Install-AksHciAdAuth -clusterName <mynewcluster> -keytab <.\current.keytab> -SPN <service/principal@CONTOSO.COM> -adminUserSID <SID of CONTOSO\Bob>
   ```

    * <mynewcluster> is the name of the target cluster created in your previous step
    * <adminUserSID> is the SID of the user to be given cluster-admin permissions. To get the SID value, on a domain-joined machine, log on with the user and in an admin command prompt, and run whoami /user:
    ```
    C:\>whoami /user

    USER INFORMATION
    ----------------
    User Name    SID
    ============ =============================================
    baksdom\abby S-1-5-21-3902202350-2488124873-408292158-1000
```
    **Example**:
    ```powershell
       Install-AksHciAdAuth -clusterName mynewcluster1 -keytab .\current.keytab -SPN k8s/apiserver@BAKSDOM.NTTEST.MICROSOFT.COM  -adminUserSID S-1-5-21-3902202350-2488124873-408292158-1000
       ```
**Note**: The Install-AksHciAdAuth command also supports user group and user group SID. Below is the list of supported options.
-adminUser <String>
 The user name to be given cluster-admin permissions. Machine must be domain joined.
 
-adminGroup <String>
 The group name to be given cluster-admin permissions. Machine must be domain joined.
 
-adminUserSID <String>
 The user SID to be given cluster-admin permissions.
 
-adminGroupSID <String>
 The group SID to be given cluster-admin permissions.

## Step 3: Install the AD Authentication feature

Run the following command to verify the webhook is successfully created
.\kubectl.exe -kubeconfig.\ <mynewcluster> get pods -n=kube-system 
Check for ad-auth webhook that it’s running.

Run the following command to verify the secret is successfully created
.\kubectl.exe -kubeconfig.\ <mynewcluster> get sectets -n=kube-system 

Then, check for secret named “keytab”.
