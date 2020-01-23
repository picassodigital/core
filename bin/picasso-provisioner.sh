[[ -v _GENV_ ]] || . picasso-guest.sh
:<<\_c
[assumptions]
provisioner-env) may require vboxfs

[usage]
. picasso-provisioner.sh; picasso-provisioner start $PROVISIONER  # called from the target script
...
picasso-provisioner stop
_c

#DEBUG=3

STAGE=${STAGE:-development}


# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
_debug3 "@ $@"

[[ -n "$@" ]] && {

_debug3 "PICASSO $PICASSO"

. $PICASSO/core/bin/longopts.sh
_debug3 "longopts: ${longopts[@]}"

for opt in "${!longopts[@]}"; do  # keys
val=${longopts[$opt]}
_debug3 "opt: $opt, val: $val"
case $opt in
verbose) DEBUG=${val:-1};;
provisioner) provisioner=$val;;
provisioner-env)
PROVISIONER_ENV=$val
_info "Environment: $PROVISIONER_ENV"
_debug3 "$(<$PROVISIONER_ENV)"
. $PROVISIONER_ENV
;;
esac
done

set --  # clear script arguments to prevent re-entry and parameter propagation to sourced sub-scripts

}
:<<\_x
function testenv() {

. $PICASSO/core/bin/longopts.sh

for opt in "${!longopts[@]}"; do  # keys
val=${longopts[$opt]}
case $opt in
provisioner-env)
_info "Environment: $val"
PROVISIONER_ENV=$val
_debug3 "$(cat $val)"
;;
esac
done
}

testenv /service/aggregate2 --opt=f0 --provisioner-env=<(cat <<!
DOMAINS="$DOMAINS"
!
)
_x

_debug

alias _quiet=''
(( DEBUG < 0 )) && alias _quiet='1>/dev/null'
(( DEBUG < -1 )) && alias _quiet='&>/dev/null'


# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
function _run_once_on_entry() {

_debug2 "_run_once_on_entry STAGE: $STAGE"

#STAGE=${STAGE:-development}

case $STAGE in

development)

_debug2 "xcvbsdwyisdds MNT_PICASSO: $MNT_PICASSO, GIT_PICASSO: $GIT_PICASSO"

if [[ -n "$MNT_PICASSO" ]]; then

_debug "MNT_PICASSO"

PICASSO=$MNT_PICASSO  # PICASSO=<source of Picasso's repo files>

elif [[ -n "$GIT_PICASSO" ]]; then

_debug "GIT_PICASSO"

[[ -d "$GIT_PICASSO" ]] && {

_debug

[[ -d $GIT_PICASSO/custom ]] || {

_debug

pushd $GIT_PICASSO

GIT_INSTALLER_PAT='fRnDafx2mhQ1NdhHoACk'
GIT_INSTALLER_URL=https://picassodigital:${GIT_INSTALLER_PAT}@gitlab.com/picassodigital/custom.git

_debug "ortewotoe9379352 git submodule add $GIT_INSTALLER_URL"

sudo git submodule add $GIT_INSTALLER_URL

#username=${username:-picasso}
#sudo chown $username:$username -R $GIT_PICASSO/custom

popd
}
}

PICASSO=$GIT_PICASSO  # PICASSO=<source of Picasso's repo files>

else

_debug sdfaerwr927972

GIT_PICASSO=$OPT_PICASSO

[[ -d "$GIT_PICASSO" ]] && {

_debug3 "$(ls -la $GIT_PICASSO)"

[[ -d $GIT_PICASSO/custom ]] || {

pushd $GIT_PICASSO

GIT_INSTALLER_PAT='fRnDafx2mhQ1NdhHoACk'
GIT_INSTALLER_URL=https://picassodigital:${GIT_INSTALLER_PAT}@gitlab.com/picassodigital/custom.git

_debug "sdfsghtiy4573 git submodule add $GIT_INSTALLER_URL"

sudo git submodule add $GIT_INSTALLER_URL

#username=${username:-picasso}
#sudo chown $username:$username -R $GIT_PICASSO/custom

popd
}
}

PICASSO=$GIT_PICASSO

fi

;;

production)

[[ -d "$GIT_PICASSO" ]] && {

[[ -d $GIT_PICASSO/custom ]] || {

pushd $GIT_PICASSO

GIT_INSTALLER_PAT='fRnDafx2mhQ1NdhHoACk'
GIT_INSTALLER_URL=https://picassodigital:${GIT_INSTALLER_PAT}@gitlab.com/picassodigital/custom.git

_debug "dsssfwwfowow git submodule add $GIT_INSTALLER_URL"

sudo git submodule add $GIT_INSTALLER_URL

#username=${username:-picasso}
#sudo chown $username:$username -R $GIT_PICASSO/custom

popd
}
}

PICASSO=$GIT_PICASSO  # PICASSO=<source of Picasso's repo files>
;;

*)
_error "Unknown STAGE: $STAGE"
;;

esac

#echo "PICASSO=$PICASSO" >> /etc/environment

_debug2 "PICASSO: $PICASSO"

[[ -d $PICASSO/custom ]] || _error "-d $PICASSO/custom"

}


# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
_info "Provisioning project: $PPROJ with script: $PROVISIONER"

[[ -v _STACK_TOP_ ]] || {

_debug3 "init _STACK_TOP_"

export _STACK_TOP_=0
declare -a _STACK_
export _STACK_
export _TOP_

_run_once_on_entry
}

:<<\_c
. picasso-provisioner.sh
picasso-provisioner start [string]
picasso-provisioner stop
_c

function picasso-provisioner() {

case $1 in

start)
if [[ -z $_TOP_ ]]; then
  _TOP_="${2:-${BASH_SOURCE[1]}:${FUNCNAME[1]}}"
else
  _TOP_="$_TOP_ ${2:-${BASH_SOURCE[1]}:${FUNCNAME[1]}}"
fi
[[ -n "$_TOP_" ]] && (( DEBUG > 0 )) && echo -e "\e[0;32mstart $_TOP_\e[0m"  # emit if _self had a parameter
_STACK_[$_STACK_TOP_]="$_TOP_"
_STACK_TOP_=$((_STACK_TOP_+1))
(( DEBUG < 2 )) || echo -e "\e[0;43m${BASH_SOURCE[1]}\e[0m"

(( DEBUG > 3 )) && set -x

return 0
;;

stop)
[[ -n "$_TOP_" ]] && (( DEBUG > 0 )) && echo -e "\e[0;32mstop $_TOP_\e[0m"  # emit if _fles had a parameter
if [ $_STACK_TOP_ -gt 0  ]; then
  _STACK_TOP_=$((_STACK_TOP_-1))
  _TOP_=${_STACK_[$_STACK_TOP_]}
  (( DEBUG < 2 )) || echo -e "\e[2;30;43m<<< ${BASH_SOURCE[1]}\e[0m"
  unset _STACK_[$_STACK_TOP_]
if [[ $_STACK_TOP_ -gt 0  ]]; then _TOP_=${_STACK_[$_STACK_TOP_-1]}; else unset _TOP_; fi
fi

(( DEBUG > 3 )) && set +x

return 0
;;

esac

}
