{ inputs, fetchurl, linuxManualConfig, ... }:
let
	crossPkgs = inputs.nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;
in
(linuxManualConfig rec {
	version = "6.1.43";
	modDirVersion = "${version}-underworld";
	extraMeta.branch = "6.1";
	
	src = inputs.linux-rockchip;

	kernelPatches = [
		{
			name = "export-symbol-suspend";
			patch = ./patches/01-export-symbol-suspend.patch;
		}
		{
			name = "export-symbol-iommu";
			patch = ./patches/02-export-symbol-iommu.patch;
		}
	];
	#hardeningDisable = [ "relro" ];

	configfile = ./linux_rk3588_experimental_purged.config;
	allowImportFromDerivation = true;
})
.overrideAttrs(prev: {
	nativeBuildInputs = prev.nativeBuildInputs ++ [ crossPkgs.ubootTools ];
})
