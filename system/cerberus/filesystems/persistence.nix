{
	environment.persistence."/@" = {
		directories = [
			"/etc/nixos"
			"/etc/libvirt"
			"/etc/NetworkManager"
			"/var/log"
			"/var/lib/libvirt"
			"/var/lib/containers"
			"/etc/ssh"
			"/lib/firmware"
		];
		files = [
			"/etc/machine-id"
			"/etc/nix/id_rsa"
		];
	};
}
