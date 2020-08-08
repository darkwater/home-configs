{ config, pkgs, ... }:

{
  onyx.configs.git.enable = true;

  programs.git = {
    userName = "Sam Lakerveld";
    userEmail = "dark@dark.red";
    signing.key = "dark@dark.red";
    extraConfig = {
      mergetool.nvim.cmd = ''nvim -f -d -c "wincmd J" "$BASE" "$LOCAL" "$REMOTE"'';
      merge.tool = "nvim";
    };
  };

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

    (pkgs.writeShellScriptBin "lock" ''
      exec i3lock -t -i ${builtins.fetchurl { url = "https://s.dark.red/xf/EORJ.png"; }}
    '')
  ];
}
