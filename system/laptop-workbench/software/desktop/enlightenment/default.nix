{ pkgs, ... }: {
	services.xserver = {
		enable = true;
		xkb.layout = "pl";

		excludePackages = [
			pkgs.xterm
		];

		xautolock = {
			enable = true;
			locker = "${pkgs.betterlockscreen}/bin/betterlockscreen --off 30 -l";
			time = 15;
			enableNotifier = true;
			notifier = "${pkgs.libnotify}/bin/notify-send 'Locking screen in 10 seconds...'";
		};
	};

	environment.systemPackages = with pkgs; [
		betterlockscreen
		libnotify
		
		xdg-user-dirs
		xdg-utils
		
		(callPackage ./e16.nix { })

		noto-fonts
		noto-fonts-cjk-sans
		noto-fonts-monochrome-emoji

		gnome.adwaita-icon-theme
		adwaita-qt
		adwaita-qt6
		libadwaita

		kdePackages.breeze
		kdePackages.breeze-icons
		kdePackages.breeze-gtk
		libsForQt5.breeze-qt5

		kdePackages.qqc2-breeze-style

		xbindkeys
		xbindkeys-config

		kdePackages.kdialog
		#dunst

		polkit_gnome
		#ssh-askpass-fullscreen
	];

	programs.ssh.askPassword = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
	#programs.ssh.askPassword = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
	programs.ssh.startAgent = true;

	programs.seahorse.enable = true;

	services.xserver.wacom.enable = true;
	services.gnome.gnome-keyring.enable = true;

	security.polkit.enable = true;

	xdg.portal = {
		enable = true;
		xdgOpenUsePortal = true;

		configPackages = [
			pkgs.xdg-desktop-portal-gtk	
		];
	};

	systemd.user.services.polkit-gnome-authentication-agent-1 = {
		description = "polkit-gnome-authentication-agent-1";
		wantedBy = [ "multi-user.target" ];
		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
			Restart = "on-failure";
			RestartSec = 1;
			TimeoutStopSec = 10;
		};
	};

	environment.variables."QT_QPA_PLATFORMTHEME" = "qt6ct";
}
