 { pkgs, ... }: {
	services.xserver = {
		displayManager.sddm.enable = false;
		displayManager.lightdm.enable = false;
		displayManager.gdm.enable = false;
		displayManager.startx.enable = true;
	};

	services.greetd = {
		enable = true;
		settings = {
			default_session = {
				command = "${pkgs.greetd.tuigreet}/bin/tuigreet -i --asterisks --time --cmd startx";
				user = "greeter";
			};
		};
		# serviceConfig = {
		# 	TTYReset = true;
		#     TTYVHangup = true;
		#     TTYVTDisallocate = true;
		# };
	};

	environment.systemPackages = with pkgs; [
		greetd.tuigreet
	];
}
