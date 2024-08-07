{ pkgs, ... }: {
	
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	services.greetd = {
		enable = true;
		settings = {
			default_session = {
				command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
				user = "greeter";
			};
		};
	};

	environment.systemPackages = with pkgs; [
		greetd.tuigreet
	];
}
