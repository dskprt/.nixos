{ pkgs, lib, ... }: {
	services = {
		xserver = {
			enable = true;

			excludePackages = [
				pkgs.xterm
			];

			displayManager.gdm.enable = true;
			desktopManager.gnome.enable = true;
		};

		# displayManager.autoLogin = {
		# 	enable = true;
		# 	user = "hades";
		# };

		gnome = {
			core-os-services.enable = true;
			core-shell.enable = true;
			core-utilities.enable = true;
			core-developer-tools.enable = false;
			games.enable = false;
		};
	};

	services.gnome.gnome-online-miners.enable = lib.mkForce false;
	services.gnome.gnome-online-accounts.enable = lib.mkForce true;
	services.gnome.gnome-initial-setup.enable = lib.mkForce false;
	services.gnome.gnome-remote-desktop.enable = lib.mkForce true;
	services.gnome.rygel.enable = lib.mkForce true;
	services.gnome.sushi.enable = lib.mkForce false;

	services.packagekit.enable = lib.mkForce false;
	services.power-profiles-daemon.enable = lib.mkForce true;

	programs.gnome-terminal.enable = lib.mkForce false;
	programs.geary.enable = lib.mkForce true;

	environment.gnome.excludePackages = (with pkgs; [
		gnome-tour
		gnome-user-docs
		orca
		gnome-console
		simple-scan
		loupe
	]) ++ (with pkgs.gnome; [
		yelp
		cheese
		epiphany
		#gnome-contacts
		gnome-logs
		#gnome-maps
		gnome-music
		nautilus
		totem
	]);

	environment.systemPackages = with pkgs; [
		gnome.gnome-shell-extensions
		gnome.gnome-tweaks
		gnome.dconf-editor

		cinnamon.nemo-with-extensions
		# cinnamon.nemo-fileroller

		gnome.adwaita-icon-theme

		konsole # terminal
		gthumb # image viewer

		# nightfox-gtk-theme
		# fluent-gtk-theme
		# paper-icon-theme

		# rose-pine-cursor

		#gnomeExtensions.forge
	];

	xdg.mime.defaultApplications = {
		"inode/directory" = "nemo.desktop";
		"application/x-gnome-saved-search" = "nemo.desktop";
	};

	xdg.portal.enable = true;
	xdg.portal.xdgOpenUsePortal = true;

	# experiment: nemo as desktop icon manager
	services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
		[org.gnome.desktop.background]
		show-desktop-icons=false
		[org.nemo.desktop]
		show-desktop-icons=true
	'';

	# dconf.settings = {
	# 	"org/gnome/shell" = {
	# 		disabled-user-extensions = false;

	# 		enabled-extensions = [
	# 			"forge@jmmaranan.com"
	# 		];
	# 	};

	# 	"org/gnome/desktop/interface".color-scheme = "prefer-dark";
	# };
}
