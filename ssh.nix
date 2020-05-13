{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";

    extraConfig = ''
      AddKeysToAgent true
    '';
  };
}
