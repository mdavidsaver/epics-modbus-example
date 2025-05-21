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
./epics-base/bin/*/camonitor TST:COUNT:I
```
