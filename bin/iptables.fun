~~~
if (( DEBUG > 0 )); then

alias _tcp_input_accept="sudo /sbin/iptables -A INPUT -p tcp -j ACCEPT -m comment --comment $_TOP_:$LINENO "
alias _tcp_output_accept="sudo /sbin/iptables -A OUTPUT -p tcp -j ACCEPT -m comment --comment $_TOP_:$LINENO "
alias _udp_input_accept="sudo /sbin/iptables -A INPUT -p udp -j ACCEPT -m comment --comment $_TOP_:$LINENO "
alias _udp_output_accept="sudo /sbin/iptables -A OUTPUT -p udp -j ACCEPT -m comment --comment $_TOP_:$LINENO "
alias _tcp_input_drop="sudo /sbin/iptables -A INPUT -p tcp -j DROP -m comment --comment $_TOP_:$LINENO "
alias _tcp_output_drop="sudo /sbin/iptables -A OUTPUT -p tcp -j DROP -m comment --comment $_TOP_:$LINENO "
alias _udp_input_drop="sudo /sbin/iptables -A INPUT -p udp -j DROP -m comment --comment $_TOP_:$LINENO "
alias _udp_output_drop="sudo /sbin/iptables -A OUTPUT -p udp -j DROP -m comment --comment $_TOP_:$LINENO "

#alias _tcp_in_accept="sudo /sbin/iptables -A TCP_IN -p tcp -j ACCEPT -m comment --comment $_TOP_:$LINENO "
function _tcp_in_accept() {
#echo "_tcp_in_accept **** $DEBUG"
(( DEBUG == 0 )) && echo "/sbin/iptables -A TCP_IN -p tcp -j ACCEPT $@ -m comment --comment $_TOP_:$LINENO "
(( DEBUG > 0 )) && echo "${_TOP_:-$0}:$LINENO /sbin/iptables -A TCP_IN -p tcp -j ACCEPT $@ -m comment --comment $_TOP_:$LINENO "
sudo /sbin/iptables -A TCP_IN -p tcp -j ACCEPT $@ -m comment --comment $_TOP_:$LINENO 
}

#alias _tcp_out_accept="sudo /sbin/iptables -A TCP_OUT -p tcp -j ACCEPT -m comment --comment $_TOP_:$LINENO "
function _tcp_out_accept() {
#echo "_tcp_out_accept **** $DEBUG"
(( DEBUG == 0 )) && echo "/sbin/iptables -A TCP_OUT -p tcp -j ACCEPT $@ -m comment --comment $_TOP_:$LINENO "
(( DEBUG > 0 )) && echo "${_TOP_:-$0}:$LINENO /sbin/iptables -A TCP_OUT -p tcp -j ACCEPT $@ -m comment --comment $_TOP_:$LINENO "
sudo /sbin/iptables -A TCP_OUT -p tcp -j ACCEPT $@ -m comment --comment $_TOP_:$LINENO 
}

alias _udp_in_accept="sudo /sbin/iptables -A UDP_IN -p udp -j ACCEPT -m comment --comment $_TOP_:$LINENO "
alias _udp_out_accept="sudo /sbin/iptables -A UDP_OUT -p udp -j ACCEPT -m comment --comment $_TOP_:$LINENO "
alias _tcp_in_drop="sudo /sbin/iptables -A TCP_IN -p tcp -j DROP -m comment --comment $_TOP_:$LINENO "
alias _tcp_out_drop="sudo /sbin/iptables -A TCP_OUT -p tcp -j DROP -m comment --comment $_TOP_:$LINENO "
alias _udp_in_drop="sudo /sbin/iptables -A UDP_IN -p udp -j DROP -m comment --comment $_TOP_:$LINENO "
alias _udp_out_drop="sudo /sbin/iptables -A UDP_OUT -p udp -j DROP -m comment --comment $_TOP_:$LINENO "

else
~~~
alias _tcp_input_accept="sudo /sbin/iptables -A INPUT -p tcp -j ACCEPT "
alias _tcp_output_accept="sudo /sbin/iptables -A OUTPUT -p tcp -j ACCEPT "
alias _udp_input_accept="sudo /sbin/iptables -A INPUT -p udp -j ACCEPT "
alias _udp_output_accept="sudo /sbin/iptables -A OUTPUT -p udp -j ACCEPT "
alias _tcp_input_drop="sudo /sbin/iptables -A INPUT -p tcp -j DROP "
alias _tcp_output_drop="sudo /sbin/iptables -A OUTPUT -p tcp -j DROP "
alias _udp_input_drop="sudo /sbin/iptables -A INPUT -p udp -j DROP "
alias _udp_output_drop="sudo /sbin/iptables -A OUTPUT -p udp -j DROP "

#alias _tcp_in_accept="sudo /sbin/iptables -A TCP_IN -p tcp -j ACCEPT "
function _tcp_in_accept() {
#echo "_tcp_in_accept **** $DEBUG"
#(( DEBUG > 0 )) && echo "${_TOP_:-$0}:$LINENO /sbin/iptables -A TCP_IN -p tcp -j ACCEPT $@ "
sudo /sbin/iptables -A TCP_IN -p tcp -j ACCEPT $@ 
}

#alias _tcp_out_accept="sudo /sbin/iptables -A TCP_OUT -p tcp -j ACCEPT "
function _tcp_out_accept() {
#echo "_tcp_out_accept **** $DEBUG"
#(( DEBUG > 0 )) && echo "${_TOP_:-$0}:$LINENO /sbin/iptables -A TCP_OUT -p tcp -j ACCEPT $@ "
sudo /sbin/iptables -A TCP_OUT -p tcp -j ACCEPT $@ 
}

alias _udp_in_accept="sudo /sbin/iptables -A UDP_IN -p udp -j ACCEPT "
alias _udp_out_accept="sudo /sbin/iptables -A UDP_OUT -p udp -j ACCEPT "
alias _tcp_in_drop="sudo /sbin/iptables -A TCP_IN -p tcp -j DROP "
alias _tcp_out_drop="sudo /sbin/iptables -A TCP_OUT -p tcp -j DROP "
alias _udp_in_drop="sudo /sbin/iptables -A UDP_IN -p udp -j DROP "
alias _udp_out_drop="sudo /sbin/iptables -A UDP_OUT -p udp -j DROP "
~~~
fi
~~~

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
:<<\_c
_open_server_firewall <interface> <port/s> <comment> <type>
port/s - local destination port/s & local source port/s
type - UDP

workflow:
client(any port) -> server(specific port) -> client(any port)
_c
:<<\_c
interface...
127.0.0.1|localhost - do not open firewall
MNIC|$MNIC_IP - open firewall on $MNIC_ ${MANAGEMENT_C}.0/$MANAGEMENT_PREFIX only
XNIC|$XNIC_IP - open firewall on $XNIC_ ${XNIC_NETWORK}.0/${XNIC_PREFIX} only
NICSA - open firewall on array of interfaces
FNICSA - open firewall on array of interfaces
_c
:<<\_c
-m multiport --dports is only needed if the range you want to open is not continuous, eg -m multiport --dports 80,443, which will open up HTTP and HTTPS only - not the ones in between
_c
:<<\_x
. $PICASSO/core/bin/iptables.fun
_open_server_firewall MNIC '53' "$VM" UDP
-A UDP_IN -s 192.168.1.0/24 -i enp0s8 -p udp -m comment --comment "/mnt/r/picasso/provision.sh:67" --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment -server -j ACCEPT
-A UDP_OUT -d 192.168.1.0/24 -o enp0s8 -p udp -m comment --comment "/mnt/r/picasso/provision.sh:68" --sport 53 -m conntrack --ctstate ESTABLISHED -m comment --comment -server -j ACCEPT
_x


function _open_server_firewall() {
_debug2 "_open_server_firewall $@"

case $1 in
MNIC_IP) local interface=MNIC;;
XNIC_IP) local interface=XNIC;;
*) local interface=$1;;
esac

_debug2
local ports=$2
local comment=$3

if [[ -n $4 ]]; then
tcp=false
echo $4 | grep -q -i 'tcp' && tcp=true
udp=false
echo $4 | grep -q -i 'udp' && udp=true
else
tcp=true  # default is tcp
udp=false
fi
_debug2 "wfow7fs90fwjf interface: $interface, ports: $ports, comment: $comment, udp: $udp, tcp: $tcp"

case $interface in
127.0.0.1|localhost)
:  # do not expose anything
#_tcp_in_accept -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server"
#_tcp_out_accept -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server"
;;
MNIC)
if $udp; then
_udp_in_accept -i $MNIC_ -s ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_udp_out_accept -o $MNIC_ -d ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
if $tcp; then
_tcp_in_accept -i $MNIC_ -s ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_tcp_out_accept -o $MNIC_ -d ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
#_tcp_in_accept -i $MNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server"
#_tcp_out_accept -o $MNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server"
fi
;;
XNIC)
if $udp; then
_udp_in_accept -i $XNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_udp_out_accept -o $XNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
if $tcp; then
#echo "_tcp_in_accept -i $MNIC_ -s ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment \"${comment}-server\""
#_tcp_in_accept -i $XNIC_ -s ${XNIC_NETWORK}/${XNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server"
#_tcp_out_accept -o $XNIC_ -d ${XNIC_NETWORK}/${XNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server"
_tcp_in_accept -i $XNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_tcp_out_accept -o $XNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
_debug2
;;
NICSA)
prev_=
for nic in "${NICSA[@]}"; do
nic_=${nic}_
[[ "$nic_" == "$prev_" ]] && continue
if [[ $nic == 'XNIC' ]]; then
if $udp; then
_udp_in_accept -i ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_udp_out_accept -o ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
if $tcp; then
_tcp_in_accept -i ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_tcp_out_accept -o ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
else
local network=${nic_}NETWORK
local prefix=${nic_}PREFIX
if $udp; then
_udp_in_accept -i ${!nic_} -s ${!network}/${!prefix} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_udp_out_accept -o ${!nic_} -d ${!network}/${!prefix} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
if $tcp; then
_tcp_in_accept -i ${!nic_} -s ${!network}/${!prefix} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_tcp_out_accept -o ${!nic_} -d ${!network}/${!prefix} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
fi
prev_=$nic_
done
;;
FNICSA)
_debug2 "{FNICSA[@]}: ${FNICSA[@]}"
prev_=
for nic in "${FNICSA[@]}"; do
_debug2 "nic: $nic"
nic_=${nic}_
_debug2 "nic_: $nic_, prev_: $prev_"
[[ "$nic_" == "$prev_" ]] && continue
_debug2 "nic_: $nic_"
if [[ $nic == 'XNIC' ]]; then
_debug2 "udp: $udp"
if $udp; then
_udp_in_accept -i ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_udp_out_accept -o ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
_debug2 "tcp: $tcp"
if $tcp; then
_tcp_in_accept -i ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_tcp_out_accept -o ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
else
local network=${nic_}NETWORK
local prefix=${nic_}PREFIX
_debug2 "network: $network, prefix: $prefix"
_debug2 "!network: ${!network}, !prefix: ${!prefix}"
_debug2 "$(env | grep MNIC)"
_debug2 "udp: $udp"
if $udp; then
#_udp_in_accept -i ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server"
#_udp_out_accept -o ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server"
_udp_in_accept -i ${!nic_} -s ${!network}/${!prefix} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_udp_out_accept -o ${!nic_} -d ${!network}/${!prefix} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
_debug2 "tcp: $tcp"
if $tcp; then
#echo _tcp_in_accept -i ${!nic_} -s ${!network}/${!prefix} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server"
#echo _tcp_out_accept -o ${!nic_} -d ${!network}/${!prefix} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server"

_tcp_in_accept -i ${!nic_} -s ${!network}/${!prefix} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_tcp_out_accept -o ${!nic_} -d ${!network}/${!prefix} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
#_tcp_in_accept -i ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server"
#_tcp_out_accept -o ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server"
fi
fi
prev_=$nic_
done
:<<\_c
default: /sbin/iptables -A TCP_IN -p tcp -j ACCEPT -i enp0s8 -s 192.168.1.0/24 -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment -server
default: /sbin/iptables -A TCP_OUT -p tcp -j ACCEPT -o enp0s8 -d 192.168.1.0/24 -m multiport --sports 80,443 -m conntrack --ctstate ESTABLISHED -m comment --comment -server
default: /sbin/iptables -A TCP_IN -p tcp -j ACCEPT -i enp0s9 -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment -server
default: /sbin/iptables -A TCP_OUT -p tcp -j ACCEPT -o enp0s9 -m multiport --sports 80,443 -m conntrack --ctstate ESTABLISHED -m comment --comment -server
_c
;;
*)
if [[ -n $MNIC_IP && $interface == $MNIC_IP ]]; then
if $udp; then
_udp_in_accept -i $MNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_udp_out_accept -o $MNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
if $tcp; then
#_tcp_in_accept -i $MNIC_ -s ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server"
#_tcp_out_accept -o $MNIC_ -d ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server"
_tcp_in_accept -i $MNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_tcp_out_accept -o $MNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
elif [[ -n $XNIC_IP && $interface == $XNIC_IP ]]; then
if $udp; then
_udp_in_accept -i $XNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_udp_out_accept -o $XNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
if $tcp; then
#_tcp_in_accept -i $XNIC_ -s ${XNIC_NETWORK}/${XNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server"
#_tcp_out_accept -o $XNIC_ -d ${XNIC_NETWORK}/${XNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server"
_tcp_in_accept -i $XNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_tcp_out_accept -o $XNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
else
_debug2 "catch-all interface: $interface, ports: $ports, comment: $comment"
if $udp; then
# $interface is an ip
_udp_in_accept -s $interface -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_udp_out_accept -d $interface -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
if $tcp; then
# $interface is an ip
_tcp_in_accept -s $interface -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-server" $5
_tcp_out_accept -d $interface -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-server" $5
fi
fi
;;
esac
_debug2 "_open_server_firewall $@ - done"
}
export -f _open_server_firewall


# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
:<<\_c
_open_client_firewall <interface> <remote destination port/s, remote source port/s> <comment>

_open_client_firewall FNICSA any:445 'Samba'

clients typically connect from random ports above 1024

local       remote
any port -> 80
any port -> 445

this assumes _iptables-input-drop-forward-drop-output-accept, because dports always refers to the remote port and does not impede any local port destinations
_c
:<<\_c
TODO:
for now i avoid the random port stuff by omitting the local source port

we could extend things like so:
_open_client_firewall FNICSA any:445 'Samba'
_open_client_firewall FNICSA any:80 'Samba'
_c


function _open_client_firewall() {
_debug2 "_open_client_firewall $@"

case $1 in
MNIC_IP) local interface=MNIC;;
XNIC_IP) local interface=XNIC;;
*) local interface=$1;;
esac

local ports=$2
local comment=$3

if [[ -n $4 ]]; then
tcp=false
echo $4 | grep -q -i 'tcp' && tcp=true
udp=false
echo $4 | grep -q -i 'udp' && udp=true
else
tcp=true  # default is tcp
udp=false
fi
_debug2 "wfow7fs90fwjf2 interface: $interface, udp: $udp, tcp: $tcp"

case $interface in
MNIC)
if $tcp; then
#_debug2 "dfdljljfd MNIC_: $MNIC_, MNIC_NETWORK: $MNIC_NETWORK, MNIC_PREFIX: $MNIC_PREFIX, ports: $ports, comment: $comment"
_tcp_out_accept -o $MNIC_ -d ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_tcp_in_accept -i $MNIC_ -s ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
#_tcp_out_accept -o $MNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
#_tcp_in_accept -i $MNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
if $udp; then
_udp_out_accept -o $MNIC_ -d ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_udp_in_accept -i $MNIC_ -s ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
;;
XNIC)
if $tcp; then
#_tcp_out_accept -o $XNIC_ -d ${XNIC_NETWORK}/${XNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
#_tcp_in_accept -i $XNIC_ -s ${XNIC_NETWORK}/${XNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
_tcp_out_accept -o $XNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_tcp_in_accept -i $XNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
if $udp; then
_udp_out_accept -o $XNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_udp_in_accept -i $XNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
;;
NICSA)
for nic in "${NICSA[@]}"; do
_debug2 "s9s6flf0wf nic: $nic"
nic_=${nic}_
if [[ $nic == 'XNIC' ]]; then
if $tcp; then
_tcp_out_accept -o ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_tcp_in_accept -i ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
if $udp; then
_udp_out_accept -o ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_udp_in_accept -i ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
else
local network=${nic_}NETWORK
local prefix=${nic_}PREFIX
if $tcp; then
_tcp_out_accept -o ${!nic_} -d ${!network}/${!prefix} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_tcp_in_accept -i ${!nic_} -s ${!network}/${!prefix} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
if $udp; then
_udp_out_accept -o ${!nic_} -d ${!network}/${!prefix} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_udp_in_accept -i ${!nic_} -s ${!network}/${!prefix} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
fi
done
;;
FNICSA)
for nic in "${FNICSA[@]}"; do
_debug2 "slsfsfwwlfsofu nic: $nic"
nic_=${nic}_
if [[ $nic == 'XNIC' ]]; then
if $tcp; then
_tcp_out_accept -o ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_tcp_in_accept -i ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
if $udp; then
_udp_out_accept -o ${!nic_} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_udp_in_accept -i ${!nic_} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
else
local network=${nic_}NETWORK
local prefix=${nic_}PREFIX
if $tcp; then
_tcp_out_accept -o ${!nic_} -d ${!network}/${!prefix} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_tcp_in_accept -i ${!nic_} -s ${!network}/${!prefix} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
if $udp; then
_udp_out_accept -o ${!nic_} -d ${!network}/${!prefix} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_udp_in_accept -i ${!nic_} -s ${!network}/${!prefix} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
fi
done
;;
*)
if [[ -n $MNIC_IP && $interface == $MNIC_IP ]]; then
if $tcp; then
#_tcp_out_accept -o $MNIC_ -d ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
#_tcp_in_accept -i $MNIC_ -s ${MNIC_NETWORK}/${MNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
_tcp_out_accept -o $MNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_tcp_in_accept -i $MNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
if $udp; then
_udp_out_accept -o $MNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_udp_in_accept -i $MNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
elif [[ -n $XNIC_IP && $interface == $XNIC_IP ]]; then
if $tcp; then
#_tcp_out_accept -o $XNIC_ -d ${XNIC_NETWORK}/${XNIC_PREFIX} -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
#_tcp_in_accept -i $XNIC_ -s ${XNIC_NETWORK}/${XNIC_PREFIX} -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
_tcp_out_accept -o $XNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_tcp_in_accept -i $XNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
if $udp; then
_udp_out_accept -o $XNIC_ -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_udp_in_accept -i $XNIC_ -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
else
_debug2 "catch-all interface: $interface, ports: $ports, comment: $comment"
if $tcp; then
# $interface is an ip
_tcp_out_accept -d $interface -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_tcp_in_accept -s $interface -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
if $udp; then
# $interface is an ip
_udp_out_accept -d $interface -m multiport --dports $ports -m conntrack --ctstate NEW,ESTABLISHED -m comment --comment "${comment}-client"
_udp_in_accept -s $interface -m multiport --sports $ports -m conntrack --ctstate ESTABLISHED -m comment --comment "${comment}-client"
fi
fi
;;
esac
_debug2 "_open_client_firewall $@ - done"
}
export -f _open_client_firewall


# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
:<<\_x
_open_server_firewall MNIC 80,443 test
_open_client_firewall MNIC 80,443 test
sudo iptables -L INPUT
sudo iptables -L OUTPUT
sudo iptables -L TCP_IN
sudo iptables -L TCP_OUT

sudo journalctl -f | grep IPT
_x


# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
:<<\_c
. $PICASSO/core/bin/iptables.fun && _iptables_accept_all
_c

function _iptables_accept_all() {

sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
}
