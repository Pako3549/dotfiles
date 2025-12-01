if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_add_path ~
fish_add_path ~/.local/bin/

# set fish_greeting ""

###----- ALIASES -----###
alias vim=nvim

###----- THEMES ENV -----###
set -gx GTK_THEME Adwaita:dark
set -gx QT_QPA_PLATFORMTHEME gtk3
set -gx QT_STYLE_OVERRIDE Adwaita-Dark
set -gx GTK2_RC_FILES /usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc:~/.gtkrc-2.0
set -gx PREFER_DARK_THEME 1

# Configure GNOME/GTK system-wide dark theme (affects keyring, login dialogs, etc.)
if command -q gsettings
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita' 2>/dev/null
    gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita-dark' 2>/dev/null
    gsettings set org.gtk.Settings.FileChooser sort-directories-first true 2>/dev/null
end

###----- PNPM HOME -----###
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

###----- ANDROID HOME -----###
set -x ANDROID_HOME $HOME/Android
set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $PATH
set -x PATH $ANDROID_HOME/platform-tools $PATH
set -x PATH $ANDROID_HOME/emulator $PATH

###----- JAVA 17 HOME -----###
set -gx JAVA_HOME ~/.sdkman/candidates/java/current
set -gx PATH $JAVA_HOME/bin $PATH

##----- PYENV -----#
set -Ux PYENV_ROOT /home/pako/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

if command -v pyenv >/dev/null
    pyenv init - | source
end

if command -v pyenv-virtualenv-init >/dev/null
    pyenv virtualenv-init - | source
end

###----- ESP-IDF -----###
alias get_idf="source $HOME/esp/esp-idf/export.fish"

###----- FUNCTIONS -----###
function fish_greeting
    echo 'Welcome'(set_color 0000CD) $USER (set_color FFFFFF)'(≧◡≦)'
end

###----- FISH COLORS -----###
set -g fish_color_autosuggestion 707A8C
set -g fish_color_cancel --reverse
set -g fish_color_command 5CCFE6
set -g fish_color_comment 5C6773
set -g fish_color_cwd 73D0FF
set -g fish_color_cwd_root red
set -g fish_color_end F29E74
set -g fish_color_error FF3333
set -g fish_color_escape 95E6CB
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_match F28779
set -g fish_color_normal CBCCC6
set -g fish_color_operator FFCC66
set -g fish_color_param CBCCC6
set -g fish_color_quote BAE67E
set -g fish_color_redirection D4BFFF
set -g fish_color_search_match --background=FFCC66
set -g fish_color_selection --background=FFCC66
set -g fish_color_status red
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline

###----- FISH PAGER COLORS -----###
set -g fish_pager_color_completion normal
set -g fish_pager_color_description B3A06D
set -g fish_pager_color_prefix normal --bold --underline
set -g fish_pager_color_progress brwhite --background=cyan
set -g fish_pager_color_selected_background --background=FFCC66

