{ config, pkgs, lib, ... }: rec {

	home.packages = (with pkgs; [
		nightfox-gtk-theme
		fluent-gtk-theme
		paper-icon-theme

		rose-pine-cursor

		gnome-extension-manager
	]) ++ (with pkgs.gnomeExtensions; [
		user-themes
		blur-my-shell
		desktop-icons-ng-ding
		tray-icons-reloaded
		dash-to-panel
		arcmenu
		transparent-top-bar-adjustable-transparency
		transparent-window-moving
		just-perfection
		alphabetical-app-grid
		forge
		gtk4-desktop-icons-ng-ding
		soft-brightness-plus
	]);

	dconf.settings = {
		# "org/gnome/shell".enabled-extensions = [
		# 	"user-theme@gnome-shell-extensions.gcampax.github.com"
		# 	"blur-my-shell@aunetx"
		# 	"trayIconsReloaded@selfmade.pl"
		# 	"arcmenu@arcmenu.com"
		# 	"just-perfection-desktop@just-perfection"
		# 	"AlphabeticalAppGrid@stuarthayhurst"
		# 	"ding@rastersoft.com"
		# 	"forge@jmmaranan.com"
		# 	"dash-to-panel@jderose9.github.com"
		# 	"drive-menu@gnome-shell-extensions.gcampax.github.com"
		# 	"transparent-top-bar@ftpix.com"
		# 	#"gtk4-ding@smedius.gitlab.com"
		# ];
		
		"org/gnome/desktop/interface" = {
			color-scheme = "prefer-dark";
			cursor-theme = "BreezeX-RosePine-Linux";
			icon-theme = "Paper";
			gtk-theme = "Fluent-Dark-compact";
			"user-theme/name" = "Fluent-Dark-compact";
		};

		"org/gnome/desktop/wm/preferences" = {
			button-layout = "appmenu:minimize,maximize,close";
		};

		"org/gnome/mutter" = {
			edge-tiling = false;
			dynamic-workspaces = true;
			attach-modal-dialogs = true;
			center-new-windows = true;
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
		
		## extensions
		# arcmenu
		"org/gnome/shell/extensions/arcmenu" = {
			arcmenu-hotkey = ["Super_L"];
			runner-hotkey = ["<Super>space"];
			menu-layout = "Redmond";
			position-in-panel = "Left";
			menu-width-adjustment = "0";
			menu-arrow-rise = lib.hm.gvariant.mkTuple [true 4];
			enable-horizontal-flip = true;
			show-external-devices = false;
			search-provider-open-windows = true;
			highlight-search-result-terms = true;
			menu-height = 600;
			force-menu-location = "TopCentered";
			apps-show-extra-details = true;
			search-entry-border-radius = lib.hm.gvariant.mkTuple [ false 25 ];
			power-display-style = "Menu";
			menu-button-appearance = "None";
		};

		# dash to panel
		"org/gnome/shell/extensions/dash-to-panel" = {
			primary-monitor = 0;
			dot-position = "BOTTOM";
			window-preview-title-position = "BOTTOM";
			hotkeys-overlay-combo = "TEMPORARILY";
			appicon-margin = 0;
			appicon-padding = 2;
			panel-positions = "{\"0\":\"BOTTOM\"}";
			panel-sizes = ''{"0":28}'';
			group-apps = false;
			show-favorites = false;
			group-apps-label-font-size = 14;
			group-apps-label-font-weight = "lighter";
			group-apps-label-max-width = 250;
			group-apps-use-fixed-width = false;
			group-apps-underline-unfocused = false;
			window-preview-hide-immediate-click = true;
			window-preview-animation-time = 250;
			window-preview-padding = 4;
			window-preview-show-title = false;
			hide-overview-on-startup = false;
			hot-keys = true;
			stockgs-keep-top-panel = true;
			trans-use-custom-opacity = true;
			trans-use-dynamic-opactiy = false;
			trans-dynamic-distance = 3;
			trans-dynamic-anim-target = 1.0;
			trans-panel-opacity = 1.0;
			isolate-monitors = true;
			panel-element-positions = ''{"0":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'';
		};

		# blur my shell
		"org/gnome/shell/extensions/blur-my-shell" = {
			"appfolder/sigma" = 25;
			"appfolder/brightness" = 0.5;
			"appfolder/style-dialogs" = 3;
			"overview/style-components" = 2;
			"dash-to-dock/blur" = false;
			"panel/blur" = false;
			"lockscreen/blur" = false;
			hacks-level = 1;
			"panel/override-background" = false;
		};

		# forge
		"org/gnome/shell/extensions/forge" = {
			window-gap-hidden-on-single = true;
		};

		# transparent top bar
		"com/ftpix/transparentbar" = {
			transparency = 100;
			dark-full-screen = false;
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
			theme = false;
			switcher-popup-delay = false;
			panel-size = 28;
			dash = false;
			search = false;
			overlay-key = false;
			type-to-search = false;
			workspace-switcher-should-show = true;
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
