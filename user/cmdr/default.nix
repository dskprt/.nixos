{ pkgs, ... }: {
	users.users.master = {
		uid = 1000;
		group = "users";
		isNormalUser = true;
		home = "/home/admin";
		shell = pkgs.fish;
		password = "shikikan";
		extraGroups = [ "wheel" "audio" "video" "dialout" "render" "docker" ];
		subUidRanges = [
			{ startUid = 100000; count = 65536; }
		];
		subGidRanges = [
			{ startGid = 100000; count = 65536; }
		];
	};
}
