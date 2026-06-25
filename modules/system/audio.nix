{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.audio;
in {
  options.wisp.audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable audio and bluetooth module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [pavucontrol playerctl qpwgraph];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    services = {
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        wireplumber.enable = true;

        extraConfig.pipewire."90-jbl-combine" = {
          "context.modules" = [
            {
              name = "libpipewire-module-combine-stream";

              args = {
                "combine.mode" = "sink";
                "node.name" = "jbl_go_both";
                "node.description" = "JBL GO 3 + GO 4";
                "combine.latency-compensate" = true;

                "combine.props" = {
                  "audio.position" = ["FL" "FR"];
                };
                "stream.props" = {
                  "stream.dont-remix" = true;
                };

                "stream.rules" = [
                  {
                    matches = [
                      {
                        "media.class" = "Audio/Sink";
                        "node.name" = "bluez_output.70_99_1C_CE_B1_95.1";
                      }
                    ];

                    actions = {
                      "create-stream" = {
                        "combine.audio.position" = ["FL" "FL"];
                        "audio.position" = ["FL" "FR"];
                      };
                    };
                  }

                  {
                    matches = [
                      {
                        "media.class" = "Audio/Sink";
                        "node.name" = "bluez_output.90_F2_60_81_0E_F8.1";
                      }
                    ];

                    actions = {
                      "create-stream" = {
                        "combine.audio.position" = ["FR" "FR"];
                        "audio.position" = ["FL" "FR"];
                      };
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    };
  };
}
