{ pkgs, config, ... }:
{
	fileSystems."/".options = [ "noatime" "nodiratime" ];
	fileSystems."/tmp".options = [ "size=8G" "noatime" "nodiratime" ];

	fileSystems."/@".options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/home".options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/nix".options = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];

	fileSystems."/@".neededForBoot = true;

	fileSystems."/@/data" = {
		device = "/dev/disk/by-uuid/3c128f46-0f69-46d4-ad26-03420dd47ab0";
		fsType = "xfs";
		options = [ "discard" "noatime" "nodiratime" "nofail" ];
	};

	system.fsPackages = [ pkgs.bindfs ];

	fileSystems."/usr/share/fonts" = {
	      device = (pkgs.buildEnv {
	            name = "system-fonts";
	            paths = config.fonts.packages;
	            pathsToLink = [ "/share/fonts" ];
	          }) + "/share/fonts";
	      fsType = "fuse.bindfs";
	      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
	  };
}
