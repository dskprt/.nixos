{
	boot.initrd.systemd.enable = true;
	boot.initrd.services.lvm.enable = true;

	boot.plymouth = {
		enable = true;
		theme = "spinner";
	};
}
