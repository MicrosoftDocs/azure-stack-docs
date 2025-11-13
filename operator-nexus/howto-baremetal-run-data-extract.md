---
title: Troubleshoot Bare-Metal Machines with the run-data-extract Command
description: Learn how to extract data from a bare-metal machine for troubleshooting and diagnostic purposes by using the run-data-extract command.
author: eak13
ms.author: ekarandjeff
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 2/13/2025
ms.custom: template-how-to, devx-track-azurecli
---

# Troubleshoot bare-metal machine issues by using the run-data-extract command

Azure Operator Nexus provides a prescribed set of data extract commands via `az networkcloud baremetalmachine run-data-extract` that help users investigate and resolve issues with on-premises bare-metal machines. Users can employ these commands to get diagnostic data from a bare-metal machine.

## Prerequisites

- The Azure command line interface and the `networkcloud` command line interface extension must be installed. For more information, see [How to install CLI extensions](./howto-install-cli-extensions.md).
- The target bare-metal machine is on and ready.
- The syntax for these commands is based on the 0.3.0+ version of the `az networkcloud` CLI.
- The name of the cluster managed resource group (`cluster_MRG`) that you created for the cluster resource.

[!INCLUDE [command-output-settings](./includes/run-commands/command-output-settings.md)]

## <a name = "executing-a-run-data-extracts-command"></a> Run a run-data-extract command

The `run-data-extract` command runs one or more predefined scripts to extract data from a bare-metal machine.

> [!WARNING]
> Microsoft doesn't provide or support any Azure Operator Nexus API calls that require users to supply plaintext usernames or passwords. Values sent are logged and considered exposed secrets, and should be rotated and revoked. We recommend that you securely use secrets by storing them in Azure Key Vault. If you have specific questions or concerns, submit a request via the Azure portal.

The following commands are currently supported:

- [SupportAssist or TSR collection for Dell troubleshooting](#hardware-support-data-collection)\
  Command name: `hardware-support-data-collection`\
  Arguments: Type of logs requested

  - `SysInfo`: System information
  - `TTYLog`: Storage `TTYLog` data
  - `Debug`: Debug logs

  > [!WARNING]
  > As of `v20250701preview` API version and later, this command isn't supported by the nonrestricted `run-data-extract` command. To run `mde-agent-information`, go to [Run a run-data-extracts-restricted command](#executing-a-run-data-extracts-restricted-command).

- [Collect Microsoft Defender for Endpoint agent information](#collect-mde-agent-information)\
  Command name: `mde-agent-information`\
  Arguments: None

- [Collect Microsoft Defender for Endpoint diagnostic support logs](#collect-mde-support-diagnostics)\
  Command name: `mde-support-diagnostics`\
  Arguments: None

- [Collect Dell hardware rollup status information](#hardware-rollup-status)\
  Command name: `hardware-rollup-status`\
  Arguments: None

  > [!WARNING]
  > As of `v20250701preview` API version and later, this command isn't supported by the nonrestricted `run-data-extract` command. To run `cluster-cve-report`, go to [Run a run-data-extracts-restricted command](#executing-a-run-data-extracts-restricted-command).

- [Generate a cluster Common Vulnerabilities and Exposures (CVE) report](#generate-cluster-cve-report)\
  Command name: `cluster-cve-report`\
  Arguments: None

- [Collect helm releases](#collect-helm-releases)\
  Command name: `collect-helm-releases`\
  Arguments: None

- [Collect `systemctl status` output](#collect-systemctl-status-output)\
  Command name: `platform-services-status`\
  Arguments: None

- [Collect system diagnostics](#collect-system-diagnostics)\
  Command name: `collect-system-diagnostics`\
  Arguments: None

The command syntax is:

```azurecli-interactive
az networkcloud baremetalmachine run-data-extract --name "<machine-name>"  \
  --resource-group "<cluster_MRG>" \
  --subscription "<subscription>" \
  --commands '[{"arguments":["<arg1>","<arg2>"],"command":"<command1>"}]'  \
  --limit-time-seconds "<timeout>"
```

You can specify multiple commands by using JSON format in the `--commands` option. Each `command` value specifies the command and arguments. For a command with multiple arguments, provide the arguments as a list in the `arguments` parameter. For instructions on how to construct the `--commands` structure, see [Azure CLI shorthand](https://github.com/Azure/azure-cli/blob/dev/doc/shorthand_syntax.md).

These commands can take a long time to run, so we recommend that you set the `--limit-time-seconds` value to at least 600 seconds (10 minutes). When you use the `Debug` option or run multiple extracts, it might take longer than 10 minutes.

In the response, the operation performs asynchronously and returns an HTTP status code of `202`. To learn how to track command completion and view the output file, go to [How to view the full output of a command in the associated storage account](#how-to-view-the-full-output-of-a-command-in-the-associated-storage-account).

### <a name = "hardware-support-data-collection"></a> The hardware-support-data-collection command

The following example runs the `hardware-support-data-collection` command and gets `SysInfo` and `TTYLog` logs from the Dell server. The script runs a `racadm supportassist collect` command on the designated bare-metal machine. The resulting tar.gz file contains the file outputs of the extract command in the ZIP file `hardware-support-data-<timestamp>.zip`.

```azurecli
az networkcloud baremetalmachine run-data-extract --name "bareMetalMachineName" \
  --resource-group "cluster_MRG" \
  --subscription "subscription" \
  --commands '[{"arguments":["SysInfo", "TTYLog"],"command":"hardware-support-data-collection"}]' \
  --limit-time-seconds 600
```

#### Output from the `hardware-support-data-collection` command

```azurecli
====Action Command Output====
Executing hardware-support-data-collection command
Getting following hardware support logs: SysInfo,TTYLog
Job JID_814372800396 is running, waiting for it to complete ...
Job JID_814372800396 Completed.
---------------------------- JOB -------------------------
[Job ID=JID_814372800396]
Job Name=SupportAssist Collection
Status=Completed
Scheduled Start Time=[Not Applicable]
Expiration Time=[Not Applicable]
Actual Start Time=[Thu, 13 Apr 2023 20:54:40]
Actual Completion Time=[Thu, 13 Apr 2023 20:59:51]
Message=[SRV088: The SupportAssist Collection Operation is completed successfully.]
Percent Complete=[100]
----------------------------------------------------------
Deleting Job JID_814372800396
Collection successfully exported to /hostfs/tmp/runcommand/hardware-support-data-2023-04-13T21:00:01.zip

================================
Script execution result can be found in storage account:
https://cm2p9bctvhxnst.blob.core.windows.net/bmm-run-command-output/dd84df50-7b02-4d10-a2be-46782cbf4eef-action-bmmdataextcmd.tar.gz?se=2023-04-14T01%3A00%3A15Zandsig=ZJcsNoBzvOkUNL0IQ3XGtbJSaZxYqmtd%2BM6rmxDFqXE%3Dandsp=randspr=httpsandsr=bandst=2023-04-13T21%3A00%3A15Zandsv=2019-12-12
```

#### Example of hardware support files that are collected

```
Archive:  TSR20240227164024_FM56PK3.pl.zip
   creating: tsr/hardware/
   creating: tsr/hardware/spd/
   creating: tsr/hardware/sysinfo/
   creating: tsr/hardware/sysinfo/inventory/
  inflating: tsr/hardware/sysinfo/inventory/sysinfo_CIM_BIOSAttribute.xml
  inflating: tsr/hardware/sysinfo/inventory/sysinfo_CIM_Sensor.xml
  inflating: tsr/hardware/sysinfo/inventory/sysinfo_DCIM_View.xml
  inflating: tsr/hardware/sysinfo/inventory/sysinfo_DCIM_SoftwareIdentity.xml
  inflating: tsr/hardware/sysinfo/inventory/sysinfo_CIM_Capabilities.xml
  inflating: tsr/hardware/sysinfo/inventory/sysinfo_CIM_StatisticalData.xml
   creating: tsr/hardware/sysinfo/lcfiles/
  inflating: tsr/hardware/sysinfo/lcfiles/lclog_0.xml.gz
  inflating: tsr/hardware/sysinfo/lcfiles/curr_lclog.xml
   creating: tsr/hardware/psu/
   creating: tsr/hardware/idracstateinfo/
  inflating: tsr/hardware/idracstateinfo/avc.log
 extracting: tsr/hardware/idracstateinfo/avc.log.persistent.1
[..snip..]
```

### <a name = "collect-mde-agent-information"></a> Collect Microsoft Defender for Endpoint agent information

You can use the `mde-agent-information` command to run a sequence of `mdatp` commands on the designated bare-metal machine. The collected data is delivered in JSON format to `/hostfs/tmp/runcommand/mde-agent-information.json`. You can find the JSON file in the ZIP file that contains the data extract in the storage account.

This example runs the `mde-agent-information` command without arguments.

```azurecli
az networkcloud baremetalmachine run-data-extract --name "bareMetalMachineName" \
  --resource-group "cluster_MRG" \
  --subscription "subscription" \
  --commands '[{"command":"mde-agent-information"}]' \
  --limit-time-seconds 600
```

#### Output from the `mde-agent-information` command

```azurecli
====Action Command Output====
Executing mde-agent-information command
MDE agent is running, proceeding with data extract
Getting MDE agent information for bareMetalMachine
Writing to /hostfs/tmp/runcommand

================================
Script execution result can be found in storage account:
 https://cmzhnh6bdsfsdwpbst.blob.core.windows.net/bmm-run-command-output/f5962f18-2228-450b-8cf7-cb8344fdss63b0-action-bmmdataextcmd.tar.gz?se=2023-07-26T19%3A07%3A22Z&sig=X9K3VoNWRFP78OKqFjvYoxubp65BbNTq%2BGnlHclI9Og%3D&sp=r&spr=https&sr=b&st=2023-07-26T15%3A07%3A22Z&sv=2019-12-12
```

#### Example that shows a collected JSON object

```
{
  "diagnosticInformation": {
      "realTimeProtectionStats": $real_time_protection_stats,
      "eventProviderStats": $event_provider_stats
      },
  "mdeDefinitions": $mde_definitions,
  "generalHealth": $general_health,
  "mdeConfiguration": $mde_config,
  "scanList": $scan_list,
  "threatInformation": {
      "list": $threat_info_list,
      "quarantineList": $threat_info_quarantine_list
    }
}
```

### <a name = "collect-mde-support-diagnostics"></a> Collect Microsoft Defender for Endpoint support diagnostics

The data that you collect by using the `mde-support-diagnostics` command employs the Microsoft Defender for Endpoint Client Analyzer tool to bundle information from the `mdatp` commands and relevant log files. The storage account TGZ file contains a ZIP file named `mde-support-diagnostics-<hostname>.zip`. You should send the ZIP file with any support requests so that support teams can use the logs for troubleshooting and root cause analysis.

This example runs the `mde-support-diagnostics` command without arguments.

```azurecli
az networkcloud baremetalmachine run-data-extract --name "bareMetalMachineName" \
  --resource-group "cluster_MRG" \
  --subscription "subscription" \
  --commands '[{"command":"mde-support-diagnostics"}]' \
  --limit-time-seconds 600
```

#### Output from the `mde-support-diagnostics` command

```azurecli
====Action Command Output====
Executing mde-support-diagnostics command
[2024-01-23 16:07:37.588][INFO] XMDEClientAnalyzer Version: 1.3.2
[2024-01-23 16:07:38.367][INFO] Top Command output: [/tmp/top_output_2024_01_23_16_07_37mel0nue0.txt]
[2024-01-23 16:07:38.367][INFO] Top Command Summary: [/tmp/top_summary_2024_01_23_16_07_370zh7dkqn.txt]
[2024-01-23 16:07:38.367][INFO] Top Command Outliers: [/tmp/top_outlier_2024_01_23_16_07_37aypcfidh.txt]
[2024-01-23 16:07:38.368][INFO] [MDE Diagnostic]
[2024-01-23 16:07:38.368][INFO]   Collecting MDE Diagnostic
[2024-01-23 16:07:38.613][WARNING] mde is not running
[2024-01-23 16:07:41.343][INFO] [SLEEP] [3sec] waiting for agent to create diagnostic package
[2024-01-23 16:07:44.347][INFO] diagnostic package path: /var/opt/microsoft/mdatp/wdavdiag/5b1edef9-3b2a-45c1-a45d-9e7e4b6b869e.zip
[2024-01-23 16:07:44.347][INFO] Successfully created MDE diagnostic zip
[2024-01-23 16:07:44.348][INFO]   Adding mde_diagnostic.zip to report directory
[2024-01-23 16:07:44.348][INFO]   Collecting MDE Health
[...snip...]
================================
Script execution result can be found in storage account:
 https://cmmj627vvrzkst.blob.core.windows.net/bmm-run-command-output/7c5557b9-b6b6-a4a4-97ea-752c38918ded-action-bmmdataextcmd.tar.gz?se=2024-01-23T20%3A11%3A32Z&sig=9h20XlZO87J7fCr0S1234xcyu%2Fl%2BVuaDh1BE0J6Yfl8%3D&sp=r&spr=https&sr=b&st=2024-01-23T16%3A11%3A32Z&sv=2019-12-12
```

After you download the execution result file, you can unzip the support files for analysis.

#### Example list of information collected by the Microsoft Defender for Endpoint Client Analyzer

```azurecli
Archive:  mde-support-diagnostics-rack1compute02.zip
  inflating: mde_diagnostic.zip
  inflating: process_information.txt
  inflating: auditd_info.txt
  inflating: auditd_log_analysis.txt
  inflating: auditd_logs.zip
  inflating: ebpf_kernel_config.txt
  inflating: ebpf_enabled_func.txt
  inflating: ebpf_syscalls.zip
  inflating: ebpf_raw_syscalls.zip
  inflating: messagess.zip
  inflating: conflicting_processes_information.txt
[...snip...]
```

### Hardware rollup status

The `hardware-rollup-status` command collects data that reflects the health of the machine subsystems. The command writes the JSON-formatted output file to `/hostfs/tmp/runcommand/rollupStatus.json`. You can find the file in the ZIP file that contains the data extract in the storage account.

This example runs the `hardware-rollup-status` command without arguments.

```azurecli
az networkcloud baremetalmachine run-data-extract --name "bareMetalMachineName" \
  --resource-group "clusete_MRG" \
  --subscription "subscription" \
  --commands '[{"command":"hardware-rollup-status"}]' \
  --limit-time-seconds 600
```

#### Output of the `hardware-rollup-status` command

```azurecli
====Action Command Output====
Executing hardware-rollup-status command
Getting rollup status logs for b37dev03a1c002
Writing to /hostfs/tmp/runcommand

================================
Script execution result can be found in storage account:
https://cmkfjft8twwpst.blob.core.windows.net/bmm-run-command-output/20b217b5-ea38-4394-9db1-21a0d392eff0-action-bmmdataextcmd.tar.gz?se=2023-09-19T18%3A47%3A17Z&sig=ZJcsNoBzvOkUNL0IQ3XGtbJSaZxYqmtd%3D&sp=r&spr=https&sr=b&st=2023-09-19T14%3A47%3A17Z&sv=2019-12-12
```

#### Example of collected JSON data

```
{
	"@odata.context" : "/redfish/v1/$metadata#DellRollupStatusCollection.DellRollupStatusCollection",
	"@odata.id" : "/redfish/v1/Systems/System.Embedded.1/Oem/Dell/DellRollupStatus",
	"@odata.type" : "#DellRollupStatusCollection.DellRollupStatusCollection",
	"Description" : "A collection of DellRollupStatus resource",
	"Members" :
	[
		{
			"@odata.context" : "/redfish/v1/$metadata#DellRollupStatus.DellRollupStatus",
			"@odata.id" : "/redfish/v1/Systems/System.Embedded.1/Oem/Dell/DellRollupStatus/iDRAC.Embedded.1_0x23_SubSystem.1_0x23_Current",
			"@odata.type" : "#DellRollupStatus.v1_0_0.DellRollupStatus",
			"CollectionName" : "CurrentRollupStatus",
			"Description" : "Represents the subcomponent roll-up statuses.",
			"Id" : "iDRAC.Embedded.1_0x23_SubSystem.1_0x23_Current",
			"InstanceID" : "iDRAC.Embedded.1#SubSystem.1#Current",
			"Name" : "DellRollupStatus",
			"RollupStatus" : "Ok",
			"SubSystem" : "Current"
		},
		{
			"@odata.context" : "/redfish/v1/$metadata#DellRollupStatus.DellRollupStatus",
			"@odata.id" : "/redfish/v1/Systems/System.Embedded.1/Oem/Dell/DellRollupStatus/iDRAC.Embedded.1_0x23_SubSystem.1_0x23_Voltage",
			"@odata.type" : "#DellRollupStatus.v1_0_0.DellRollupStatus",
			"CollectionName" : "VoltageRollupStatus",
			"Description" : "Represents the subcomponent roll-up statuses.",
			"Id" : "iDRAC.Embedded.1_0x23_SubSystem.1_0x23_Voltage",
			"InstanceID" : "iDRAC.Embedded.1#SubSystem.1#Voltage",
			"Name" : "DellRollupStatus",
			"RollupStatus" : "Ok",
			"SubSystem" : "Voltage"
		},
[..snip..]
```

### <a name = "generate-cluster-cve-report"></a> Generate a cluster CVE report

You can use the `cluster-cve-report` command to collect vulnerability data, which is delivered in JSON format to `{year}-{month}-{day}-nexus-cluster-vulnerability-report.json`. You can find the JSON file in the ZIP file that contains the data extract in the storage account. The data includes vulnerability data per container image in the cluster.

This example runs the `cluster-cve-report` command without arguments.

> [!NOTE]
> The target machine must be a control-plane node or the action doesn't run.

```azurecli
az networkcloud baremetalmachine run-data-extract --name "bareMetalMachineName" \
  --resource-group "cluster_MRG" \
  --subscription "subscription" \
  --commands '[{"command":"cluster-cve-report"}]' \
  --limit-time-seconds 600
```

#### Output of the `cluster-cve-report` command

```azurecli
====Action Command Output====
Nexus cluster vulnerability report saved.


================================
Script execution result can be found in storage account:
https://cmkfjft8twwpst.blob.core.windows.net/bmm-run-command-output/20b217b5-ea38-4394-9db1-21a0d392eff0-action-bmmdataextcmd.tar.gz?se=2023-09-19T18%3A47%3A17Z&sig=ZJcsNoBzvOkUNL0IQ3XGtbJSaZxYqmtd%3D&sp=r&spr=https&sr=b&st=2023-09-19T14%3A47%3A17Z&sv=2019-12-12
```

#### CVE report schema

```JSON
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Vulnerability Report",
  "type": "object",
  "properties": {
    "metadata": {
      "type": "object",
      "properties": {
        "dateRetrieved": {
          "type": "string",
          "format": "date-time",
          "description": "The date and time when the data was retrieved."
        },
        "platform": {
          "type": "string",
          "description": "The name of the platform."
        },
        "resource": {
          "type": "string",
          "description": "The name of the resource."
        },
        "clusterId": {
          "type": "string",
          "description": "The resource ID of the cluster."
        },
        "runtimeVersion": {
          "type": "string",
          "description": "The version of the runtime."
        },
        "managementVersion": {
          "type": "string",
          "description": "The version of the management software."
        },
        "vulnerabilitySummary": {
          "type": "object",
          "properties": {
            "uniqueVulnerabilities": {
              "type": "object",
              "properties": {
                "critical": { "type": "integer" },
                "high": { "type": "integer" },
                "medium": { "type": "integer" },
                "low": { "type": "integer" },
                "unknown": { "type": "integer" }
              },
              "required": ["critical", "high", "medium", "low", "unknown"]
            },
            "totalVulnerabilities": {
              "type": "object",
              "properties": {
                "critical": { "type": "integer" },
                "high": { "type": "integer" },
                "medium": { "type": "integer" },
                "low": { "type": "integer" },
                "unknown": { "type": "integer" }
              },
              "required": ["critical", "high", "medium", "low", "unknown"]
            }
          },
          "required": ["uniqueVulnerabilities", "totalVulnerabilities"]
        }
      },
      "required": [
        "dateRetrieved",
        "platform",
        "resource",
        "clusterId",
        "runtimeVersion",
        "managementVersion",
        "vulnerabilitySummary"
      ]
    },
    "containers": {
      "type": "object",
      "additionalProperties": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "namespace": {
              "type": "array",
              "description": "The namespaces where the container image is in-use.",
              "items": { "type": "string" }
            },
            "digest": {
              "type": "string",
              "description": "The digest of the container image."
            },
            "observedCount": {
              "type": "integer",
              "description": "The number of times the container image has been observed."
            },
            "os": {
              "type": "object",
              "properties": {
                "family": {
                  "type": "string",
                  "description": "The family of the operating system."
                }
              },
              "required": ["family"]
            },
            "vulnerabilities": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "title": { "type": "string" },
                  "vulnerabilityID": { "type": "string" },
                  "fixedVersion": { "type": "string" },
                  "installedVersion": { "type": "string" },
                  "referenceLink": { "type": "string", "format": "uri" },
                  "publishedDate": { "type": "string", "format": "date-time" },
                  "dataSource": { "type": "string" },
                  "score": { "type": "number" },
                  "severity": { "type": "string" },
                  "severitySource": { "type": "string" },
                  "resource": { "type": "string" },
                  "target": { "type": "string" },
                  "packageType": { "type": "string" },
                  "exploitAvailable": { "type": "boolean" }
                },
                "required": [
                  "title",
                  "vulnerabilityID",
                  "fixedVersion",
                  "installedVersion",
                  "referenceLink",
                  "publishedDate",
                  "dataSource",
                  "score",
                  "severity",
                  "severitySource",
                  "resource",
                  "target",
                  "packageType",
                  "exploitAvailable"
                ]
              }
            }
          },
          "required": ["namespace", "digest", "os", "observedCount", "vulnerabilities"]
        }
      }
    }
  },
  "required": ["metadata", "containers"]
}
```

#### CVE data details

The CVE data is refreshed per container image every 24 hours or when there's a change to the Kubernetes resource that references the image.

### Collect helm releases

You can use the `collect-helm-releases` command to collect helm release data, which is delivered in JSON format to `{year}-{month}-{day}-helm-releases.json`. You can find the JSON file in the ZIP file that contains the data extract in the storage account. The data contains all helm release information from the cluster, which includes the standard data that's returned from a `helm list` command.

This example runs the `collect-helm-releases` command without arguments.

> [!NOTE]
> The target machine must be a control-plane node or the action doesn't run.

```azurecli
az networkcloud baremetalmachine run-data-extract --name "bareMetalMachineName" \
  --resource-group "cluster_MRG" \
  --subscription "subscription" \
  --commands '[{"command":"collect-helm-releases"}]' \
  --limit-time-seconds 600
```

#### Output of the `collect-helm-releases` command

```azurecli
====Action Command Output====
Helm releases report saved.


================================
Script execution result can be found in storage account:
https://cmcr5xp3mbn7st.blob.core.windows.net/bmm-run-command-output/a29dcbdb-5524-4172-8b55-88e0e5ec93ff-action-bmmdataextcmd.tar.gz?se=2024-10-30T02%3A09%3A54Z&sig=v6cjiIDBP9viEijs%2B%2BwJDrHIAbLEmuiVmCEEDHEi%2FEc%3D&sp=r&spr=https&sr=b&st=2024-10-29T22%3A09%3A54Z&sv=2023-11-03
```

#### Helm release schema

```JSON
{
  "$schema": "http://json-schema.org/schema#",
  "type": "object",
  "properties": {
    "metadata": {
      "type": "object",
      "properties": {
        "dateRetrieved": {
          "type": "string"
        },
        "platform": {
          "type": "string"
        },
        "resource": {
          "type": "string"
        },
        "clusterId": {
          "type": "string"
        },
        "runtimeVersion": {
          "type": "string"
        },
        "managementVersion": {
          "type": "string"
        }
      },
      "required": [
        "clusterId",
        "dateRetrieved",
        "managementVersion",
        "platform",
        "resource",
        "runtimeVersion"
      ]
    },
    "helmReleases": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "namespace": {
            "type": "string"
          },
          "revision": {
            "type": "string"
          },
          "updated": {
            "type": "string"
          },
          "status": {
            "type": "string"
          },
          "chart": {
            "type": "string"
          },
          "app_version": {
            "type": "string"
          }
        },
        "required": [
          "app_version",
          "chart",
          "name",
          "namespace",
          "revision",
          "status",
          "updated"
        ]
      }
    }
  },
  "required": [
    "helmReleases",
    "metadata"
  ]
}
```

#### Collect systemctl status output

You can use the `platform-services-status` command to collect service status information. The output is in plaintext format and returns an overview of the status of the services on the host and the `systemctl status` for each found service.

This example runs the `platform-services-status` command without arguments.

```azurecli
az networkcloud baremetalmachine run-data-extract --name "bareMetalMachineName" \
  --resource-group "clusete_MRG" \
  --subscription "subscription" \
  --commands '[{"command":"platform-services-status"}]' \
  --limit-time-seconds 600
  --output-directory "/path/to/local/directory"
```

#### Output of the `platform-services-status` command

```azurecli
====Action Command Output====
UNIT                                                                                          LOAD      ACTIVE   SUB     DESCRIPTION
aods-infra-vf-config.service                                                                  not-found inactive dead    aods-infra-vf-config.service
aods-pnic-config-infra.service                                                                not-found inactive dead    aods-pnic-config-infra.service
aods-pnic-config-workload.service                                                             not-found inactive dead    aods-pnic-config-workload.service
arc-unenroll-file-semaphore.service                                                           loaded    active   exited  Arc-unenrollment upon shutdown service
atop-rotate.service                                                                           loaded    inactive dead    Restart atop daemon to rotate logs
atop.service                                                                                  loaded    active   running Atop advanced performance monitor
atopacct.service                                                                              loaded    active   running Atop process accounting daemon
audit.service                                                                                 loaded    inactive dead    Audit service
auditd.service                                                                                loaded    active   running Security Auditing Service
azurelinux-sysinfo.service                                                                    loaded    inactive dead    Azure Linux Sysinfo Service
blk-availability.service                                                                      loaded    inactive dead    Availability of block devices
[..snip..]


-------
● arc-unenroll-file-semaphore.service - Arc-unenrollment upon shutdown service
     Loaded: loaded (/etc/systemd/system/arc-unenroll-file-semaphore.service; enabled; vendor preset: enabled)
     Active: active (exited) since Tue 2024-11-12 06:33:40 UTC; 11h ago
   Main PID: 11663 (code=exited, status=0/SUCCESS)
        CPU: 5ms

Nov 12 06:33:39 rack1compute01 systemd[1]: Starting Arc-unenrollment upon shutdown service...
Nov 12 06:33:40 rack1compute01 systemd[1]: Finished Arc-unenrollment upon shutdown service.


-------
○ atop-rotate.service - Restart atop daemon to rotate logs
     Loaded: loaded (/usr/lib/systemd/system/atop-rotate.service; static)
     Active: inactive (dead)
TriggeredBy: ● atop-rotate.timer
[..snip..]

```

### Collect system diagnostics

You can use the `collect-system-diagnostics` command to collect system diagnostics logs. The command retrieves all necessary logs, which gives you deeper visibility within the bare-metal machine. It collects the following types of diagnostics data:

- System and kernel diagnostics:
  - **Kernel information**: Logs, human-readable messages, version, and architecture, for in-depth kernel diagnostics.
  - **Operating system Logs**: Essential logs that detail system activity and container logs for system services.

- Hardware and resource usage:
  - **CPU and IO throttled processes**: Identifies throttling issues, providing insights into performance bottlenecks.
  - **Network interface statistics**: Detailed statistics for network interfaces to diagnose errors and drops.

- Software and services:
  - **Installed packages**: A list of all installed packages, vital for understanding the system's software environment.
  - **Active system services**: Information on active services, process snapshots, and detailed system and process statistics.
  - **Container runtime and Kubernetes components logs**: Logs for Kubernetes components and other vital services for cluster diagnostics.

- Networking and connectivity:
  - **Network connection tracking information**: Connection tracking (Conntrack) statistics and connection lists for firewall diagnostics.
  - **Network configuration and interface details**: Interface configurations, IP routing, addresses, and neighbor information.
  - **Any additional interface configuration and logs**: Logs related to the configuration of all interfaces inside the node.
  - **Network connectivity tests**: Tests external network connectivity and Kubernetes API server communication.
  - **DNS resolution configuration**: DNS resolver configuration for diagnosing resolution issues with domain names.
  - **Networking configuration and logs**: Comprehensive networking data, including connection tracking and interface configurations.
  - **CNI configuration**: Container network interface (CNI) configuration for container networking diagnostics.

- Security and compliance:
  - **SELinux status**: Reports the Security-Enhanced Linux (SELinux) mode to understand access control and security contexts.
  - **iptables rules**: Configuration of `iptables` rule sets for insights into firewall settings.

- Storage and file systems:
  - **Mount points and volume information**: Detailed information on mount points, volumes, disk usage, and file system specifics.

- Azure Arc `azcmagent` logs:
  - Collects log files for the Azure-connected machine agent and extensions and puts them in a ZIP archive.

- **Configuration and management**:
  - **System configuration**: `Sysctl` parameters for a comprehensive view of kernel runtime configuration.
  - **Kubernetes configuration and health**: Kubernetes setup details, including configurations and service listings.
  - **Container runtime information**: Configuration, version information, and details on running containers.
  - **CRI information**: Operations data for the container runtime interface (CRI), which aids in container orchestration diagnostics.

This example runs the `collect-system-diagnostics` command without arguments.

```azurecli
az networkcloud baremetalmachine run-data-extract --name "bareMetalMachineName" \
  --resource-group "cluster_MRG" \
  --subscription "subscription" \
  --commands '[{"command":"collect-system-diagnostics"}]' \
  --limit-time-seconds 900
```

#### Output of the `collect-system-diagnostics` command

```azurecli
====Action Command Output====
Trying to check for root... 
Trying to check for required utilities... 
Trying to create required directories... 
Trying to check for disk space... 
Trying to start collecting logs... Trying to collect common operating system logs... 
Trying to collect mount points and volume information... 
Trying to collect SELinux status... 
Trying to collect Containerd daemon information... 
Trying to collect Containerd running information... 
Trying to collect Container Runtime Interface (CRI) information... Trying to collect CRI information... 
Trying to collect kubelet information... 
Trying to collect Multus logs if they exist... 
Trying to collect azcmagent logs... time="2025-09-09T15:21:55Z" level=info msg="Adding directory /var/opt/azcmagent/log to zip"
time="2025-09-09T15:21:55Z" level=info msg="Adding directory /var/lib/GuestConfig/arc_policy_logs to zip"
time="2025-09-09T15:21:57Z" level=info msg="Adding directory /var/lib/GuestConfig/ext_mgr_logs to zip"
time="2025-09-09T15:21:57Z" level=info msg="Adding directory /var/lib/GuestConfig/extension_logs to zip"
time="2025-09-09T15:21:57Z" level=info msg="Adding directory /var/lib/GuestConfig/extension_reports to zip"
time="2025-09-09T15:21:57Z" level=info msg="Adding directory /var/lib/GuestConfig/gc_agent_logs to zip"
time="2025-09-09T15:21:57Z" level=info msg="Diagnostic logs have been saved to /tmp/azcmagent-logs-3765466.zip."


Collecting System logs
Trying to collect kernel logs... 
Trying to collect installed packages... 
Trying to collect active system services... 
Trying to collect sysctls information... 
Trying to collect CPU Throttled Process Information... 
Trying to collect IO Throttled Process Information... 
Trying to collect conntrack information... conntrack v1.4.8 (conntrack-tools): 1917 flow entries have been shown.

Trying to collect ipvsadm information... 
Trying to collect kernel command line... 
Trying to collect configuration files... Collecting Networking logs
Trying to collect networking information... conntrack v1.4.8 (conntrack-tools): 1916 flow entries have been shown.

Trying to collect CNI configuration information... 
Trying to collect iptables information... 

Trying to archive gathered information... 
Finishing up...

	Done... your bundled logs are located in /hostfs/tmp/runcommand/system_diagnostics_bareMetalMachineName_2025-09-09_1519-UTC.tar.gz



================================
Script execution result can be downloaded from storage account using the command: 
 az storage blob download --blob-url https://simdev4003469vm1sa.blob.core.windows.net/command-output-blob/runcommand-output-7d601db8-75b7-4af2-94dd-f4f49ee0b0b7.tar.gz --file runcommand-output-7d601db8-75b7-4af2-94dd-f4f49ee0b0b7.tar.gz --auth-mode login  > /dev/null 2>&1
```

[!INCLUDE [command-output-view](./includes/run-commands/command-output-view.md)]

The downloaded tar.gz file contains the full output and the file outputs of the extract command in ZIP format.

The command output provides a prompt to download the full output from the user-provided storage account. The tar.gz file also contains the file outputs of the extract command in ZIP format. Download the output file from the storage blob to a local directory by specifying the directory path in the optional argument `--output-directory`.

> [!WARNING]
> The `--output-directory` argument overwrites any files in the local directory that have the same name as the new files you create.

The storage account might be locked, and you might receive the error message: "403 This request is not authorized to perform this operation." This error is triggered by networking or firewall restrictions. For procedures that you can use to verify access, go to the [user-managed storage](#send-command-output-to-a-user-specified-storage-account) section.

## <a name = "executing-a-run-data-extracts-restricted-command"></a> Run a run-data-extracts-restricted command

### Prerequisites

- Minimum supported API of `v20250701preview` or `v20250901` and later
- A configured storage blob container
- The target bare-metal machine is on and ready.
- Required `az networkcloud` CLI extension version 4.0.0b1 or later
- The cluster managed resource group name (`cluster_MRG`) that you created for the cluster resource.

The functionality of the `run-data-extracts-restricted` command mirrors the nonrestricted `run-data-extracts` command and includes fine-grained access control via role-based access control (RBAC). It allows customers to run sensitive data extraction operations on bare-metal machines with elevated privileges.

You can run the `run-data-extracts-restricted` command as a new and separate API action. The action will be introduced in the `v20250701preview` and `v20250901` versions of the GA API, and will mirror the behavior of the original command but with restricted access to specific sub-commands. The following list contains the allowed sub-commands for `run-data-extracts-restricted`:

- [Collect Microsoft Defender for Endpoint agent information](#collect-mde-agent-information)\
  Command name: `mde-agent-information`\
  Arguments: None

- [Generate a cluster Common Vulnerabilities and Exposures (CVE) report](#generate-cluster-cve-report)\
  Command name: `cluster-cve-report`\
  Arguments: None

You can run the command by using `az networkcloud baremetalmachine run-data-extracts-restricted`. It accepts arguments similar to the `run-data-extract` command.

### Example

```azurecli-interactive
az networkcloud baremetalmachine run-data-extracts-restricted --name "<machine-name>"  \
  --resource-group "<cluster_MRG>" \
  --subscription "<subscriptionID>" \
  --commands '[{"arguments":["--min-severity=8"],"command":"cluster-cve-report"}]'  \
  --limit-time-seconds "600"
  --output-directory ~/path/to/my/output/directory
```

### Storage and output

The output from `run` command executions is, by default, stored in the blob container defined by `commandOutputSettings`. Override of the `commandOutputSettings` value is supported per command output type (like `BareMetalMachineRunDataExtractsRestricted`). To learn how to specify the `commandOutputSettings` override for the run command, see [Azure Operator Nexus cluster support for managed identities and user-provided resources](./howto-cluster-managed-identity-user-provided-resources.md).
