defmodule BigBrother.MixProject do
  use Mix.Project

  def project do
    [
      app: :big_brother,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BigBrother.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:breaker, "0.1.0", path: "../breaker"}
    ]
  end
end
