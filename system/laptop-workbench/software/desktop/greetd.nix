 { pkgs, ... }: {

	services.xserver = {
		displayManager.sddm.enable = false;
		displayManager.lightdm.enable = false;
		displayManager.gdm.enable = false;
		#displayManager.startx.enable = true;
	};

	services.greetd = {
		enable = true;
		vt = 2;
		settings = {
			default_session = {
				command = "${pkgs.greetd.tuigreet}/bin/tuigreet -i --asterisks --time --cmd startplasma-wayland";
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
