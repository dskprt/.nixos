{ lib, pkgs, ... }: {
	imports = [
		./persistence.nix
		#./luks.nix
	];

	fileSystems."/" = {
		device = "tmpfs";
		fsType = "tmpfs";
		options = [ "noatime" "nodiratime" "size=2G" ];
	};

	fileSystems."/tmp" = {
		device = "tmpfs";
		fsType = "tmpfs";
		options = [ "noatime" "nodiratime" "size=10G" ];
	};

	# fileSystems."/boot/firmware" = {
	# 	device = "/dev/disk/by-label/firmware";
	# 	fsType = "vfat";
	# };

	fileSystems."/boot" = {
		device = "/dev/disk/by-label/firmware";
		fsType = "vfat";
		options = [ "defaults" ];
	};

	fileSystems."/home" = {
		device = "/dev/disk/by-label/emmc-primary";
		fsType = "btrfs";
		options = [ "subvol=home" "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	};

	fileSystems."/root" = {
		device = "/dev/disk/by-label/emmc-primary";
		fsType = "btrfs";
		options = [ "subvol=root" "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	};

	fileSystems."/nix" = {
		device = "/dev/disk/by-label/emmc-primary";
		fsType = "btrfs";
		options = [ "subvol=nix" "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	};

	fileSystems."/@" = {
		device = "/dev/disk/by-label/emmc-primary";
		fsType = "btrfs";
		options = [ "subvol=persist" "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
		neededForBoot = true;
	};

	# system.fsPackages = [ pkgs.bindfs ];

	# fileSystems."/usr/share/fonts" = {
	# 	device = (pkgs.buildEnv {
	# 		name = "system-fonts";
	# 		paths = config.fonts.packages;
	# 		pathsToLink = [ "/share/fonts" ];
	# 	}) + "/share/fonts";

	# 	fsType = "fuse.bindfs";
	# 	options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
	# };
}
