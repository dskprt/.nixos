{ inputs, pkgs, aarch64_pkgs_cross, config, lib, ... }:
let
	uboot = aarch64_pkgs_cross.callPackage ./cerberus/boot/uboot/upstream.nix { 
		inherit inputs;
		inherit pkgs;
		inherit aarch64_pkgs_cross;
	};
in
{
	
	imports = [
		"${inputs.nixpkgs}/nixos/modules/profiles/installation-device.nix"
		"${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
	];

	fileSystems = {
		"/boot/firmware" = {
			device = "/dev/disk/by-label/firmware";
			fsType = "vfat";
		};
		"/" = {
			device = "/dev/disk/by-label/NIXOS_SD";
			fsType = "ext4";
		};
	};

	sdImage = {
		firmwarePartitionOffset = 16;
		firmwarePartitionName = "firmware";
		firmwareSize = 64;

		compressImage = false;
		expandOnBoot = true;

		 populateFirmwareCommands = ''
		 	dd if=${uboot}/u-boot-rockchip.bin of=$img seek=64 conv=notrunc
		 '';

		postBuildCommands = ''
			mkdir -p firmware
			cp ${uboot}/u-boot-rockchip.bin firmware/
		'';

		populateRootCommands = ''
			mkdir -p ./files/boot
			${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
		'';
	};

	installer.cloneConfig = false;
	boot.consoleLogLevel = lib.mkForce 5;
}
