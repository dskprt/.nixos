{ inputs, pkgs, lib, aarch64_pkgs_cross, ... }:
let
	crossPkgs = inputs.nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;

	mali-g610-firmware = aarch64_pkgs_cross.stdenv.mkDerivation {
		pname = "mali-g610-firmware";
		version = "2023-12-28";

		src = pkgs.fetchurl {
			url = "https://github.com/JeffyCN/mirrors/raw/e08ced3e0235b25a7ba2a3aeefd0e2fcbd434b68/firmware/g610/mali_csffw.bin";
			hash = "sha256-jnyCGlXKHDRcx59hJDYW3SX8NbgfCQlG8wKIbWdxLfU=";
		};

		buildCommand = ''
			install -Dm444 $src $out/lib/firmware/mali_csffw.bin
		'';
	};

	libmali-valhall = aarch64_pkgs_cross.stdenv.mkDerivation {
		pname = "libmali-valhall";
		version = "unstable-16.10.2023";

		src = pkgs.fetchurl {
			url = "https://github.com/JeffyCN/mirrors/raw/bd6bb095780f880bf8f368ef6770563a313aebb4/lib/aarch64-linux-gnu/libmali-valhall-g610-g13p0-x11-wayland-gbm.so";
			hash = "sha256-Om/LCtpMlEEMyp9nY09Frd3lIC0U1SIhvQrUUCANLS8=";
		};

		buildCommand = ''
			mkdir $out/lib -p
			cp $src $out/lib/libmali.so.1
			ln -s libmali.so.1 $out/lib/libmali-valhall-g610-g6p0-x11-wayland-gbm.so
			for l in libEGL.so libEGL.so.1 libgbm.so.1 libGLESv2.so libGLESv2.so.2 libOpenCL.so.1; do ln -s libmali.so.1 $out/lib/$l; done
		'';
	};
in
{
	hardware = {
		enableRedistributableFirmware = true;

		firmware = [
			mali-g610-firmware
		];

		opengl.package =
			((aarch64_pkgs_cross.mesa.override {
				galliumDrivers = [ "panthor" "swrast" ];
				vulkanDrivers = [ "panthor" "swrast" ];
			}).overrideAttrs (prev: {
				pname = "mesa";
				version = "24.0.6";
				src = aarch64_pkgs_cross.fetchurl {
					url = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-24.0.6/mesa-mesa-24.0.6.tar.gz";
					hash = "";
				};
			})).drivers;
			#extraPackages = [ libmali-valhall ];
	};
}
