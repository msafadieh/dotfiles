{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
        enable = true;
        theme = "simple";
        plugins = ["git" "python"];
    };
    loginShellInit = ''
        HYPHEN_INSENSITIVE="true"
        DISABLE_UPDATE_PROMPT="true"
        DISABLE_AUTO_TITLE="true"

        alias ld-off='xrandr --output eDP --off'
        if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
            exec startx -- vt1 &> /dev/null
        fi
    '';
  };

  programs.vim = {
   defaultEditor = true;
  };
}
