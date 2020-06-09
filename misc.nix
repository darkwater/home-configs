{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
  };

  home.packages = [
    (pkgs.writeShellScriptBin "hc" ''
      cat <<EOF | ${pkgs.bluez}/bin/bluetoothctl
        select 00:1A:7D:DA:71:11
        power on
        connect 2C:41:A1:C8:F7:18
      EOF
    '')

    (pkgs.writeShellScriptBin "hdc" ''
      cat <<EOF | ${pkgs.bluez}/bin/bluetoothctl
        select 00:1A:7D:DA:71:11
        disconnect 2C:41:A1:C8:F7:18
      EOF
    '')
  ];
}
