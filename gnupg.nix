{ config, pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    maxCacheTtl = 60;
    pinentryFlavor = "gtk2";
  };
}
