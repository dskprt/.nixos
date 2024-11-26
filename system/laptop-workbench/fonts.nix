{ pkgs, ... }:
{
	fonts.packages = with pkgs; [
		poppins
		rubik
		texlivePackages.archivo
	];
}
