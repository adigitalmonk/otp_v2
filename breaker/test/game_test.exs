defmodule Breaker.GameTest do
  use ExUnit.Case
  alias Breaker.Game

  test "New Ceates a game structure" do
    answer = [1, 2, 3, 4]

    assert %Game{answer: ^answer, move_history: []} = Game.new(answer)
  end

  test "Move adds move to head of list" do
    move = [1, 2, 3, 4]
    move2 = [2, 3, 4, 5]

    %Game{move_history: history} =
      Game.new()
      |> Game.move(move)
      |> Game.move(move2)

    assert history == [move2, move]
  end

  test "Humanize returns Lose Status" do
    game =
      Enum.reduce(1..10, Game.new([1, 1, 1, 1]), fn _, acc -> Game.move(acc, [2, 2, 2, 2]) end)

    assert "YOU LOSE" = Game.humanize(game)
  end

  test "Humanize returns Win Status" do
    assert "YOU WIN" =
             [1, 1, 1, 1]
             |> Game.new()
             |> Game.move([1, 1, 1, 1])
             |> Game.humanize()
  end
end
