{ pkgs, ... }: {
	
	hardware.pulseaudio.enable = false;
	
	security.rtkit.enable = true;

	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;

		extraConfig.pipewire = {
			"92-low-latency" = {
				"context.properties" = {
					"default.clock.rate" = 48000;
					"default.clock.quantum" = 512;
					"default.clock.min-quantum" = 256;
					"default.clock.max-quantum" = 1024;
				};
			};
		};
	};

	#environment.variables."PULSE_LATENCY_MSEC" = "16";
}
