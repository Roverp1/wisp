{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.transmission;
in {
  options.wisp.transmission = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable transmission daemon";
    };
  };

  config = let
    username = "roverp";
    userHome = config.users.users.${username}.home;
    downloadDir = "${userHome}/Downloads/torrents";
  in
    lib.mkIf cfg.enable {
      # now handled by hm and can be removed?
      # systemd.tmpfiles.rules = [
      #   "d ${downloadDir} 0755 ${username} users -"
      #   "d ${downloadDir}/.incomplete 0755 ${username} users -"
      #   "d ${downloadDir}/.watch 0755 ${username} users -"
      # ];

      services.transmission = {
        enable = true;
        package = pkgs.transmission_4;

        user = username;
        group = "users";

        settings = {
          rpc-bind-address = "127.0.0.1";
          rpc-port = 9091;
          rpc-whitelist-enabled = false;
          rpc-authentication-required = false;

          peer-port = 51413;
          peer-port-random-on-start = false;

          download-dir = downloadDir;

          incomplete-dir-enabled = true;
          incomplete-dir = "${downloadDir}/.incomplete";

          watch-dir-enabled = true;
          watch-dir = "${downloadDir}/.watch";

          speed-limit-down-enabled = false;
          speed-limit-up-enabled = false;
          encryption = "preferred";
        };
      };

      networking.firewall.allowedTCPPorts = [51413];
      networking.firewall.allowedUDPPorts = [51413];
    };
}
