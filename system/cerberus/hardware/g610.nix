{ inputs, pkgs, lib, aarch64_pkgs_cross, ... }:
let
	mali-g610-firmware = pkgs.stdenvNoCC.mkDerivation {
		pname = "mali-g610-firmware";
		version = "unstable";

		dontBuild = true;
		dontFixup = true;
		compressFirmware = false;

		src = pkgs.fetchurl {
			url = "https://github.com/JeffyCN/mirrors/raw/e08ced3e0235b25a7ba2a3aeefd0e2fcbd434b68/firmware/g610/mali_csffw.bin";
			hash = "sha256-jnyCGlXKHDRcx59hJDYW3SX8NbgfCQlG8wKIbWdxLfU=";
		};

		buildCommand = ''
			install -Dm444 $src $out/lib/firmware/mali_csffw.bin
		'';
	};

	libmali-valhall-g610 = pkgs.stdenv.mkDerivation rec {
		pname = "libmali-valhall-g610";
		version = "unstable";

		libfile = "libmali-valhall-g610-g13p0-x11-wayland-gbm.so";

		dontConfigure = true;

		src = pkgs.fetchurl {
			url = "https://github.com/JeffyCN/mirrors/raw/bd6bb095780f880bf8f368ef6770563a313aebb4/lib/aarch64-linux-gnu/${libfile}";
			hash = "sha256-Om/LCtpMlEEMyp9nY09Frd3lIC0U1SIhvQrUUCANLS8=";
		};

		nativeBuildInputs = with pkgs; [
			autoPatchelfHook
		];

		buildInputs = with pkgs; [
			stdenv.cc.cc.lib
			libdrm
			wayland
			libxcb
			libX11
		];

		preBuild = ''
			addAutoPatchelfSearchPath ${pkgs.stdenv.cc.cc.lib}/aarch64-unknown-linux-gnu/lib
		'';

		installPhase = ''
			runHook preInstall

			mkdir -p $out/lib
			mkdir -p $out/etc/OpenCL/vendors
			mkdir -p $out/share/glvnd/egl_vendor.d

			install --mode=755 lib/aarch64-linux-gnu/${libfile} $out/lib

			echo $out/lib/${libfile} > $out/etc/OpenCL/vendors/mali.icd

			cat > $out/share/glvnd/egl_vendor.d/60_mali.json << EOF
			{
				"file_format_version" : "1.0.0",
				"ICD" : {
					"library_path" : "$out/lib/${libfile}"
				}
			}
			EOF

			runHook postInstall
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
				version = "24.1.0-rc2";
				src = aarch64_pkgs_cross.fetchurl {
					url = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-24.0.6/mesa-mesa-24.1.0-rc2.tar.gz";
					hash = "";
				};
			})).drivers;
			extraPackages = [ libmali-valhall-g610 ];
	};
}
