{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./ssh.nix
    ./alacritty.nix
    ./autorandr.nix
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
    };
  };

  config = {
    programs.home-manager.enable =
      # not sure where else to assert stuff

      assert lib.asserts.assertOneOf "meta.role" config.meta.role
        [ "desktop" "laptop" "server" ];

      true;

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

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "19.09";
  };
}
