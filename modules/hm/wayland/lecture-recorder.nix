{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.programs.lecture-recorder;

  lecture-record = pkgs.writeShellApplication {
    name = "lecture-record";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.userPkgs.gpu-screen-recorder
    ];
    text = ''
      usage() {
        printf 'Usage: lecture-record [lecture-name]\n' >&2
      }

      if [[ "''${1:-}" == "-h" || "''${1:-}" == "--help" ]]; then
        usage
        exit 0
      fi

      if [[ "$#" -gt 1 ]]; then
        usage
        exit 2
      fi

      timestamp="$(date '+%Y-%m-%d_%H-%M-%S')"
      lecture_name="''${1:-}"
      safe_name="$(printf '%s' "$lecture_name" | tr -cs '[:alnum:]' '-')"
      safe_name="''${safe_name#-}"
      safe_name="''${safe_name%-}"

      if [[ -n "$safe_name" ]]; then
        filename="''${safe_name}_''${timestamp}.mkv"
      else
        filename="''${timestamp}.mkv"
      fi

      output_dir="''${HOME}/Videos/Lectures"
      output_file="''${output_dir}/''${filename}"
      mkdir -p "$output_dir"

      if [[ -e "$output_file" ]]; then
        printf 'Recording already exists: %s\n' "$output_file" >&2
        exit 1
      fi

      printf 'Recording to %s\n' "$output_file" >&2

      exec gpu-screen-recorder \
        -w portal \
        -restore-portal-session yes \
        -f 30 \
        -c mkv \
        -a ${lib.escapeShellArg "app:${cfg.audioApplication}"} \
        -o "$output_file"
    '';
  };
in {
  options.wisp.programs.lecture-recorder = {
    enable = lib.mkEnableOption "the lightweight lecture recorder";

    audioApplication = lib.mkOption {
      type = lib.types.str;
      default = "Chromium";
      description = "GPU Screen Recorder application name reported for Teams audio capture.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.userPkgs.gpu-screen-recorder
      lecture-record
    ];
  };
}
