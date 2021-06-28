defmodule Repool.Service do
  alias Repool.Core, as: Counter

  def listen(state) do
    receive do
      :inc ->
        Counter.add(state, 1)
      :dec ->
        Counter.add(state, -1)
      {:message, from} ->
        send(from, Counter.get(state))
        state
    end
  end

  def loop(state) do
    state
    |> listen()
    |> loop()
  end

  def start_link(str) do
    spawn(fn -> str |> Counter.new() |> loop() end)
  end

  def inc(counter) do
     send(counter, :inc)
  end

  def dec(counter) do
    send(counter, :dec)
  end

  def get(counter) do
    send(counter, {:message, self()})
    receive do
      count -> count
    end
  end
end
