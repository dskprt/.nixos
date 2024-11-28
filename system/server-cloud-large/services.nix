{ ... }:
{
	systemd.services = {
		"wisp-server" = {
			enable = true;
			
			wantedBy = [ "multi-user.target" ];
			after = [ "network.target" ];
			description = "Start the WISP server for v86 networking (via epoxy-tls)";
			
			serviceConfig = {
				Type = "simple";
				User = "runner";
				ExecStart = "/@/data/wisp/epoxy-server /@/data/wisp/config.toml";
				ExecStop = "pkill epoxy-server";
				Restart = "on-failure";
			};
		};
	};
}
