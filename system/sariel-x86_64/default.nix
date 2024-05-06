{ inputs, lib, config, pkgs, aarch64_pkgs_cross, ... }: {
	imports = [
		../../cachix.nix

		# submodules
		./users
		./boot
		./software
	];

	nixpkgs.config.allowUnfree = true;

	nix = {
		registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
		nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

		gc = {
			automatic = true;
			dates = "daily";
			options = "--delete-older-than 7d";
		};

		settings = {
			experimental-features = "nix-command flakes";
			auto-optimise-store = true;
		};

		optimise.automatic = true;
		channel.enable = false;
	};
 
	powerManagement = {
		enable = true;
		cpuFreqGovernor = "schedutil";
	};

	zramSwap = {
		enable = true;
		memoryPercent = 100;
	};

	## we really don't need these
	documentation.man.enable = false;
	documentation.dev.enable = false;
	documentation.info.enable = false;
	# but these might still be useful
	documentation.doc.enable = true;
	documentation.nixos.enable = true;

	documentation.man.generateCaches = false;

	## enable periodic fstrim
	services.fstrim.enable = true;

	## networking
	networking.networkmanager.enable = true;

	## time
	time.timeZone = "Europe/Warsaw";

	## console
	i18n.defaultLocale = "en_GB.UTF-8";
	i18n.supportedLocales = [
		"en_GB.UTF-8/UTF-8"
	];
	
	console = {
		#font = "Lat2-Terminus16";
		keyMap = "pl";
		earlySetup = true;
	};

	## firewall
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	networking.firewall.enable = true;

	## https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	system.stateVersion = "24.05";
}
