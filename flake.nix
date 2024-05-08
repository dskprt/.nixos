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
		wired.url = "github:Toqozz/wired-notify";

		# Stylix
		#stylix.url = "github:danth/stylix";

		# Disko
		disko.url = "github:nix-community/disko";
		disko.inputs.nixpkgs.follows = "nixpkgs";

		# cerberus-specific stuff
		linux-rockchip = { url = "github:armbian/linux-rockchip/rk-6.1-rkr1"; flake = false; };
		rkbin = { url = "github:armbian/rkbin"; flake = false; };
		uboot = { url = "github:u-boot/u-boot/v2024.07-rc2"; flake = false; };
		armbian-firmware = { url = "github:armbian/firmware"; flake = false; };
	};

	outputs = {
		nixpkgs,
		home-manager,
		impermanence,
		wired,
		linux-rockchip,
		rkbin,
		uboot,
		armbian-firmware,
		...
	}@inputs: let
		x86_64_pkgs_native = import nixpkgs {
			system = "x86_64-linux";
		};

		aarch64_pkgs_cross = import nixpkgs {
			localSystem = "aarch64-linux";
			crossSystem = "aarch64-linux";
		};

		pkgs = import nixpkgs {
			config = { allowUnfree = true; };
		};
	in {
		nixosConfigurations = {
			"moon" = nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs; };
				modules = [
					inputs.disko.nixosModules.disko
					./system/moon

					{
						boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
						networking.hostName = "moon";
					}
				];
			};
			"cerberus" = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				specialArgs = { inherit inputs; inherit aarch64_pkgs_cross; };
				modules = [
					inputs.disko.nixosModules.disko
					./system/cerberus
					./system/cerberus/boot/kernel/build.nix

					{
						#nixpkgs.crossSystem.system = "aarch64-linux";
						#nixpkgs.localSystem.system = "x86_64-linux";

						# necessary for firmware
						nixpkgs.config.allowUnfree = true;

						nixpkgs.overlays = [
							(final: super: {
								makeModulesClosure = x:
								super.makeModulesClosure (x // { allowMissing = true; });
							})
						];

						networking.hostName = "cerberus";
					}
				];
			};
			"sariel-aarch64" = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				specialArgs = { inherit inputs; inherit aarch64_pkgs_cross; };
				modules = [
					inputs.disko.nixosModules.disko
					./system/sdimage.nix
					./system/sariel-aarch64

					{
						# necessary for firmware
						nixpkgs.config.allowUnfree = true;

						nixpkgs.overlays = [
							(final: super: {
								makeModulesClosure = x:
								super.makeModulesClosure (x // { allowMissing = true; });
							})
						];

						networking.hostName = "sariel";
					}
				];
			};
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
			"scarlet@moon" = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs {
					system = "x86_64-linux";
					overlays =
						import ./pkgs/default.nix
						++ [
							wired.overlays.default
						];
				};
				
				extraSpecialArgs = { inherit inputs; };
				
				modules = [
					wired.homeManagerModules.default
					#stylix.homeManagerModules.stylix
					./user/scarlet/home
				];
			};

			"crimson@moon" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.x86_64-linux;
				extraSpecialArgs = { inherit inputs; };
				modules = [ ./user/crimson/home ];
			};

			# "white" = home-manager.lib.homeManagerConfiguration {
			# 	pkgs = nixpkgs.legacyPackages.x86_64-linux;
			# 	extraSpecialArgs = { inherit inputs; };
			# 	modules = [ ./user/white/home ];
			# };

			"hades@cerberus" = home-manager.lib.homeManagerConfiguration {
				pkgs = import nixpkgs {
					system = "aarch64-linux";
				};

				extraSpecialArgs = { inherit inputs; };

				modules = [
					./user/hades/home
				];
			};
		};

		devShells.x86_64-linux.kernelEnv = (x86_64_pkgs_native.buildFHSUserEnv {
			name = "kernel-build-env";

			targetPkgs = pkgs: (with pkgs; [
				# we need theses packages to make `make menuconfig` work.
				pkg-config
				ncurses
				# arm64 cross-compilation toolchain
				aarch64_pkgs_cross.gccStdenv.cc
				# native gcc
				gcc
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
