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

In order to effectively troubleshoot issues, it's important to understand the key components involved in the authentication and enrollment process.
The process relies on platform level components that facilitate communication between the VM and Azure services.

## Feature support versions

- Ensure that your Nexus Cluster is running Azure Local Nexus `2510.1` Management Bundle and `4.7.0` Minor Runtime or later.
- The feature support is available in API version `2025-07-01-preview` or later.
- Make sure the [`networkcloud` extension] is installed with a version that supports the required API version.
  You can find supported versions in the [`networkcloud` extension release history] on GitHub.

[`networkcloud` extension]: /cli/azure/networkcloud
[`networkcloud` extension release history]: https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst

> [!IMPORTANT]
> To use managed identity features for Azure Arc enrollment, you must assign a system-assigned or user-assigned managed identity when you create the VM.
> You cannot add a managed identity after the VM is created.
> If you plan to authenticate using other methods, such as service principals or personal access tokens, a managed identity is not required.

## Examine the cloud-init logs

If you are using the `--user-data-content` parameter to pass a cloud-init script during VM creation, you can check the cloud-init logs for errors or issues related to the execution of the script.
See [Use cloud-init user data script or manual execution for Azure Arc enrollment] for more information.

[Use cloud-init user data script or manual execution for Azure Arc enrollment]: ./howto-arc-enroll-virtual-machine-using-managed-identities#use-cloud-init-user-data-script-or-manual-execution-for-azure-arc-enrollment

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
If this was skipped during creation, you will need to manually add the required endpoints.
See [Required proxy and network settings to enable outbound connectivity], for more details.

The easiest way is to see the egress endpoints configured for the CSN is through Azure portal.
Or, you can use the `networkcloud` extension to check the egress endpoints:

```azurecli-interactive
az networkcloud cloudservicesnetwork show --name "$CSN_NAME" --resource-group "$RESOURCE_GROUP" --query "properties.enabledEgressEndpoints"
```

### Tenant Proxy configuration

The tenant proxy is configured in the Network Fabric Controller (NFC) and is used by the VM for egress traffic.
See [Required proxy and network settings to enable outbound connectivity], for more details.

[Required proxy and network settings to enable outbound connectivity]: ./howto-arc-enroll-virtual-machine-using-managed-identities#required-proxy-and-network-settings-to-enable-outbound-connectivity

Ensure environment variables are set correctly within the prior to executing `az login --identity` or `azcmagent connect` commands.

```bash
export HTTPS_PROXY=http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
export https_proxy=http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
export HTTPS_PROXY=http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
export https_proxy=http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>
export NO_PROXY=169.254.169.254
export no_proxy=169.254.169.254
```

Also, the `azcmagent` should set proxy settings:

```bash
azcmagent config set proxy.url "http://<TENANT_PROXY_IP>:<TENANT_PROXY_PORT>"
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

- System-assigned managed identity is not enabled on the VM
- User-assigned managed identity is not properly assigned to the VM
- Identity permissions issues
- IMDS endpoint is not accessible
- Network connectivity issues

1. Verify the VM was created with an associated managed identity.
   If the VM was not created with an associated managed identity, you must recreate the VM with one to use managed identity authentication.
   See [Nexus VM with associated managed identities at creation time](./howto-arc-enroll-virtual-machine-using-managed-identities#nexus-vm-with-associated-managed-identities-at-creation-time) for more information.

```azurecli-interactive
az networkcloud virtualmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP" --query "identity"
```

1. Check IMDS connectivity from within the VM.
   If the IMDS endpoint is not accessible, there could be a network connectivity issue or the IMDS sidecar container may not be running.
   SSH into the VM and run the following commands:

    ```bash
    export NO_PROXY=169.254.169.254

    # Basic connectivity test
    ping -c 3 169.254.169.254

    # Test IMDS sidecar container is accessible and running
    curl -v --max-time 3 -H "Metadata:true" "http://169.254.169.254/healthz"
    ```

## Error: Failed to retrieve access token

When either the `az login --identity` or `az account get-access-token` commands are executed, and the error indicates that the access token could not be retrieved.

Example error message:

```
ERROR: Failed to retrieve access token
```

Possible causes:

- Managed identity is not associated with the VM
- Managed identity permissions are insufficient
- Network connectivity to Azure endpoints is blocked
- Token request timeout

1. Verify managed identity has appropriate permissions.

   See the [Assign roles to the managed identity] for more details.
   ```bash
   # For system-assigned identity
   az role assignment list \
       --assignee $(az networkcloud virtualmachine show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP" --query "identity.principalId" -o tsv)

   # For user-assigned identity
   az role assignment list \
       --assignee $(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "principalId" -o tsv)
   ```

2. Test network connectivity to Azure endpoints:
   ```bash
   # Test from within the VM
   curl -I https://management.azure.com/
   curl -I https://login.microsoftonline.com/
   ```

3. Check cloud services network egress endpoints configuration:
   ```bash
   az networkcloud cloudservicesnetwork show \
       --name "$CSN_NAME" \
       --resource-group "$RESOURCE_GROUP" \
       --query "additionalEgressEndpoints"
   ```

[Assign roles to the managed identity]: ./howto-arc-enroll-virtual-machine-using-managed-identities#assign-roles-to-the-managed-identity

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

1. Verify required Azure Arc endpoints are accessible:
   ```bash
   # Test connectivity to Azure Arc endpoints
   curl -I https://management.azure.com/
   curl -I https://login.microsoftonline.com/
   curl -I https://pas.windows.net/
   curl -I https://san-af-eastus-prod.azurewebsites.net/
   ```

2. Check if the managed identity has "Azure Connected Machine Onboarding" role:
   ```bash
   az role assignment create \
       --assignee "$PRINCIPAL_ID" \
       --role "Azure Connected Machine Onboarding" \
       --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
   ```

3. Verify azcmagent version and status:
   ```bash
   azcmagent version
   azcmagent show
   ```

4. Run azcmagent with additional debugging:
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

## Managed identity configuration issues

### System-assigned managed identity problems

1. **Verify SAMI is enabled during VM creation:**
   ```bash
   az networkcloud virtualmachine create \
       --mi-system-assigned --system-assigned \
       # ... other parameters
   ```

2. **Check SAMI status after creation:**
   ```bash
   az networkcloud virtualmachine show \
       --name "$VM_NAME" \
       --resource-group "$RESOURCE_GROUP" \
       --query "identity.type"
   ```

### User-assigned managed identity problems

1. **Verify UAMI is created and assigned:**
   ```bash
   # Create UAMI
   az identity create \
       --name "$UAMI_NAME" \
       --resource-group "$RESOURCE_GROUP"

   # Assign to VM during creation
   az networkcloud virtualmachine create \
       --mi-user-assigned --user-assigned "$UAMI_ID" \
       # ... other parameters
   ```

2. **Check UAMI assignment:**
   ```bash
   az networkcloud virtualmachine show \
       --name "$VM_NAME" \
       --resource-group "$RESOURCE_GROUP" \
       --query "identity.userAssignedIdentities"
   ```


### Alternative access token retrieval methods

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
  - CSN configuration details
  - Proxy settings used
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
- [Azure Connected Machine agent troubleshooting](/azure/azure-arc/servers/troubleshoot-agent-onboard)
- [Managed identities troubleshooting](/entra/identity/managed-identities-azure-resources/managed-identities-faq)
- [Azure Connected Machine agent connect reference](/azure/azure-arc/servers/azcmagent-connect#access-token)
- [How to use managed identities to get an access token](/entra/identity/managed-identities-azure-resources/how-to-use-vm-token#get-a-token-using-go)
