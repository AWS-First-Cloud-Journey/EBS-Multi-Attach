#!/usr/bin/env bash

# Install the "nvme" command
# See: https://github.com/linux-nvme/nvme-cli
sudo apt-get install -y nvme-cli

# Create a mount point (directory)
sudo mkdir -p /some/mount

# Find ephemeral storage (assuming a single ephemeral disk) and format it
# (This is intended to be run on first boot in user data, so the disk is not formatted)
EPHEMERAL_DISK=$(sudo nvme list | grep 'Amazon EC2 NVMe Instance Storage' | awk '{ print $1 }')
sudo mkfs.ext4 $EPHEMERAL_DISK
sudo mount -t ext4 $EPHEMERAL_DISK /some/mount

# Add ephemeral disk mount to /etc/fstab (even though data may be lost in stop/starts of EC2)
# This helps with mounting by UUID
EPHEMERAL_UUID=$(sudo blkid -s UUID -o value $EPHEMERAL_DISK)
echo "UUID=$EPHEMERAL_UUID /opt/nomad ext4 defaults 0 0" | sudo tee -a /etc/fstab
