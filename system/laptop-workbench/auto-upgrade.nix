{
	system.autoUpgrade = {
		enable = true;
		dates = "daily";
		operation = "boot";
		flake = "/etc/nixos/flake#workbench";
		flags = [
			"--recreate-lock-file"
		];
	};
}
