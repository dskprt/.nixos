{ lib, ... }: {

	disko.devices = {
		disk.disk1 = {
			device = "/dev/mmcblk0"; # TODO check this!
			type = "disk";

			content = {
				type = "gpt";

				partitions = {
					firmware = {
						size = "64M";
						type = "EF00";
						name = "firmware";

						content = {
							type = "filesystem";
							format = "vfat";
							mountpoint = "/boot/firmware";
							mountOptions = [ "defaults" ];
						};
					};

					luks_primary = {
						size = "100%";
						name = "luks_primary";

						settings = {
							allowDiscards = true;
						};

						content = {
							type = "btrfs";
							name = "primary";
							extraArgs = [ "-f" "--csum xxhash" ];

							subvolumes = {
								"persist" = {
									mountpoint = "/@";
									mountOptions = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
								};
								"home" = {
									mountpoint = "/home";
									mountOptions = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
								};
								"nix" = {
									mountpoint = "/nix";
									mountOptions = [ "compress=zstd:2" "space_cache=v2" "discard=async" "commit=60" "noatime" "nodiratime" "ssd" ];
								};
							};
						};
					};
				};
			};
		};
		nodev = {
			"/" = {
				fsType = "tmpfs";
				mountOptions = [ "size=2G" "noatime" "nodiratime" ];
			};
			"/tmp" = {
				fsType = "tmpfs";
				mountOptions = [ "size=10G" "noatime" "nodiratime" ];
			};
		};
	};
}
