{ config, pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    maxCacheTtl = 120;
    pinentryFlavor = "gtk2";
  };
}
