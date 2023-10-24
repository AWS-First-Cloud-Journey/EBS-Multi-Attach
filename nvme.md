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
