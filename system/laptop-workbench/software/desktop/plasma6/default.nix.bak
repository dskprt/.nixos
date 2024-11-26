{ pkgs, inputs, ... }: {
	services.xserver = {
		enable = true;

		excludePackages = [
			pkgs.xterm
		];

		desktopManager.plasma6 = {
			enable = true;
			enableQt5Integration = true;
		};
		
		displayManager.sddm.enable = false;
		displayManager.startx.enable = true;
	};

	environment.plasma6.excludePackages = with pkgs; [
		pkgs.kdePackages.elisa
		kdePackages.okular
	];

	environment.systemPackages = with pkgs; [
		kdePackages.plasma-pa
		kdePackages.plasma-nm
		kdePackages.wacomtablet
		
		kdePackages.kdialog
		
		kdePackages.bluez-qt
		kdePackages.bluedevil

		kdePackages.partitionmanager
		kdePackages.kcalc

		gnome.adwaita-icon-theme

		xdg-desktop-portal
		kdePackages.xdg-desktop-portal-kde

		libsForQt5.qt5.qtbase
		qt6.qtbase
	];

	services.xserver.wacom.enable = true;
	
	xdg.portal.enable = true;
	xdg.portal.xdgOpenUsePortal = true;
}
