{ pkgs, lib, ... }: {

	boot.kernelPackages = pkgs.linuxKernel.packages.linux_testing;
	boot.kernelParams = [ "systemd.show_status=auto" "sysrq_always_enabled=1" ];
	boot.consoleLogLevel = 9;

	boot.loader = {
		efi.canTouchEfiVariables = true;
		
		systemd-boot = {
			enable = true;
			configurationLimit = 10;
			consoleMode = "auto";
		};
	};
}
