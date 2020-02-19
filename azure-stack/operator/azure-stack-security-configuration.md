---
title: Configure Azure Stack Hub security controls
description: Learn how to configure security controls in Azure Stack Hub
author: IngridAtMicrosoft

ms.topic: article
ms.date: 06/17/2019
ms.author: inhenkel
ms.reviewer: fiseraci
ms.lastreviewed: 06/17/2019
# As a service administrator, I want to learn about the security controls applied to Azure Stack Hub, so that I can configure security.
---

# Configure Azure Stack Hub security controls

This article explains the security controls that can be changed in Azure Stack Hub and highlights the tradeoffs where applicable.

Azure Stack Hub architecture is built on two security principle pillars: assume breach and hardened by default. For more information Azure Stack Hub security, see [Azure Stack Hub infrastructure security posture](azure-stack-security-foundations.md). While the default security posture of Azure Stack Hub is production-ready, there are some deployment scenarios that require additional hardening.

## TLS version policy

The Transport Layer Security (TLS) protocol is a widely adopted cryptographic protocol to establish an encrypted communication over the network. TLS has evolved over time and multiple versions have been released. Azure Stack Hub infrastructure exclusively uses TLS 1.2 for all its communications. For external interfaces, Azure Stack Hub currently defaults to use TLS 1.2. However, for backwards compatibility, it also supports negotiating down to TLS 1.1. and 1.0. When a TLS client requests to communicate over TLS 1.1 or TLS 1.0, Azure Stack Hub honors the request by negotiating to a lower TLS version. If the client requests TLS 1.2, Azure Stack Hub will establish a TLS connection using TLS 1.2.

Since TLS 1.0 and 1.1 are incrementally being deprecated or banned by organizations and compliance standards, beginning with the 1906 update, you can now configure the TLS policy in Azure Stack Hub. You can enforce a TLS 1.2 only policy where any attempt of establishing a TLS session with a version lower than 1.2 is not permitted and rejected.

> [!IMPORTANT]
> Microsoft recommends using TLS 1.2 only policy for Azure Stack Hub production environments.

## Get TLS policy

Use the [privileged endpoint (PEP)](azure-stack-privileged-endpoint.md) to view the TLS policy for all Azure Stack Hub endpoints:

```powershell
Get-TLSPolicy
```

Example output:

    TLS_1.2

## Set TLS policy

Use the [privileged endpoint (PEP)](azure-stack-privileged-endpoint.md) to set the TLS policy for all Azure Stack Hub endpoints:

```powershell
Set-TLSPolicy -Version <String>
```

Parameters for *Set-TLSPolicy* cmdlet:

| Parameter | Description | Type | Required |
|---------|---------|---------|---------|
| *Version* | Allowed version(s) of TLS in Azure Stack Hub | String | yes|

Use one of the following values to configure the permitted TLS versions for all Azure Stack Hub endpoints:

| Version value | Description |
|---------|---------|
| *TLS_All* | Azure Stack Hub TLS endpoints support TLS 1.2, but down negotiation to TLS 1.1 and TLS 1.0 is allowed. |
| *TLS_1.2* | Azure Stack Hub TLS endpoints support TLS 1.2 only. | 

Updating the TLS policy takes a few minutes to complete.

### Enforce TLS 1.2 configuration example

This example sets your TLS policy to enforce TLS 1.2 only.

```powershell
Set-TLSPolicy -Version TLS_1.2
```

Example output:

    VERBOSE: Successfully setting enforce TLS 1.2 to True
    VERBOSE: Invoking action plan to update GPOs
    VERBOSE: Create Client for execution of action plan
    VERBOSE: Start action plan
    <...>
    VERBOSE: Verifying TLS policy
    VERBOSE: Get GPO TLS protocols registry 'enabled' values
    VERBOSE: GPO TLS applied with the following preferences:
    VERBOSE:     TLS protocol SSL 2.0 enabled value: 0
    VERBOSE:     TLS protocol SSL 3.0 enabled value: 0
    VERBOSE:     TLS protocol TLS 1.0 enabled value: 0
    VERBOSE:     TLS protocol TLS 1.1 enabled value: 0
    VERBOSE:     TLS protocol TLS 1.2 enabled value: 1
    VERBOSE: TLS 1.2 is enforced

### Allow all versions of TLS (1.2, 1.1 and 1.0) configuration example

This example sets your TLS policy to allow all versions of TLS (1.2, 1.1 and 1.0).

```powershell
Set-TLSPolicy -Version TLS_All
```

Example output:

    VERBOSE: Successfully setting enforce TLS 1.2 to False
    VERBOSE: Invoking action plan to update GPOs
    VERBOSE: Create Client for execution of action plan
    VERBOSE: Start action plan
    <...>
    VERBOSE: Verifying TLS policy
    VERBOSE: Get GPO TLS protocols registry 'enabled' values
    VERBOSE: GPO TLS applied with the following preferences:
    VERBOSE:     TLS protocol SSL 2.0 enabled value: 0
    VERBOSE:     TLS protocol SSL 3.0 enabled value: 0
    VERBOSE:     TLS protocol TLS 1.0 enabled value: 1
    VERBOSE:     TLS protocol TLS 1.1 enabled value: 1
    VERBOSE:     TLS protocol TLS 1.2 enabled value: 1
    VERBOSE: TLS 1.2 is not enforced

## Next steps

- [Learn about Azure Stack Hub infrastructure security posture](azure-stack-security-foundations.md)
- [Learn how to rotate your secrets in Azure Stack Hub](azure-stack-rotate-secrets.md)
- [Update Windows Defender Antivirus on Azure Stack Hub](azure-stack-security-av.md)
