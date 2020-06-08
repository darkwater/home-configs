{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "1m";

    extraConfig = ''
      AddKeysToAgent true
    '';

    matchBlocks = {
      kuudou = {
        user = "u233274";
        hostname = "u233274.your-storagebox.de";
        port = 23;
      };
    };
  };

  programs.zsh.shellAliases = {
    sn = "ssh -aS none";
  };
}
