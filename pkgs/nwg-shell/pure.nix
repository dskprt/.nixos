{ config, pkgs, ... }:
let
	nwg-shell-git = builtins.fetchGit {
		url = "https://github.com/nwg-piotr/nwg-shell";
		ref = "main";
		rev = "36ee7870e4a716c7ee715e41fe5fa3c8d41d132c";
		shallow = true;
	};

	nwg-shell-config-git = builtins.fetchGit {
		url = "https://github.com/nwg-piotr/nwg-shell-config";
		ref = "master";
		rev = "acf76d564e0e7e116520dbf6a301676b1c61dff6";
		shallow = true;
	};

	nwg-azote-git = builtins.fetchGit {
		url = "https://github.com/nwg-piotr/azote";
		ref = "master";
		rev = "4952f35141eddf5c64693b2faf25a76a485372bb";
		shallow = true;
	};
in
{
	home.packages = with pkgs; [
		xdg-desktop-portal
		xdg-desktop-portal-hyprland

		#waybar-hyprland
		#kitty

		# nwg-shell
		(python311.withPackages (p: with p; [
			setuptools
			wheel
			geopy
			dasbus
			pygobject3
			i3ipc

			(
				buildPythonPackage rec {
					pname = "nwg-shell";
					version = "main";
					src = nwg-shell-git;
					doCheck = false;
				}
			)

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

	home.file."${config.xdg.configHome}" = {
		source = "${nwg-shell-git}/nwg_shell/skel/config";
		recursive = true;
	};

	#home.file."${config.xdg.dataHome}/nwg-look" = {
	#	source = "${nwg-shell-git}/nwg_shell/skel/data/nwg-look";
	#	recursive = true;
	#};

	# we don't want any updates whatsoever
	# but still want utilities like nwg-shell-config to work
	home.file."${config.xdg.dataHome}/nwg-shell/data" = {
		source = ./nwg-shell-data;
	};

	wayland.windowManager.hyprland.enable = true;
	#wayland.windowManager.hyprland.extraConfig = ''
	#	source = ./hypr.conf
	#'';
}
