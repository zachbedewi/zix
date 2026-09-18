{
  flake.modules.nixos.audio = { pkgs, ... }: {
    services.pipewire.wireplumber = {
      extraConfig = {
        "50-no-suspend" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                { "node.name" = "~alsa_input.*"; }
                { "node.name" = "~alsa_output.*"; }
              ];
              actions.update-props = {
                "session.suspend-timeout-seconds" = 0;
                "node.always-process" = true;
                "dither.method" = "wannamaker3";
                "dither.noise" = 1;
              };
            }
          ];
          "monitor.bluez.rules" = [
            {
              matches = [ { "node.name" = "~bluez_output.*"; } ];
              actions.update-props."session.suspend-timeout-seconds" = 5;
            }
          ];
        };

        "51-device-policy" = {
          "monitor.alsa.rules" = [
            {
              matches = [ { "node.name" = "~alsa_output.*hdmi.*"; } ];
              actions.update-props = {
                "priority.driver" = 100;
                "priority.session" = 100;
              };
            }
          ];
        };

        "52-defaults" = {
          "wireplumber.settings" = {
            "device.routes.default-sink-volume" = 0.75;
            "device.routes.default-source-volume" = 1.0;
            "device.restore-routes" = true;
            "device.routes.default-sink-volume-persistent" = true;
          };
        };

        "60-bluetooth" = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.codecs" = [
              "ldac"
              "aptx_hd"
              "aptx"
              "aac"
              "sbc_xq"
              "sbc"
            ];
            "bluez5.roles" = [
              "a2dp_sink"
              "a2dp_source"
              "bap_sink"
              "bap_source"
              "hsp_hs"
              "hsp_ag"
              "hfp_hf"
              "hfp_ag"
            ];
          };
        };

        "61-bluetooth-policy" = {
          "wireplumber.settings" = {
            "bluetooth.autoswitch-to-headset-profile" = false;
          };
        };
      };

      extraLv2Packages = with pkgs; [
        lsp-plugins
        calf
      ];
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Experimental = true;
        FastConnectable = true;
        JustWorksRepairing = "always";
      };
    };
  };
}
