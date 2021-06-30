defmodule Breaker do
  use GenServer

  alias Breaker.Game

  def move(game \\ __MODULE__, move) do
    GenServer.call(game, {:move, move}) |> IO.puts()
  end

  def start_link(opts) do
    name = opts[:name] || __MODULE__
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @impl true
  def init(opts) do
    {:ok, Game.new(opts[:answer], opts)}
  end

  @impl true
  def handle_call({:move, move}, _from, game) do
    game = Game.move(game, move)
    {:reply, Game.humanize(game), game}
  end
end
