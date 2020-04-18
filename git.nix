{ config, pkgs, ... }:

{
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
}
