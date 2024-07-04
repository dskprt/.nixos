{ inputs, fetchurl, linuxManualConfig, aarch64_pkgs_cross, ... }:
# let
# 	llvmPackages = aarch64_pkgs_cross.llvmPackages_18;
# 	inherit (llvmPackages) clang stdenv;
# in
(linuxManualConfig rec {
	version = "6.10.0-rc4";
	modDirVersion = "${version}";
	extraMeta.branch = "6.10";
	
	src = fetchurl {
		url = "https://git.kernel.org/torvalds/t/linux-6.10-rc4.tar.gz";
		hash = "sha256-PUxS9xxHFX5sh9Xny/+NZ8AFSNIYkDIvUnS+6+e9P3w=";
	};

	# kernelPatches = [
	# 	{
	# 		name = "export-symbol-suspend";
	# 		patch = ./patches/01-export-symbol-suspend.patch;
	# 	}
	# 	{
	# 		name = "export-symbol-iommu";
	# 		patch = ./patches/02-export-symbol-iommu.patch;
	# 	}
	# ];

	configfile = ./vendor.config;
	allowImportFromDerivation = true;
})
.overrideAttrs(prev: {
	name = "k";
	nativeBuildInputs = prev.nativeBuildInputs ++ [ aarch64_pkgs_cross.ubootTools ];
})
