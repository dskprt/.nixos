{ inputs, pkgs, lib, aarch64_pkgs_cross, ... }:
let
	uboot = aarch64_pkgs_cross.callPackage ./uboot/upstream.nix {
		inherit inputs;
		inherit pkgs;
		inherit aarch64_pkgs_cross;
	};
in
{
	imports = [
		./uboot/build.nix
	];
	
	boot.kernelPackages = aarch64_pkgs_cross.recurseIntoAttrs (aarch64_pkgs_cross.linuxPackagesFor
		(aarch64_pkgs_cross.callPackage ./kernel/armbian/linux_rk3588.nix {
			inherit inputs;
			inherit aarch64_pkgs_cross;
		}));
	
	boot.kernelParams = [
		"console=tty1"
		"console=ttyS2,1500000"

		"systemd.show_status=auto"
		"sysrq_always_enabled=1"

		"systemd.setenv=SYSTEMD_SULOGIN_FORCE=1"
	];
	boot.consoleLogLevel = 7;

	boot.supportedFilesystems = lib.mkForce [
		"vfat"
		"ext4"
		"btrfs"
	];

	boot.initrd.includeDefaultModules = lib.mkForce false;
	boot.initrd.availableKernelModules = lib.mkForce [
		"mmc_block"
		"hid"
		"dm_mod"
		"dm_crypt"
		"input_leds"
		"btrfs"
	];

	boot.loader = {
		grub.enable = lib.mkForce false;
		generic-extlinux-compatible.enable = true;
	};

	environment.systemPackages = with aarch64_pkgs_cross; [
		uboot
		rkbin
	];

	hardware = {
		deviceTree = {
			name = "rockchip/rk3588s-orangepi-5b.dtb";
			overlays = [];
		};
	};
}
