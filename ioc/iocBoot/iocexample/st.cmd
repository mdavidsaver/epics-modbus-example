#!../../bin/linux-x86_64/mbus

epicsEnvSet("DEVICE_ADDR", "127.0.0.1:5020")
epicsEnvSet("DEVICE_POLL", "100") # polling interval (ms)
epicsEnvSet("DEVICE_TIMEOUT", "70") # ms

epicsEnvSet("EPICS_DB_INCLUDE_PATH", "../../db")

## Register all support components
dbLoadDatabase "../../dbd/mbus.dbd"
mbus_registerRecordDeviceDriver(pdbbase) 

# Configure communication with a server
drvAsynIPPortConfigure("DEV", "$(DEVICE_ADDR)")
asynSetOption("DEV",0, "disconnectOnReadTimeout", "Y")
modbusInterposeConfig("DEV", 0, $(DEVICE_TIMEOUT))

# Configure register range(s)
# read holding register -> code 3
drvModbusAsynConfigure("DEV_HR", "DEV", 0, 3, 0, 64, 0, $(DEVICE_POLL))

dbLoadRecords("modbus-server.db", "PORT=DEV_HR,P=TST:")

iocInit()
