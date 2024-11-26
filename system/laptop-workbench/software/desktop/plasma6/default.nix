{ pkgs, ... }:
{
	services = {
		xserver.enable = true;
		
		displayManager.sddm = {
			enable = false;
			#wayland.enable = true;
		};

		desktopManager.plasma6.enable = true;

		colord.enable = true;
	};

	security.pam.services.greetd.kwallet.enable = true;
	security.pam.services.greetd.kwallet.package = pkgs.kdePackages.kwallet-pam;

	environment.plasma6.excludePackages = with pkgs.kdePackages; [
		elisa
	];

	environment.systemPackages = with pkgs; [
		colord
		kdePackages.colord-kde

		kdePackages.kdesu
		kdePackages.kwalletmanager
		
		kdePackages.wacomtablet
		
		kdePackages.kdialog

		kdePackages.partitionmanager
		kdePackages.kcalc

		fluent-gtk-theme
		paper-icon-theme

		rose-pine-cursor

		xdg-desktop-portal
		kdePackages.xdg-desktop-portal-kde

		libsForQt5.qt5.qtbase
		qt6.qtbase
	];

	services.xserver.wacom.enable = true;
	
	xdg.portal.enable = true;
	xdg.portal.xdgOpenUsePortal = true;
}
