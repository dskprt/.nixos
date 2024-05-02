{ config, pkgs, ... }:
let
	nwg-shell-git = builtins.fetchGit {
		url = "https://github.com/nwg-piotr/nwg-shell";
		ref = "main";
		rev = "22e77a5ddfd66215a98d926734f1e55bb6a7a5cf";
		shallow = true;
	};

	nwg-shell-config-git = builtins.fetchGit {
		url = "https://github.com/nwg-piotr/nwg-shell-config";
		ref = "master";
		rev = "cb8feb9711afcd60684a5bb596b1dbfbceb8f723";
		shallow = true;
	};

	nwg-azote-git = builtins.fetchGit {
		url = "https://github.com/nwg-piotr/azote";
		ref = "master";
		rev = "6020968d363c9f71c1c5adbb0bded90b1d12a2a0";
		shallow = true;
	};
in
{
	home.packages = with pkgs; [
		xdg-desktop-portal
		xdg-desktop-portal-hyprland

		#waybar-hyprland
		kitty
		cinnamon.nemo-with-extensions
		
		# nwg-shell
		(python311.withPackages (p: with p; [
			setuptools
			wheel
			geopy
			dasbus
			pygobject3
			i3ipc

			#(
			#	buildPythonPackage rec {
			#		pname = "nwg-shell";
			#		version = "main";
			#		src = nwg-shell-git;
			#		doCheck = false;
			#	}
			#)

			(
				buildPythonPackage rec {
					pname = "nwg-shell-config";
					version = "master";
					src = nwg-shell-config-git;
					doCheck = false;
				}
			)

			(
				buildPythonPackage rec {
					pname = "azote";
					version = "master";
					src = nwg-azote-git;
					doCheck = false;
				}
			)
		]))
		
		grim
		slurp
		swayidle
		swaylock
		swappy
		wl-clipboard
		jq
		lxappearance
		foot
		wlsunset
		wdisplays
		swaynotificationcenter
		autotiling
		gopsuinfo

		nwg-panel
		nwg-wrapper
		nwg-bar
		nwg-dock
		nwg-drawer
		nwg-menu
	];

	#home.file."${config.xdg.configHome}" = {
	#	source = "${nwg-shell-git}/nwg_shell/skel/config";
	#	recursive = true;
	#};

	#home.file."${config.xdg.dataHome}/nwg-look" = {
	#	source = "${nwg-shell-git}/nwg_shell/skel/data/nwg-look";
	#	recursive = true;
	#};

	# we don't want any updates whatsoever
	# but still want utilities like nwg-shell-config to work
	#home.file."${config.xdg.dataHome}/nwg-shell/data" = {
	#	source = ./nwg-shell-data;
	#};

	wayland.windowManager.hyprland = {
		enable = true;
		systemd.enable = true;
	};
}
