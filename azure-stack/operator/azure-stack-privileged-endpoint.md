---
title: Using the privileged endpoint in Azure Stack Hub 
description: Learn how to use the privileged endpoint (PEP) in Azure Stack Hub as an operator.
author: mattbriggs

ms.topic: article
ms.date: 12/16/2020
ms.author: mabrigg
ms.reviewer: fiseraci
ms.lastreviewed: 04/28/2020
ms.custom: conteperfq4


# Intent: As an Azure Stack operator, I want to use the privileged endpoint in Azure Stack so I can complete certain tasks.
# Keyword: azure stack privileged endpoint PEP

---

# Use the privileged endpoint in Azure Stack Hub

As an Azure Stack Hub operator, you should use the administrator portal, PowerShell, or Azure Resource Manager APIs for most day-to-day management tasks. However, for some less common operations, you need to use the *privileged endpoint* (PEP). The PEP is a pre-configured remote PowerShell console that provides you with just enough capabilities to help you do a required task. The endpoint uses [PowerShell JEA (Just Enough Administration)](/powershell/scripting/learn/remoting/jea/overview) to expose only a restricted set of cmdlets. To access the PEP and invoke the restricted set of cmdlets, a low-privileged account is used. No admin accounts are required. For additional security, scripting isn't allowed.

You can use the PEP to perform these tasks:

- Low-level tasks, such as [collecting diagnostic logs](azure-stack-get-azurestacklog.md).
- Many post-deployment datacenter integration tasks for integrated systems, such as adding Domain Name System (DNS) forwarders after deployment, setting up Microsoft Graph integration, Active Directory Federation Services (AD FS) integration, certificate rotation, and so on.
- To work with support to obtain temporary, high-level access for in-depth troubleshooting of an integrated system.

The PEP logs every action (and its corresponding output) that you perform in the PowerShell session. This provides full transparency and complete auditing of operations. You can keep these log files for future audits.

> [!NOTE]
> In the Azure Stack Development Kit (ASDK), you can run some of the commands available in the PEP directly from a PowerShell session on the development kit host. However, you may want to test some operations using the PEP, such as log collection, because this is the only method available to perform certain operations in an integrated systems environment.

[!INCLUDE [Azure Stack Hub Operator Access Workstation](../includes/operator-note-owa.md)]

## Access the privileged endpoint

You access the PEP through a remote PowerShell session on the virtual machine (VM) that hosts the PEP. In the ASDK, this VM is named **AzS-ERCS01**. If you're using an integrated system, there are three instances of the PEP, each running inside a VM (*Prefix*-ERCS01, *Prefix*-ERCS02, or *Prefix*-ERCS03) on different hosts for resiliency.

Before you begin this procedure for an integrated system, make sure you can access the PEP either by IP address or through DNS. After the initial deployment of Azure Stack Hub, you can access the PEP only by IP address because DNS integration isn't set up yet. Your OEM hardware vendor will provide you with a JSON file named **AzureStackStampDeploymentInfo** that contains the PEP IP addresses.

You may also find the IP address in the Azure Stack Hub administrator portal. Open the portal, for example, `https://adminportal.local.azurestack.external`. Select **Region Management** > **Properties**.

You will need set your current culture setting to `en-US` when running the privileged endpoint, otherwise cmdlets such as Test-AzureStack or Get-AzureStackLog will not work as expected.

> [!NOTE]
> For security reasons, we require that you connect to the PEP only from a hardened VM running on top of the hardware lifecycle host, or from a dedicated and secure computer, such as a [Privileged Access Workstation](https://4sysops.com/archives/understand-the-microsoft-privileged-access-workstation-paw-security-model). The original configuration of the hardware lifecycle host must not be modified from its original configuration  (including installing new software) or used to connect to the PEP.

1. Establish the trust.

   - On an integrated system, run the following command from an elevated Windows PowerShell session to add the PEP as a trusted host on the hardened VM running on the hardware lifecycle host or the Privileged Access Workstation.

      ```powershell  
      Set-Item WSMan:\localhost\Client\TrustedHosts -Value '<IP Address of Privileged Endpoint>' -Concatenate
      ```
      
   - If you're running the ASDK, sign in to the development kit host.

1. On the hardened VM running on the hardware lifecycle host or the Privileged Access Workstation, open a Windows PowerShell session. Run the following commands to establish a remote session on the VM that hosts the PEP:
 
   - On an integrated system:

      ```powershell  
      $cred = Get-Credential

      $pep = New-PSSession -ComputerName <IP_address_of_ERCS> -ConfigurationName PrivilegedEndpoint -Credential $cred -SessionOption (New-PSSessionOption -Culture en-US -UICulture en-US)
      Enter-PSSession $pep
      ```
    
      The `ComputerName` parameter can be either the IP address or the DNS name of one of the VMs that hosts the PEP.

      > [!NOTE]  
      > Azure Stack Hub doesn't make a remote call when validating the PEP credential. It relies on a locally-stored RSA public key to do that.

   - If you're running the ASDK:

      ```powershell  
      $cred = Get-Credential
    
      $pep = New-PSSession -ComputerName azs-ercs01 -ConfigurationName PrivilegedEndpoint -Credential $cred -SessionOption (New-PSSessionOption -Culture en-US -UICulture en-US)
      Enter-PSSession $pep
      ```
    
   When prompted, use the following credentials:
   
   -  **User name**: Specify the CloudAdmin account, in the format **&lt;*Azure Stack Hub domain*&gt;\cloudadmin**. (For ASDK, the user name is **azurestack\cloudadmin**)
   - **Password**: Enter the same password that was provided during installation for the AzureStackAdmin domain administrator account.

   > [!NOTE]
   > If you're unable to connect to the ERCS endpoint, retry steps one and two with another ERCS VM IP address.

1. After you connect, the prompt will change to **[*IP address or ERCS VM name*]: PS>** or to **[azs-ercs01]: PS>**, depending on the environment. From here, run `Get-Command` to view the list of available cmdlets.

   You can find a reference for cmdlets in at [Azure Stack Hub privileged endpoint reference](../reference/pep-2002/index.md)

   Many of these cmdlets are intended only for integrated system environments (such as the cmdlets related to datacenter integration). In the ASDK, the following cmdlets have been validated:

   - Clear-Host
   - Close-PrivilegedEndpoint
   - Exit-PSSession
   - Get-AzureStackLog
   - Get-AzureStackStampInformation
   - Get-Command
   - Get-FormatData
   - Get-Help
   - Get-ThirdPartyNotices
   - Measure-Object
   - New-CloudAdminUser
   - Out-Default
   - Remove-CloudAdminUser
   - Select-Object
   - Set-CloudAdminUserPassword
   - Test-AzureStack
   - Stop-AzureStack
   - Get-ClusterLog

## How to use the privileged endpoint 

As mentioned above, the PEP is a [PowerShell JEA](/powershell/scripting/learn/remoting/jea/overview) endpoint. While providing a strong security layer, a JEA endpoint reduces some of the basic PowerShell capabilities, such as scripting or tab completion. If you try any type of script operation, the operation fails with the error **ScriptsNotAllowed**. This failure is expected behavior.

For instance, to get the list of parameters for a given cmdlet, run the following command:

```powershell
    Get-Command <cmdlet_name> -Syntax
```

Alternatively, you can use the [**Import-PSSession**](/powershell/module/microsoft.powershell.utility/import-pssession?view=powershell-5.1) cmdlet to import all the PEP cmdlets into the current session on your local machine. The cmdlets and functions of the PEP are now available on your local machine, together with tab completion and, more in general, scripting. You can also run the **[Get-Help](/powershell/module/microsoft.powershell.core/get-help)** module to review cmdlet instructions.

To import the PEP session on your local machine, do the following steps:

1. Establish the trust.

   - On an integrated system, run the following command from an elevated Windows PowerShell session to add the PEP as a trusted host on the hardened VM running on the hardware lifecycle host or the Privileged Access Workstation.

      ```powershell
      winrm s winrm/config/client '@{TrustedHosts="<IP Address of Privileged Endpoint>"}'
      ```

   - If you're running the ASDK, sign in to the development kit host.

1. On the hardened VM running on the hardware lifecycle host or the Privileged Access Workstation, open a Windows PowerShell session. Run the following commands to establish a remote session on the virtual machine that hosts the PEP:

   - On an integrated system:
    
      ```powershell  
      $cred = Get-Credential
      
      $session = New-PSSession -ComputerName <IP_address_of_ERCS> `
        -ConfigurationName PrivilegedEndpoint -Credential $cred
      ```
    
      The `ComputerName` parameter can be either the IP address or the DNS name of one of the VMs that hosts the PEP.

   - If you're running the ASDK:
     
      ```powershell  
      $cred = Get-Credential
    
      $session = New-PSSession -ComputerName azs-ercs01 `
        -ConfigurationName PrivilegedEndpoint -Credential $cred
      ```

   When prompted, use the following credentials:

   - **User name**: Specify the CloudAdmin account, in the format **&lt;*Azure Stack Hub domain*&gt;\cloudadmin**. (For ASDK, the user name is **azurestack\cloudadmin**.)
      
   - **Password**: Enter the same password that was provided during installation for the AzureStackAdmin domain administrator account.

1. Import the PEP session into your local machine:

   ```powershell 
   Import-PSSession $session
   ```

1. Now, you can use tab-completion and do scripting as usual on your local PowerShell session with all the functions and cmdlets of the PEP, without decreasing the security posture of Azure Stack Hub. Enjoy!


## Close the privileged endpoint session

As mentioned earlier, the PEP logs every action (and its corresponding output) that you do in the PowerShell session. You must close the session by using the  `Close-PrivilegedEndpoint` cmdlet. This cmdlet correctly closes the endpoint, and transfers the log files to an external file share for retention.

To close the endpoint session:

1. Create an external file share that's accessible by the PEP. In a development kit environment, you can just create a file share on the development kit host.
1. Run the following cmdlet:

   ```powershell  
   Close-PrivilegedEndpoint -TranscriptsPathDestination "\\fileshareIP\SharedFolder" -Credential Get-Credential
   ```

   The cmdlet uses the parameters in the following table:

   | Parameter | Description | Type | Required |
   |---------|---------|---------|---------|
   | *TranscriptsPathDestination* | Path to the external file share defined as "fileshareIP\sharefoldername" | String | Yes|
   | *Credential* | Credentials to access the file share | SecureString | 	Yes |


After the transcript log files are successfully transferred to the file share, they're automatically deleted from the PEP. 

> [!NOTE]
> If you close the PEP session by using the cmdlets `Exit-PSSession` or `Exit`, or you just close the PowerShell console, the transcript logs don't transfer to a file share. They remain in the PEP. The next time you run `Close-PrivilegedEndpoint` and include a file share, the transcript logs from the previous session(s) will also transfer. Don't use `Exit-PSSession` or `Exit` to close the PEP session; use `Close-PrivilegedEndpoint` instead.

## Unlocking the privileged endpoint for support scenarios

During a support scenario, the Microsoft support engineer might need to elevate the privileged endpoint PowerShell session to access the internals of the Azure Stack Hub infrastructure. This process is sometimes informally referred to as "break the glass" or "unlock the PEP". The PEP session elevation process is a two step, two people, two organization authentication process. 
The unlock procedure is initiated by the Azure Stack Hub operator, who retains control of their environment at all times. The operator accesses the PEP and executes this cmdlet:
 
 ```powershell  
      Get-SupportSessionToken
 ```

The cmdlet returns the support session request token, a very long alphanumeric string. The operator then passes the request token to the Microsoft support engineer via a medium of their choice (e.g., chat, email). The Microsoft support engineer uses the request token to generate, if valid, a support session authorization token and sends it back to the Azure Stack Hub operator. On the same PEP PowerShell session, the operator then passes the authorization token as input to this cmdlet:

```powershell  
      unlock-supportsession
      cmdlet Unlock-SupportSession at command pipeline position 1
      Supply values for the following parameters:
      ResponseToken:
 ```

If the authorization token is valid, the PEP PowerShell session is elevated by providing full admin capabilities and full reachability into the infrastructure. 

> [!NOTE]
> All the operations and cmdlets executed in an elevated PEP session must be performed under strict supervision of the Microsoft support engineer. Failure to do so could result in serious downtime, data loss and could require a full redeployment of the Azure Stack Hub environment.

Once the support session is terminated, it is very important to close back the elevated PEP session by using the **Close-PrivilegedEndpoint** cmdlet as explained in the section above. One the PEP session is terminated, the unlock token is no longer valid and cannot be reused to unlock the PEP session again.
An elevated PEP session has a validity of 8 hours, after which, if not terminated, the elevated PEP session will automatically lock back to a regular PEP session.

## Content of the privileged endpoint tokens

The PEP support session request and authorization tokens leverage cryptography to protect access and ensure that only authorized tokens can unlock the PEP session. The tokens are designed to cryptographically guarantee that a response token can only be accepted by the PEP session that generated the request token. 
PEP tokens do not contain any kind of information that could uniquely identify an Azure Stack Hub environment or a customer. They are completely anonymous. Below the details of the content of each token are provided.
 
### Support session request token

The PEP support session request token is composed of three objects:

- A randomly generated Session ID.
- A self-signed certificate, generated for the purpose of having a one-time public/private key pair. The certificate does not contain any information on the environment.
- A time stamp that indicates the request token expiration.

The request token is then encrypted with the public key of the Azure cloud against which the Azure Stack Hub environment is registered to.
 
### Support session authorization response token

The PEP support authorization response token is composed of two objects:

- The randomly generated session ID extracted from the request token.
- A time stamp that indicates the response token expiration.
      
The response token is then encrypted with the self-signed certificate contained in the request token. The self-signed certificate was decrypted with the private key associated with the Azure cloud against which the Azure Stack Hub environment is registered to.


## Next steps

- [Azure Stack Hub diagnostic tools](./diagnostic-log-collection.md)
- [Azure Stack Hub privileged endpoint reference](../reference/pep-2002/index.md)