{ pkgs, ... }: {
	environment.systemPackages = with pkgs; [
		adwaita-qt
		adwaita-qt6	

		gnome.adwaita-icon-theme
	];

	environment.variables = {
		GTK_THEME = "Adwaita:dark";		
	};

	qt.style = "adwaita-dark";
}
