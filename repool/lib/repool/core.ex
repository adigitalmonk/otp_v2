defmodule Repool.Core do
  def new(string \\ "42") when is_binary(string) do
    String.to_integer(string)
  end

  def add(state, number) do
    state + number
  end

  def get(state) do
    "The Count is #{state}"
  end
end
