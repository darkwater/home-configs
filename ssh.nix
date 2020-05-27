{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "1m";

    extraConfig = ''
      AddKeysToAgent true
      ForwardAgent yes
    '';
  };

  programs.zsh.shellAliases = {
    sn = "ssh -aS none";
  };
}
