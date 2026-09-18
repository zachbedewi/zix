{
  flake.modules.homeManager.audio =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      services = {
        easyeffects.enable = true;

        mpd = {
          enable = true;
          musicDirectory = "${config.home.homeDirectory}/Music";
          extraConfig = ''
            audio_output {
              type        "pipewire"
              name        "PipeWire Output"
            }
            audio_output {
              type        "fifo"
              name        "Visualiser"
              path        "/tmp/mpd.fifo"
              format      "44100:16:2"
            }
            replaygain "album"
            audio_buffer_size "4096"
          '';
        };

        mpdris2.enable = true;
      };

      programs = {
        cava = {
          enable = true;
          settings = {
            general.framerate = 60;
            input.method = "pipewire";
            input.source = "auto";
            smoothing.noise_reduction = 30;
          };
        };

        beets = {
          enable = true;
          settings = {
            directory = "${config.home.homeDirectory}/Music";
            library = "${config.home.homeDirectory}/.local/share/beets/library.db";
            import = {
              move = true;
              write = true;
            };
            plugins = [
              "fetchart"
              "embedart"
              "lastgenre"
              "replaygain"
              "duplicates"
              "scrub"
            ];
            replaygain.backend = "ffmpeg";
          };
        };
      };

      home.packages = with pkgs; [
        pwvucontrol
        pavucontrol
        qpwgraph
        coppwr
        alsa-utils
        playerctl
        strawberry
        rmpc

        (writeShellApplication {
          name = "audio-doctor";
          runtimeInputs = [
            pipewire
            wireplumber
            alsa-utils
            gnugrep
            util-linux
          ];
          text = ''
            echo "=== Graph status ==="
            wpctl status

            echo
            echo "=== Clock / quantum ==="
            pw-metadata -n settings

            echo
            echo "=== Node load + xruns (ERR column) ==="
            pw-top -b -n 1

            echo
            echo "=== ALSA devices ==="
            aplay -l
            arecord -l

            echo
            echo "=== Service state ==="
            systemctl --user --no-pager status pipewire wireplumber pipewire-pulse \
              | grep -E "●|Active:"

            echo
            echo "=== Recent errors ==="
            journalctl --user -u pipewire -u wireplumber -b --no-pager -p err | tail -20
          '';
        })

        (writeShellApplication {
          name = "audio-latency";
          runtimeInputs = [
            pipewire
            bc
          ];
          text = ''
            if [ $# -eq 0 ]; then
              echo "usage: audio-latency <quantum|auto>"
              echo "  e.g. audio-latency 64    # ~1.3ms @48k, for tracking"
              echo "       audio-latency 1024  # ~21ms, desktop default"
              echo "       audio-latency auto   # release the override"
              pw-metadata -n settings | grep -E "quantum|rate"
              exit 0
            fi
            if [ "$1" = "auto" ]; then
              pw-metadata -n settings 0 clock.force-quantum 0
              echo "Quantum released to dynamic negotiation."
            else
              pw-metadata -n settings 0 clock.force-quantum "$1"
              echo "Quantum forced to $1 samples ($(echo "scale=2; $1/48" | bc)ms @48kHz)."
            fi
          '';
        })
      ];
    };
}
