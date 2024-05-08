{ inputs, pkgs, aarch64_pkgs_cross, ... }:
let
	uboot-version = "v2024.07-rc2";

	uboot-config = pkgs.stdenvNoCC.mkDerivation {
		pname = "u-boot-config";
		version = "${uboot-version}";

		dontBuild = true;
		dontFixup = true;

		src = ./uboot.config;

		buildCommand = ''
			echo copying $src to $out
			
			cp $src $out
		'';
	};
in
pkgs.stdenv.mkDerivation rec {
	pname = "u-boot";
	version = "${uboot-version}";

	src = inputs.uboot;

	patches = [ ./patches/upstream/01-sdmmc-enable.patch ];

	nativeBuildInputs = with pkgs; [
		(python312.withPackages (p: with p; [
			setuptools
			pyelftools
		]))

		swig
		ncurses
		gnumake
		bison
		flex
		openssl
		bc
	] ++ [ aarch64_pkgs_cross.rkbin ];

	configurePhase = ''
		# make HOSTCC=clang CC=clang CROSS_COMPILE=aarch64-unknown-linux-gnu-\
		# 	ARCH=arm evb-rk3588_defconfig
		cp ${uboot-config} .config
	'';

	buildPhase = ''
		patchShebangs tools scripts

		make -j$(nproc) \
			ROCKCHIP_TPL=${aarch64_pkgs_cross.rkbin}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.16.bin \
			BL31=${aarch64_pkgs_cross.rkbin}/bin/rk35/rk3588_bl31_v1.45.elf
	'';

	installPhase = ''
		mkdir $out
		cp u-boot-rockchip.bin $out
	'';
}
