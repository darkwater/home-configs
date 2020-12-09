{ config, pkgs, ... }:

{
  onyx.configs.git.enable = true;

  programs.git = let
    diff-highlight = "${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight";
  in {
    userName = "Sam Lakerveld";
    userEmail = "dark@dark.red";
    signing.key = "dark@dark.red";
    extraConfig = {
      mergetool.nvim.cmd = ''nvim -f -d -c "wincmd J" "$BASE" "$LOCAL" "$REMOTE"'';
      merge.tool = "nvim";
      pager.log = "${diff-highlight} | less";
      pager.show = "${diff-highlight} | less";
      pager.diff = "${diff-highlight} | less";
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

    (pkgs.writeShellScriptBin "selproj-zsh" ''
      set -e

      cd ~
      dir="$(ls -dt p/* w/* g/* |
             sed -e '
               s.^p/.\x1b[0;35mp \x1b[36m/ \x1b[34;1m.
               s.^w/.\x1b[0;33mw \x1b[36m/ \x1b[34;1m.
               s.^g/.\x1b[0;32mg \x1b[36m/ \x1b[34;1m.
             ' |
             fzf --ansi --reverse |
             tr -d ' ')"

      test -z "$dir" && exit
      cd "$dir"

      if test -e shell.nix; then
        exec nix-shell --run "zsh $*"
      else
        exec zsh "$@"
      fi
    '')

    (pkgs.writeShellScriptBin "lock" ''
      exec ${pkgs.i3lock-color}/bin/i3lock-color -t -i ${builtins.fetchurl { url = "https://s.dark.red/xf/EORJ.png"; }} \
        -k --timecolor=ffffffc0 --datecolor=ffffffc0
    '')

    (pkgs.writeShellScriptBin "twitch" ''
      exec mpv https://twitch.tv/$1
    '')
  ];
}
