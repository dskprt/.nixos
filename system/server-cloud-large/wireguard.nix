{ config, pkgs, lib, ... }:
{
	boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

	networking.firewall.allowedUDPPorts = [
		51820
	];
  
  systemd.network = {
    enable = true;
    netdevs = {
      "wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/@/wireguard/private.key";
          ListenPort = 51820;
          RouteTable = "main"; # wg-quick creates routing entries automatically but we must use use this option in systemd.
        };
        wireguardPeers = [
          # configuration since nixos-unstable/nixos-24.11
          #{
          #  PublicKey = "L4msD0mEG2ctKDtaMJW2y3cs1fT2LBRVV7iVlWZ2nZc=";
          #  AllowedIPs = ["10.10.0.2"];
          #}
          # configuration for nixos 24.05
          #{
          #  wireguardPeerConfig = {
          #    PublicKey = "L4msD0mEG2ctKDtaMJW2y3cs1fT2LBRVV7iVlWZ2nZc=";
          #    AllowedIPs = ["10.10.0.2"];
          #  };
          #}
          {
          	PublicKey = "g8uNahrRAq8yC+PLpJQht995S2ngh11Nuo+wllCqows=";
          	#AllowedIPs = [ "0.0.0.0/0" "::0/0" ];
          	AllowedIPs = [ "10.10.0.2/24" ];
          }
        ];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = ["10.10.0.1/24"];
      networkConfig = {
        IPMasquerade = "ipv4";
        #IPForward = true;
      };
    };
  };
}
