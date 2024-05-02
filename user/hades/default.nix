{ pkgs, ... }: {
	users.users.hades = {
		uid = 1000;
		group = "users";
		isNormalUser = true;
		home = "/home/default";
		shell = pkgs.fish;
		hashedPasswordFile = "/@/default.pass";
		extraGroups = [ "wheel" "audio" "video" "dialout" "kvm" "render" ];
		subUidRanges = [
			{ startUid = 100000; count = 65536; }
		];
		subGidRanges = [
			{ startGid = 100000; count = 65536; }
		];
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCgo+2yFgSlrX2KV2jnG2yb2T5eAroA9TQ7/puKL6ql kiso@workbench"
		];
	};
}
