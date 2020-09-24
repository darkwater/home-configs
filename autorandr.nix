{ config, pkgs, ... }:

let
  match = key: arms: arms.${key};
in {
  programs.autorandr = let
    bg = builtins.fetchurl {
      url = "https://dark.red/wallpapers/atsushi.png";
      sha256 = "0a8y0d7ibrgzwp9lfw41vd9n1r7pzrbxkk9db6vi2pw1gkrqkyij";
    };
  in {
    enable = true;
    hooks.postswitch.background = "feh --bg-fill ${bg}";
    hooks.postswitch.polybar = "systemctl --user restart polybar";
    profiles = match config.meta.role {
      "desktop" = let
        DisplayPort-1 = primary: {
          enable = true;
          inherit primary;
          position = "0x0";
          mode = "1920x1080";
          rate = "144.00";
        };
        DisplayPort-0 = primary: {
          enable = true;
          inherit primary;
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
          config.DisplayPort-0 = DisplayPort-0 true;
          config.DisplayPort-1 = DisplayPort-1 false;
          hooks.postswitch = ''
            pkill synergys || true
            systemctl --user stop scream-ivshmem
          '';
        };
        "console" = {
          fingerprint.DisplayPort-0 = import edids/home-right.nix;
          config.DisplayPort-0 = DisplayPort-0 true;
          hooks.postswitch = ''
            pactl load-module module-loopback sink_input_properties=media.name=Console latency_msec=1 source=alsa_input.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.multichannel-input
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
        "work" = {
          fingerprint = {
            DP-1-2-1 = import edids/work-right.nix;
            DP-1-2-2 = import edids/work-left.nix;
          };
          config = {
            DP-1-2-1 = {
              enable = true;
              primary = true;
              position = "1920x0";
              mode = "1920x1080";
            };
            DP-1-2-2 = {
              enable = true;
              position = "0x0";
              mode = "1920x1080";
            };
          };
        };
      };
    };
  };
}
