{ inputs, config, ... }:
let
	pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;
in
{
	imports = [
		"${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
	];

	sdImage = {
		firmwarePartitionOffset = 16;
		firmwarePartitionName = "firmware";
		firmwareSize = 256;

		compressImage = false;
		expandOnBoot = true;

		populateFirmwareCommands = ''
			${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./firmware
			dd if=${pkgs.ubootOrangePi5}/u-boot-rockchip.bin of=$img seek=64 conv=notrunc
		'';

		populateRootCommands = ''
			mkdir -p ./files/boot
		'';
	};
}
