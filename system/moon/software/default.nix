{ pkgs, ... }: {
	imports = [
		#./desktop/enlightenment
		#./desktop/greetd.nix
		./desktop/gnome
	];

	#services.tlp.enable = true;
	services.acpid.enable = true;
	services.tailscale.enable = true;
	services.asusd.enable = true;
	services.printing.enable = true;

	services.openssh = {
		enable = true;
		settings.X11Forwarding = false;
	};

	services.supergfxd = {
		enable = false;
	#	settings = {
	#		mode = "Hybrid";
	#		vfio_enable = true;
	#		vfio_save = false;
	#		always_reboot = false;
	#		no_logind = true;
	#		logout_timeout_s = 60;
	#		hotplug_type = "None";
	#	};
	};

	#powerManagement.powertop.enable = true;

	programs.steam.enable = true;
	programs.fish.enable = true;
	programs.dconf.enable = true;
	programs.adb.enable = true;
	programs.nix-ld.enable = true;
	#programs.kdeconnect.enable = true;
	programs.direnv.enable = true;
	programs.virt-manager.enable = true;

	programs.corectrl = {
		enable = true;
		gpuOverclock.enable = true;
	};

	programs.nix-index = {
		enable = true;

		enableFishIntegration = true;
		enableBashIntegration = false;
		enableZshIntegration = false;
	};

	environment.systemPackages = with pkgs; [
		home-manager
		cachix

		gitFull
		micro
		tmux
		
		(python312.withPackages (pp: [
			pp.setuptools
		]))

		nvtopPackages.amd
		htop
		acpi

		rsync
		curl
		binutils
		file
		inetutils
		usbutils
		pciutils
		util-linux

		nvme-cli
		amdctl
		asusctl

		xfsprogs

		qemu

		wineWowPackages.staging
		winetricks
		protontricks

		vivaldi
		vivaldi-ffmpeg-codecs

		#distrobox
		virtiofsd
	];

	nixpkgs.overlays = [
		(final: prev: {
			steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
				extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
					openssl
				]) ++ ([(pkgs.runCommand "share-fonts" { preferLocalBuild = true; } ''
					mkdir -p "$out/share/fonts"
					font_regexp='.*\.\(ttf\|ttc\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
					find ${toString (import ./fonts.nix { inherit pkgs; })} -regex "$font_regexp" \
						-exec ln -sf -t "$out/share/fonts" '{}' \;
				'')]);
			});
		})
	];

	# virtualisation.sharedDirectories = {
	# 	default-share = {
	# 		source = "/@/data/virtual machines/shared";
	# 		target = "vm_shared";
	# 	};
	# };

	virtualisation = {
		#waydroid.enable = true;
		#lxd.enable = true;

		spiceUSBRedirection.enable = true;

		libvirtd = {
			enable = true;

			qemu.verbatimConfig = ''
				cgroup_device_acl = [
					"/dev/kvmfr0", "/dev/kvm",
					"/dev/null", "/dev/zero", "/dev/random", "/dev/urandom",
					"/dev/ptmx", "/dev/pts/ptmx", "/dev/pts/0"
				]
			'';
		};
		
		podman = {
			enable = true;
			dockerCompat = true;
		};
	};

	environment.variables = {
		EDITOR = "micro";
		GTK_USE_PORTAL = "1";
		GDK_DEBUG = "portals";
	};

	programs.nano.syntaxHighlight = false;
	environment.defaultPackages = [];
}
