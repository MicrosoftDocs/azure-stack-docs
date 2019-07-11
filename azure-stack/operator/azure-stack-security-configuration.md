---
title: Configure Azure Stack security controls
description: Learn how to configure security controls in Azure Stack
services: azure-stack
author: PatAltimore

ms.service: azure-stack
ms.topic: article
ms.date: 06/17/2019
ms.author: patricka
ms.reviewer: fiseraci
ms.lastreviewed: 06/17/2019
# As a service administrator, I want to learn about the security controls applied to Azure Stack, so that I can configure security.
---

# Configure Azure Stack security controls

*Applies to: Azure Stack integrated systems*

This article explains the security controls that can be changed in Azure Stack and highlights the tradeoffs where applicable.

Azure Stack architecture is built on two security principle pillars: assume breach and hardened by default. For more information Azure Stack security, see [Azure Stack infrastructure security posture](azure-stack-security-foundations.md). While the default security posture of Azure Stack is production-ready, there are some deployment scenarios that require additional hardening.

## TLS version policy

The Transport Layer Security (TLS) protocol is a widely adopted cryptographic protocol to establish an encrypted communication over the network. TLS has evolved over time and multiple versions have been released. Azure Stack infrastructure exclusively uses TLS 1.2 for all its communications. For external interfaces, Azure Stack currently defaults to use TLS 1.2. However, for backwards compatibility, it also supports negotiating down to TLS 1.1. and 1.0. When a TLS client requests to communicate over TLS 1.1 or TLS 1.0, Azure Stack honors the request by negotiating to a lower TLS version. If the client requests TLS 1.2, Azure Stack will establish a TLS connection using TLS 1.2.

Since TLS 1.0 and 1.1 are incrementally being deprecated or banned by organizations and compliance standards, beginning with the 1906 update, you can now configure the TLS policy in Azure Stack. You can enforce a TLS 1.2 only policy where any attempt of establishing a TLS session with a version lower than 1.2 is not permitted and rejected.

> [!IMPORTANT]
> Microsoft recommends using TLS 1.2 only policy for Azure Stack production environments.

## Get TLS policy

Use the [privileged endpoint (PEP)](azure-stack-privileged-endpoint.md) to view the TLS policy for all Azure Stack endpoints:

```powershell
Get-TLSPolicy
```

Example output:

    TLS_1.2

## Set TLS policy

Use the [privileged endpoint (PEP)](azure-stack-privileged-endpoint.md) to set the TLS policy for all Azure Stack endpoints:

```powershell
Set-TLSPolicy -Version <String>
```

Parameters for *Set-TLSPolicy* cmdlet:

| Parameter | Description | Type | Required |
|---------|---------|---------|---------|
| *Version* | Allowed version(s) of TLS in Azure Stack | String | yes|

Use one of the following values to configure the permitted TLS versions for all Azure Stack endpoints:

| Version value | Description |
|---------|---------|
| *TLS_All* | Azure Stack TLS endpoints support TLS 1.2, but down negotiation to TLS 1.1 and TLS 1.0 is allowed. |
| *TLS_1.2* | Azure Stack TLS endpoints support TLS 1.2 only. | 

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

- [Learn about Azure Stack infrastructure security posture](azure-stack-security-foundations.md)
- [Learn how to rotate your secrets in Azure Stack](azure-stack-rotate-secrets.md)
- [Update Windows Defender Antivirus on Azure Stack](azure-stack-security-av.md)
