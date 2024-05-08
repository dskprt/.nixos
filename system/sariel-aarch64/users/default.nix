{ pkgs, lib, ... }: {
	
	users.mutableUsers = false;

	users.users.root.password = lib.mkForce "sariel";
	users.users.root.hashedPasswordFile = lib.mkForce null;
	users.users.root.hashedPassword = lib.mkForce null;
	users.users.root.initialPassword = lib.mkForce null;
	users.users.root.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCgo+2yFgSlrX2KV2jnG2yb2T5eAroA9TQ7/puKL6ql kiso@workbench"
	];
}
