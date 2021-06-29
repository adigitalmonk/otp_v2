defmodule Repool.Server do
  use GenServer

  alias Repool.Core, as: Counter

  def child_spec({initial, name}) do
    %{id: name, start: {Repool.Server, :start_link, [{initial, name}]}}
  end

  def inc(pid \\ :sara), do: GenServer.cast(pid, :inc)

  def dec(pid \\ :sara), do: GenServer.cast(pid, :dec)

  def get(pid \\ :sara), do: GenServer.call(pid, :get)

  def boom(pid \\ :sara), do: GenServer.cast(pid, :boom)

  def start_link({state, name}) when is_binary(state) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  @impl true
  def init(state), do: {:ok, Counter.new(state)} |> IO.inspect(label: :server)

  @impl true
  def handle_cast(:inc, state), do: {:noreply, Counter.add(state, 1)}
  def handle_cast(:dec, state), do: {:noreply, Counter.add(state, -1)}

  def handle_cast(:boom, _state) do
    raise "sent to join the dead"
  end

  @impl true
  def handle_call(:get, _from, state), do: {:reply, Counter.get(state), state}
end
