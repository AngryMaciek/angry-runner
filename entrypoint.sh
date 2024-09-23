#!/bin/bash
echo "[INFO] angry user setup, please wait a moment..."
ID=${HOSTUID:-9001}
useradd --shell /bin/bash -u $ID -o -c "" -m angryuser
adduser angryuser conda &> /dev/null
/usr/sbin/gosu angryuser /usr/local/bin/prezto-user-setup.sh &> /dev/null
/usr/sbin/gosu angryuser /bin/bash -c "/mambaforge/bin/conda init bash &> /dev/null"
/usr/sbin/gosu angryuser /bin/bash -c "/mambaforge/bin/conda init zsh &> /dev/null"
/usr/sbin/gosu angryuser /bin/bash -c "/mambaforge/bin/conda config --set changeps1 False &> /dev/null"
exec "$@"
