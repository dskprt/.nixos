{ lib, ... }:
{
	virtualisation = {
		containers = {
			enable = true;
			
			storage.settings.storage = {
				graphroot = "/@/data/oci/containers/storage";
			};
		};

		podman = {
			enable = true;
			dockerCompat = true;
			dockerSocket.enable = true;

			defaultNetwork.settings.dns_enabled = true;
		};

		oci-containers.containers = {
			"portainer-ce" = {
				image = "portainer/portainer-ce:2.24.0-alpine";
				autoStart = true;
				ports = [
					"0.0.0.0:8000:8000"
					"0.0.0.0:9000:9000"
					"0.0.0.0:9443:9443"
				];
				volumes = [
					"/run/podman/podman.sock:/var/run/docker.sock"
					"portainer:/data"
				];
				extraOptions = [ "--privileged" ];
			};
		};
	};
}
