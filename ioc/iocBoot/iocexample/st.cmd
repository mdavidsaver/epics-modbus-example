#!../../bin/linux-x86_64/mbus

#- SPDX-FileCopyrightText: 2005 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change mbus to something else
#- everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase "../../dbd/mbus.dbd"
mbus_registerRecordDeviceDriver(pdbbase) 

## Load record instances
#dbLoadRecords("../../db/mbus.db","user=dev")

iocInit()

## Start any sequence programs
#seq sncmbus,"user=dev"
