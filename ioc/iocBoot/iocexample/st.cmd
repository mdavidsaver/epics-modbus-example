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
# modbus function codes:
#  3 - read holder registers
#  6 - write single register

drvModbusAsynConfigure("DEV_R_0001", "DEV", 0, 3,    1, 125, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_R_0125", "DEV", 0, 3,  125, 125, 0, $(DEVICE_POLL))

drvModbusAsynConfigure("DEV_R_0251", "DEV", 0, 3,  251, 125, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_R_0376", "DEV", 0, 3,  376, 125, 0, $(DEVICE_POLL))

drvModbusAsynConfigure("DEV_R_0501", "DEV", 0, 3,  501, 125, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_R_0626", "DEV", 0, 3,  626, 125, 0, $(DEVICE_POLL))

drvModbusAsynConfigure("DEV_R_0751", "DEV", 0, 3,  751, 125, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_R_0876", "DEV", 0, 3,  876, 125, 0, $(DEVICE_POLL))

drvModbusAsynConfigure("DEV_R_2000", "DEV", 0, 3, 2000, 8, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_W_2000", "DEV", 0, 6, 2000, 8, 0, 0)

drvModbusAsynConfigure("DEV_R_3000", "DEV", 0, 3, 3000, 8, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_W_3000", "DEV", 0, 6, 3000, 8, 0, 0)

drvModbusAsynConfigure("DEV_R_4000", "DEV", 0, 3, 4000, 9, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_W_4000", "DEV", 0, 6, 4000, 9, 0, 0)

drvModbusAsynConfigure("DEV_R_5000", "DEV", 0, 3, 5000, 3, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_W_5000", "DEV", 0, 6, 5000, 3, 0, 0)

drvModbusAsynConfigure("DEV_R_5100", "DEV", 0, 3, 5100, 7, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_W_5100", "DEV", 0, 6, 5100, 7, 0, 0)

drvModbusAsynConfigure("DEV_R_5200", "DEV", 0, 3, 5200, 7, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_W_5200", "DEV", 0, 6, 5200, 7, 0, 0)

drvModbusAsynConfigure("DEV_R_5300", "DEV", 0, 3, 5300, 8, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_W_5300", "DEV", 0, 6, 5300, 8, 0, 0)

drvModbusAsynConfigure("DEV_R_5400", "DEV", 0, 3, 5400, 8, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_W_5400", "DEV", 0, 6, 5400, 8, 0, 0)

drvModbusAsynConfigure("DEV_R_6000", "DEV", 0, 3, 6000, 2, 0, $(DEVICE_POLL))
drvModbusAsynConfigure("DEV_W_6000", "DEV", 0, 6, 6000, 2, 0, 0)

dbLoadRecords("modbus-server.db", "PORT=DEV_HR,P=TST:")

iocInit()
