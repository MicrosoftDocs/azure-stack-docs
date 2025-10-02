---
title: Troubleshoot issues with virtual machine Arc enrollment using managed identities
description: This article offers step-by-step troubleshooting guidance for resolving issues when enrolling virtual machines with managed identities in Azure Arc.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: troubleshooting
ms.date: 09/30/2025
ms.author: omarrivera
author: g0r1v3r4
---

# Troubleshoot Nexus virtual machines using managed identities

Use this article to troubleshoot common problems encountered when enrolling Azure Operator Nexus virtual machines (VM) with Azure Arc using managed identities associated with the VM.

## Feature support versions

- Ensure that your Nexus Cluster is running Azure Local Nexus `2510.1` Management Bundle and `4.7.0` Minor Runtime or later.
- The feature support is available in API version `2025-07-01-preview` or later.
- Make sure the [`networkcloud` extension] is installed with a version that supports the required API version.
  You can find supported versions in the [`networkcloud` extension release history] on GitHub.

[`networkcloud` extension]: /cli/azure/networkcloud
[`networkcloud` extension release history]: https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst

> [!IMPORTANT]
> To use managed identity features for Azure Arc enrollment, you must assign a system-assigned or user-assigned managed identity when you create the VM.
> You can't add a managed identity after the VM is created.
> If you plan to authenticate using other methods, such as service principals or personal access tokens, a managed identity isn't required.

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
If the flag was skipped or missed during creation, you will need to manually add the required endpoints.
See [Required proxy and network settings to enable outbound connectivity], for more details.

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
See [Required proxy and network settings to enable outbound connectivity], for more details.

[Required proxy and network settings to enable outbound connectivity]: ./howto-arc-enroll-virtual-machine-using-managed-identities.md#required-proxy-and-network-settings-to-enable-outbound-connectivity

Ensure environment variables are set correctly within the prior to executing `az login --identity` or `azcmagent connect` commands.

```bash
export HTTPS_PROXY=http://169.254.0.11:3128
export https_proxy=http://169.254.0.11:3128
export HTTPS_PROXY=http://169.254.0.11:3128
export https_proxy=http://169.254.0.11:3128
export NO_PROXY=169.254.169.254
export no_proxy=169.254.169.254
```

Also, the `azcmagent` should set proxy settings:

```bash
azcmagent config set proxy.url "http://169.254.0.11:3128"
```

## Verify Managed Identity permissions

Ensure that the managed identity associated with the VM has the necessary permissions to perform Azure Arc enrollment.
See [Choose a managed identity option](./howto-arc-enroll-virtual-machine-using-managed-identities.md#choose-a-managed-identity-option) for more details.

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

# VM network connectivity sanity tests

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

## Error: Failed to login with managed identity

When the `az login --identity` command is executed, and the error indicates that the login with managed identity failed.

Example error messages:

```
ERROR: Failed to login with system-assigned managed identity

# OR

ERROR: Failed to login with user-assigned managed identity
```

Possible causes:

- VM was not created with an associated managed identity, or the identity was added after VM creation
- System-assigned managed identity is not enabled on the VM
- User-assigned managed identity is not properly assigned to the VM
- Identity permissions issues
- IMDS endpoint is not accessible
- Network connectivity issues
- Check [proxy settings](#csn-proxy-configuration)

1. Verify the VM was created with an associated managed identity.
   If the VM was not created with an associated managed identity, you must recreate the VM with one to use managed identity authentication.
   See [Nexus VM with associated managed identities at creation time](./howto-arc-enroll-virtual-machine-using-managed-identities.md#nexus-vm-with-associated-managed-identities-at-creation-time) for more information.

2. Verify the managed identity has been assigned to the VM.
   See the [Verify Managed Identity permissions](#verify-managed-identity-permissions) section for more details.


3. Check IMDS connectivity from within the VM.
   If the IMDS endpoint is not accessible, there could be a network connectivity issue or the IMDS sidecar container may not be running.
   See the [VM network connectivity sanity tests](#vm-network-connectivity-sanity-tests) section for more details.

## Error: Failed to retrieve access token

When either the `az login --identity` or `az account get-access-token` commands are executed, and the error indicates that the access token could not be retrieved.

Example error message:

```
ERROR: Failed to retrieve access token
```

Possible causes:

- Managed identity is not associated with the VM
- Managed identity permissions are insufficient
- Network connectivity to Azure endpoints is blocked by [CSN egress configurations](#csn-proxy-configuration)
- Check [proxy settings](#csn-proxy-configuration)

1. Verify managed identity has appropriate permissions.
   See the [Assign roles to the managed identity] for more details.

2. Test network connectivity to Azure endpoints.
  See the [VM network connectivity sanity tests](#vm-network-connectivity-sanity-tests) section for more details.

3. Check [CSN egress endpoints configurations](#cloud-services-network-csn-configurations).
   Ensure that the CSN has the required egress endpoints configured.

[Assign roles to the managed identity]: ./howto-arc-enroll-virtual-machine-using-managed-identities.md#assign-roles-to-the-managed-identity

## Error: Failed to connect to Azure Arc

When the `azcmagent connect` command is executed, and the error indicates that the connection or the enrollment failed.

Example error message:
```
ERROR: Failed to connect to Azure Arc
```

Possible causes:

- Network connectivity issues to Azure Arc endpoints
- Insufficient permissions for Arc enrollment
- Invalid access token
- Resource group or subscription issues
- Network connectivity to Azure endpoints is blocked by [CSN egress configurations](#csn-proxy-configuration)
- Check [proxy settings](#csn-proxy-configuration)

1. Ensure that the access token is valid and has not expired.
   Usually, the access token retrieved using `az account get-access-token` is valid for short period of time.
   Anytime permissions on the managed identity are changed, a new access token must be retrieved.

2. Verify required Azure Arc endpoints are accessible:
   See the [VM network connectivity sanity tests](#vm-network-connectivity-sanity-tests) section for more details.

3. Check if the managed identity has the necessary roles assigned for Azure Arc enrollment.
   See the [Verify Managed Identity permissions](#verify-managed-identity-permissions) section for more details.

4. Check [CSN egress endpoints configurations](#cloud-services-network-csn-configurations).
   Ensure that the CSN has the required egress endpoints configured.

5. Check [Proxy settings](#csn-proxy-configuration).
   Ensure that the proxy settings are correctly configured in the environment variables and for `azcmagent`.

6. Verify azcmagent version and status:

   ```bash
   azcmagent version
   azcmagent show
   ```

7. Run azcmagent with additional debugging:

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

Please follow the steps provided by the Azure Arc agent to troubleshoot further.

- [Azure Connected Machine agent troubleshooting]
- [Azure Connected Machine agent connect reference]

### Enable azcmagent logging

Enable verbose logging for azcmagent.
You can also set the verbosity by using the `--verbose` or `--debug` flags when running `azcmagent` commands.
See [azcmagent CLI documentation](/azure/azure-arc/servers/azcmagent) for more details.

```bash
azcmagent config set log.level DEBUG
```

Check azcmagent logs.

```bash
journalctl -u azcmagent -f
```

## Alternative access token retrieval methods

There may be scenarios where using `az login --identity` does not work as expected.
If you prefer not to use the Azure CLI for authentication, you can retrieve an access token directly using `az rest` or `curl`.
This approach can be useful in environments where the Azure CLI is not available or if you encounter issues with the CLI.

The example is meant to provide alternatives for retrieving the access token; however, it is always preferred to use the Azure CLI.

### Using `az rest`

With a system-assigned identity:

```azurecli
az rest --method get \
  --url "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01" \
  --headers '{"Metadata":"true"}'
```

Or using a user-assigned identity:

> [!IMPORTANT]
> The `msi_res_id` query parameter must be set to the resource ID of the user-assigned managed identity.
> The value must be URL encoded. The example assumes this is done already. Outside the scope of this example.

```azurecli
az rest --method get \
  --url "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01&msi_res_id=${UAMI_ID}" \
  --headers '{"Metadata":"true"}'
```

### Using `curl`

```bash
curl -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01"
```

```bash
curl -H "Metadata: true" "http://169.254.169.254/metadata/identity/oauth2/token?resource=https%3A%2F%2Fmanagement.core.windows.net%2F&api-version=2018-02-01&msi_res_id=${UAMI_ID}"
```

[!include[stillHavingIssues](./includes/contact-support.md)]

If you're still experiencing issues after following this troubleshooting guide, consider reaching out to Microsoft support for further assistance.
When contacting support, provide the following information to help diagnose the issue:

  - Cloud-init logs: `/var/log/cloud-init-output.log`
  - azcmagent logs: `sudo journalctl -u azcmagent`
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