---
title: Troubleshoot issues with Azure Arc enrollment for virtual machines with managed identities
description: This article offers step-by-step troubleshooting guidance for resolving issues when enrolling virtual machines with managed identities.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: troubleshooting
ms.date: 09/30/2025
ms.author: omarrivera
author: g0r1v3r4
---

# Troubleshoot issues with Azure Arc enrollment for virtual machines with managed identities

Use this article to troubleshoot common issues or pitfalls when enrolling Azure Operator Nexus virtual machines (VMs) with Azure Arc using managed identities.

## Feature support versions

- Ensure that your Operator Nexus Cluster is running management bundle `2510.1` version and runtime version `4.7.0`  or later.
- The feature support is available in API version `2025-07-01-preview` or later.
- Make sure the [`networkcloud` az CLI extension] is installed with a version that supports the required API version.
  You can find supported versions in the [`networkcloud` extension release history] on GitHub.

[`networkcloud` az CLI extension]: /cli/azure/networkcloud
[`networkcloud` extension release history]: https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst

## Examine the cloud-init logs

If you're using the `--user-data-content` parameter to pass a cloud-init script during VM creation, you can check the cloud-init logs for errors or issues related to the execution of the script.
For more information, see [Use cloud-init user data script or manual execution for Azure Arc enrollment].

[Use cloud-init user data script or manual execution for Azure Arc enrollment]: howto-arc-enroll-virtual-machine-using-managed-identities.md#use-cloud-init-user-data-script-or-manual-execution-for-azure-arc-enrollment

> [!NOTE]
> The `--user-data` parameter is deprecated and will be removed in a future release.
> Verify in the [`networkcloud` extension release history] for the latest updates.

A cloud-init script is a widely used approach for customizing VMs during their first boot:

- Executes scripts and configurations during VM initialization
- Handles user creation, package installation, and service configuration
- Logs activities to `/var/log/cloud-init-output.log`

## Nexus VM Instance Metadata Service (IMDS) sidecar container

As part of the Nexus VM deployment, an IMDS sidecar container is deployed alongside the VM.
This sidecar container is responsible for proxying requests to the platform level token service.
Nexus VMs are configured to route traffic meant for the IP address `169.254.169.254` to the IMDS sidecar container.
For this reason, the IP address `169.254.169.254` must be added to the `NO_PROXY` environment variable.
The IMDS sidecar container listens on port `80` for HTTP traffic.

## Cloud Services Network (CSN) configurations

Ensure that your cloud services network (CSN) is configured to allow egress traffic to the necessary Azure endpoints.
The CSN must be created with the `--enable-default-egress-endpoints "True"` flag to automatically include the necessary endpoints.
If the flag is skipped or missed during creation, you need to manually add the required endpoints.
For more information, see [Required proxy and network settings to enable outbound connectivity].

The easiest way is to see the egress endpoints configured for the CSN is through Azure portal.
Or, you can use the `networkcloud` extension to verify the setting is set to `True`:

```azurecli-interactive
az networkcloud cloudservicesnetwork show --name "$CSN_NAME" --resource-group "$RESOURCE_GROUP" --query "enableDefaultEgressEndpoints" -o tsv
```

```azurecli-interactive
az networkcloud cloudservicesnetwork show  --name "$CSN_NAME" --resource-group "$RESOURCE_GROUP" --query "additionalEgressEndpoints"
```

```azurecli-interactive
az networkcloud cloudservicesnetwork show --name "$CSN_NAME" --resource-group "$RESOURCE_GROUP" --query "enabledEgressEndpoints"
```

### CSN Proxy configuration

The CSN proxy is used by the VM for egress traffic. The value is always `http://169.254.0.11:3128`.
For more information, see [Required proxy and network settings to enable outbound connectivity].

[Required proxy and network settings to enable outbound connectivity]: ./howto-arc-enroll-virtual-machine-using-managed-identities.md#required-proxy-and-network-settings-to-enable-outbound-connectivity

Ensure environment variables are set correctly within the VM session before executing `az login --identity` or `azcmagent connect` commands.

```bash
export HTTPS_PROXY=http://169.254.0.11:3128
export https_proxy=http://169.254.0.11:3128
export HTTPS_PROXY=http://169.254.0.11:3128
export https_proxy=http://169.254.0.11:3128
export NO_PROXY=localhost,127.0.0.1,::1,169.254.169.254
export no_proxy=localhost,127.0.0.1,::1,169.254.169.254
```

Also, the `azcmagent` should set proxy settings:

```bash
azcmagent config set proxy.url "http://169.254.0.11:3128"
```

## Verify Managed Identity permissions

Ensure that the managed identity associated with the VM has the necessary permissions to perform Azure Arc enrollment.
For more information, see [Choose a managed identity option](./howto-arc-enroll-virtual-machine-using-managed-identities.md#choose-a-managed-identity-option).

```azurecli-interactive
az networkcloud virtualmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP" --query "identity"
```

For system-assigned identity

```azurecli-interactive
az role assignment list --assignee $(az networkcloud virtualmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP" --query "identity.principalId" -o tsv)
```

For user-assigned identity

```azurecli-interactive
az role assignment list --assignee $(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "principalId" -o tsv)
```

The required roles to allow the managed identity to Azure Arc enroll the VM are:

- `HybridCompute Machine ListAccessDetails Action`
- `Azure Connected Machine Resource Manager`

Other documentation worth reviewing:

- [How to use managed identities to get an access token]

## VM network connectivity sanity tests

SSH into the VM and run the following commands:

```bash
export NO_PROXY=169.254.169.254

# Basic connectivity test
ping -c 3 169.254.169.254

# Test IMDS sidecar container is accessible and running
curl -v --max-time 3 -H "Metadata:true" "http://169.254.169.254/healthz"
```

```bash
# Test connectivity to Azure Arc endpoints
curl -I https://management.azure.com/
curl -I https://login.microsoftonline.com/
curl -I https://pas.windows.net/
curl -I https://san-af-eastus-prod.azurewebsites.net/
```

```bash
# Test DNS resolution for endpoints
nslookup management.azure.com
nslookup login.microsoftonline.com
```

## Error: Failed to sign in with managed identity

When the `az login --identity` command is executed, and the error indicates that the sign-in with managed identity failed.

Example error messages:

```
ERROR: Failed to log in with system-assigned managed identity

# OR

ERROR: Failed to log in with user-assigned managed identity
```

Possible causes:

- VM wasn't created with an associated managed identity, or the identity was added after VM creation
- System-assigned managed identity isn't enabled on the VM
- User-assigned managed identity isn't properly assigned to the VM
- Identity permissions issues
- IMDS endpoint isn't accessible
- Network connectivity issues
- Check [proxy settings](#csn-proxy-configuration)

Possible solutions:

1. Verify the VM was created with an associated managed identity.
   If the VM wasn't created with an associated managed identity, you must recreate the VM with one to use managed identity authentication.
   For more information, see [Nexus VM with associated managed identities at creation time](./howto-arc-enroll-virtual-machine-using-managed-identities.md#vm-with-associated-managed-identities-at-creation-time).

2. Verify the correct managed identity is assigned to the VM.
   For more information, see the [Verify Managed Identity permissions](#verify-managed-identity-permissions) section.

3. Check IMDS connectivity from within the VM.
   If the IMDS endpoint isn't accessible, there could be a network connectivity issue or the IMDS sidecar container might not be running.
   For more information, see the [VM network connectivity sanity tests](#vm-network-connectivity-sanity-tests) section.

## Error: Failed to retrieve access token

When either the `az login --identity` or `az account get-access-token` commands are executed, and the error indicates that the access token couldn't be retrieved.

Example error message:

```
ERROR: Failed to retrieve access token
```

Possible causes:

- Managed identity isn't associated with the VM
- Managed identity permissions are insufficient
- Network connectivity to Azure endpoints might be missing from the [CSN egress configurations](#csn-proxy-configuration)
- Check [proxy settings](#csn-proxy-configuration)

Possible solutions:

1. Verify managed identity has appropriate permissions.
   For more information, see the [Assign roles to the managed identity] section.

2. Test network connectivity to Azure endpoints.
   For more information, see the [VM network connectivity sanity tests](#vm-network-connectivity-sanity-tests) section.

3. Check [CSN egress endpoints configurations](#cloud-services-network-csn-configurations).
   Ensure that the CSN has the required egress endpoints configured.

[Assign roles to the managed identity]: ./howto-arc-enroll-virtual-machine-using-managed-identities.md#assign-roles-to-the-managed-identity

## Error: Failed to connect to Azure Arc

When the `azcmagent connect` command is executed, and the error indicates the connection, or the enrollment failed.

Example error message:
```
ERROR: Failed to connect to Azure Arc
```

Possible causes:

- Network connectivity issues to Azure Arc endpoints
- Insufficient permissions for Arc enrollment
- Invalid access token
- Resource group or subscription issues
- Network connectivity to Azure endpoints might be missing from the [CSN egress configurations](#csn-proxy-configuration)
- Check [proxy settings](#csn-proxy-configuration)

Possible solutions:

1. Ensure that the access token is valid and isn't expired.
   Usually, the access token retrieved using `az account get-access-token` is valid for short period of time.
   Anytime permissions on the managed identity are changed, a new access token must be retrieved.

2. Verify required Azure Arc endpoints are accessible:
   For more information, see the [VM network connectivity sanity tests](#vm-network-connectivity-sanity-tests) section.

3. Check if the managed identity has the necessary roles assigned for Azure Arc enrollment.
   For more information, see the [Verify Managed Identity permissions](#verify-managed-identity-permissions) section.

4. Check [CSN egress endpoints configurations](#cloud-services-network-csn-configurations).
   Ensure that the CSN has the required egress endpoints configured.

5. Check [Proxy settings](#csn-proxy-configuration).
   Ensure that the proxy settings are correctly configured in the environment variables and for `azcmagent`.

6. Verify `azcmagent` version and status:

   ```bash
   azcmagent version
   azcmagent show
   ```

7. Run `azcmagent` with more debugging:

   ```bash
   sudo azcmagent connect \
       --resource-group "$RESOURCE_GROUP" \
       --tenant-id "$TENANT_ID" \
       --location "$LOCATION" \
       --subscription-id "$SUBSCRIPTION_ID" \
       --access-token "$ACCESS_TOKEN" \
       --verbose \
       --debug
   ```

Follow the steps provided by the Azure Arc agent to troubleshoot further.

- [Azure Connected Machine agent troubleshooting]
- [Azure Connected Machine agent connect reference]

Enable verbose logging for `azcmagent`.
You can also set the verbosity by using the `--verbose` or `--debug` flags when running `azcmagent` commands.
For more information, see [`azcmagent` CLI documentation](/azure/azure-arc/servers/azcmagent).

```bash
azcmagent config set log.level DEBUG
```

Check `azcmagent` logs.

```bash
journalctl -u azcmagent -f
```

## Alternative access token retrieval methods

When authenticating with Azure services, you might need to request an access token using your desired managed identity.
After authenticating with `az login --identity`, you can retrieve an access token for the Azure Resource Manager (ARM) endpoint using the following command:

> [!TIP]
> If the managed identity roles or permissions are changed, the token must be refreshed to reflect the changes.

```azurecli-interactive
ACCESS_TOKEN=$(az account get-access-token --resource https://management.azure.com/ --query accessToken -o tsv)
```

However, if you encounter issues with the Azure CLI `az login --identity` command or prefer not to use it, there are alternative methods to retrieve an access token directly from the IMDS endpoint.
The example is meant to provide alternatives for retrieving the access token using `az rest` or `curl`.

Use `az rest` to retrieve a token with a system-assigned identity:

```azurecli-interactive
az rest --method get \
  --url "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01" \
  --headers '{"Metadata":"true"}'
```

Or using `curl` with a system-assigned identity:

```bash
curl -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01"
```

Use `az rest` to retrieve a token with a user-assigned identity:

> [!IMPORTANT]
> Set the `msi_res_id` query parameter to the resource ID of the user-assigned managed identity.
> URL encode the value before using it. The example assumes the value is already encoded.

```azurecli
az rest --method get \
  --url "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01&msi_res_id=${UAMI_ID}" \
  --headers '{"Metadata":"true"}'
```

Or using `curl` with a user-assigned identity:

```bash
curl -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01&msi_res_id=${UAMI_ID}"
```

[!INCLUDE[stillHavingIssues](./includes/contact-support.md)]

If you're still experiencing issues after following this troubleshooting guide, consider reaching out to Microsoft support for further assistance.
When contacting support, provide the following information to help diagnose the issue:

  - Cloud-init logs: `/var/log/cloud-init-output.log`
  - `azcmagent` logs: `sudo journalctl -u azcmagent`
  - Network connectivity tests results
  - VM and managed identity configuration details
  - [CSN configuration details](#cloud-services-network-csn-configurations)
  - [Proxy settings used](#csn-proxy-configuration)
  - Exact error messages encountered when running `az login --identity` and `azcmagent connect` commands

## Related articles

- [How to enroll Azure Operator Nexus virtual machines with Azure Arc using managed identities](./howto-arc-enroll-virtual-machine-using-managed-identities.md)
- [Prerequisites for deploying tenant workloads](./quickstarts-tenant-workload-prerequisites.md)
- [Create a virtual machine using Azure CLI](./quickstarts-virtual-machine-deployment-cli.md)
- [Create a virtual machine using PowerShell](./quickstarts-virtual-machine-deployment-ps.md)
- [Create a virtual machine using ARM template](./quickstarts-virtual-machine-deployment-arm.md)
- [Create a virtual machine using Bicep](./quickstarts-virtual-machine-deployment-bicep.md)
- [Connect hybrid machines to Azure using a deployment script](/azure/azure-arc/servers/onboard-portal#install-and-validate-the-agent-on-linux)
- [Quickstart: Connect a Linux machine with Azure Arc-enabled servers (package-based installation)](/azure/azure-arc/servers/quick-onboard-linux)
- [Quickstart: Connect a machine to Arc-enabled servers (Windows or Linux install script)](/azure/azure-arc/servers/quick-enable-hybrid-vm)
- [Azure Connected Machine agent troubleshooting]
- [Managed identities troubleshooting]
- [Azure Connected Machine agent connect reference]
- [How to use managed identities to get an access token]

<!-- Links added for reuse -->
[Azure Connected Machine agent troubleshooting]: /azure/azure-arc/servers/troubleshoot-agent-onboard
[Managed identities troubleshooting]: /entra/identity/managed-identities-azure-resources/managed-identities-faq
[Azure Connected Machine agent connect reference]: /azure/azure-arc/servers/azcmagent-connect#access-token
[How to use managed identities to get an access token]: /entra/identity/managed-identities-azure-resources/how-to-use-vm-token#get-a-token-using-go