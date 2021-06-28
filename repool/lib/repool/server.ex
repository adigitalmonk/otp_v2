defmodule Repool.Server do
  use GenServer

  alias Repool.Core, as: Counter

  def inc(), do: GenServer.cast(:repool_counter, :inc)

  def dec(), do: GenServer.cast(:repool_counter, :dec)

  def get(), do: GenServer.call(:repool_counter, :get)

  def boom(), do: GenServer.cast(:repool_counter, :boom)

  def start_link(state) when is_binary(state) do
    GenServer.start_link(__MODULE__, state, name: :repool_counter)
  end

  @impl true
  def init(state), do: {:ok, Counter.new(state)}

  @impl true
  def handle_cast(:inc, state), do: {:noreply, Counter.add(state, 1)}
  def handle_cast(:dec, state), do: {:noreply, Counter.add(state, -1)}

  def handle_cast(:boom, _state) do
    raise "sent to join the dead"
  end

  @impl true
  def handle_call(:get, _from, state), do: {:reply, Counter.get(state), state}
end
