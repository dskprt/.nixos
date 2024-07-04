{ inputs, lib, config, pkgs, aarch64_pkgs_cross, x86_64_pkgs_cross, ... }: {
	imports = [
		(inputs.impermanence + "/nixos.nix")

		../../cachix.nix
		./audio.nix
		./appimage.nix

		# submodules
		#./filesystems
		./users
		./boot
		./software
		./hardware/g610.nix
		./hardware/ap6275p.nix
	];

	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnsupportedSystem = true;

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
	};

	fonts.fontDir.enable = true;
 
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
	networking.wireless.enable = lib.mkForce false;
	# the kernel(?) presents with a wlan1 device which seems to be the SOC built-in rkwifi
	# chip that always is disconnected and has NO-CARRIER, so disable it
	systemd.network.netdevs.wlan1.enable = false;

	## time
	time.timeZone = "Europe/Warsaw";

	## console
	i18n.defaultLocale = "en_GB.UTF-8";
	i18n.supportedLocales = [
		"en_GB.UTF-8/UTF-8"
		"ja_JP.UTF-8/UTF-8"
		"pl_PL.UTF-8/UTF-8"
		"szl_PL/UTF-8"
	];
	
	console = {
		#font = "Lat2-Terminus16";
		keyMap = "pl";
		earlySetup = true;
	};

	## bluetooth
	hardware.bluetooth.enable = true;

	## firewall
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	networking.firewall.enable = true;

	## https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	system.stateVersion = "24.05";
}
