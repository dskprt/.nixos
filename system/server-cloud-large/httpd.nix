{ ... }:
{
	services.httpd = {
		enable = true;
		#enablePerl = true;

		virtualHosts = {
			"portainer.black-matter.org" = {
				listen = [
					{
						ip = "0.0.0.0";
						port = 443;
						ssl = true;
					}
				];

				sslServerCert = "/@/cloudflare/cert.pem";
				sslServerKey = "/@/cloudflare/key.pem";

				extraConfig = ''
					ProxyPreserveHost On
					ProxyPassMatch ^/(.*)$ http://10.88.0.1:9000/$1
					ProxyPassReverse ^/(.*)$ http://10.88.0.1:9000/$1
				'';
			};
			"v86.black-matter.org" = {
				listen = [
					{
						ip = "0.0.0.0";
						port = 443;
						ssl = true;
					}
				];

				sslServerCert = "/@/cloudflare/cert.pem";
				sslServerKey = "/@/cloudflare/key.pem";

				extraConfig = ''
					ProxyPreserveHost On
					ProxyPassMatch ^/(.*)$ http://0.0.0.0:8000/$1
					ProxyPassReverse ^/(.*)$ http://0.0.0.0:8000/$1
				'';
			};
			"vault_private.black-matter.org" = {
				listen = [
					{
						ip = "0.0.0.0";
						port = 443;
						ssl = true;
					}
				];

				sslServerCert = "/@/cloudflare/cert.pem";
				sslServerKey = "/@/cloudflare/key.pem";

				extraConfig = ''
					# <Location />
					# 	Require ip 10.10.0.0/24
					# </Location>
										
					# <Location />
					# 	Order allow,deny
					# 	Deny from all
					# 	Allow from 10.10.0.0/24
					# 	# ProxyPass / http://10.89.0.1:10080/$1
					# 	# ProxyPassReverse / http://10.89.0.1:10080/$1
					# </Location>
				
					ProxyPreserveHost On
					ProxyPassMatch ^/(.*)$ http://10.89.0.1:10080/$1
					ProxyPassReverse ^/(.*)$ http://10.89.0.1:10080/$1
				'';
			};
		};
	};
}
