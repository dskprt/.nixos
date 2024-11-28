{ ... }:
{
	#environment.variables.CLOUDFLARE_API_TOKEN = [ (builtins.readFile "/@/cloudflare/api.key") ];

	services.caddy = {
		enable = true;

		virtualHosts = {
			"portainer.black-matter.org".extraConfig = ''
				tls /@/cloudflare/cert.pem /@/cloudflare/key.pem
				reverse_proxy http://10.88.0.1:9000
			'';

			"vault_private.black-matter.org".extraConfig = ''
				tls {
					dns cloudflare {env.CLOUDFLARE_API_TOKEN}
				}
				
				reverse_proxy http://10.89.0.1:10080
			'';
		};
	};
}
