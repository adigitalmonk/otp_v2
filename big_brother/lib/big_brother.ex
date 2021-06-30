defmodule BigBrother do
  def start_configured_game(name, game_type) when is_atom(name) do
    :big_brother
    |> Application.get_env(Breaker)
    |> Map.get(game_type)
    |> case do
      nil ->
        :error

      opts ->
        opts
        |> Keyword.put(:name, name)
        |> start_game()
    end
  end

  def start_game(opts) do
    {:ok, _pid} = DynamicSupervisor.start_child(BigBrother.DynamicSupervisor, {Breaker, opts})

    :ok
  end
end
