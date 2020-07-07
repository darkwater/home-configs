{ config, pkgs, lib, ... }:

let
  onyx = import (builtins.fetchTarball https://git.dark.red/darkwater/onyx/-/archive/master.tar.gz) {};
in {
  imports = [
    onyx.home-modules

    ./alacritty.nix
    ./autorandr.nix
    ./gnupg.nix
    ./misc.nix
    ./polybar.nix
    ./ssh.nix
    ./taskwarrior.nix
  ];

  options = {
    meta = with lib; {
      role = mkOption {
        description = "Role of this system.";
        example = "desktop";
        type = types.str;
      };

      headless = mkOption {
        description = "Whether this system has a monitor attached to it.";
        type = types.bool;
      };

      dpi = mkOption {
        description = "DPI of primary monitor.";
        default = 96;
        type = types.int;
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = lib.asserts.assertOneOf "meta.role" config.meta.role [ "desktop" "laptop" "server" ];
        message = "meta.role should contain the kind of system this is for.";
      }
    ];

    programs.home-manager.enable = true;

    nixpkgs.overlays = [ onyx.overlay ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "20.03";
  };
}
