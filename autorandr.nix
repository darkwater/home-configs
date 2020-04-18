{ config, pkgs, ... }:

let
  match = key: arms: arms.${key};
in {
  programs.autorandr = let
    bg = builtins.fetchurl {
      url = "https://dark.red/wallpapers/celeste.png";
      sha256 = "1b0j6cdy4qgzvfh4pajmsr7vs3ilkvy9m4z44yvmbi3rxqjibyrf";
    };
  in {
    enable = true;
    hooks.postswitch.background = "feh --bg-fill ${bg}";
    profiles = match config.meta.role {
      "desktop" = let
        DisplayPort-1 = primary: {
          enable = true;
          inherit primary;
          position = "0x0";
          mode = "1920x1080";
          rate = "144.00";
        };
        DisplayPort-0 = {
          enable = true;
          primary = true;
          position = "1920x0";
          mode = "1920x1080";
          rate = "144.00";
        };
      in {
        "normal" = {
          fingerprint = {
            DisplayPort-1 = import edids/home-left.nix;
            DisplayPort-0 = import edids/home-right.nix;
          };
          config.DisplayPort-0 = DisplayPort-0;
          config.DisplayPort-1 = DisplayPort-1 false;
          hooks.postswitch = ''
            pkill synergys || true
          '';
        };
        "winbox" = {
          fingerprint.DisplayPort-1 = import edids/home-left.nix;
          config.DisplayPort-1 = DisplayPort-1 true;
          hooks.postswitch = ''
            synergys
            systemctl --user start scream-ivshmem
          '';
        };
      };
      "laptop" = {
        "normal" = {
          fingerprint.eDP-1 = import edids/laptop-edp.nix;
          config.eDP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
          };
        };
      };
    };
  };
}
