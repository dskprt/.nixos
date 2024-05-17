{ pkgs, lib, ... }: {
	imports = [
		#./plymouth.nix
	];

	boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
	boot.kernelParams = [ "amd_pstate=active" "amd_pstate.replace=1"
		"amdgpu.sg_display=0" "amdgpu.ppfeaturemask=0xfff7ffff"
		"systemd.show_status=auto" "sysrq_always_enabled=1" ];
	boot.consoleLogLevel = 9;

	#boot.initrd.preLVMCommands = ''
	#	for tty in /dev/tty{1..6}; do
	#		setleds -D +num < "$tty";
	#	done
	#'';

	boot.loader = {
		efi.canTouchEfiVariables = true;
		
		grub = {
			enable = true;
			efiSupport = true;
			device = "nodev";
			configurationLimit = 20;
			theme = pkgs.stdenv.mkDerivation {
				pname = "workbench-grub-theme";
				version = "1.0";
				src = builtins.path {
					path = ./theme;
					name = "workbench-grub-theme";
				};
				installPhase = "mkdir -p $out && cp * $out/";
			};
			splashImage = ./theme/background.png;
		};
	};

	#specialisation.mainline.configuration = {
	#	system.nixos.tags = [ "mainline" ];
	#	boot.kernelPackages = pkgs.linuxPackages_testing;
	#};

# 	specialisation.igpu.configuration = {
# 		system.nixos.tags = [ "igpu" ];
# 		boot.kernelParams = [ "asus_wmi.gpu_mux_mode=1" "asus_wmi.dgpu_disable=1" ];
# 	};
# 
# 	specialisation.dgpu.configuration = {
# 		system.nixos.tags = [ "dgpu" ];
# 		boot.kernelParams = [ "asus_wmi.gpu_mux_mode=0" "asus_wmi.dgpu_disable=0" ];
# 	};

 	specialisation.vm.configuration = {
 		system.nixos.tags = [ "vfio" ];
 		boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];

		boot.extraModprobeConfig = ''
			softdep amdgpu pre: vfio-pci
			softdep drm pre: vfio-pci
			options vfio-pci ids=1002:7480,1002:ab30
		'';
 		
 		#boot.extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_4.kvmfr ];
 		#boot.extraModprobeConfig = ''
 		#	options kvmfr static_size_mb=32
 		#'';
 
 		#environment.systemPackages = with pkgs; [
 		#	looking-glass-client
 		#];
 
 		#services.udev.extraRules = ''
 		#	SUBSYSTEM=="kvmfr", OWNER="kiso", GROUP="kvm", MODE="0600"
 		#'';
 	};

	specialisation.rescue.configuration = {
		system.nixos.tags = [ "rescue" ];
		boot.kernelParams = [ "systemd.unit=rescue.target" "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" "modprobe.blacklist=amdgpu" ];
	};

	specialisation.emergency.configuration = {
		system.nixos.tags = [ "emergency" ];
		boot.kernelParams = [ "systemd.unit=emergency.target" "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" ];
	};

	systemd.services.noGpuSleep = {
		wantedBy = [ "multi-user.target" ];
		description = "Disables the D3cold power state for the dGPU";
		serviceConfig = {
			Type = "oneshot";
			User = "root";
			RemainAfterExit = "yes";
			WorkingDirectory = "/sys/bus/pci/devices/0000:03:00.0";
			ExecStart = "${pkgs.bash}/bin/bash -c 'echo 0 > /sys/bus/pci/devices/0000:03:00.0/d3cold_allowed'";
			ExecStop = "${pkgs.bash}/bin/bash -c 'echo 1 > /sys/bus/pci/devices/0000:03:00.0/d3cold_allowed'";
		};
	};

	systemd.services.chargingLimit = {
		wantedBy = [ "multi-user.target" ];
		description = "Lowers the battery charging limit to increase lifespan";
		serviceConfig = {
			Type = "oneshot";
			User = "root";
			RemainAfterExit = "yes";
			WorkingDirectory = "/sys/class/power_supply/BAT0";
			ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
			ExecStart = "${pkgs.bash}/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
			ExecStop = "${pkgs.bash}/bin/bash -c 'echo 100 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
		};
	};
}
