{
	environment.persistence."/@" = {
		directories = [
			"/etc/nixos"
			"/var/log"
			"/var/lib/containers"
			"/etc/ssh"
			"/var/lib/nixos"
		];
		files = [
			"/etc/machine-id"
			"/etc/nix/id_rsa"
		];
	};
}
