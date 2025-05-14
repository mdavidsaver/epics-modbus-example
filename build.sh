#!/bin/sh
set -e -x

cat <<EOF > asyn/configure/RELEASE.local
EPICS_BASE=\$(TOP)/../epics-base
EOF

cat <<EOF > modbus/configure/RELEASE.local
ASYN=\$(TOP)/../asyn
EPICS_BASE=\$(TOP)/../epics-base
EOF

cat <<EOF > ioc/configure/RELEASE.local
MODBUS=\$(TOP)/../modbus
ASYN=\$(TOP)/../asyn
EPICS_BASE=\$(TOP)/../epics-base
EOF

make -C epics-base "$@"
make -C asyn "$@"
make -C modbus "$@"
make -C ioc "$@"
