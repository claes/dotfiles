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
export PS1="\033[1m\u@\h: \w\033[0m\n\t "

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

#
# CVS
#
if test -d $HOME/work/cvs/; then
    #we are at work - do this better
    export CVSROOT=:ext:claes@spock:/usr/local/work/CVS
    export CVS_RSH=ssh
    export CDPATH=$CDPATH:$HOME/work/cvs/
    #export CVSROOT=/mnt/nfs/spock/CVS
fi

#
# Aliases
#
test -s ~/.alias && . ~/.alias
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias todo='emacs -nw ~/todo.txt'
alias mv='mv -vi'
alias rm='rm -v'
alias cp='cp -v'
alias safels="ls -q"

# The 'ls' family (this assumes you use the GNU ls)
alias la='ls -Al'               # show hidden files
alias ls='ls -hF --color'	# add colors for filetype recognition
alias lx='ls -lXB'              # sort by extension
alias lk='ls -lSr'              # sort by size
alias lc='ls -lcr'		# sort by change time  
alias lu='ls -lur'		# sort by access time   
alias lr='ls -lR'               # recursive ls
alias lt='ls -ltr'              # sort by date
alias lart="ls -lart"
alias lm='ls -al |more'         # pipe through 'more'
alias tree='tree -Csu'		# nice alternative to 'ls'
alias xbox='curlftpfs -o user=xbox:xbox 192.168.1.102 ~/mnt/xbox'
alias e="emacs -nw"
alias cupdate="cvs -qn update | grep ^[^?]"


install-tarball() 
{
    TARBALL=$1
    if [ -z $TARBALL ] 
	then
	echo "You must supply a tarball to install" 
	return 1
    fi
    if [ ! -f $TARBALL ] 
	then
	echo "The tarball $TARBALL does not exist"
	return 1
    fi

    GNU_CONFIGURE=$(tar tf $TARBALL | grep ^[^/]*/configure$)    
    if [ -z $GNU_CONFIGURE ] 
	then
	echo "$TARBALL is not auto-installable"
	return 1
    fi
    echo "Starting... $GNU_CONFIGURE"
    cp $TARBALL $OPT_TARBALLS && \
    tar --directory=$OPT_SRC -xvf $OPT_TARBALLS/$TARBALL && \
    TARBALL_SRC_DIR=$(dirname $OPT_SRC/$GNU_CONFIGURE) && \
    pushd $TARBALL_SRC_DIR && \
    ./configure --prefix=$OPT_LOCAL && \
    make && \
    make install
    popd
}

install-perltarball() 
{
    TARBALL=$1
    if [ -z $TARBALL ] 
	then
	echo "You must supply a tarball to install" 
	return 1
    fi
    if [ ! -f $TARBALL ] 
	then
	echo "The tarball $TARBALL does not exist"
	return 1
    fi
    PERL_MAKEFILE=$(tar tf $TARBALL | grep ^[^/]*/Makefile.PL$)    

    if [ -z $PERL_MAKEFILE ] 
	then
	echo "$TARBALL is not auto-installable"
	return 1
    fi
    echo "Starting... $PERL_MAKEFILE"
    cp $TARBALL $OPT_TARBALLS && \
    tar --directory=$OPT_SRC -xvf $OPT_TARBALLS/$TARBALL && \
	TARBALL_SRC_DIR=$(dirname $OPT_SRC/$PERL_MAKEFILE) && \
    pushd $TARBALL_SRC_DIR && \
    perl Makefile.PL PREFIX=$OPT_LOCAL && \
    make && \
    make install
    popd
}

#
# File & strings related functions:
#

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }
# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }

#
# Process/system related functions:

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }


#
# Programmable completion
# 
if [ "${BASH_VERSION%.*}" \< "2.05" ]; then
    echo "You will need to upgrade to version 2.05 for programmable completion"
    return
fi

# Turn on extended globbing and programmable completion
shopt -s extglob progcomp

# Make directory commands see only directories
complete -d pushd

complete -f -X '!*.?(t)bz?(2)' bunzip2 bzcat bzcmp bzdiff bzegrep bzfgrep bzgrep
complete -f -X '!*.@(zip|ZIP|jar|JAR|exe|EXE|pk3|war|wsz|ear|zargo|xpi|sxw|ott)' unzip zipinfo
complete -f -X '*.Z' compress znew
complete -f -X '!*.@(Z|gz|tgz|Gz|dz)' gunzip zcmp zdiff zcat zegrep zfgrep zgrep zless zmore
complete -f -X '!*.Z' uncompress
complete -f -X '!*.@(gif|jp?(e)g|miff|tif?(f)|pn[gm]|p[bgp]m|bmp|xpm|ico|xwd|tga|pcx|GIF|JP?(E)G|MIFF|TIF?(F)|PN[GM]|P[BGP]M|BMP|XPM|ICO|XWD|TGA|PCX)' ee display gimp
complete -f -X '!*.@(gif|jp?(e)g|tif?(f)|png|p[bgp]m|bmp|x[bp]m|rle|rgb|pcx|fits|pm|GIF|JPG|JP?(E)G|TIF?(F)|PNG|P[BGP]M|BMP|X[BP]M|RLE|RGB|PCX|FITS|PM)' xv qiv
complete -f -X '!*.@(@(?(e)ps|?(E)PS|pdf|PDF)?(.gz|.GZ|.bz2|.BZ2|.Z))' gv ggv kghostview
complete -f -X '!*.@(dvi|DVI)?(.@(gz|Z|bz2))' xdvi
complete -f -X '!*.@(dvi|DVI)' dvips dviselect dvitype kdvi dvipdf advi
complete -f -X '!*.@(pdf|PDF)' acroread gpdf xpdf kpdf
complete -f -X '!*.@(@(?(e)ps|?(E)PS)?(.gz|.GZ)|pdf|PDF|gif|jp?(e)g|miff|tif?(f)|pn[gm]|p[bgp]m|bmp|xpm|ico|xwd|tga|pcx|GIF|JP?(E)G|MIFF|TIF?(F)|PN[GM]|P[BGP]M|BMP|XPM|ICO|XWD|TGA|PCX)' evince
complete -f -X '!*.@(?(e)ps|?(E)PS)' ps2pdf
complete -f -X '!*.texi*' makeinfo texi2html
complete -f -X '!*.@(?(la)tex|?(LA)TEX|texi|TEXI|dtx|DTX|ins|INS)' tex latex slitex jadetex pdfjadetex pdftex pdflatex texi2dvi
complete -f -X '!*.@(mp3|MP3)' mpg123 mpg321 madplay xmms 
complete -f -X '!*.@(mp?(e)g|MP?(E)G|wma|avi|AVI|asf|vob|VOB|bin|dat|vcd|ps|pes|fli|viv|rm|ram|yuv|mov|MOV|qt|QT|wmv|mp3|MP3|ogg|OGG|ogm|OGM|mp4|MP4|wav|WAV|asx|ASX|mng|MNG|3gp)' xine aaxine fbxine kaffeine mplayer
complete -f -X '!*.@(avi|asf|wmv)' aviplay
complete -f -X '!*.@(rm?(j)|ra?(m)|smi?(l))' realplay
complete -f -X '!*.@(mpg|mpeg|avi|mov|qt)' xanim
complete -f -X '!*.@(ogg|OGG|m3u|flac|spx)' ogg123
complete -f -X '!*.@(mp3|MP3|ogg|OGG|pls|m3u)' gqmpeg freeamp
complete -f -X '!*.fig' xfig
complete -f -X '!*.@(mid?(i)|MID?(I))' playmidi
complete -f -X '!*.@(mid?(i)|MID?(I)|rmi|RMI|rcp|RCP|[gr]36|[GR]36|g18|G18|mod|MOD|xm|XM|it|IT|x3m|X3M)' timidity
complete -f -X '*.@(o|so|so.!(conf)|a|t@(ar?(.@(Z|gz|bz?(2)))|gz|bz?(2))|rpm|zip|ZIP|gif|GIF|jp?(e)g|JP?(E)G|mp3|MP3|mp?(e)g|MPG|avi|AVI|asf|ASF|ogg|OGG|class|CLASS)' vi vim gvim rvim view rview rgvim rgview gview
complete -f -X '*.@(o|so|so.!(conf)|a|rpm|gif|GIF|jp?(e)g|JP?(E)G|mp3|MP3|mp?(e)g|MPG|avi|AVI|asf|ASF|ogg|OGG|class|CLASS)' emacs
complete -f -X '!*.@(exe|EXE|com|COM|scr|SCR|exe.so)' wine
complete -f -X '!*.@(zip|ZIP|z|Z|gz|GZ|tgz|TGZ)' bzme
complete -f -X '!*.@(?([xX]|[sS])[hH][tT][mM]?([lL]))' netscape mozilla lynx opera galeon curl dillo elinks amaya
complete -f -X '!*.@(sxw|stw|sxg|sgl|doc|dot|rtf|txt|htm|html|odt|ott|odm)' oowriter
complete -f -X '!*.@(sxi|sti|pps|ppt|pot|odp|otp)' ooimpress
complete -f -X '!*.@(sxc|stc|xls|xlw|xlt|csv|ods|ots)' oocalc
complete -f -X '!*.@(sxd|std|sda|sdd|odg|otg)' oodraw
complete -f -X '!*.@(sxm|smf|mml|odf)' oomath
complete -f -X '!*.odb' oobase
complete -f -X '!*.rpm' rpm2cpio
complete -f -X '!*.xml' ant

# user commands see only users
complete -u su usermod userdel passwd chage write chfn groups slay w

# bg completes with stopped jobs
complete -A stopped -P '%' bg

# other job commands
complete -j -P '%' fg jobs disown

# readonly and unset complete with shell variables
complete -v readonly unset

# set completes with set options
complete -A setopt set

# shopt completes with shopt options
complete -A shopt shopt

# helptopics
complete -A helptopic help

# unalias completes with aliases
complete -a unalias

# bind completes with readline bindings (make this more intelligent)
complete -A binding bind

# type and which complete on commands
complete -c command type which

# builtin completes on builtins
complete -b builtin

complete -A hostname   ssh rsh rcp telnet rlogin r ftp ping disk

complete -A directory  mkdir rmdir
complete -A directory  -o bashdefault cd


# This is a 'universal' completion function - it works when commands have
# a so-called 'long options' mode , ie: 'ls --all' instead of 'ls -a'

_get_longopts () 
{ 
    $1 --help | sed  -e '/--/!d' -e 's/.*--\([^[:space:].,]*\).*/--\1/'| grep ^"$2" |sort -u ;
}

_longopts_func ()
{
    case "${2:-*}" in
	-*)	;;
	*)	return ;;
    esac

    case "$1" in
	\~*)	eval cmd="$1" ;;
	*)	cmd="$1" ;;
    esac
    COMPREPLY=( $(_get_longopts ${1} ${2} ) )
}
complete  -o default -F _longopts_func configure bash
complete  -o default -F _longopts_func wget id info a2ps ls recode cp mv rm tar gzip gunzip


_make_targets ()
{
    local mdef makef gcmd cur prev i

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    # if prev argument is -f, return possible filename completions.
    # we could be a little smarter here and return matches against
    # `makefile Makefile *.mk', whatever exists
    case "$prev" in
        -*f)    COMPREPLY=( $(compgen -f $cur ) ); return 0;;
    esac

    # if we want an option, return the possible posix options
    case "$cur" in
        -)      COMPREPLY=(-e -f -i -k -n -p -q -r -S -s -t); return 0;;
    esac

    # make reads `makefile' before `Makefile'
    if [ -f makefile ]; then
        mdef=makefile
    elif [ -f Makefile ]; then
        mdef=Makefile
    else
        mdef=*.mk               # local convention
    fi

    # before we scan for targets, see if a makefile name was specified
    # with -f
    for (( i=0; i < ${#COMP_WORDS[@]}; i++ )); do
        if [[ ${COMP_WORDS[i]} == -*f ]]; then
            eval makef=${COMP_WORDS[i+1]}       # eval for tilde expansion
            break
        fi
    done

        [ -z "$makef" ] && makef=$mdef

    # if we have a partial word to complete, restrict completions to
    # matches of that word
    if [ -n "$2" ]; then gcmd='grep "^$2"' ; else gcmd=cat ; fi

    # if we don't want to use *.mk, we can take out the cat and use
    # test -f $makef and input redirection
    COMPREPLY=( $(cat $makef 2>/dev/null | awk 'BEGIN {FS=":"} /^[^.#   ][^=]*:/ {print $1}' | tr -s ' ' '\012' | sort -u | eval $gcmd ) )
}

complete -F _make_targets -X '+($*|*.[cho])' make gmake pmake


# cvs(1) completion
_cvs ()
{
    local cur prev
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ] || [ "${prev:0:1}" = "-" ]; then
        COMPREPLY=( $( compgen -W 'add admin checkout commit diff \
        export history import log rdiff release remove rtag status \
        tag update' $cur ))
    else
        COMPREPLY=( $( compgen -f $cur ))
    fi
    return 0
}
complete -F _cvs cvs

_killall ()
{
    local cur prev
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}

    # get a list of processes (the first sed evaluation
    # takes care of swapped out processes, the second
    # takes care of getting the basename of the process)
    COMPREPLY=( $( /bin/ps -u $USER -o comm  | \
        sed -e '1,1d' -e 's#[]\[]##g' -e 's#^.*/##'| \
        awk '{if ($0 ~ /^'$cur'/) print $0}' ))

    return 0
}

complete -F _killall killall 


#
#Old stuff below
#

#Last. source the appropriate environment according to host
#Do this in the end to give the ability to override 
#previous configuration
# HOSTCONFFILE=etc/`hostname`.sh
# if test -f $HOSTCONFFILE
# then
#         source $HOSTCONFFILE
# fi


#Last. source the appropriate environment according to host
#Do this in the end to give the ability to override 
#previous configuration
#if test -n "`hostname | grep -i spock`" 
#then 
#	echo This is spock
#	source ~/etc/spock.sh
#elif test -n "`hostname | grep -i holmer`" 
#then 
#	echo This is holmer
#	source ~/etc/holmer.sh
#elif test -n "`hostname | grep -i hybris`" 
#then 
#	echo This is hybris
#	source ~/etc/hybris.sh
#fi


#For future...
#testpath="
#                $HOME/bin
#                /usr/local/bin
#                /usr/bin
#                /sbin
#"
#export TESTPATH=`pathify $testpath` 
#pathify () {
#  /bin/echo "$@" | 
#  /usr/bin/sed \
#  -e 's/^[ 	]*//' \
#  -e s'/[ 	]*$//' \
#  -e s'/[ 	][ 	]*/:/g'
#        }
