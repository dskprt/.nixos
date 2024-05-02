{ pkgs, config, inputs, ... }: {
	system.build.tarball = pkgs.callPackage "${inputs.nixpkgs}/nixos/lib/make-system-tarball.nix" {
		storeContents = [
			{
				symlink = "/bin/init";
				object = "${config.system.build.toplevel}/init";
			}
		];
		contents = [];
		compressCommand = "zstd";
		compressionExtension = "";
	};
}
