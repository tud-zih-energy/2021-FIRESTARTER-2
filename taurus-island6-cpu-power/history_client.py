#!/usr/bin/env python3

import asyncio
from datetime import timedelta
import pickle
import metricq
from metricq.history_client import HistoryRequestType
from uuid import uuid4

TOKEN="fs20paper"
SERVER="***REDACT***"

BINS_PER_W=10

class Counter(dict):
    def __missing__(self, key):
        return 0

async def aget_history(server, token, metric):
    pwr_cntr = Counter()

    client = metricq.HistoryClient(token=f"{token}-{uuid4()}", management_url=server, event_loop=asyncio.get_running_loop())

    total_begin = metricq.Timestamp.from_iso8601("2018-01-01T00:00:00.0Z")
    total_end = metricq.Timestamp.from_iso8601("2019-01-01T00:00:00.0Z")
    chunk_duration = metricq.Timedelta.from_timedelta(timedelta(days=7))
    interval_max = metricq.Timedelta.from_timedelta(timedelta(seconds=60))

    await client.connect()

    chunk_begin = total_begin
    while chunk_begin < total_end:
        chunk_end = chunk_begin + chunk_duration
        chunk_end = min(chunk_end, total_end)
        print(f"Requesting chunk from {chunk_begin} to {chunk_end} of {metric}")

        result = await client.history_data_request(
            metric,
            start_time=chunk_begin,
            end_time=chunk_end,
            interval_max=interval_max,
            request_type=HistoryRequestType.AGGREGATE_TIMELINE,
            timeout=240
        )
        for aggregate in result.aggregates():
            if aggregate.timestamp < chunk_begin:
                continue
            if aggregate.count == 0:
                continue
            key = float(int(aggregate.sum / aggregate.count * BINS_PER_W) / BINS_PER_W)
            pwr_cntr[key] += 1
        chunk_begin = chunk_end

    await client.stop(None)

    return pwr_cntr

async def history_island6(server, token):
    num_nodes = 612
    cntrs = [None] * num_nodes
    cntrs_tasks = [None] * num_nodes
    for i in range(1, num_nodes + 1):
        metric = f"taurus.taurusi{6000+i}.power"
        cntrs_tasks[i-1] = asyncio.create_task(aget_history(SERVER, TOKEN, metric))

    for i in range(num_nodes):
        cntrs[i] = await cntrs_tasks[i]

    return cntrs

if __name__ == "__main__":
    cntrs = asyncio.run(history_island6(SERVER, TOKEN))

    with open('data_18_19.pickle', 'wb') as f:
        pickle.dump(cntrs, f)
