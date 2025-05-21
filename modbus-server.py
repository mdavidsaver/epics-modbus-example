#!/usr/bin/env python3
"""Example dummy modbus server.

Serves holding registers 0-63.

Register 10 is a 1Hz counter.
"""

import asyncio
import signal
import logging

import numpy as np

from pymodbus.server import StartAsyncTcpServer as StartServer
from pymodbus.datastore import ModbusSequentialDataBlock, ModbusSlaveContext, ModbusServerContext

async def main():
    loop = asyncio.get_running_loop()

    reg = ModbusSequentialDataBlock.create()
    # BUG?  pymodbus 3.0.0 remote register 0 is offset 1 in DataBlock

    T=np.arange(250)*1e-6
    reg.values[  2: 252] = (np.sin(2*np.pi*2e3*T)*10000).astype('i2')
    reg.values[252: 502] = (np.sin(2*np.pi*2e3*T)*15000).astype('i2')
    reg.values[502: 752] = (np.sin(2*np.pi*2e3*T)*20000).astype('i2')
    reg.values[751:1002] = (np.sin(2*np.pi*2e3*T)*25000).astype('i2')

    reg.values[1+3007] = 0b1000000000 # SIN_Pulser_Fault - system fault

    reg.values[1+4000] = 17*100 # SIK_T1_Measure
    reg.values[1+4002] = int(18.5*100) # SIK_T2_Measure

    async def ticker():
        status = 0
        while True:
            await asyncio.sleep(1.0)
            reg.values[1+5401] = status
            status = (status+1)%7

    ticker = asyncio.create_task(ticker())

    print('Starting')
    srv = await StartServer(
        context=ModbusServerContext(
            slaves=ModbusSlaveContext(
                # holding registers
                hr=reg,
            ),
        ),
        address=('127.0.0.1', 5020),
        allow_reuse_address=True,
        defer_start=True,
    )

    stop = asyncio.Event()
    loop.add_signal_handler(signal.SIGINT, stop.set)
    async def run():
        try:
            await srv.serve_forever()
        except asyncio.CancelledError:
            raise
        except:
            stop.set()
            logging.exception("oops")
            raise
        finally:
            await srv.shutdown()
    runner = asyncio.create_task(run())

    print('Running')
    await stop.wait()
    print('Stopping')

    for task in [runner, ticker]:
        task.cancel()
    for task in [runner, ticker]:
        try:
            await task
        except asyncio.CancelledError:
            pass
    print('Done')

if __name__=='__main__':
    asyncio.run(main())
