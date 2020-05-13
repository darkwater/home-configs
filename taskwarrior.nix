{ config, pkgs, ... }:

{
  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-256";

    config = {
      color = {
        alternate = "on grey1";
        blocked = "grey11";
        blocking = "";
      };

      uda.notes = {
        label = "Notes";
        type = "string";
      };
    };
  };

  home.file = builtins.listToAttrs (
    builtins.map
      ({ name, text }: {
        name = "${config.programs.taskwarrior.dataLocation}/hooks/${name}";
        value = {
          executable = true;
          inherit text;
        };
      })
      [
        {
          name = "on-modify.timewarrior";
          text = ''
            exec ${pkgs.python}/bin/python ${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior
          '';
        }
        # {
        #   name = "on-modify.propagate-due.sh";
        #   text = ''
        #     echo failed
        #     exit 1
        #   '';
        # }
        # {
        #   name = "on-exit.sh";
        #   text = ''
        #     for n in "$@"; do echo "$n"; done | jq -csR 'split("\n")'
        #     exit 1
        #   '';
        # }
      ]
  );

  home.packages = with pkgs; [
    timewarrior

    # (writeTextDir "share/zsh/vendor-completions/_task"
    #   (builtins.readFile
    #     (builtins.fetchurl "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/taskwarrior/_task")))
  ];
}
