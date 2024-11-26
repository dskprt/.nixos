{
	description = "nixos configuration";

	inputs = {
		# Nixpkgs
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		# Home manager
		home-manager.url = "github:nix-community/home-manager/master";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		# Impermanence
		impermanence.url = "github:nix-community/impermanence";

		# Hyprland
		#hyprland.url = "github:hyprwm/Hyprland";

		# Visual Studio Code extensions
		nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

		# wired-notify notification daemon
		#wired.url = "github:Toqozz/wired-notify";

		# Stylix
		#stylix.url = "github:danth/stylix";

		nix-index-database.url = "github:nix-community/nix-index-database";
		nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

		# Nix User Repository
		nur.url = "github:nix-community/NUR";

		# nix-alien
		nix-alien.url = "github:thiagokokada/nix-alien";

		# cerberus-specific stuff
		#linux-rockchip = { url = "github:armbian/linux-rockchip/rk-6.1-rkr1"; flake = false; };
		#kbin = { url = "github:armbian/rkbin"; flake = false; };
		#uboot = { url = "github:u-boot/u-boot/v2024.07-rc2"; flake = false; };
		#armbian-firmware = { url = "github:armbian/firmware"; flake = false; };
		#mesa-updated = { url = "github:K900/nixpkgs/mesa-24.1"; };
	};

	outputs = {
		nixpkgs,
		nur,
		#mesa-updated,
		home-manager,
		impermanence,
		#wired,
		#linux-rockchip,
		#rkbin,
		#uboot,
		#armbian-firmware,
		nix-index-database,
		nix-alien,
		...
	}@inputs: let
		x86_64_pkgs_native = import nixpkgs {
			system = "x86_64-linux";
			config = { allowUnsupportedSystem = true; };
		};

		x86_64_pkgs_cross = import nixpkgs {
			localSystem = "x86_64-linux";
			crossSystem = "x86_64-linux";
			config = { allowUnsupportedSystem = true; };
		};

		aarch64_pkgs_cross = import nixpkgs {
			localSystem = "x86_64-linux";
			crossSystem = "aarch64-linux";
			config = { allowUnfree = true; };
		};

		# mesa-updated_cross = import mesa-updated {
		# 	localSystem = "x86_64-linux";
		# 	crossSystem = "aarch64-linux";
		# };

		# pkgs = import nixpkgs {
		# 	config = { allowUnfree = true; };
		# };
	in {
		nixosConfigurations = {
			"lappy" = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [
					({ inputs, pkgs, ... }: {
						# nixpkgs.overlays = [ inputs.nix-alien.overlays.default ];
						# environment.systemPackages = with pkgs; [ nix-alien ];
						# programs.nix-ld.enable = true;

						environment.systemPackages = with inputs.nix-alien.packages."x86_64-linux"; [
							nix-alien
						];

						programs.nix-ld.enable = true;
					})
				
					nur.nixosModules.nur
					./system/laptop-workbench
					nix-index-database.nixosModules.nix-index

					{
						boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
						networking.hostName = "lappy";
					}
				];
			};
			"server-cloud-large" = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				specialArgs = { inherit inputs; };
				modules = [
					nur.nixosModules.nur
					./system/server-large

					{
						networking.hostName = "gangut";
					}
				];
			};
# 			"cerberus" = nixpkgs.lib.nixosSystem {
# 				system = "aarch64-linux";
# 				specialArgs = { inherit inputs aarch64_pkgs_cross x86_64_pkgs_cross; };
# 				modules = [
# 					./system/sdimage.nix
# 					./system/cerberus
# 					#./system/cerberus/filesystem
# 					./system/cerberus/boot/kernel/build.nix
# 
# 					{
# 						#nixpkgs.crossSystem.system = "aarch64-linux";
# 						#nixpkgs.localSystem.system = "x86_64-linux";
# 
# 						nixpkgs.overlays = [
# 							(final: super: {
# 								makeModulesClosure = x:
# 								super.makeModulesClosure (x // { allowMissing = true; });
# 							})
# 						];
# 
# 						networking.hostName = "cerberus";
# 					}
# 				];
# 			};
# 			"sariel-aarch64" = nixpkgs.lib.nixosSystem {
# 				system = "aarch64-linux";
# 				specialArgs = { inherit inputs; inherit aarch64_pkgs_cross; };
# 				modules = [
# 					./system/sdimage.nix
# 					./system/sariel-aarch64
# 
# 					{
# 						# necessary for firmware
# 						nixpkgs.config.allowUnfree = true;
# 
# 						nixpkgs.overlays = [
# 							(final: super: {
# 								makeModulesClosure = x:
# 								super.makeModulesClosure (x // { allowMissing = true; });
# 							})
# 						];
# 
# 						networking.hostName = "sariel";
# 					}
# 				];
# 			};
			# "sariel-x86_64" = nixpkgs.lib.nixosSystem {
			# 	specialArgs = { inherit inputs; };
			# 	modules = [
			# 		./system/sariel-x86_64

			# 		{
			# 			networking.hostName = "sariel";
			# 		}
			# 	];
			# };
		};

		homeConfigurations = {
			"master@lappy" = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs {
					system = "x86_64-linux";
					# overlays =
					# 	import ./pkgs/default.nix
					# 	++ [
					# 		wired.overlays.default
					# 	];
				};
				
				extraSpecialArgs = { inherit inputs; };
				
				modules = [
					#wired.homeManagerModules.default
					#stylix.homeManagerModules.stylix
					./user/master/home
				];
			};

			#"crimson@moon" = home-manager.lib.homeManagerConfiguration {
			#	pkgs = nixpkgs.legacyPackages.x86_64-linux;
			#	extraSpecialArgs = { inherit inputs; };
			#	modules = [ ./user/crimson/home ];
			#};

			# "white" = home-manager.lib.homeManagerConfiguration {
			# 	pkgs = nixpkgs.legacyPackages.x86_64-linux;
			# 	extraSpecialArgs = { inherit inputs; };
			# 	modules = [ ./user/white/home ];
			# };

			#"hades@cerberus" = home-manager.lib.homeManagerConfiguration {
			#	pkgs = import nixpkgs {
			#		system = "aarch64-linux";
			#	};
#
#				extraSpecialArgs = { inherit inputs; };
#
#				modules = [
#					./user/hades/home
#				];
#			};
		};

		devShells.x86_64-linux.kernelEnv = (x86_64_pkgs_native.buildFHSUserEnv.override { stdenv = x86_64_pkgs_native.llvmPackages_18.stdenv; } {
			name = "kernel-build-env";

			targetPkgs = pkgs: (with pkgs; [
				# we need theses packages to make `make menuconfig` work.
				pkg-config
				ncurses
				# arm64 cross-compilation toolchain
				aarch64_pkgs_cross.gccStdenv.cc
				# native gcc
				gcc
				llvmPackages_18.clang
			] ++ pkgs.linux.nativeBuildInputs);

			runScript = x86_64_pkgs_native.writeScript "init.sh" ''
				# set the cross-compilation environment variables.
				export CROSS_COMPILE=aarch64-unknown-linux-gnu-
				export ARCH=arm64
				export PKG_CONFIG_PATH="${x86_64_pkgs_native.ncurses.dev}/lib/pkgconfig:"
				exec fish
			'';
		}).env;
	};
}
