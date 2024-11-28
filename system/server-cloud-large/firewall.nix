{ ... }:
{
	networking.firewall = {
		enable = true;
		checkReversePath = true;

		allowedTCPPorts = [
			22 # ssh
			80 # http
			443 # https
			3269 # wisp
		];
	};
}
