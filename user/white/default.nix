{ pkgs, ... }: {
	users.users.white = {
		uid = 10000;
		group = "users";
		isNormalUser = true;
		home = "/home/guest";
		shell = pkgs.bash;
		hashedPasswordFile = "/@/guest.pass";
		extraGroups = [ ];
	};
}
