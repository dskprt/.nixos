{ pkgs, ... }:
{
	users.users.cmdr = {
		uid = 1000;
		group = "users";
		isNormalUser = true;
		home = "/home/admin";
		shell = pkgs.bash;
		hashedPasswordFile = "/@/admin.pass";
		extraGroups = [ "wheel" "audio" "video" "dialout" "render" "podman" ];
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
