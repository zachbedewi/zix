{
  flake.modules.nixos.audio = { lib, ... }: {
    services = {
      pulseaudio.enable = false;

      pipewire = {
        enable = true;
        audio.enable = true;

        alsa.enable = true;
        alsa.support32Bit = true;

        pulse.enable = true;
        jack.enable = true;

        wireplumber.enable = true;
        socketActivation = true;

        extraConfig = {
          pipewire = {
            "10-clock" = {
              "context.properties" = {
                "default.clock.rate" = 48000;
                "default.clock.allowed-rates" = [
                  44100
                  48000
                  88200
                  96000
                  176400
                  192000
                ];

                "default.clock.quantum" = 1024;
                "default.clock.min-quantum" = 32;
                "default.clock.max-quantum" = 2048;
                "default.clock.quantum-limit" = 8192;

                "module.x11.bell" = false;
              };
            };

            "11-quality" = {
              "stream.properties" = {
                "resample.quality" = 10;
                "resample.disable" = false;
                "channelmix.normalize" = false;
                "channelmix.mix-lfe" = true;
                "dither.method" = "wannamaker3";
                "dither.noise" = 1;
              };
            };
          };

          pipewire-pulse."92-pulse" = {
            "pulse.properties" = {
              "pulse.min.quantum" = "256/48000";
              "pulse.default.req" = "1024/48000";
              "pulse.max.quantum" = "2048/48000";
            };
            "stream.properties" = {
              "resample.quality" = 10;
            };
          };

          jack."80-jack" = {
            "jack.properties" = {
              "node.latency" = "256/48000";
              "jack.merge-monitor" = true;
              "jack.short-name" = true;
            };
          };
        };
      };

      udev.extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      '';
    };

    security = {
      rtkit.enable = true;

      pam.loginLimits = [
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "nice";
          type = "-";
          value = "-19";
        }
      ];
    };

    boot = {
      kernelParams = [
        "threadirqs"
        "preempt=full"
      ];

      kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "dev.hpet.max-user-freq" = 3072;
      };

      kernelModules = [
        "snd-seq"
        "snd-rawmidi"
        "snd_virmidi"
      ];
    };

    programs.dconf.enable = true;

    environment.variables =
      let
        makePluginPath =
          format:
          (lib.makeSearchPath format [
            "$HOME/.nix-profile/lib"
            "/run/current-system/sw/lib"
            "/etc/profiles/per-user/$USER/lib"
          ])
          + ":$HOME/.${format}";
      in
      {
        LADSPA_PATH = makePluginPath "ladspa";
        LV2_PATH = makePluginPath "lv2";
        VST3_PATH = makePluginPath "vst3";
      };
  };
}
