{ inputs, lib, config, pkgs, ... }:
let
	community-vscode-extensions = inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace;
in
{
	# You can import other home-manager modules here
	imports = [
		# If you want to use home-manager modules from other flakes (such as nix-colors):
		# inputs.nix-colors.homeManagerModule
		#./gnome.nix
		#./cde
		#./hyprland
		#./stylix.nix
		#./e16
		#./gnome
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
			# Workaround for https://github.com/nix-community/home-manager/issues/2942
			allowUnfreePredicate = (_: true);
			# github-desktop needs openssl-1.1.1 :(
			permittedInsecurePackages = [
				"openssl-1.1.1u"
				"electron-25.9.0"
			];
			packageOverrides = super: {
				mplayer = super.mplayer.override {
					v4lSupport = true;
				};
			};
		};
	};

	home = {
		username = "scarlet";
		homeDirectory = "/home/default";
	};

	services.easyeffects.enable = true;
	
	programs.home-manager.enable = true;
	
	home.packages = with pkgs; [
		any-nix-shell
		clipboard-jh

		#sshfs
		#partition-manager
		aria2

		#mplayer
		#discord
		strawberry-qt6
		vlc
		#krita
		obsidian

		lutris
		#legendary-gl
		prismlauncher
		#clonehero
		ferium
		#ckan

		#kompare
		krita
		#okteta

		#graalvm-ce
		temurin-bin
		#temurin-bin-17
		#jetbrains.idea-community
		jetbrains-toolbox

		#kdevelop

		poetry
		#pipenv

		fluidsynth
		soundfont-generaluser
		soundfont-fluid

		spotify
		nicotine-plus

		#oneko
		vesktop
		#kdePackages.konversation
		#prusa-slicer

		# needed for tmodloader
		dotnet-runtime_8

		# IDEs
		#jetbrains.clion

		(vscode-with-extensions.override {
			vscodeExtensions = with vscode-extensions; [
				tamasfe.even-better-toml
				
				ms-python.python
	
				ms-vscode.cpptools
				ms-vscode.cmake-tools
				
				editorconfig.editorconfig
			] ++ (with community-vscode-extensions; [
				ms-vscode.cpptools-themes
				webfreak.debug
				rioj7.vscode-file-templates
				mesonbuild.mesonbuild
				leonardssh.vscord

				platformio.platformio-ide

				bbenoist.nix

				(ms-dotnettools.csharp.overrideAttrs (_: { sourceRoot = "extension"; }))
				(ms-dotnettools.vscodeintellicode-csharp.overrideAttrs (_: { sourceRoot = "extension"; }))
				(ms-dotnettools.dotnet-maui.overrideAttrs (_: { sourceRoot = "extension"; }))
				ms-dotnettools.csdevkit
				ms-dotnettools.vscode-dotnet-runtime
			]) ++ [
				community-vscode-extensions."13xforever".language-x86-64-assembly
			];
		})
	];

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			function fish_prompt
				set_color brblue; printf "<"

				if test -n "$IN_NIX_SHELL"
						set_color --dim brblue; printf "<nix-shell> "; set_color normal
				end

				set_color white; printf "$USER"; set_color magenta; printf "@"; set_color white; printf "$hostname"
				set_color brblack; printf (string replace "$HOME" "~" ":$(pwd)")

				set_color cyan; printf (fish_vcs_prompt)

				set_color brblue; printf "> "; set_color white
			end

			set fish_greeting # Disable greeting
			any-nix-shell fish --info-right | source
		'';
		shellInit = ''
			set -Ux PIPENV_VENV_IN_PROJECT 1
			set -Ux POETRY_VIRTUALENVS_IN_PROJECT 1

			set -Ux PIPENV_TIMEOUT 999999999
			
			set -x HSA_OVERRIDE_GFX_VERSION 11.0.2
			set -x PYTORCH_HIP_ALLOC_CONF garbage_collection_threshold:0.95,max_split_size_mb:128

			set -x WINEDLLOVERRIDES winemenubuilder.exe=d
			set -x WINEDEBUG -all

			set -x EM_CACHE ~/.cache/emscripten

			function runbg
				$argv &> /dev/null &
			end
		'';
		shellAliases = {
			".." = "cd ..";
			"..." = "cd ../..";
		};
	};

	programs.mangohud = {
		enable = true;
		settings = {
			fps_limit = 165;
			#vsync = 0;
			#gl_vsync = 1;

			#preset = 3;

			gpu_stats = true;
			gpu_temp = true;
			#gpu_junction_temp = true;
			gpu_power = true;
			gpu_load_change = true;
			#gpu_fan = true;
			gpu_core_clock = true;

			cpu_stats = true;
			cpu_temp = true;
			cpu_power = true;
			cpu_load_change = true;
			cpu_mhz = true;
			
			#core_load = true;
			#core_load_change = true;

			io_read = true;
			io_write = true;

			vram = true;
			ram = true;

			fps = true;
			frametime = true;

			battery = true;
			#battery_icon = true;

			#font_size = 20;
			round_corners = 8;
			no_display = true;

			gpu_name = true;
			exec_name = true;
		};
	};

	dconf.settings = {
		"org/virt-manager/virt-manager/connections" = {
			autoconnect = ["qemu:///system"];
			uris = ["qemu:///system"];
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
	home.stateVersion = "23.11";
}
