{ pkgs, ... }: {
	
	users.mutableUsers = false;

	users.users.root.password = "sariel";
	users.users.root.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMCgo+2yFgSlrX2KV2jnG2yb2T5eAroA9TQ7/puKL6ql kiso@workbench"
	];
}
