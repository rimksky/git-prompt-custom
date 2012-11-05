# bash
# color git-prompt for bash
#
# * INSTALL
#
# 1. Copy "git-completion.bash" and "git-prompt.sh" to your PATH
# These are in DIR of "/contrib/completion/" # contained in git source.
# Example is a case which copied these files to ~/bin.
#
# 2. Copy this "git-prompt-custom.bash" to same dir.
# If you wish to customise default prompt format, rewirte "PS1" variable of 
# "__update_prompt" function.
# 
#
#  Example(.bashrc):
#
#    if [ -f ~/bin/git-completion.bash ]; then
#        . ~/bin/git-completion.bash
#    fi
#    if [ -f ~/bin/git-prompt.sh ]; then
#        . ~/bin/git-prompt.sh
#    fi
#    if [ -f ~/bin/git-prompt-custom.bash ]; then
#        . ~/bin/git-prompt-custom.bash
#    fi
#

# set PROMPT_COMMAND
if [ -z "$GIT_PS1_INIT_PROMPT_COMMAND" ]; then
    GIT_PS1_INIT_PROMPT_COMMAND=$PROMPT_COMMAND
fi
PROMPT_COMMAND="__update_prompt${GIT_PS1_INIT_PROMPT_COMMAND:+; }$GIT_PS1_INIT_PROMPT_COMMAND"

# __git_ps1 color
__git_ps1_custom ()
{
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    local esc="\e["
    local escend="m"
    local p="$(__git_ps1 '%s')"
    local s=""
    local e=""
    if [ -n "$p" ]; then
        local tmp=""
        tmp=$(echo "$p" | cut -f2 -d" ")
        tmp=$(echo "$tmp" | cut -f1 -d"|")
        local t1=$(echo "$tmp" | sed -e "s/[^*]//g")
        local t2=$(echo "$tmp" | sed -e "s/[^+#]//g")
        local t3=$(echo "$tmp" | sed -e "s/[^$]//g")
        local t4=$(echo "$tmp" | sed -e "s/[^%]//g")
        if [ "$t1" = "*" -o "$t4" = "%" ]; then
            if [ "$t2" = "+" -o "$t2" = "#" ]; then
                s="31;1" # red bold
            else
                s="31" # red
            fi
        elif [ "$t2" = "+" -o "$t2" = "#" ]; then
            s="32" # green
        fi
        if [ "$t3" = "$" ]; then
            if [ -n "$s" ]; then
                s="44;$s" # bg blue
            else
                s="44" # bg blue
            fi
        fi
        if [ -n "$s" ]; then
            s="${esc}${s}${escend}"
            e="${esc}${escend}"
        fi
        echo "$s($p)$e"
   fi 
}

# update
__update_prompt ()
{
    local ps="$(__git_ps1_custom)"
    GIT_PS1_INIT_PS1="${GIT_PS1_INIT_PS1:-$PS1}"
    PS1="${GIT_PS1_INIT_PS1/\\$ /}"
    if [ -n "$ps" ]; then
        PS1="${PS1}:${ps:+$ps}\\$ "
    else
        PS1=$GIT_PS1_INIT_PS1
    fi
}
