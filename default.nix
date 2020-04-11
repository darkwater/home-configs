{ system, headless }:
{ config, pkgs, ... }:

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
        size = 8.5;
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

  programs.git = {
    enable = true;
    userName = "Sam Lakerveld";
    userEmail = "dark@dark.red";

    aliases = {
      st = "status";
      ci = "commit --verbose";
      ca = "commit --verbose --all";
      co = "checkout";
      di = "diff";
      dc = "diff --cached";
      ds = "diff --stat=160,120";
      dt = "difftool";
      aa = "add --all";
      ai = "add --interactive";
      ap = "add --patch";
      ff = "merge --ff-only";
      fa = "fetch --all";
      dh1 = "diff HEAD~1";
      pom = "push origin master";
      noff = "merge --no-ff";
      amend = "commit --amend";
      pullff = "pull --ff-only";
    };

    ignores = [ ".gdb_history" ];

    extraConfig = {
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
    };
  };

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";

    extraConfig = ''
      AddKeysToAgent true
    '';

    matchBlocks = {
      "fubuki" = {
        hostname = "dark.red";
        forwardAgent = true;
      };
      "shinbuki" = {
        hostname = "shin.dark.red";
        forwardAgent = true;
      };
    };
  };

  services.compton = {
    enable = true;
    backend = "glx";
    vSync = "opengl-swc";
    extraOptions = ''
      wintypes: {
        dock = { opacity = 0.92; };
      }
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}
