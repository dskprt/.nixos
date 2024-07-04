{ config, pkgs, ... }:
{
	wayland.windowManager.hyprland = {
		enable = true;

		settings = {
			xwayland = {
				force_zero_scaling = true;
			};

			general = {
				gaps_in = 5;
				gaps_out = 10;
				border_size = 2;

				col = {
					active_border = "rgba(ee7f1bff) rgba(005ddfff) 180deg";
					inactive_border = "0xffffffff";
					nogroup_border = "0xffd5dbeb";
					nogroup_border_active = "rgba(ee7f1bff) rgba(005ddfff) 180deg";
				};

				cursor_inactive_timeout = 5;
				resize_on_border = true;
			};

			decoration = {
				rounding = 16;

				active_opacity = 1;
				inactive_opacity = 1;
				fullscreen_opacity = 1;

				dim_inactive = true;
				dim_strength = 0.1;

				blur = {
					enabled = false;
					size = 5;
					passes = 4;
					new_optimizations = true;
					xray = true;
					ignore_opacity = true;
				};

				drop_shadow = true;
				shadow_ignore_window = true;
				shadow_range = 25;
				shadow_render_power = 4;

				col.shadow = "0x99161915";
				col.shadow_inactive = "0x55161925";
			};

			animations = {
				enabled = true;

				bezier = [
					"overshot, 0.13, 0.99, 0.29, 1.1"
					"linear, 0.0, 0.0, 1.0, 1.0"
				];

				animation = [
					"windows, 1, 4, overshot, slide"
					"border, 1, 10, default"
					"fade, 1, 10, default"
					"workspaces, 1, 6, overshot, slide"
					"borderangle, 1, 150, linear, loop"
				];
			};

			dwindle = {
				pseudotile = true;
				force_split = 0;
				preserve_split = true;
			};

			input = {
				touchpad = {
					natural_scroll = true;
					disable_while_typing = true;
				};
			};

			gestures = {
				workspace_swipe = true;
				workspace_swipe_invert = true;
				workspace_swipe_fingers=  true;
			};

			misc = {
				focus_on_activate = true;
			};

			binds.allow_workspace_cycles = true;

			custom = {
				rules = {
					
				};

				binds = {
					bind = [
						"SUPER, T, exec, tilix"
					];
				};
			};
		};
	};

	home.packages = with pkgs; [
		tilix
	];
}
