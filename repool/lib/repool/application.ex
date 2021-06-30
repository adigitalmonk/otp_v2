defmodule Repool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.inspect("starting", label: :supervisor)

    children = [
      # Starts a worker by calling: Repool.Worker.start_link(arg)
      {DynamicSupervisor, strategy: :one_for_one, name: Repool.DynamicSupervisor}
      # {Repool.Server, {"0", :sara}},
      # {Repool.Server, {"1", :brad}},
      # {Repool.Server, {"42", :bruce}},
      # {Repool.Server, {"2", :jason}},
      # {Repool.Server, {"24", :kaleb}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: Repool.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
