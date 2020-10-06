---
title: Use DISKSPD to test workload storage performance
description: This topic provides guidance on how to use DISKSPD to test workload storage performance.
author: jasonnyi
ms.author: jasonyi
ms.topic: how-to
ms.date: 10/06/2020
---

# Use DISKSPD to test workload storage performance

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic provides guidance on how to use DISKSPD to test workload storage performance. You now have an Azure Stack HCI Cluster set up - all ready to go. Great, but how do you know if you are getting the promised performance metrics, whether it be latency, throughput, or IOPS? This is where you may wish turn to DISKSPD. After reading the article, we will have learned how to run DISKSPD, understand a subset of the parameters, interpret the output, and gain a general understanding of the variables that affect performance.

## What is DISKSPD?
At its core, DISKSPD is an I/O generating, command-line tool for micro-benchmarking. Great, so what do all these terms mean? Anyone who sets up an Azure Cluster, physical server, etc. has a reason. It could be that they wish to set up a web hosting environment, run virtual desktops for the employees, etc. Whatever the real-world use case may be, you likely want to simulate a test before deploying your actual application. However, testing your application in a real scenario is often difficult – this is where DISKSPD comes in. DISKSPD is a tool to customize and create your own synthetic workloads and test your application before deployment. The cool thing about the tool is that it gives the user the freedom to configure and tweak the parameters to create a specific scenario that resembles user’s real workload. By doing so, you can get a glimpse into what your system is capable of before deployment. At its core, DISKSPD simply issues a bunch of read and write operations.

Now we know what DISKSPD is, but when should we use it? DISKSPD will have a difficult time emulating complex workloads. As a result, DISKSPD is great when your workload is not closely approximated by single-threaded file copy but you need a simple tool that produces acceptable baseline results.

## Quick startup guide: from installation to running DISKSPD
Without further ado, let’s get started.

1. The first thing you need to do is log into the virtual machine that you will use for the DISKSPD test, with administrator rights. In our case, we will be running on the VM called, “node1.”
1. Once logged in, you can download the tool from the [repository](https://github.com/microsoft/diskspd). This link contains the open source code as well as a wiki page that details all the parameters and specifications. The only file we really care about is the executable that can be downloaded as a ZIP file. Within it, you will see 3 subfolders: amd64 (64-bit systems), x86 (32-bit systems), and ARM64 (ARM systems). This will help you run the tool in every Windows version, client, or server. We will be using the amd64 version.

    :::image type="content" source="../media/diskspd/download-directory.png" alt-text="Directory to download the DISKSPD .zip file." lightbox="../media/diskspd/download-directory.png":::

1.	Open PowerShell as an administrator.
<!---see Dan PW topic for example format for these steps.--->

1.	Go to where your DISKSPD file is located.

1.	Run DISKSPD with a single line command. The command line format is listed below. Simply replace everything inside the square brackets, including the brackets themselves with your appropriate settings.
    - .\[INSERT_DISKSPD_PATH] [INSERT_SET_OF_PARAMETERS]  [INSERT_CSV_PATH_FOR_TEST_FILE] > [INSERT_OUTPUT_FILE.txt]
    
    Here is an example command you can run:
    - .\diskspd -t2 -o32 -b4k -r4k -w0 -d120 -Sh -D -L -c5G C:\ClusterStorage\test01\targetfile\IO.dat > test04.txt

## Choosing key parameters
Well, that was simple right? Unfortunately, there is more to it than that - let’s unpack what we did. First, there are various parameters that you can tinker with and it can get pretty specific. However, today we used the following set of baseline parameters.

> [!NOTE]
> DISKSPD parameters are case sensitive.

**-t2** => This indicates the number of threads per target/test file. This number is often based on the number of CPU cores. In our case, we used 2 to stress all our CPU processors.

**-o32** => This indicates the number of outstanding I/O requests per target per thread. This is also known as the queue depth, and in our case, we used 32 to stress the CPU.

**-b4K** => This indicates the block size in bytes, KiB, MiB, or GiB. In our case, we used 4K block size to simulate a random I/O test.

**-r4K** => This indicates the random I/O aligned to the specified size in bytes, KiB, MiB, Gib, or blocks (Overrides the -s parameter). We used the common 4K byte size to properly align with our block size.

**-w0** => This specifies the percentage of operations that are write requests (-w0 is equivalent to 100% read). We used 0% writes for the purpose of a simple test.

**-d120** => This specifies the duration of the test, not including cool-down or warm-up. The default value is 10 seconds, but it is recommended that you use at least 60 seconds for any serious workload. We used 120 seconds in order to minimize any outliers. 

**-Suw** => Disables software and hardware write caching (equivalent to -Sh)

**-D** => Captures IOPS statistics such as standard deviation, in intervals of milliseconds (per-thread, per-target)

**-L** => Measures latency statistics

**-c** => Sets the sample file size that will be used in the test. Can be set in bytes, KiB, MiB, GiB, or blocks. We used a 5GB target file. 

For a complete list of parameters, refer to the [Github repository](https://github.com/Microsoft/diskspd/wiki/Command-line-and-parameters).

## Understanding the environment
The performance heavily depends on your environment. So, what is our environment? Our specification involves an Azure cluster with storage pool and Storage Spaces Direct (S2D). More specifically, we have a total of 5 virtual machines: DC, node1, node2, node3, and the mgmt node. The cluster itself is a three-node cluster with a three-way mirrored resiliency structure. Therefore, three data copies will be maintained. Each “node” in the cluster is a Standard_B2ms VM with a maximum IOPS limit of 1920. Within each node, there are four premium P30 SSD drives with a maximum IOPS limit of 5000. Finally, each SSD drive has 1 TB of memory.

We generate the test file under the unified namespace that the Cluster Shared Volume (CSV) provides (C:\ClusteredStorage) in order to utilize the entire pool of drives.

>[!NOTE]
> The current environment does NOT have Hyper-V or a nested virtualization structure.

As you’ll see, it is entirely possible to independently hit either the IOPS or bandwidth ceiling at the VM or disk limit. And so, it is important to understand your VM size and drive type as both have a maximum IOPS limit and a bandwidth ceiling. Having this knowledge will help you locate bottlenecks and understand your performance results. You can refer to the two links below to discover what size may be appropriate for your workload.

- [VM sizes](https://docs.microsoft.com/azure/virtual-machines/sizes-general?toc=/azure/virtual-machines/linux/toc.json&bc=/azure/virtual-machines/linux/breadcrumb/toc.json)
- [Disk types](https://azure.microsoft.com/pricing/details/managed-disks/)

Here is what our environment looks like. The green represents the IOPS limit on the VM and the red represents the IOPS limit on the hard drive.

:::image type="content" source="../media/diskspd/environment.png" alt-text="The DISKSPD environment." lightbox="../media/diskspd/environment.png":::

## Understanding the output
Armed with our understanding of the parameters and environment, let’s interpret the output. First, the goal of our test was to max out the IOPS with no regards to latency. This way, we can visually see whether we reach our artificial IOPS limit within Azure. If you wish to graphically visualize the total IOPS, you can refer to the Windows Admin Center or the task manager.

Here, we have a diagram of what the DISKSPD process looks like. It depicts an example of a 1MiB write operation from a non-coordinator node. The three-way resiliency structure along with the operation from a non-coordinator node leads to two network hops, decreasing the performance. If you are wondering what a coordinator is, don’t worry! We will talk about this in a later section.
<!---set up section ref to Things to consider section.--->

:::image type="content" source="../media/diskspd/example-process.png" alt-text="Example diagram of the DISKSPD process that shows a 1MiB write operation from a non-coordinator node." lightbox="../media/diskspd/example-process.png":::

Now that we have a visual understanding, let’s examine the four main sections of our txt file output.
1.	Input settings
   
   This section describes the command you ran, the input parameters, and additional details about the test run.

   :::image type="content" source="../media/diskspd/command-input-parameters.png" alt-text="Example output shows command and input parameters." lightbox="../media/diskspd/command-input-parameters.png":::






## Batch test + extracting results into Excel
TBD

## Things to consider...
TBD

## Other common examples + experiments
TBD

### Online Transaction Processing (OLTP) workload
TBD

### Online Analytical Processing (OLAP) workload
TBD

<!---Example note format.--->
   >[!NOTE]
   > TBD.

<!---Example figure format--->
<!---:::image type="content" source="./media/network-controller/topology-option-1.png" alt-text="Option 1 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::--->

### Cache
TBD

<!---Example table format.--->
| Fun                                      | Table                                   |
| :--------------------------------------- | :-------------------------------------- |
| left-aligned column                      | right-aligned column                    |
| $100                                     | $100                                    |
| $10                                      | $10                                     |




## Next steps
For more information, see also:
<!---Placeholders for format examples. Replace all before initial topic review.--->

- [Azure Stack HCI overview](../overview.md)
- [Storage Spaces Direct hardware requirements](/windows-server/storage/storage-spaces/storage-spaces-direct-hardware-requirements)
