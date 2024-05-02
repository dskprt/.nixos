{ inputs, pkgs, lib, aarch64_pkgs_cross, ... }:
let
	crossPkgs = inputs.nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;
in
{
	boot.kernelPackages = aarch64_pkgs_cross.recurseIntoAttrs (aarch64_pkgs_cross.linuxPackagesFor
		(aarch64_pkgs_cross.callPackage ./kernel/linux_rk3588.nix { inherit inputs; }));
	
	boot.kernelParams = [
		"earlycon"
		"console=tty1"
		"console=ttyS2,1500000"

		"systemd.show_status=auto"
		"sysrq_always_enabled=1"

		"coherent_pool=2M"
		"irqchip.gicv3_pseudo_nmi=0"
	];
	boot.consoleLogLevel = 9;

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
		# systemd-boot = {
		# 	enable = true;
		# 	consoleMode = "auto";
		# 	configurationLimit = 10;
		# };
	};

	environment.systemPackages = with aarch64_pkgs_cross; [
		ubootOrangePi5
		rkbin
	];

	hardware = {
		deviceTree = {
			name = "rockchip/rk3588s-orangepi-5b.dtb";
			overlays = [];
		};
	};
}
