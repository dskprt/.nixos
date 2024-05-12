# TODO we will most likely be able to switch to the upstream kernel when 6.10 releases
{ inputs, fetchurl, linuxManualConfig, aarch64_pkgs_cross, ... }:
let
	llvmPackages = aarch64_pkgs_cross.llvmPackages_18;
	inherit (llvmPackages) clang stdenv;
in
(linuxManualConfig rec {
	version = "6.1.43";
	modDirVersion = "${version}-underworld";
	extraMeta.branch = "6.1";
	
	src = fetchurl {
		url = "https://github.com/armbian/linux-rockchip/archive/3611c0f68000a5f53612dcc4858e3b5369eab35f.tar.gz";
		hash = "";
	};

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

	configfile = ./new2.config;
	allowImportFromDerivation = true;
})
.overrideAttrs(prev: {
	name = "k";
	nativeBuildInputs = prev.nativeBuildInputs ++ [ aarch64_pkgs_cross.ubootTools ];
})
