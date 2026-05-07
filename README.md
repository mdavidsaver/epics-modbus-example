# Example EPICS IOC with ModbusTCP driver

An example of an EPICS IOC using the modbus driver to communicate
with a simulation modbus server/device.

This example shows a situation where the IOC holds the authoritative
value for all setting records.
This value is re-written to the device each time the TCP connection
is re-established.

# Requirements

Tested with Debian 12 on amd64 host.

```sh
sudo apt-get install git build-essential libreadline-dev python3-pymodbus
```

... or

Tested with Rocky Linux 8

```sh
sudo dnf install git glibc make readline-devel python3-virtualenv
virtualenv venv
./venv/bin/pip install 'pymodbus~=3.8.0' 'numpy~=2.2.4'
. venv/bin/activate
```

# Setup

```sh
git clone --recursive https://github.com/mdavidsaver/epics-modbus-example
cd epics-modbus-example
./build.sh -j2
```

# Run

In one terminal, run the simulation server.

```sh
cd epics-modbus-example
./modbus-server.py
```

In another terminal, run the IOC.

```sh
cd epics-modbus-example/ioc/iocBoot/iocexample
./st.cmd
```

In a third terminal run a client

```sh
cd epics-modbus-example
./epics-base/bin/*/camonitor TST:Pls:Flt-Sts TST:P:3-I
```
