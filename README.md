# EBS-Multi-Attach
EBS Multi Attach NVME Persistent Preservation on Nitro EC2 EBS Optimized

#### NVME CLI

#### Installing nvme-cli

You can install `nvme-cli` from your distribution's package manager. For instance, on Fedora, CentOS, or similar:

```
sudo dnf install nvme-cli
```

On Amazon Linux 2:

```
sudo yum install nvme-cli
```

#### Exploring an NVMe Drive

After installing nvme-cli for your distribution, you can explore your NVMe drive. There is no man page for nvme-cli, but you can get lots of help by entering:

```
nvme help
```

The output will provide you with a list of available sub-commands and their usage.

#### List All NVMe Drives

To list all NVMe devices and namespaces on your machine, use the following command:

```
sudo nvme list
```

The output will provide information about the NVMe drive, including its serial number, model, namespace, usage, format, and firmware revision.

#### Get Detailed Information About a Drive

You can obtain even more information about the drive and the features it supports by using the id-ctrl subcommand. For example:

```
sudo nvme id-ctrl /dev/nvme0n1
```

This command will display detailed information about the NVMe controller, including vendor ID, serial number, model name, and various controller attributes.

#### Drive Health

You can check the overall health of a drive with the smart-log subcommand:

```
sudo nvme smart-log /dev/nvme0n1
```

The output will provide information about the drive's temperature, available spare capacity, power-on hours, and more.

#### Formatting an NVMe Drive

You can format an NVMe drive using nvme-cli, but be cautious, as it will erase all data on the drive. Backup important data before proceeding. Use the format subcommand, replacing 'X' with the appropriate location as listed in the results of nvme list:

```
sudo nvme format /dev/nvme0nX
```

#### Securely Erasing an NVMe Drive

When preparing to sell or dispose of your NVMe computer, securely erase the drive, but remember to back up important data first. This command erases all data:

```
sudo nvme sanitize /dev/nvme0nX
```

#### To read data from an NVMe drive starting from block 1000 and reading 10 blocks with a data size of 1:

```
sudo nvme read /dev/nvme1n1 --start-block=1000 --block-count=10 --data-size 1
```

#### To write data to an NVMe drive at namespace 0, controller 1, with a data size of 4096:

```
sudo nvme write /dev/nvme1n1 -s 0 -c 1 -z 4096
```



#### SSH into EC2 Instances

To SSH into EC2 instances that have been configured with the above script, you can use the following commands for node1 and node2:

#### Node 1:

```
ssh -i "nvme-key.pem" ec2-user@ec2-52-221-202-154.ap-southeast-1.compute.amazonaws.com
```


#### Node 2:

```
ssh -i "nvme-key.pem" ec2-user@ec2-54-169-183-116.ap-southeast-1.compute.amazonaws.com
```

#### Requirements

- The script is intended for EC2 instances that belong to the "compute optimized" instance families. This includes instance types such as C5, C5a, C5ad, C5d, C5n, C6a, C6g, C6gd, C6gn, C6i, C6id, C6in, C7a, C7g, C7gd, C7gn, C7i, Hpc6a, Hpc7g, and Hpc7a.
- It is recommended to use an instance type like c5.large and ensure EBS optimization.

#### Additional NVMe Commands

Here are some additional NVMe commands and related operations you might find useful:

#### Checking NVMe Modules

You can check the NVMe modules using the following command:

```
ls /sys/module/ | grep nvme
```

#### EBS Volume ID

To find the EBS volume ID for an NVMe device (e.g., /dev/nvme1n1), use the following command:

```
sudo /sbin/ebsnvme-id /dev/nvme1n1
```

#### Managing Persistent Reservations

#### Node 1:

#### Register a persistent reservation:

```
sudo nvme resv-register -n 1 --crkey=0x0 --nrkey=0xa1 --rrega=0 /dev/nvme1n1
```

#### Acquire a persistent reservation:

```
sudo nvme resv-acquire -n 1 --crkey=0xa1 --rtype=1 --racqa=0 /dev/nvme0n1
```

#### Release a persistent reservation:

```
sudo nvme resv-release /dev/nvme1n1 -n 1 -t 1
sudo nvme resv-release /dev/nvme1n1
```

#### Report the persistent reservation:

```
sudo nvme resv-report /dev/nvme1n1 -n1 -e 1 -o normal
```

#### Node 2:

#### Acquire a persistent reservation with a different key:

```
sudo nvme resv-acquire -n 1 --crkey=0xb1 --rtype=2 --racqa=0 /dev/nvme1n1
```

#### Persistent Reservation Values

Here are the definitions for different values of persistent reservations:

```
0h: Reserved
1h: Write Exclusive Reservation
2h: Exclusive Access Reservation
3h: Write Exclusive - Registrants Only Reservation
4h: Exclusive Access - Registrants Only Reservation
5h: Write Exclusive - All Registrants Reservation
6h: Exclusive Access - All Registrants Reservation
07h-FFh: Reserved
```

#### Additional Disk Operations

You can perform various disk operations using commands like sudo fdisk -l, sudo mkfs.ext4 /dev/nvme1n1p1, sudo mkdir /shared, sudo mount /dev/nvme1n1p1 /shared, and sudo ls /shared.

#### Check NVMe Health

To check the health of an NVMe drive, you can use:

```
sudo nvme id-ctrl /dev/nvme1n1 -H
```


#### Determine Filesystem Type

To determine the filesystem type of a device (e.g., /dev/nvme1n1p1), you can use:

```
sudo file -s /dev/nvme1n1p1
```

#### Reference documents 

- [NVMe Command-Line Interface (nvme-cli) - Opensource.com](https://opensource.com/article/21/9/nvme-cli)

- [Open Source NVMe Management Utility (NVMe Command Line Interface - NVMe CLI) - NVM Express](https://nvmexpress.org/open-source-nvme-management-utility-nvme-command-line-interface-nvme-cli/)

- [Understanding Linux SCSI Reservation - The Geek Diary](https://www.thegeekdiary.com/understanding-linux-scsi-reservation/)

- [Mounting AWS NVMe Ephemeral Volumes - GitHub Gist](https://gist.githubusercontent.com/fideloper/40f7807920aa1198fa07b9e69dc82b56/raw/ebe6d8bd5388b60208f56d91f1934a0172f4f483/mount_aws_nvme_ephemeral.sh)

- [Mounting a NVMe Disk on AWS EC2 - Stack Overflow](https://stackoverflow.com/questions/45167717/mounting-a-nvme-disk-on-aws-ec2)

- [EC2 Linux Instance Store Volumes - AWS Knowledge Center](https://repost.aws/knowledge-center/ec2-linux-instance-store-volumes)

- [How to Attach and Mount an NVMe EBS Volume on EC2 - Cloudinsidr](https://www.cloudinsidr.com/content/how-to-attach-and-mount-an-nvme-ebs-volume-on-ec2/)
