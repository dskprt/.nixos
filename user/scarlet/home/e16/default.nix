{ pkgs, config, lib, ... }: {
	imports = [
		#./wired.nix
	];
	
	home.packages = with pkgs; [
		brightnessctl
		pamixer

		kdePackages.kcalc # calculator
		kdePackages.kate # text editor
		krusader # file manager
		krename
		kdePackages.ark # archive manager
		kdePackages.spectacle # screenshot tool
		gthumb # image viewer

		kdePackages.konsole

		rofi
		#rofi-screenshot
		flameshot
		rofi-bluetooth

		gkrellm
		tint2
		wmctrl

		lxappearance

		pantheon.elementary-gtk-theme
		#kanagawa-gtk-theme TODO needs updating nixpkgs
		#kanagawa-icon-theme
		gruvbox-gtk-theme
		paper-icon-theme

		volantes-cursors

		gnome.dconf-editor
		kdePackages.qt6ct

		networkmanagerapplet
	];

	services.wired.enable = true;

	home.file.".e16" = {
		source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/user/scarlet/home/e16/cfg";
		recursive = true;
	};

	home.file.".config/tint2" = {
		source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/user/scarlet/home/e16/tint2";
		recursive = true;
	};

	home.file.".xbindkeysrc".source =
		config.lib.file.mkOutOfStoreSymlink "/etc/nixos/user/scarlet/home/e16/.xbindkeysrc";

	home.file.".xinitrc".text = ''
		#!/bin/sh
		export XDG_SESSION_TYPE=x11
		export XDG_CURRENT_DESKTOP=ENLIGHTENMENT
		
		eval $(gnome-keyring-daemon --start --daemonize)
		export SSH_AUTH_SOCK
		
		(sleep 1 && dbus-update-activation-environment --all) &
		(sleep 2 && dbus-run-session) &
		(sleep 1 && xbindkeys) &
		(sleep 1 && bash $HOME/.e16/batmond.sh) &
		(sleep 1 && gkrellm) &
		(sleep 1 && tint2) &
		(sleep 1 && nm-applet) &
		(systemctl --user start easyeffects) &
		(systemctl --user start polkit-gnome-authentication-agent-1) &
		(sleep 2 && systemctl --user start wired) &
		exec e16
	'';
}
