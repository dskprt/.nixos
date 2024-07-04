{ inputs, pkgs, lib, ... }:
let
	ap6275p-firmware = pkgs.stdenvNoCC.mkDerivation {
		pname = "ap6275p-firmware";
		version = "unstable";

		dontBuild = true;
		dontFixup = true;
		compressFirmware = false;

		src = inputs.armbian-firmware + "/ap6275p";

		buildCommand = ''
			mkdir -p $out/lib/firmware/ap6275p
			cp $src/* $out/lib/firmware/ap6275p/

			cp $out/lib/firmware/ap6275p/config.txt $out/lib/firmware/ap6275p/config_bcm43752a2_pcie_ag.txt
		'';
	};
in
{
	hardware.firmware = [
		ap6275p-firmware
	];

	systemd.tmpfiles.rules = [
		"L+ /lib/firmware - - - - /run/current-system/firmware"
	];
}
