{ config, pkgs, lib, ... }: rec {
	home.packages = (with pkgs; [
		kora-icon-theme
		orchis-theme
	]) ++ (with pkgs.gnomeExtensions; [
		user-themes
		#user-avatar-in-quick-settings
		gsconnect
		blur-my-shell
		desktop-icons-ng-ding
		tray-icons-reloaded
		dash-to-dock
		arcmenu
		tactile
		#transparent-top-bar-adjustable-transparency
		transparent-window-moving
		just-perfection
		#app-grid-tweaks
		#ddterm
		alphabetical-app-grid
		quake-mode
	]);

	dconf.settings = {
		"org/gnome/shell".enabled-extensions = [
			"user-theme@gnome-shell-extensions.gcampax.github.com"
			#"gsconnect@andyholmes.github.io"
			"blur-my-shell@aunetx"
			"trayIconsReloaded@selfmade.pl"
			"dash-to-dock@micxgx.gmail.com"
			"arcmenu@arcmenu.com"
			"tactile@lundal.io"
			"transparent-window-moving@noobsai.github.com"
			"just-perfection-desktop@just-perfection"
			"AlphabeticalAppGrid@stuarthayhurst"
			"ding@rastersoft.com"
			"quake-mode@repsac-by.github.com"
		];
		
		"org/gnome/desktop/interface" = {
			color-scheme = "prefer-dark";
		};

		"org/gnome/desktop/wm/preferences" = {
			button-layout = "appmenu:minimize,maximize,close";
		};

		"org/gnome/mutter" = {
			edge-tiling = true;
			dynamic-workspaces = true;
			attach-modal-dialogs = true;
			center-new-windows = true;
		};

		"org/gnome/shell/app-switcher" = {
			current-workspace-only = true;
		};

		"org/gnome/settings-daemon/plugins/power" = {
			power-button-action = "interactive";
		};

		# file chooser
		"org/gtk/gtk4/settings/file-chooser" = {
			show-hidden = false;
			sidebar-width = 180;
			sort-directories-first = true;
			view-type = "list";
			window-size = lib.hm.gvariant.mkTuple [940 600];
		};

		"org/gtk/settings/file-chooser" = {
			show-hidden = false;
			sidebar-width = 180;
			sort-directories-first = true;
			window-size = lib.hm.gvariant.mkTuple [940 600];
		};

		# nautilus
		"org/gnome/nautilus/preferences" = {
			default-folder-viewer = "list-view";
		};

		# theming
		"org/gnome/desktop/interface" = {
			icon-theme = "kora";
			gtk-theme = "Orchis-Red-Dark";
		};

		"org/gnome/shell/extensions/user-theme" = {
			name = "Orchis-Red-Dark";
		};
		
		## extensions
		# arcmenu
		"org/gnome/shell/extensions/arcmenu" = {
			enable-standalone-runner-menu = true;
			runner-menu-custom-hotkey = "<Alt>F1";
			menu-layout = "Redmond";
			position-in-panel = "Left";
			menu-width-adjustment = "25";
			menu-arrow-rise = lib.hm.gvariant.mkTuple [true 8];
			enable-horizontal-flip = true;
			show-external-devices = true;
			search-provider-open-windows = true;
			highlight-search-result-terms = true;
		};

		# blur my shell
		"org/gnome/shell/extensions/blur-my-shell" = {
			sigma = 25;
			brightness = 0.66;
		};

		"org/gnome/shell/extensions/blur-my-shell/panel" = {
			override-background-dynamically = false;
		};
		
		"org/gnome/shell/extensions/blur-my-shell/appfolder" = {
			style-dialogs = 1;
		};

		"org/gnome/shell/extensions/blur-my-shell/applications" = {
			blur = false;
		};

		# dash to dock
		"org/gnome/shell/extensions/dash-to-dock" = {
			height-fraction = 0.8;
			dash-max-icon-size = 40;
			show-favorites = false;
			show-show-apps-button = false;
			show-mounts = false;
			show-mounts-network = false;
			hide-tooltip = true;
			click-action = "focus-minimize-or-preview";
			scroll-action = "cycle-windows";
			apply-custom-theme = true;
			show-trash = false;
		};

		# just perfection
		"org/gnome/shell/extensions/just-perfection" = {
			window-demands-attention-focus = true;
			startup-status = 0;
			theme = true;
		};

		# quake mode
		#"com/github/repsac-by/quake-mode.quake-mode-always-on-top" = true;
		#"com/github/repsac-by/quake-mode.quake-mode-hide-from-overview" = true;
		#"com/github/repsac-by/quake-mode.quake-mode-focusout" = true;
		#"com/github/repsac-by/quake-mode/apps.app-1" = "org.gnome.Terminal.desktop";
		#"com/github/repsac-by/quake-mode.quake-mode-width" = 60;
		#"com/github/repsac-by/quake-mode.quake-mode-height" = 50;

		# tactile
		"org/gnome/shell/extensions/tactile" = {
			row-2 = 1;
			border-size = 2;
			text-color = "rgb(255,0,0)";
			border-color = "rgba(255,0,0,0.5)";
			background-color = "rgba(0,0,0,0.2)";
		};

		# transparent window moving
		"org/gnome/shell/extensions/transparent-window-moving" = {
			transition-time = 0.3;
		};

		# tray icons reloaded
		"org/gnome/shell/extensions/trayIconsReloaded" = {
			position-weight = 0;
			icons-limit = 8;
			icon-size = 16;
			tray-margin-left = 4;
			tray-margin-right = 4;
			icon-padding-horizontal = 6;
		};
		
	};
}
