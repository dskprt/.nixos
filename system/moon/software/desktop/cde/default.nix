{ pkgs, libs, ... }:
let
	#pkgs = import <nixpkgs> {};

	cde-mkicons = pkgs.writeShellScriptBin "cde-mkicons" ''
		file=`basename ''${1%.*}`

		${pkgs.imagemagick}/bin/convert $1 -resize 48x48 ~/.dt/icons/$file.l.pm
		${pkgs.imagemagick}/bin/convert $1 -resize 32x32 ~/.dt/icons/$file.m.pm
		${pkgs.imagemagick}/bin/convert $1 -resize 24x24 ~/.dt/icons/$file.s.pm
		${pkgs.imagemagick}/bin/convert $1 -resize 16x16 ~/.dt/icons/$file.t.pm
	'';

	cde-battery = pkgs.writeScriptBin "cde-battery" ''
		#!${pkgs.cdesktopenv}/opt/dt/bin/dtksh
		${pkgs.lib.readFile (pkgs.fetchurl {
			url = "https://raw.githubusercontent.com/edorig/dtksh/5f49e402b391c81ebea9609bdec9c7716e70a8c0/battery";
			sha256 = "0zjn9zl1as9xbk2845bbdy2xfj29b4hvvalcz8kf2llkndbfswvl";
		})}
	'';
in {
	services.xserver = {
		enable = true;
		displayManager.defaultSession = "CDE";

		displayManager.lightdm = {
			enable = true;
			greeters.gtk.enable = true;
		};
	
		desktopManager.cde = {
			enable = true;

			extraPackages = with pkgs; [
				cde-mkicons
				cde-battery

				xorg.xclock
				xorg.bitmap
				xorg.xlsfonts
				xorg.xfd
				xorg.xrefresh
				xorg.xload
				xorg.xwininfo
				xorg.xdpyinfo
				xorg.xwd
				xorg.xwud
			];
		};

		layout = "pl";
	};

	services.gnome.gnome-keyring.enable = true;
	programs.seahorse.enable = true;

	environment.systemPackages = with pkgs; [
		alacritty
		cdesktopenv
	];

	xdg.portal = {
		enable = true;
		xdgOpenUsePortal = true;

		extraPortals = [
			pkgs.xdg-desktop-portal-gtk	
		];

		config = {
			common = {
				default = [ "gtk" ];
			};
			cde = {
				default = [ "cde" "gtk" ];
				"org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
			};
		};
	};
}
