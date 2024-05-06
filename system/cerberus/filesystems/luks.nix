{
	boot.initrd.luks.devices = {
		primary = {
			# cryptsetup config /dev/xxxx --label yyyy
			device = "/dev/disk/by-label/luks_primary";
		};
	};
}
