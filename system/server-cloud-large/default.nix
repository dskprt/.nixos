{ inputs, lib, config, pkgs, ... }: {
	# You can import other NixOS modules here
	imports = [
		(inputs.impermanence + "/nixos.nix")

		../../cachix.nix

		# subfiles
		./filesystems
		./users
		./boot
		./software

		./firewall.nix
		./podman.nix
		./httpd.nix
		#./caddy.nix
		./wireguard.nix
		./services.nix
		./acme.nix
		
		# hardware configuration
		./hardware.nix
	];

	nixpkgs = {
		overlays = [];
		config = {
			allowUnfree = true;
		};
	};

	nix = {
		registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
		nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 14d";
		};

		settings = {
			experimental-features = "nix-command flakes";
			auto-optimise-store = true;
		};

		optimise.automatic = true;
	};

	documentation.man.enable = false;
	documentation.dev.enable = false;
	documentation.info.enable = false;
	documentation.doc.enable = false;
	documentation.nixos.enable = false;

	#security.sudo.enable = false;
 
	powerManagement = {
		enable = true;
		cpuFreqGovernor = "schedutil";
	};

	zramSwap = {
		enable = true;
		memoryPercent = 100;
	};

	## enable periodic fstrim
	services.fstrim.enable = true;

	## networking
	systemd.network.enable = true;
	networking.useNetworkd = true;

	## time
	time.timeZone = "Europe/Zurich";
	#time.hardwareClockInLocalTime = true;

	## console
	i18n.defaultLocale = "en_US.UTF-8";
	i18n.supportedLocales = [
		"en_US.UTF-8/UTF-8"
	];

	## https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	system.stateVersion = "25.05";
}
