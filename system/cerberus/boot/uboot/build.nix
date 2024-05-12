{ inputs, config, pkgs, aarch64_pkgs_cross, ... }: {

	config.system.build.uboot =
		aarch64_pkgs_cross.callPackage ./upstream.nix {
			inherit inputs;
			inherit pkgs;
			inherit aarch64_pkgs_cross;
		};
}
