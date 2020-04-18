{ config, pkgs, ... }:

{
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
}
