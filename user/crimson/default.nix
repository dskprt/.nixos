{ pkgs, ... }: {
	users.users.crimson = {
		uid = 1001;
		group = "users";
		isNormalUser = true;
		home = "/home/secondary";
		shell = pkgs.fish;
		hashedPasswordFile = "/@/secondary.pass";
		extraGroups = [ "wheel" "audio" "video" "dialout" "render" "adbusers" ];
	};
}
