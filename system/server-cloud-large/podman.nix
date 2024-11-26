{ ... }:
{
	virtualisation.containers.enable = true;
	virtualisation = {
		containers.enable = true;

		podman = {
			enable = true;
			dockerCompat = true;

			defaultNetwork.settings.dns_enabled = true;
		};

		# oci-containers.containers = {
		# 	"portainer-ce" = {
		# 		image = "portainer/portainer-ce:2.24.0-alpine";
		# 		autoStart = true;
		# 		ports = [
		# 			"0.0.0.0:8000:8000"
		# 			"0.0.0.0:9443:9443"
		# 		];
		# 		volumes = [
		# 			"/var/run/docker.sock:/var/run/docker.sock"
		# 			"portainer:/data"
		# 		];
		# 	};
		# };
	};
}
