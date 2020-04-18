{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  nixpkgs.overlays = [
    (self: super: {
      alacritty = unstable.alacritty;
    })
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 6; y = 8; };
        dynamic_padding = false;
      };
      scrolling = {
        hostiry = 10000;
        multiplier = 3;
        auto_scroll = false;
      };
      font = {
        normal = { family = "Hack"; };
        size = 10;
      };
      draw_bold_text_with_bright_colors = true;
      background_opacity = 0.92;
      colors = {
        primary = { foreground = "0xeaeaea"; background = "0x1d1f21"; };
        normal = {
          black   = "0x000000";
          red     = "0xcc6666";
          yellow  = "0xf0c674";
          green   = "0xb9ca4a";
          cyan    = "0x8abeb7";
          blue    = "0x81a2be";
          magenta = "0xb294bb";
          white   = "0xeaeaea";
        };
        bright = {
          black   = "0x666666";
          red     = "0xff3334";
          yellow  = "0xe7c547";
          green   = "0x9ec400";
          cyan    = "0x54ced6";
          blue    = "0x7aa6da";
          magenta = "0xb77ee0";
          white   = "0xffffff";
        };
      };
      mouse = {
        hide_when_typing = true;
        url = { modifiers = "Control"; };
      };
    };
  };
}
