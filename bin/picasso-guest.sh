# this file may be symlinked as follows: sudo ln -s $PICASSO/core/bin/picasso-guest.sh /etc/profile.d/picasso-guest.sh
# shebangs fail in /etc/profile.d/*
# iow: don't use a shebang in this file
# [[ -v _GENV_ ]] || . picasso-guest.sh

(( DEBUG < 3 )) || echo -e "\e[0;43m${BASH_SOURCE[0]}\e[0m"


# ----------
# explicitly define _debug so it is available for bootstrapping

function _debug() {
(( DEBUG > 0 || PDEBUG > 0 )) && {
    local l=${#BASH_LINENO[@]}
    local f=${BASH_SOURCE[1]}
    f=$(basename ${f:-#})
    echo -e "\e[1;32m${f}:${BASH_LINENO[-$l]} $@\e[0m"
  }
true
}


# ----------
# source guest environment

#DEBUG=1

_debug "whoami: $(whoami), PWD: $PWD, HOME: $HOME"

_GENV_=true  # we don't export this value. in bash, sub-shells do not inherit aliases which we may have defined in init.d. to include those aliases in our environment we must reload our environment in sub-shells.

# this script may be run within a host context which has its own OPT_PICASSO
OPT_PICASSO=${OPT_PICASSO:-/opt/picasso}; PGUEST=$OPT_PICASSO/core/guest
#PICASSO=${PICASSO:-/opt/picasso}; PGUEST=$PICASSO/core/guest

_debug "OPT_PICASSO: $OPT_PICASSO"

# ----------
for script in $(/usr/bin/find $OPT_PICASSO/core/init.d/ -maxdepth 1 -name '*.*' \( -type l -o -type f \) | /usr/bin/sort); do
#for script in $(/usr/bin/find $PICASSO/core/init.d/ -maxdepth 1 -name '*.*' \( -type l -o -type f \) | /usr/bin/sort); do
#_debug "asslalhasf script: $script"
. $script || _error ". $script"
done

# init.d/00-yoga.sh  # -> _debug, _debug2, _debug3...

:<<\_c
$PGUEST/init.d/??-*.sh  # originate from basebox
$PGUEST/init.d/?-*.sh  # originate from subsequent provisioning

load provisioning environment
_c


# ----------
for script in $(/usr/bin/find $PGUEST/init.d/ -maxdepth 1 -name '*.*' \( -type l -o -type f \) | /usr/bin/sort); do
_debug3 "werwr9w9r79b script: $script"
. $script || _error ". $script"
done

for script in $(/usr/bin/find $PGUEST/network.d/ -maxdepth 1 -name '*.env' \( -type l -o -type f \) | /usr/bin/sort); do
_debug3 "sewttwree script: $script"
. $script || _error ". $script"
done

# non-interactive, non-login bash shells execute the contents of the file specified in $BASH_ENV
# automatically run non-interactively (ie: to run a sub-shell script)
# if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; fi
#export BASH_ENV=$PICASSO/core/bin/picasso-guest.sh

#export YOGA_LOGFILE=$PICASSO/log/installs
#export YOGA_LOGSPEC=$_TOP_:$LINENO  # default of what to include in log

true


