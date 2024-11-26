{ ... }:
{
	networking.firewall = {
		enable = true;
		checkReversePath = true;

		allowedTCPPorts = [
			80
			22
		];
	};
}
