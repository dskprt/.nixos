{ pkgs, ... }: {
	users.users.master = {
		uid = 1000;
		group = "users";
		isNormalUser = true;
		home = "/home/default";
		shell = pkgs.fish;
		hashedPasswordFile = "/@/default.pass";
		extraGroups = [ "wheel" "audio" "video" "dialout" "kvm" "render" "adbusers" "libvirt" "docker" ];
		subUidRanges = [
			{ startUid = 100000; count = 65536; }
		];
		subGidRanges = [
			{ startGid = 100000; count = 65536; }
		];
	};
}
