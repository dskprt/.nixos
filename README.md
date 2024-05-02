## how to
(0. fork this repository)
1. clone this repository to `/etc/nixos` or wherever you'd like it
2. configure the system according to your hardware and needs
   1. use `nixos-generate-config --show-hardware-config` to generate hardware.nix and put it in `system/\*/`
   2. configure the filesystems
      - uncomment additional imports in filesystems/default.nix if you're using luks and/or impermanence
      - put additional filesystem options in filesystems/option.nix
      - change luks disk label in filesystems/luks.nix if using luks
   3. if using an nvidia gpu switch import from ./gpu/amd.nix to ./gpu/nvidia.nix in system/\*/default.nix
3. use `sudo nixos-install --root /mnt --flake .#<hostname>` to build the system
4. reboot & login to user
5. `home-manager switch --flake .#<user>@<username>` to build user configuration

## rebuilding configuration
- `sudo nixos-rebuild switch/boot --flake .#zeppy` for system configuration
- `home-manager switch --flake .#<user>@<hostname>` for user configuration
