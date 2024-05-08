{ pkgs, ... }: {
	imports = [
		#./desktop/gnome
	];

	services.tlp.enable = true;
	#services.acpid.enable = true;
	services.tailscale.enable = true;

	services.openssh = {
		enable = true;
		settings = {
			X11Forwarding = true;
			PasswordAuthentication = false;
		};
	};

	programs.fish.enable = true;
	programs.dconf.enable = true;
	programs.nix-ld.enable = true;
	programs.direnv.enable = true;

	programs.nix-index = {
		enable = true;

		enableFishIntegration = true;
		enableBashIntegration = false;
		enableZshIntegration = false;
	};

	powerManagement.powertop.enable = true;

	environment.systemPackages = with pkgs; [
		home-manager
		cachix

		gitFull
		micro
		tmux
		
		(python312.withPackages (pp: [
			pp.setuptools
		]))

		btop
		#acpi

		rsync
		curl
		binutils
		file
		inetutils
		usbutils
		pciutils
		util-linux

		lm_sensors
		i2c-tools
		minicom

		xfsprogs

		ubootTools

		# vivaldi
		# vivaldi-ffmpeg-codecs

		# wineWowPackages.staging
		# winetricks
		# box64
	];

	virtualisation = {
		#waydroid.enable = true;
	};

	environment.variables = {
		EDITOR = "micro";
		GTK_USE_PORTAL = "1";
		GDK_DEBUG = "portals";
	};

	programs.nano.syntaxHighlight = false;
	environment.defaultPackages = [];
}
