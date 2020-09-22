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

      uda.gitlabtitle.type = "string";
      uda.gitlabtitle.label = "Gitlab Title";
      uda.gitlabdescription.type = "string";
      uda.gitlabdescription.label = "Gitlab Description";
      uda.gitlabcreatedon.type = "date";
      uda.gitlabcreatedon.label = "Gitlab Created";
      uda.gitlabupdatedat.type = "date";
      uda.gitlabupdatedat.label = "Gitlab Updated";
      uda.gitlabduedate.type = "date";
      uda.gitlabduedate.label = "Gitlab Due Date";
      uda.gitlabmilestone.type = "string";
      uda.gitlabmilestone.label = "Gitlab Milestone";
      uda.gitlaburl.type = "string";
      uda.gitlaburl.label = "Gitlab URL";
      uda.gitlabrepo.type = "string";
      uda.gitlabrepo.label = "Gitlab Repo Slug";
      uda.gitlabtype.type = "string";
      uda.gitlabtype.label = "Gitlab Type";
      uda.gitlabnumber.type = "string";
      uda.gitlabnumber.label = "Gitlab Issue/MR #";
      uda.gitlabstate.type = "string";
      uda.gitlabstate.label = "Gitlab Issue/MR State";
      uda.gitlabupvotes.type = "numeric";
      uda.gitlabupvotes.label = "Gitlab Upvotes";
      uda.gitlabdownvotes.type = "numeric";
      uda.gitlabdownvotes.label = "Gitlab Downvotes";
      uda.gitlabwip.type = "numeric";
      uda.gitlabwip.label = "Gitlab MR Work-In-Progress Flag";
      uda.gitlabauthor.type = "string";
      uda.gitlabauthor.label = "Gitlab Author";
      uda.gitlabassignee.type = "string";
      uda.gitlabassignee.label = "Gitlab Assignee";
      uda.gitlabnamespace.type = "string";
      uda.gitlabnamespace.label = "Gitlab Namespace";
      uda.gitlabweight.type = "numeric";
      uda.gitlabweight.label = "Gitlab Weight";
      uda.jiraissuetype.type = "string";
      uda.jiraissuetype.label = "Issue Type";
      uda.jirasummary.type = "string";
      uda.jirasummary.label = "Jira Summary";
      uda.jiraurl.type = "string";
      uda.jiraurl.label = "Jira URL";
      uda.jiradescription.type = "string";
      uda.jiradescription.label = "Jira Description";
      uda.jiraid.type = "string";
      uda.jiraid.label = "Jira Issue ID";
      uda.jiraestimate.type = "numeric";
      uda.jiraestimate.label = "Estimate";
      uda.jirafixversion.type = "string";
      uda.jirafixversion.label = "Fix Version";
      uda.jiracreatedts.type = "date";
      uda.jiracreatedts.label = "Created At";
      uda.jirastatus.type = "string";
      uda.jirastatus.label = "Jira Status";
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
    python38Packages.bugwarrior

    # (writeTextDir "share/zsh/vendor-completions/_task"
    #   (builtins.readFile
    #     (builtins.fetchurl "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/taskwarrior/_task")))
  ];
}
