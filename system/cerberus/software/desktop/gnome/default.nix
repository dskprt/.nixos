{ pkgs, lib, ... }: {
	services = {
		xserver = {
			enable = true;

			excludePackages = [
				pkgs.xterm
			];

			displayManager = {
				gdm.enable = true;
				autoLogin = {
					enable = true;
					user = "hades";
				};
			};
			
			desktopManager.gnome.enable = true;
		};
		gnome = {
			core-os-services.enable = true;
			core-shell.enable = true;
			core-utilities.enable = true;
			core-developer-tools.enable = false;
			games.enable = false;
		};
	};

	services.gnome.gnome-online-miners.enable = false;
	services.gnome.gnome-online-accounts.enable = true;
	services.gnome.gnome-initial-setup.enable = false;
	services.gnome.gnome-remote-desktop.enable = true;
	services.gnome.rygel.enable = true;
	services.gnome.sushi.enable = false;

	services.packagekit.enable = false;
	services.power-profiles-daemon.enable = lib.mkForce false;

	programs.gnome-terminal.enable = false;
	programs.geary.enable = true;

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

		nightfox-gtk-theme
		fluent-gtk-theme
		paper-icon-theme

		rose-pine-cursor

		gnomeExtensions.forge
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

	dconf.settings = {
		"org/gnome/shell" = {
			disabled-user-extensions = false;

			enabled-extensions = [
				"forge@jmmaranan.com"
			];
		};

		"org/gnome/desktop/interface".color-scheme = "prefer-dark";
	};
}
