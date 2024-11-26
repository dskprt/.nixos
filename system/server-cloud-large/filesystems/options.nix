{ pkgs, config, ... }:
{
	fileSystems."/".options = [ "noatime" "nodiratime" ];
	fileSystems."/tmp".options = [ "size=12G" "noatime" "nodiratime" ];

	fileSystems."/@".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/home".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/nix".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];

	fileSystems."/@".neededForBoot = true;

	# fileSystems."/@/data" = {
	# 	device = "/dev/disk/by-uuid/3c128f46-0f69-46d4-ad26-03420dd47ab0";
	# 	fsType = "xfs";
	# 	options = [ "discard" "noatime" "nodiratime" "nofail" ];
	# };
}
