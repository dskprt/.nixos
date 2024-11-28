{ pkgs, ... }:
{
	services.openssh = {
		enable = true;
		settings = {
			PrintMotd = true;
			PermitRootLogin = "no";
			PasswordAuthentication = false;
			KbdInteractiveAuthentication = false;
		};
	};

	programs.git = {
		enable = true;
		lfs.enable = true;
	};

	programs.nix-index = {
		enable = true;

		enableFishIntegration = false;
		enableBashIntegration = true;
		enableZshIntegration = false;
	};

	programs.command-not-found.enable = false;

	environment.systemPackages = with pkgs; [
		cachix

		micro
		tmux
		
		btop
		acpi

		rsync
		curl
		binutils
		file
		inetutils
		usbutils
		pciutils
		util-linux

		xfsprogs

		podman-compose
		wireguard-tools
		qemu-user
		python312Full
	];

	environment.variables = {
		EDITOR = "micro";
	};

	programs.nano.syntaxHighlight = false;
	environment.defaultPackages = [];
}
