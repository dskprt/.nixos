{ pkgs, ... }: {
	boot.initrd.kernelModules = [ "amdgpu" ];
	services.xserver.videoDrivers = [ "amdgpu" ];

	hardware.opengl.driSupport = true;
	hardware.opengl.driSupport32Bit = true;

	hardware.opengl.extraPackages = with pkgs; [
		vaapiVdpau
		libvdpau-va-gl

		rocmPackages.rocm-runtime
		rocmPackages.rocm-smi
		rocmPackages.rocm-device-libs
		rocmPackages.rocminfo
		rocmPackages.clr
		#rocmPackages.clr.icd
		#rocmPackages.miopen

		#clinfo
	];

	systemd.tmpfiles.rules = [
		"L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
	];
}
