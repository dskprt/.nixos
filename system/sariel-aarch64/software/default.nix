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
		home-manager
		cachix

		gitFull
		micro
		tmux

		btop

		rsync
		curl

		xfsprogs
	];

	environment.variables = {
		EDITOR = "micro";
	};

	programs.nano.syntaxHighlight = false;
	environment.defaultPackages = [];
}
