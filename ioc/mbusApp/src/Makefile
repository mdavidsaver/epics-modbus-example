# SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#
# SPDX-License-Identifier: EPICS

TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = mbus
# mbus.dbd will be created and installed
DBD += mbus.dbd

# mbus.dbd will be made up from these files:
mbus_DBD += base.dbd

# Include dbd files from all support applications:
mbus_DBD += modbusSupport.dbd
mbus_DBD += asyn.dbd drvAsynIPPort.dbd

# Add all the support libraries needed by this IOC
mbus_LIBS += asyn
mbus_LIBS += modbus

# mbus_registerRecordDeviceDriver.cpp derives from mbus.dbd
mbus_SRCS += mbus_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
mbus_SRCS_DEFAULT += mbusMain.cpp
mbus_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#mbus_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
mbus_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

