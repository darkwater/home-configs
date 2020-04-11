{ system, headless }:
{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};

  match = key: arms: arms.${key};
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

  programs.autorandr = let
    bg = builtins.fetchurl {
      url = "https://dark.red/wallpapers/celeste.png";
      sha256 = "1b0j6cdy4qgzvfh4pajmsr7vs3ilkvy9m4z44yvmbi3rxqjibyrf";
    };
  in {
    enable = true;
    hooks.postswitch.background = "feh --bg-fill ${bg}";
    profiles = match system {
      "desktop" = let
        DisplayPort-0 = "00ffffffffffff0005e360247d01000024190104a5351e783b6435a5544f9e27125054bfef00d1c081803168317c4568457c6168617c023a801871382d40582c4500132b2100001efc7e80887038124018203500132b2100001e000000fd003092a0a021010a202020202020000000fc003234363047340a20202020202001aa02031ef14b0103051404131f12021190230907078301000065030c001000fe5b80a07038354030203500132b2100001e866f80a07038404030203500132b2100001e011d007251d01e206e285500132b2100001eab22a0a050841a3030203600132b2100001a7c2e90a0601a1e4030203600132b2100001a000000000000004e";
        DisplayPort-1 = "00ffffffffffff0005e36024dd0600000e1a0104a5351e783b6435a5544f9e27125054bfef00d1c081803168317c4568457c6168617c023a801871382d40582c4500132b2100001efc7e80887038124018203500132b2100001e000000fd002392a0a021010a202020202020000000fc003234363047340a202020202020016702031ef14b0103051404131f12021190230907078301000065030c001000fe5b80a07038354030203500132b2100001e866f80a07038404030203500132b2100001e011d007251d01e206e285500132b2100001eab22a0a050841a3030203600132b2100001a7c2e90a0601a1e4030203600132b2100001a000000000000004e";
      in {
        "normal" = {
          fingerprint = {
            inherit DisplayPort-0 DisplayPort-1;
          };
          config = {
            DisplayPort-0 = {
              enable = true;
              primary = true;
              position = "1920x0";
              mode = "1920x1080";
              rate = "144.00";
            };
            DisplayPort-1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "144.00";
            };
          };
          hooks.postswitch = ''
            pkill synergys || true
          '';
        };
        "winbox" = {
          fingerprint = {
            inherit DisplayPort-1;
          };
          config = {
            DisplayPort-1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "144.00";
            };
          };
          hooks.postswitch = ''
            synergys
            systemctl --user start scream-ivshmem
          '';
        };
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
