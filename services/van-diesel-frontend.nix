{ config, lib, pkgs, ... }:

let
  cfg = config.services.van-diesel-frontend;

in
{
  options = {
    services.van-diesel-frontend = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the Van Diesel frontend.
        '';
      };

      port = lib.mkOption {
        type = lib.types.int;
        default = 80;
        description = ''
          The port to host the Van Diesel frontend on.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."van-diesel-frontend.cfg" = {
      text = ''
        The port on which the Van Diesel frontend is supposed to run is ${cfg.port}.
      '';
    };
  };
}
