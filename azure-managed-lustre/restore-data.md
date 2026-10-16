---
title: Restore data from Azure Blob Storage to Azure Managed Lustre
description: Learn how to prefetch blob contents in an Azure Managed Lustre file system by using Lustre HSM restore commands.
ms.topic: how-to
ms.date: 10/16/2026
author: akashdubey
ms.author: akashdubey
ms.reviewer: brianl
---

# Restore data from Blob Storage

By default, an import adds the blob names and metadata to the file system namespace. The system retrieves the blob contents when a client first accesses the corresponding file.

For certain workloads and scenarios, you might prefer to restore blob data from a container before it is first accessed. You can prefetch the contents of blobs to avoid the initial delay when a client accesses the data for the first time after import.

To prefetch the contents of blobs, use the Lustre `lfs hsm_restore` command from a mounted client with `sudo` capabilities. The following command prefetches the contents of the blobs into the file system:

```bash
nohup find local/directory -type f -print0 | xargs -0 -n 1 sudo lfs hsm_restore &
```

This command tells the metadata server to asynchronously process a restoration request. The command line doesn't wait for the restore to complete. The command line can queue up a large number of entries for restore at the metadata server. This approach can overwhelm the metadata server and degrade performance for restores.

To avoid this potential performance issue, create a basic script that attempts to walk the path and issues restore requests in batches of a specified size. To achieve reasonable performance and avoid overwhelming the metadata server, use batch sizes from 1,000 to 5,000 requests.

## Example: Create a batch restore script

The following example shows how to create a script to restore data from a blob container in batches. Create a file named `file_restorer.bash` with the following contents:

```bash
#!/bin/bash
set -feu
set -o pipefail
main()
{
    if [ $# -lt 2 ]; then
        echo "$0 <path_to_fully_restore> <max_restores_at_a_time>"
        echo "Missing parameters"
        exit 1
    fi
    local RESTORE_PATH=$1
    local MAX_RESTORES=$2
    local FILES_LIST="/tmp/files_to_restore"
    find "$RESTORE_PATH" -type f > "$FILES_LIST"
    local TOTAL_FILES
    TOTAL_FILES=$(wc -l "$FILES_LIST")
    local RESTORE_TOTAL=0
    local RESTORE_COUNT=0
    while IFS="" read -r p || [ -n "$p" ]; do
        printf '%s\n' "$p"
        lfs hsm_restore "$p"
        ((RESTORE_COUNT++)) || true
        ((RESTORE_TOTAL++)) || true
        if (( RESTORE_COUNT >= MAX_RESTORES )); then
            while true; do
                local STATE
                STATE=$(lfs hsm_state "$p")
                RELEASED=') released exists archived'
                if ! [[ $STATE =~ $RELEASED ]]; then
                    echo "Restored $RESTORE_TOTAL / $TOTAL_FILES"
                    break
                fi
                sleep 0.2
            done
            RESTORE_COUNT=0
        fi
    done < "$FILES_LIST"
}
main "$@"
```

The following example shows how to run the script along with the sample output:

```bash
root@vm:~# time ~azureuser/file_restorer.bash /lustre/client/ 5000
Finding all files to restore beneath: /lustre/client/
Found 78100 to restore
Initiating restores in batches of 5000...
Restored 5000 / 78100
Restored 10000 / 78100
Restored 15000 / 78100
Restored 20000 / 78100
Restored 25000 / 78100
Restored 30000 / 78100
Restored 35000 / 78100
Restored 40000 / 78100
Restored 45000 / 78100
Restored 50000 / 78100
Restored 55000 / 78100
Restored 60000 / 78100
Restored 65000 / 78100
Restored 70000 / 78100
Restored 75000 / 78100
Restored 78100 / 78100
real	6m59.633s
user	1m20.273s
sys	0m37.960s
```

> [!NOTE]
> At this time, Azure Managed Lustre restores data from Blob Storage at a maximum throughput rate of ~7.5 GiB per second.

## Related content

- [Use Azure Blob Storage with an Azure Managed Lustre file system](blob-integration.md)
- [Import data from Azure Blob Storage](import-data.md)
- [Export data to Azure Blob Storage](export-data.md)
