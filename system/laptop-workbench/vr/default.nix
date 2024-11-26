{ pkgs, lib, ... }:
let
# 	alvr-git = pkgs.stdenv.mkDerivation rec {
# 		pname = "alvr";
# 		version = "20.9.1";
# 
# 		src = pkgs.fetchurl {
# 			url = "https://github.com/alvr-org/ALVR/archive/refs/tags/v${version}.tar.gz";
# 			hash = "sha256-p248nNiaOlZeapx0fcdrsVG+mUwKS4JbsajfBj9mpDg=";
# 		};
# 
# 		# nativeBuildInputs = with pkgs.buildPackages; [
# 		# 	rustc
# 		# 	cargo
# 		# ];
# 
# 		buildInputs = with pkgs.buildPackages; [
# 			clang
# 			curl
# 			nasm
# 			pkg-config
# 			yasm
# 			vulkan-headers
# 			libva
# 			libdrm
# 			unzip
# 			ffmpeg-full
# 			pipewire
# 		];
# 
# 		configurePhase = ''
# 			cargo xtask prepare-deps --platform linux --no-nvidia
# 		'';
# 
# 		buildPhase = ''
# 			cargo xtask build-streamer --release
# 		'';
# 
# 		installPhase = ''
# 			mkdir -p $out/bin
# 			cp $src/build/alvr_streamer_linux $out/bin/alvr_streamer
# 		'';
# 	};

	alvr-git = pkgs.callPackage ./alvr.nix { };
in
{
	programs.alvr = {
		enable = true;
		openFirewall = true;

		package = alvr-git;
	};

	services.monado = {
		enable = true;
		defaultRuntime = false; # Register as default OpenXR runtime
	};

	systemd.user.services.monado.environment = {
		STEAMVR_LH_ENABLE = "1";
		XRT_COMPOSITOR_COMPUTE = "1";
		WMR_HANDTRACKING = "0";
	};
}
