{ pkgs, config, ... }:
{
	fileSystems."/".options = [ "noatime" "nodiratime" ];
	fileSystems."/tmp".options = [ "size=12G" "noatime" "nodiratime" ];

	fileSystems."/@".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/home".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
	fileSystems."/nix".options = [ "compress=zstd:1" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];

	fileSystems."/@".neededForBoot = true;

	fileSystems."/@/data" = {
		device = "/dev/disk/by-uuid/0836aed3-44ba-4e44-be5d-b18dbe887d79";
		fsType = "xfs";
		options = [ "discard" "noatime" "nodiratime" "nofail" ];
	};
}
