{ inputs, lib, config, pkgs, ... }: {
	nixpkgs = {
		config = {
			allowUnfree = true;
			allowUnfreePredicate = (_: true);

			permittedInsecurePackages = [
				"electron-25.9.0"
			];
		};
	};

	home = {
		username = "hades";
		homeDirectory = "/home/default";
	};

	services.easyeffects.enable = true;
	
	programs.home-manager.enable = true;
	
	home.packages = with pkgs; [
		any-nix-shell
		clipboard-jh

		aria2

		vlc

		lutris

		poetry

		fluidsynth
		soundfont-generaluser
		soundfont-fluid

		spotify

		vesktop
	];

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			function fish_prompt
				set_color red; printf "<"

				if test -n "$IN_NIX_SHELL"
						set_color --dim brblue; printf "<nix-shell> "; set_color normal
				end

				set_color white; printf "$USER"; set_color red; printf "@"; set_color white; printf "$hostname"
				set_color brblack; printf (string replace "$HOME" "~" ":$(pwd)")

				set_color cyan; printf (fish_vcs_prompt)

				set_color red; printf "> "; set_color white
			end

			set fish_greeting # Disable greeting
			any-nix-shell fish --info-right | source
		'';
		shellInit = ''
			set -Ux POETRY_VIRTUALENVS_IN_PROJECT 1

			set -x WINEDLLOVERRIDES winemenubuilder.exe=d
			set -x WINEDEBUG -all
		'';
		shellAliases = {
			".." = "cd ..";
			"..." = "cd ../..";
		};
	};

	home.sessionVariables = {
		#"QT_QPA_PLATFORM" = "wayland";
		#"NIXOS_OZONE_WL" = "1";
		"LUTRIS_SKIP_INIT" = "1";
	};

	# Nicely reload system units when changing configs
	systemd.user.startServices = "sd-switch";

	# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	home.stateVersion = "24.05";
}
