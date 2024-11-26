{ pkgs, lib, ... }:
{
	boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.kernelParams = [
		"panic=10"
		"console=tty0"
		"console=ttyAMA0,115200"
		"console=ttyS0,115200"
		"net.ifnames=0"
	];
	boot.initrd.kernelModules = [ "dm-snapshot" "dm-crypt" ];
	boot.consoleLogLevel = 9;

	boot.loader = {
		efi.canTouchEfiVariables = true;
		systemd-boot.enable = true;
	};
}
