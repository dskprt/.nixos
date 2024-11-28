{ pkgs, ... }:
{
	users.groups.runner = {
		gid = 10000;
	};
	
	users.users.runner = {
		uid = 10000;
		group = "runner";
		isNormalUser = true;
		home = "/home/runner";
		extraGroups = [ "users" ];
		shell = pkgs.tcsh;
	};
}
