{ ... }:
{
	services.acme = {
		acceptTerms = true;
		defaults.email = "director@black-matter.org";

		certs."*.private.black-matter.org" = {};
	};
}
