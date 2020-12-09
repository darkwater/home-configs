{ config, pkgs, ... }:

let
  all-profiles = {
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
          pactl unload-module module-loopback
        '';
      };
      "console" = {
        fingerprint.DisplayPort-0 = import edids/home-right.nix;
        config.DisplayPort-0 = DisplayPort-0 true;
        hooks.postswitch = ''
          pactl load-module module-loopback sink_input_properties=media.name=Console latency_msec=1 source=alsa_input.usb-0d8c_C-Media_USB_Audio_Device-00.multichannel-input
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
in {
  programs.autorandr = let
    bg = builtins.fetchurl {
      url = "https://dark.red/wallpapers/nekomimi.png";
      sha256 = "0bcm4nhbbj8dw3babfnx11j84rfxvr82qn28jsmfilrvzj9ygqsz";
    };
  in {
    enable = all-profiles ? ${config.meta.role};
    profiles = all-profiles.${config.meta.role};
    hooks.postswitch.background = "feh --bg-fill ${bg}";
    hooks.postswitch.polybar = "systemctl --user restart polybar";
  };
}
