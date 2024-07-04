# TODO we will most likely be able to switch to the upstream kernel when 6.10 releases
{ inputs, fetchurl, linuxManualConfig, aarch64_pkgs_cross, ... }:
let
	llvmPackages = aarch64_pkgs_cross.llvmPackages_18;
	inherit (llvmPackages) clang stdenv;
in
(linuxManualConfig rec {
	version = "6.1.43";
	modDirVersion = "${version}";
	extraMeta.branch = "6.1";
	
	src = fetchurl {
		url = "https://github.com/armbian/linux-rockchip/archive/95c73cd79661ccdf45beaa97854a76799f4349aa.tar.gz";
		hash = "sha256-x1pMJ6vT9dnE37wC2TOAWbUt6u/koB1UbbvtCIKGPFY=";
	};

	kernelPatches = [
		{
			name = "export-symbol-suspend";
			patch = ../patches/01-export-symbol-suspend.patch;
		}
		{
			name = "export-symbol-iommu";
			patch = ../patches/02-export-symbol-iommu.patch;
		}
		# {
		# 	name = "rockchip-vop2-setup";
		# 	patch = ../patches/03-rockchip_drm_vop2.patch;
		# }
	];
	#hardeningDisable = [ "relro" ];

	configfile = ./vendor.config;
	allowImportFromDerivation = true;
})
.overrideAttrs(prev: {
	name = "k";
	nativeBuildInputs = prev.nativeBuildInputs ++ [ aarch64_pkgs_cross.ubootTools ];
})
