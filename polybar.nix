{ config, pkgs, ... }:

let
  cut = "${pkgs.coreutils}/bin/cut";

  winbox-indicator = pkgs.writeShellScript "windicator" ''
    ${pkgs.libvirt}/bin/virsh -c qemu:///system domstate winbox
  '';
in {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      alsaSupport   = false;
      githubSupport = true;
      mpdSupport    = true;
      pulseSupport  = true;
      iwSupport     = false; # ???
      nlSupport     = true;  # one of these two
      i3Support     = true;
    };
    script = "polybar primary &";
    config = {
      "bar/primary" = {
        bottom = true;
        dpi = config.meta.dpi;
        height = 28 * config.meta.dpi / 96;
        padding = 2;
        fixed-center = true;
        font-0 = "Hack:size=10;2";
        font-1 = "Noto Sans CJK JP:size=12;3";
        background-0 = "#eb1d1f21";
        background-1 = "#ff101214";
        underline-size = 2;
        modules-left = "i3";
        modules-right = "winbox load date";
        tray-position = "right";
        tray-maxsize = 16 * config.meta.dpi / 96;
        separator = "  ⋄  ";
        separator-foreground = "#afffffff";
      };

      "module/i3" = {
        type = "internal/i3";
        scroll-up = "i3-msg workspace prev";
        scroll-down = "i3-msg workspace next";
        wrapping-scroll = false;
        index-sort = true;

        label-phantom = " %icon% ";
        label-phantom-foreground = "#80ffffff";

        label-unfocused = " %icon% ";
        label-unfocused-foreground = "#f0ffffff";

        label-focused = " %icon% ";
        label-focused-foreground = "#00afff";
        label-focused-underline = "#00afff";

        label-visible = " %icon% ";
        label-visible-foreground = "#ffffff";
        label-visible-underline = "#ffffff";

        label-urgent = " %icon% ";
        label-urgent-foreground = "#ffaf00";

        label-separator = "";
        label-output-separator = "  ";

        ws-phantom-0 = "21;21:1-1;1-";
        ws-phantom-1 = "22;22:1-2;1-";
        ws-phantom-2 = "23;23:1-3;1-";
        ws-phantom-3 = "24;24:1-4;1-";
        ws-phantom-4 = "11;11:2-1;2-";
        ws-phantom-5 = "12;12:2-2;2-";
        ws-phantom-6 = "13;13:2-3;2-";

        fuzzy-match = true;
        ws-icon-0 = "-1;月";
        ws-icon-1 = "-2;火";
        ws-icon-2 = "-3;水";
        ws-icon-3 = "-4;木";
        ws-icon-4 = "-5;金";
        ws-icon-5 = "-6;土";
        ws-icon-6 = "-7;日";
        ws-icon-7 = "-8;八";
        ws-icon-8 = "-9;九";
      };

      "module/winbox" = {
        type = "custom/script";
        interval = 5;

        exec = "${pkgs.libvirt}/bin/virsh -c qemu:///system domstate winbox";
        label = "WIN: %output%";
        label-foreground = "#81a2be";
      };
      "module/load" = {
        type = "custom/script";
        interval = 5;

        exec = "${cut} -d' ' -f2 /proc/loadavg";
        label = "%output%x";
        label-foreground = "#cc6666";
      };
      "module/date" = {
        type = "internal/date";
        interval = 5;

        date = "%a %d %b";
        time = "%H:%M";
        label = "%date% %time%";
        label-foreground = "#f0c674";
      };
    };
  };
}
