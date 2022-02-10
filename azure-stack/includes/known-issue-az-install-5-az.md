---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 11/4/2021
ms.reviewer: balsu
ms.lastreviewed: 11/4/2021
---

### Error thrown with New-AzADServicePrincipal and New-AzADApplication

- Applicable: Azure Stack environments using Azure Active Directory (Azure AD).
- Cause: Azure Active Directory Graph introduced a breaking change to restrict the `IdentifierUri` for Active Directory applications to be the subdomains of a verified domain in the directory. Before the change, this restriction was only enforced for the multi-tenant apps. Now this restriction applies to single tenant apps as well. The change will result in the following error: `Values of identifierUris property must use a verified domain of the organization or its subdomain' is displayed when running`. 
- Remediation: You can work around this restriction in two ways.
    - You'll need to use a service principle name that is a subdomain of the directory tenant. For example, if the directory is `contoso.onmicrosoft.com`, the service principal name has to be of the form of `<foo>.contoso.onmicrosoft.com`. Use the following cmdlet:
        ```powershell  
        New-AzADServicePrincipal -Role Owner -DisplayName <foo>.contoso.onmicrosoft.com
        ```
        For more information about identity and using service principals with Azure Stack Hub, see [Overview of identity providers for Azure Stack Hub](/azure-stack/operator/azure-stack-identity-overview).
    
    - Create the Azure AD app providing a valid `IdentifierUri` and then create the service principal associating the app using the following cmdlet:
        ```powershell  
        $app=New-AzADApplication -DisplayName 'newapp' -IdentifierUris http://anything.contoso.onmicrosoft.com
        New-AzADServicePrincipal -Role Owner -ApplicationId $app.ApplicationId
        ```

- Occurrence: Common


### Error thrown with Set-AzKeyvaultAccessPolicy

- Applicable: Azure Stack environments using ADFS.
- Symptom: Error thrown as  `Requested OData version is not supported.  Only OData version 4.0 is supported` while executing the cmdlet. 
- Remediation: 
    - Please use the BypassObjectIdValidation parameter
        ```powershell  
                Set-AzKeyVaultAccessPolicy -VaultName $KeyVaultName -ResourceGroupName $RGName -ObjectId $ServicePrincipalObjectId -BypassObjectIdValidation -PermissionsToKeys all -PermissionsToSecrets all
        ```
- Occurrence: Common

