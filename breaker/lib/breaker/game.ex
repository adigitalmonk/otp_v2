defmodule Breaker.Game do
  alias Breaker.Score

  defstruct [:answer, :move_history]

  @type t :: %__MODULE__{
          answer: list(integer()),
          move_history: list(list(integer()))
        }

  @default_game_length 10

  @spec new(list() | nil) :: t()
  def new(answer \\ nil)

  def new(nil) do
    1..8 |> Enum.take_random(4) |> new()
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

  def humanize(%__MODULE__{answer: answer, move_history: [answer | _rest]}) do
    "YOU WIN"
  end

  def humanize(%__MODULE__{move_history: history})
      when length(history) >= @default_game_length do
    "YOU LOSE"
  end

  def humanize(%__MODULE__{answer: answer, move_history: history}) do
    history
    |> Enum.map(fn move ->
      score =
        move
        |> Score.new(answer)
        |> Score.humanize()

      # convert score with score function
      ~s/#{Enum.join(move, " | ")} : #{score}/
    end)
    |> Enum.join("\n")
  end
end
