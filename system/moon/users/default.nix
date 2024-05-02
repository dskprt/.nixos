{ pkgs, ... }: {
	imports = [
		../../../user/scarlet
		../../../user/crimson
		../../../user/white
	];

	users.mutableUsers = false;
}
