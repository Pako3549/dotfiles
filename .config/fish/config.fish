if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_add_path ~
# set fish_greeting ""

###----- ALIASES -----###
alias vim=nvim

###----- THEMES ENV -----###
set -gx GTK_THEME Adwaita:dark
set -gx QT_QPA_PLATFORMTHEME gtk3
set -gx QT_STYLE_OVERRIDE Adwaita-Dark

###----- PNPM HOME -----#
set -gx PNPM_HOME "/home/pako/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

###----- FUNCTIONS -----###
function fish_greeting
    echo 'Welcome'(set_color 0000CD) $USER (set_color FFFFFF)'(≧◡≦)'
end
