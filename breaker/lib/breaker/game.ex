defmodule Breaker.Game do
  # alias Breaker.Score

  defstruct [:answer, :move_history]

  @type t :: %__MODULE__{
          answer: list(integer()),
          move_history: list(list(integer()))
        }

  @default_game_length 10

  @spec new(list()) :: __MODULE__.t()
  def new(answer \\ nil)

  def new(nil) do
    new(Enum.map(1..4, fn _ -> Enum.random(1..8) end))
  end

  def new(answer) when is_list(answer) do
    %__MODULE__{
      answer: answer,
      move_history: []
    }
  end

  def move(%__MODULE__{move_history: history} = game_struct, move)
      when is_list(move) and length(history) < @default_game_length do
    Map.put(game_struct, :move_history, [move | history])
  end

  def move(game_struct, _), do: game_struct

  def humanize(%__MODULE__{answer: answer, move_history: [head | _rest]})
      when head == answer do
    "YOU WIN"
  end

  def humanize(%__MODULE__{move_history: history})
      when length(history) >= @default_game_length do
    "YOU LOSE"
  end

  def humanize(%__MODULE__{answer: _answer, move_history: history}) do
    history
    |> Enum.map(fn _move ->
      # move
      # |> Score.new
      # |> Score.covnert
      # convert score with score function
      "Score would go here"
    end)
    |> Enum.join("\n")
  end
end
