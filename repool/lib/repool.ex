defmodule Repool do
  alias Repool.Server

  @moduledoc """
  Documentation for `Repool`.
  """

  def start_counter(count, atom_name) when is_binary(count) and is_atom(atom_name) do
    DynamicSupervisor.start_child(Repool.DynamicSupervisor, {Server, {count, atom_name}})
  end
end
