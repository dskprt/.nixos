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

	# this is needed, otherwise the driver won't be able to find the firmware
	# aparently this doesn't work on the system even though it worked on the sd image
	systemd.tmpfiles.rules = [
		"L+ /lib/firmware/ap6275p - - - - ${ap6275p-firmware}/lib/firmware/ap6275p"
	];
}
