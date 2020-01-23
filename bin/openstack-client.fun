:<<\_c
. $PICASSO/core/bin/openstack-client.fun
_c

. $PICASSO/core/bin/consul.fun

_kv_get_file openrc $PWORK/$PID/bin/openrc && chmod 644 $PWORK/$PID/bin/openrc

:<<\_x
which openrc  # /mnt/c/picasso/bin/openrc

PATH=$PWORK/$PID/bin:$PATH
which openrc  # $PWORK/$PID/bin/openrc
_x

