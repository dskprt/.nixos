{
	boot.initrd.luks.devices = {
		luks_system = {
			# cryptsetup config /dev/xxxx --label yyyy
			device = "/dev/disk/by-label/luks_system";
			preLVM = true;
		};
	};
}
