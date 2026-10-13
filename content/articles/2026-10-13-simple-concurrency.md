---
title = "Simple Concurrency"
date = "2026-10-13"
description = "Random concurrency tip that I use pretty frequently at my jobs"
---

This is a bit of a random one but I often run into this issue where I need to ETL data out of postgress and reformat it and put it somewhere else. Our databases can run quite large so you can't really do the Repo.all variants without blowing up the pool so instead I leverage something like this:

```elixir
defmodule MyApp.StreamETL do
  @batch_size 500
  @stream_concurrency 4

  defp worker(parent, params, aggregate) do
    receive do
      {:batch, rows} ->
        aggregate = process_batch(rows, params, aggregate)
        send(parent, {:ack, self(), aggregate})
        worker(parent, params, aggregate)

      :done ->
        aggregate
    end
  end

  # Your ETL / reformatting work goes here
  defp process_batch(rows, _params, aggregate) do
    Enum.reduce(rows, aggregate, fn row, acc -> [row | acc] end)
  end

  defp stream_data(params, pids) do
    params
    # Can be any query function
    |> build_query()
    |> Repo.stream(max_rows: @batch_size)
    |> Stream.chunk_every(@batch_size)
    |> Enum.reduce({0, pids, []}, &dispatch_stream_batch/2)
    |> drain_stream_batches()
  end

  defp dispatch_stream_batch(batch, {in_flight, free, acc}) do
    # Block until a worker is free (backpressure)
    {in_flight, free, acc} =
      receive_stream_acks(in_flight, free, acc, @stream_concurrency - 1)

    [worker_pid | free] = free
    send(worker_pid, {:batch, batch})
    {in_flight + 1, free, acc}
  end

  defp drain_stream_batches({in_flight, free, acc}) do
    receive_stream_acks(in_flight, free, acc, 0)
  end

  defp receive_stream_acks(in_flight, free, acc, max_in_flight)
       when in_flight <= max_in_flight do
    {in_flight, free, acc}
  end

  defp receive_stream_acks(in_flight, free, acc, max_in_flight) do
    receive do
      {:ack, worker_pid, _worker_acc} ->
        receive_stream_acks(in_flight - 1, [worker_pid | free], acc, max_in_flight)
    end
  end

  # --- script / entrypoint ---

  def run(params) do
    parent = self()

    # Spin up workers up to whatever concurrency you can tolerate
    workers =
      Enum.map(1..@stream_concurrency, fn _ ->
        Task.async(fn -> worker(parent, params, []) end)
      end)

    # Repo.stream must run inside a transaction
    Repo.transaction(
      fn -> stream_data(params, Enum.map(workers, & &1.pid)) end,
      timeout: :infinity
    )

    Enum.each(workers, &send(&1.pid, :done))
    Enum.map(workers, &Task.await(&1, :infinity))
  end
end
```

How it works is that it sends messages from the stream results to the top level processor and each one goes until it hits a :done atom. At that point all the results are then returned. You can optionally ignore all the results or refactor to write somewhere else like another process etc etc. Very versatile. Anyways that's all for now.