{ inputs, pkgs, aarch64_pkgs_cross, ... }:
pkgs.stdenv.mkDerivation rec {
	pname = "u-boot";
	version = "v2023.07.02";

	#src = inputs.uboot;
	src = pkgs.fetchFromGitHub {
          owner = "u-boot";
          repo = "u-boot";
          rev = "${version}";
          sha256 = "sha256-HPBjm/rIkfTCyAKCFvCqoK7oNN9e9rV9l32qLmI/qz4=";
        };

	# u-boot for evb is not enable the sdmmc node, which cause issue as
	# b-boot cannot detect sdcard to boot from
	# the order of boot also need to swap, the eMMC mapped to mm0 (not same as Linux kernel)
	# will then tell u-boot to load images from eMMC first instead of sdcard
	# FIXME: this is strage cuz the order seem correct in Linux kernel
	patches = [ ./patches/legacy/01-sdmmc-enable.patch ];

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
		make ARCH=arm evb-rk3588_defconfig
	'';

	# buildPhase = ''
	# 	patchShebangs tools scripts
	# 	make -j$(nproc) \
	# 		ROCKCHIP_TPL=${pkgs.rkbin}/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.16.bin \
	# 		BL31=${pkgs.rkbin}/bin/rk35/rk3588_bl31_v1.45.elf
	# '';

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
