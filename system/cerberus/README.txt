1. how to put this on an sdcard to boot it?
reference(s): https://github.com/ryan4yin/nixos-rk3588/blob/main/modules/sd-image/sd-image-rock5a.nix,
			  pre-built nixos-rk3588 image,
			  official radxa debian image,
			  https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_4,
			  https://wiki.nixos.org/wiki/NixOS_on_ARM/Installation,
			  https://nix.dev/tutorials/nixos/installing-nixos-on-a-raspberry-pi.html

i guess you'd have to somehow build a rootfs image/tarball (on an x86_64 host)
then create partitions n stuff for the bootloader eh

perhaps it's possible to boot the installer by just replacing the kernel in the minimal arm iso?
actually the arm iso seems to be a full system rather than the installer, but it still should be fine
rather should use a generic sdcard image (https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux)

and after the minimal system is booted (perhaps into ram? not sure if thats possible), then we would
 (if possible) configure partitions, and it should (hopefully) be possible to deploy the "proper" system
 from the host with colmena

also perhaps we can flash u-boot to spi flash...?


STOCK DEBIAN DISK IMAGE LAYOUT:
- 16 MiB free (unallocated) for u-boot (need to be flashed with a utility, see https://docs.radxa.com/en/rock5/rock5c/low-level-dev/u-boot)
- 16 MiB FAT32 partition ("config", contains rsetup before.txt and config.txt first boot commands, most likely distro-specific and not needed)
- x MiB FAT32 EFI partition ("boot", apparently doesn't have anything on it? i don't see why an EFI partition would be needed anyway...)
- rest rootfs partition (with /boot containing the kernel, initrd, config, dtbo/, and extlinux)
