#!/bin/bash

# 1-wire sensors
JOB=temp
INSTANCE=cascadepi
GATEWAY=http://pidock:9091/metrics/jobs/${JOB}/instances/${INSTANCE}

T=$(cat /sys/bus/w1/devices/28-041591c4d8ff/w1_slave  | grep "t=" | cut -f2 -d=)
OUTSIDE=$(/usr/bin/python -c "print ${T} * 9/5000.0 + 32")

T=$(cat /sys/bus/w1/devices/28-0415a4e882ff/w1_slave  | grep "t=" | cut -f2 -d=)
GARAGE=$(/usr/bin/python -c "print ${T} * 9/5000.0 + 32")

T=$(cat /sys/bus/w1/devices/28-0415a4f05dff/w1_slave  | grep "t=" | cut -f2 -d=)
INSIDE=$(/usr/bin/python -c "print ${T} * 9/5000.0 + 32")

# Radio Thermostat of America Thermostat
T=$(curl -s http://thermostat/tstat)
UPSTAIRS=$(echo ${T} | jq -r ".temp")
TARGET_TEMP=$(echo ${T} | jq -r ".t_heat")
FURNACE=$(echo ${T} | jq -r ".tstate")

# Prometheus
/bin/cat <<EOF | /usr/bin/curl --data-binary @- $GATEWAY
cascade_temp{label="outside"} ${OUTSIDE}
cascade_temp{label="garage"} ${GARAGE}
cascade_temp{label="inside"} ${INSIDE}
cascade_temp{label="upstairs"} ${UPSTAIRS}
cascade_temp{label="target"} ${TARGET_TEMP}
cascade_furnace{label="on"} ${FURNACE}
EOF
