{ inputs, lib, config, pkgs, ... }: {
	# You can import other NixOS modules here
	imports = [
		(inputs.impermanence + "/nixos.nix")

		./num-on-boot.nix
		../../cachix.nix

		./audio.nix

		# subfiles
		./filesystems
		./users
		./boot
		./software
		#./vr
		./gpu/amd.nix
		./appimage.nix
		# ./gpu/nvidia.nix

		# custom systemd services
		# ./services/00-amdctl-undervolt.nix

		# auto upgrade config
		#./auto-upgrade.nix

		./fonts.nix

		# hardware config
		./hardware.nix
	];

	nixpkgs = {
		# You can add overlays here
		overlays = [
			# If you want to use overlays exported from other flakes:
			# neovim-nightly-overlay.overlays.default

			# Or define it inline, for example:
			# (final: prev: {
			#   hi = final.hello.overrideAttrs (oldAttrs: {
			#     patches = [ ./change-hello-to-hi.patch ];
			#   });
			# })
		];
		# Configure your nixpkgs instance
		config = {
			# Disable if you don't want unfree packages
			allowUnfree = true;
		};
	};

	nix = {
		# This will add each flake input as a registry
		# To make nix3 commands consistent with your flake
		registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

		# This will additionally add your inputs to the system's legacy channels
		# Making legacy nix commands consistent as well, awesome!
		nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 14d";
		};

		settings = {
			# Enable flakes and new 'nix' command
			experimental-features = "nix-command flakes";
			# Deduplicate and optimize nix store
			auto-optimise-store = true;
		};

		optimise.automatic = true;
	};

	documentation.man.enable = false;
	documentation.dev.enable = false;
	documentation.info.enable = false;
	documentation.doc.enable = false;
	documentation.nixos.enable = true;

	security.sudo.enable = true;
	#security.sudo-rs.enable = true;

	security.sudo.extraConfig = ''
		Defaults passwd_timeout=0
		Defaults passprompt="* password for %p: "
		Defaults timestamp_timeout=0
		Defaults insults
		Defaults lecture = never
		#Defaults passwd_timeout=0,passprompt="^G* password for %p: ",timestamp_timeout=0,insults,lecture=never
	'';

	fonts.fontDir.enable = true;
 
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
	networking.networkmanager.enable = true;
	networking.networkmanager.plugins = with pkgs; [
		networkmanager_strongswan
		networkmanager-openvpn
		networkmanager-l2tp
	];

	## time
	time.timeZone = "Europe/Warsaw";
	#time.hardwareClockInLocalTime = true;

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
		packages = with pkgs; [ terminus_font ];
		font = "${pkgs.terminus_font}/share/consolefonts/ter-u14n.psf.gz";
	};

	## bluetooth
	hardware.bluetooth.enable = true;

	## firewall
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	networking.firewall.enable = true;
	networking.firewall.checkReversePath = false;

	## https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	system.stateVersion = "23.11";
}
