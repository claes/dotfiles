#
# .bashrc
#
if [ -f /etc/bashrc ]; then
        . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

#Turn bell off
bind 'set bell-style none'
#Circular completion (rather than menu)
#bind '"\t":menu-complete'

ulimit -S -c 0		# Don't want any coredumps
set -o notify
#set -o noclobber
#set -o ignoreeof
#set -o nounset
#set -o xtrace          # useful for debugging

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
#shopt -s mailwarn
shopt -s sourcepath
shopt -s no_empty_cmd_completion  # bash>=2.04 only
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob	# necessary for programmable completion

# Disable options:
shopt -u mailwarn
unset MAILCHECK		# I don't want my shell to warn me of incoming mail

#
# Shell Prompt
#
# Last parts are for Konsole
export PS1="\033[1m\u@\h: \w\033[0m\n\t \$(if [ \$? = 0 ]; then echo -e '\e[01;32m:)'; else echo -e '\e[01;31m:('; fi)\033[0m "

#export LC_ALL=en_US
export HISTTIMEFORMAT="%T " 
export HISTIGNORE="&:bg:fg:ll:h"
export HOSTFILE=$HOME/.hosts	# Put a list of remote hosts in ~/.hosts
export PAGER=less
export HISTSIZE=1500
export EDITOR=emacs
export CVSEDITOR="emacs -nw"
export SVN_EDITOR="emacs -nw"
export GIT_EDITOR="emacs -nw"
export LS_OPTIONS="--color=tty -T 0 -F --show-control-chars"
#export LESSCHARSET=iso8859
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-' # Use this if lesspipe.sh exists
export CDPATH=".:~"

#Needed for .XCompose to work?
#GTK_IM_MODULE=xim 

# Not used yet
# colors for ls, etc.
# dir soc exe chr sgi w-s
# |sym|pip|blk|sui|w+s|
# | | | | | | | | | | |
#export LSCOLORS=gaaGbacadaBaHaDaGaEaEa

#
# Set up dotfiles for other programs, if missing
#
if [ ! -f $HOME/.screenrc ]; then
cat > $HOME/.screenrc << EOF
escape ^Jj #Control-J becomes escape to save Control-A
EOF
fi

#
# Set up local installation environment
#
OPT_DIR=$HOME/opt
OPT_LOCAL=$HOME/opt/local
OPT_SRC=$OPT_DIR/src
OPT_TARBALLS=$OPT_SRC/tarballs

test -d $OPT_DIR || mkdir -p $OPT_DIR
test -d $OPT_LOCAL || mkdir -p $OPT_LOCAL
test -d $OPT_SRC || mkdir -p $OPT_SRC
test -d $OPT_TARBALLS || mkdir -p $OPT_TARBALLS

#Needed for separate installation when using KDE
export KDEDIRS=$KDEDIRS:$OPT_LOCAL
export PATH=$OPT_LOCAL/bin:$PATH
export XDG_CONFIG_DIRS=$OPT_LOCAL/etc:$XDG_CONFIG_DIRS
export XDG_DATA_DIRS=$OPT_LOCAL/share:$XDG_DATA_DIRS
export MANPATH=$OPT_LOCAL/share/man:$MANPATH
export INFOPATH=$OPT_LOCAL/share/info:$INFOPATH
export PKG_CONFIG_PATH=$OPT_LOCAL/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$OPT_LOCAL/lib:$LD_LIBRARY_PATH
export LDPATH=$OPT_LOCAL/lib:$LDPATH

#
# Set up python environment
#
if test -e $OPT_LOCAL/python; then
    export PYTHONPATH=$OPT_LOCAL/python
fi

#
# Set up java environment
#

if test -e $HOME/work/java/java; then
    export JDK_HOME=$HOME/work/java/java
    export JAVA_HOME=$JDK_HOME
    export PATH=$JAVA_HOME/bin:$PATH:
    export MANPATH=$JAVA_HOME/man:$MANPATH
fi

if test -e $HOME/work/java/jwsdp; then
    export JWSDP_HOME=$HOME/work/java/jwsdp
fi
if test -e $HOME/work/java/ant; then
    export ANT_HOME=$HOME/work/java/ant
    export PATH=$ANT_HOME/bin:$PATH
fi
if test -e $HOME/work/java/maven; then
    export MAVEN_HOME=$HOME/work/java/maven
    export PATH=$PATH:$MAVEN_HOME/bin
fi
if test -e $HOME/work/java/android; then
    export ANDROID_HOME=$HOME/work/java/android
    export PATH=$PATH:$ANDROID_HOME/bin
fi

if test -d $HOME/work/java/lib/classpath/; then
    for i in  $HOME/work/java/lib/classpath/*/*.jar
      do
      CLP=$CLP:$i
    done
    export CLASSPATH=$CLP
    unset CLP
fi

#
# Work path: work related executables
#
if test -d $HOME/work/bin; then
    export PATH=$PATH:$HOME/work/bin
fi


#
# Local path: executables only for this host
#
if test -d $HOME/local/bin; then
    export PATH=$PATH:$HOME/local/bin
fi

#Aliases
if test -s ~/.bash-aliases; then
    . ~/.bash-aliases
fi

#Completion
if test -s ~/.bash-completion; then
    . ~/.bash-completion
fi

