#!/bin/sh

# Use awk to extract the "NixOS" menuentry block
#nixos_kernel_entry=$(awk '/menuentry "NixOS"/,/\}/' /boot/grub/grub.cfg)

# Extract kernel path and parameters
#nixos_kernel_path=$(echo "$nixos_kernel_entry" | grep -oP 'kernels/\K[^ ]+')
#nixos_kernel_params=$(echo "$nixos_kernel_entry" | sed -n 's/.*init=\(.*\)$/init=\1/p')

#nixos_kernel_path=$(ls -1t /boot/kernels | grep -E ".*-linux-[0-9.]+-bzImage" | head -n 1)
#nixos_initrd_path=$(ls -1t /boot/kernels | grep -E ".*-initrd-linux-[0-9.]+-initrd" | head -n 1)
nixos_kernel_path=$(ls -1t /nix/store | grep -E "^[a-z0-9]+-linux-[0-9]+\.[0-9]+\.[0-9]+\$" | head -n 1)-bzImage
nixos_initrd_path=$(ls -1t /nix/store | grep -E "^[a-z0-9]+-initrd-linux-[0-9]+\.[0-9]+\.[0-9]+\$" | head -n 1)-initrd

nixos_kernel_init=$(ls -1t /nix/store | grep -E ".*-nixos-system-workbench-[0-9.]+[a-zA-Z0-9]+" | head -n 1)/init

#mount_point="/boot"
#device=$(df -P "$mount_point" | awk 'NR==2 {print $1}')
#uuid=$(lsblk -no UUID "$device")
uuid=$(blkid -s UUID -o value /dev/nvme0n1p1)

echo "constructing extra vfio entry for vfio-pci.ids=$vfioPciIds"

echo "\$uuid = $uuid"
echo "\$nixos_kernel_path = $nixos_kernel_path"
echo "\$nixos_initrd_path = $nixos_initrd_path"
echo "\$nixos_kernel_init = $nixos_kernel_init"

menuentry="menuentry \"NixOS - (vfio-pci.ids=$vfioPciIds)\" --class nixos --unrestricted {
	search --set=drive1 --fs-uuid $uuid
	linux (\$drive1)//kernels/$nixos_kernel_path init=/nix/store/$nixos_kernel_init amd_pstate=active amd_pstate.replace=1 amdgpu.sg_display=0 amdgpu.ppfeaturemask=0xfff7ffff loglevel=6 vfio-pci.ids=$vfioPciIds
	initrd (\$drive1)//kernels/$nixos_initrd_path
}"

echo "$menuentry" > $out
