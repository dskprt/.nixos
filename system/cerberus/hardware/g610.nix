{ inputs, pkgs, lib, aarch64_pkgs_cross, ... }:
let
	mali-g610-firmware = pkgs.stdenvNoCC.mkDerivation {
		pname = "mali-g610-firmware";
		version = "unstable";

		dontBuild = true;
		dontFixup = true;
		compressFirmware = false;

		# src = pkgs.fetchurl {
		# 	url = "https://github.com/JeffyCN/mirrors/raw/e08ced3e0235b25a7ba2a3aeefd0e2fcbd434b68/firmware/g610/mali_csffw.bin";
		# 	hash = "sha256-jnyCGlXKHDRcx59hJDYW3SX8NbgfCQlG8wKIbWdxLfU=";
		# };
		src = ./mali_csffw.bin;

		buildCommand = ''
			mkdir -p $out/lib/firmware/arm/mali/arch10.8
			cp $src $out/lib/firmware/arm/mali/arch10.8/mali_csffw.bin
		'';
	};

	# mali-g610-firmware = (pkgs.runCommandNoCC "mali-g610-csffw" {} ''
	# 	mkdir -p $out/lib/firmware/arm/mali/arch10.8
	# 	cp ${./mali_csffw.bin} $out/lib/firmware/arm/mali/arch10.8/mali_csffw.bin
    # '');

	libmali-valhall-g610 = pkgs.stdenv.mkDerivation rec {
		pname = "libmali-valhall-g610";
		version = "unstable";

		libfile = "libmali-valhall-g610-g13p0-x11-wayland-gbm.so";

		dontUnpack = true;
		dontConfigure = true;

		src = pkgs.fetchurl {
			url = "https://github.com/JeffyCN/mirrors/raw/bd6bb095780f880bf8f368ef6770563a313aebb4/lib/aarch64-linux-gnu/${libfile}";
			hash = "sha256-Om/LCtpMlEEMyp9nY09Frd3lIC0U1SIhvQrUUCANLS8=";
		};

		# installPhase = ''
		# 	mkdir $out/lib -p
		# 	cp ${src} $out/lib/libmali.so.1
		# 	ln -s $out/lib/libmali.so.1 $out/lib/libmali-valhall-g610-g6p0-x11-wayland-gbm.so
		# 	for l in libEGL.so libEGL.so.1 libgbm.so.1 libGLESv2.so libGLESv2.so.2 libOpenCL.so.1; do ln -s $out/lib/libmali.so.1 $out/lib/$l; done
		# '';

		nativeBuildInputs = with pkgs; [
			autoPatchelfHook
		];

		buildInputs = with pkgs; [
			stdenv.cc.cc.lib
			libdrm
			wayland
			xorg.libxcb
			xorg.libX11
		];

		preBuild = ''
			addAutoPatchelfSearchPath ${pkgs.stdenv.cc.cc.lib}/aarch64-unknown-linux-gnu/lib
		'';

		installPhase = ''
			runHook preInstall

			mkdir -p $out/lib
			mkdir -p $out/etc/OpenCL/vendors
			mkdir -p $out/share/glvnd/egl_vendor.d

			install --mode=755 ${src} $out/lib

			cp ${src} $out/lib/${libfile}

			echo $out/lib/${libfile} > $out/etc/OpenCL/vendors/mali.icd

cat > $out/share/glvnd/egl_vendor.d/40_mali.json << EOF
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

	# mesa-custom = ((pkgs.mesa.override {
	# 		galliumDrivers = [ "panfrost" "kmsro" "swrast" "zink" ];
	# 		vulkanDrivers = [ "panfrost" "swrast" ];

	# 		enableOpenCL = false;
	# 		withValgrind = false;
	# 		enableTeflon = false;
	# 	}).overrideAttrs (prev: {
	# 		# version = "24.1.0";

	# 		# src = aarch64_pkgs_cross.fetchurl {
	# 		# 	url = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-24.1.0/mesa-mesa-24.1.0.tar.gz";
	# 		# 	hash = "sha256-E5DsderS65QcAWRKF7LKufeHp3+td1Rrp+5zoTnXxlk=";
	# 		# };

	# 		haveDozen = false;

	# 		mesonFlags = prev.mesonFlags ++ [
	# 			(lib.mesonEnable "gallium-vdpau" false)
	# 			(lib.mesonEnable "gallium-va" false)
	# 			(lib.mesonEnable "gallium-xa" false)

	# 			(lib.mesonBool "teflon" false)

	# 			(lib.mesonEnable "glvnd" true)
	# 			(lib.mesonOption "intel-clc" "system")
	# 			(lib.mesonBool "install-intel-clc" true)
	# 			(lib.mesonEnable "intel-rt" false)
	# 			(lib.mesonEnable "zstd" true)

	# 			(lib.mesonOption "tools" "panfrost")
	# 		];
	# 	})).drivers;
in
{
	hardware = {
		enableRedistributableFirmware = true;

		firmware = [
			mali-g610-firmware
		];

		#opengl.package = mesa-updated_cross.mesa.drivers;
		#opengl.package = lib.mkForce mesa-custom;
		#opengl.package32 = lib.mkForce mesa-custom;
		#opengl.package = (aarch64_pkgs_cross.callPackage ../software/mesa.nix { inherit aarch64_pkgs_cross; } );

		opengl.extraPackages = [
			libmali-valhall-g610
			#pkgs.libvdpau-va-gl
		];

		opengl.enable = true;
	};
}
