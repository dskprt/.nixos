{ inputs, config, aarch64_pkgs_cross, ... }: {

	config.system.build.kernel = aarch64_pkgs_cross.recurseIntoAttrs (aarch64_pkgs_cross.linuxPackagesFor
		(aarch64_pkgs_cross.callPackage ./linux_rk3588.nix { inherit inputs; }));
}
