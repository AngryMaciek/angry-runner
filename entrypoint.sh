#!/bin/bash
ID=${HOSTUID:-9001}
useradd --shell /bin/bash -u $ID -o -c "" -m angryuser
export HOME=/home/angryuser
adduser angryuser conda &> /dev/null
/usr/sbin/gosu angryuser /bin/bash -c "/mambaforge/bin/conda init bash &> /dev/null"
exec "$@"
