#!/usr/bin/env python3
"""Example dummy modbus server.

Serves holding registers 0-63.

Register 10 is a 1Hz counter.
"""

import asyncio
import signal
import logging

from pymodbus.server import StartAsyncTcpServer as StartServer
from pymodbus.datastore import ModbusSequentialDataBlock, ModbusSlaveContext, ModbusServerContext

async def main():
    loop = asyncio.get_running_loop()

    reg = ModbusSequentialDataBlock(0, list(range(65)))
    # BUG?  pymodbus 3.0.0 remote register 0 is offset 1 in DataBlock
    # so initialize addresses 0 -> 63 with values 1 -> 64

    async def ticker():
        count = 0
        while True:
            await asyncio.sleep(1.0)
            reg.setValues(1+10, count) # base address off-by-one :(
            count = (count + 1) & 0xffff

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
