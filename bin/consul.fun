:<<\_c
. $PICASSO/core/bin/consul.fun
_c

which curl || _install curl

#CONSUL_HTTP_ADDR=${CONSUL_HTTP_ADDR:-http://bit.cafe:8500}
#CONSUL_HTTP_ADDR=${CONSUL_HTTP_ADDR:-http://$DOMAIN/consul}  # reverse proxy
~~~
[[ -z "$CONSUL_HTTP_ADDR" ]] && {

_alert "CONSUL_HTTP_ADDR" $CONSUL_HTTP_ADDR"

DOMAIN=${DOMAIN:-$GENESIS_DOMAIN}

[[ -z "$DOMAIN" ]] && _error '-z "$DOMAIN"'

:<<\_s
. $PICASSO/core/bin/dns.fun

ip=$(_dns_get_ip consul.$DOMAIN)

CONSUL_HTTP_ADDR="http://${ip}${CONSUL_PROXY_PATH}"  # reverse proxy
_s

CONSUL_PROXY_PATH=${CONSUL_PROXY_PATH:-/kv}
CONSUL_HTTP_ADDR=http://${DOMAIN}${CONSUL_PROXY_PATH}
#CONSUL_HTTP_ADDR=https://aggregate.${CONSUL_DATACENTER}.${DOMAIN}:8501
}
~~~

# ----------
:<<\_c
we are returning stdout; therefore, we cannot write anything else like _debug to it
_c

function _kv_get() {
local key=$1

#[[ -z $CONSUL_HTTP_ADDR ]] && { _alert "Missing CONSUL_HTTP_ADDR"; return 1; }

#_debug3 "curl -sX GET $CONSUL_HTTP_ADDR/v1/kv/$key?raw" 1>2  # we are returning stdout so we can't send anything else to it

#curl -4 -sX GET $CONSUL_HTTP_ADDR/v1/kv/$key?raw
if [[ -n "$CONSUL_CACERT" ]]; then
curl --cacert $CONSUL_CACERT --cert $CONSUL_CLIENT_CERT --key $CONSUL_CLIENT_KEY \
  -sX GET $CONSUL_HTTP_ADDR/v1/kv/$key?raw
else
curl \
  -sX GET $CONSUL_HTTP_ADDR/v1/kv/$key?raw
fi
#wget -qO- $CONSUL_HTTP_ADDR/v1/kv/$key?raw
}
export -f _kv_get

:<<\_x
curl $CONSUL_HTTP_ADDR/v1/kv/DNS_KEY?raw
curl -X GET $CONSUL_HTTP_ADDR/v1/kv/DNS_KEY?raw
curl -sX GET $CONSUL_HTTP_ADDR/v1/kv/$key?raw
curl --resolve $nameserver -X GET $CONSUL_HTTP_ADDR/v1/kv/$key?raw
_x

:<<\_x
. $PWORK/$PID/bin/init.sh
curl $CONSUL_HTTP_ADDR/v1/kv/DNS_KEY?raw

#. $OPT_PICASSO/core/bin/consul.fun
_kv_get OS_AUTH_URL
_x


# ----------
:<<\_s
function _kv_set() {
local key=$1
local value=$2

_info "vault kv put secret/$PID identity=$IDENTITY_MANAGEMENT_IP"

1>/dev/null vault kv put secret/$PID identity=$IDENTITY_MANAGEMENT_IP
identity_ip=$(vault kv get -field identity -format table secret/$PID)
[[ $identity_ip == $IDENTITY_MANAGEMENT_IP ]] || _error "identity_ip/$identity_ip != IDENTITY_MANAGEMENT_IP/$IDENTITY_MANAGEMENT_IP"
}
_s

function _kv_set() {
local key=$1
local value=$2

#[[ -z $CONSUL_HTTP_ADDR ]] && { _alert "Missing CONSUL_HTTP_ADDR"; return 1; }

_debug3 "curl -sX PUT -d \"$value\" $CONSUL_HTTP_ADDR/v1/kv/$key"

#curl -4 -sX PUT -d "$value" $CONSUL_HTTP_ADDR/v1/kv/$key
#1>/dev/null curl -sX PUT -d "$value" $CONSUL_HTTP_ADDR/v1/kv/$key
if [[ -n "$CONSUL_CACERT" ]]; then
rv=$(
curl --cacert $CONSUL_CACERT --cert $CONSUL_CLIENT_CERT --key $CONSUL_CLIENT_KEY \
  -sX PUT -d "$value" $CONSUL_HTTP_ADDR/v1/kv/$key
)
else
rv=$(
curl \
  -sX PUT -d "$value" $CONSUL_HTTP_ADDR/v1/kv/$key
)
fi
x=$?
[[ $x == 0 ]] || _alert "_kv_set returned x: $x, rv: $rv"

#wget --post-data="$value" $CONSUL_HTTP_ADDR/v1/kv/$key  # requires newish wget
}
export -f _kv_set

#curl -sX PUT -d "$value" $CONSUL_HTTP_ADDR/v1/kv/$key
#curl --resolve $nameserver -X PUT -d "$value" $CONSUL_HTTP_ADDR/v1/kv/$key
:<<\_x
CONSUL_PROXY_PATH=/kv
CONSUL_HTTP_ADDR=${CONSUL_HTTP_ADDR:-http://${DOMAIN}${CONSUL_PROXY_PATH}}  # reverse proxy
key=key
value=value
curl -sX PUT -d "$value" $CONSUL_HTTP_ADDR/v1/kv/$key
_x
:<<\_x
. openrc admin admin dev
_kv_set os_auth_url $OS_AUTH_URL
_x


# ----------
function _kv_set_file() {
local key=$1
local file=$2
local type=${3:-application/zip}

_debug "CONSUL_HTTP_ADDR: $CONSUL_HTTP_ADDR"

_debug3 "curl -sX PUT -d \"$file\" $CONSUL_HTTP_ADDR/v1/kv/$key"

#curl -4 $CONSUL_HTTP_ADDR/v1/kv/$key --upload-file $file
#r=$(curl -s --upload-file $file $CONSUL_HTTP_ADDR/v1/kv/$key -H "Content-Type: $type" -H 'Expect:')
if [[ -n "$CONSUL_CACERT" ]]; then
r=$(
curl --cacert $CONSUL_CACERT --cert $CONSUL_CLIENT_CERT --key $CONSUL_CLIENT_KEY \
  -s --upload-file $file $CONSUL_HTTP_ADDR/v1/kv/$key -H "Content-Type: $type" -H 'Expect:'
)
else
r=$(
curl \
  -s --upload-file $file $CONSUL_HTTP_ADDR/v1/kv/$key -H "Content-Type: $type" -H 'Expect:'
)
fi

[[ "$r" == 'true' ]] || _alert "_kv_set_file returned r: $r"

#wget --post-file=$file $CONSUL_HTTP_ADDR/v1/kv/$key
}
export -f _kv_set_file

#curl -sX PUT -d "$(<$file)" $CONSUL_HTTP_ADDR/v1/kv/$key
:<<\_x
echo "hello world!" > ./bar
wget --post-file=./bar $CONSUL_HTTP_ADDR/v1/kv/foo

_kv_set_file foo ./bar
_x

~~~
ret=$(curl -sX PUT -d "$value" $CONSUL_HTTP_ADDR/v1/kv/$key)
echo "ret: $ret"
if [[ $? -eq 0 && $ret == 'true' ]]; then

# consul kv get $key
result=$(curl -sX GET $CONSUL_HTTP_ADDR/v1/kv/$key?raw)
echo "?: $?, result: $result"
if [[ $? -eq 0 && $result == $value ]]; then
_info "Consul [OK]"
else
_error "Consul: $result != $value"
fi
else
_error "Consul: $ret != 'true'"
fi
~~~

# ----------
function _kv_get_file() {
local key=$1
local file=$2
local type=${3:-application/zip}
:<<\_x
key=openrc
file=/tmp/openrc
type=application/zip
CONSUL_PROXY_PATH=/kv
CONSUL_HTTP_ADDR=${CONSUL_HTTP_ADDR:-http://${DOMAIN}${CONSUL_PROXY_PATH}}  # reverse proxy
curl -o $file $CONSUL_HTTP_ADDR/v1/kv/$key?raw -H "Content-Type: $type" -H 'Expect:'
cat $file
_x

_debug "CONSUL_HTTP_ADDR: $CONSUL_HTTP_ADDR"

_debug3 "curl -sX PUT -d \"$file\" $CONSUL_HTTP_ADDR/v1/kv/$key"

#curl -4 $CONSUL_HTTP_ADDR/v1/kv/$key --upload-file $file
#curl -s -o $file $CONSUL_HTTP_ADDR/v1/kv/$key?raw -H "Content-Type: $type" -H 'Expect:'
if [[ -n "$CONSUL_CACERT" ]]; then
curl --cacert $CONSUL_CACERT --cert $CONSUL_CLIENT_CERT --key $CONSUL_CLIENT_KEY \
  -s -o $file $CONSUL_HTTP_ADDR/v1/kv/$key?raw -H "Content-Type: $type" -H 'Expect:'
else
curl \
  -s -o $file $CONSUL_HTTP_ADDR/v1/kv/$key?raw -H "Content-Type: $type" -H 'Expect:'
fi

# return $?
}
export -f _kv_get_file

