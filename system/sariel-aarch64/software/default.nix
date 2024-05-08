{ pkgs, ... }: {

	services.openssh = {
		enable = true;
		settings = {
			X11Forwarding = true;
			PasswordAuthentication = true;
			PermitRootLogin = "yes";
		};
	};

	environment.systemPackages = with pkgs; [
		git
		micro
		tmux

		btop

		rsync
		curl
		binutils
		inetutils
		usbutils
		pciutils
		util-linux

		xfsprogs
		e2fsprogs
		cryptsetup

		ubootTools
	];

	environment.variables = {
		EDITOR = "micro";
	};

	programs.nano.syntaxHighlight = false;
	environment.defaultPackages = [];
}
