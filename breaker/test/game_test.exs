defmodule Breaker.GameTest do
  use ExUnit.Case
  alias Breaker.Game

  def create_game(opts) do
    known_input = opts[:input] || [1, 1, 1, 1]
    known_game = Game.new(known_input)
    %{game: known_game}
  end

  def assert_key(map, key, expected) do
    assert Map.get(map, key) == expected
    map
  end

  def assert_guess(%{move_history: []} = map, []) do
    map
  end

  def assert_guess(%{move_history: [latest | _rest]} = map, expected) do
    assert latest == expected
    map
  end

  def assert_humanize(game, expected) do
    assert Game.humanize(game) == expected
    game
  end

  describe "Full Scenario" do
    test "Steps through an entire game successfully" do
      [1, 2, 3, 4]
      |> Game.new()
      |> assert_key(:answer, [1, 2, 3, 4])
      |> assert_guess([])
      |> assert_humanize("")
      |> Game.move([4, 3, 2, 1])
      |> assert_guess([4, 3, 2, 1])
      |> assert_humanize("4 | 3 | 2 | 1 : wwww")
      |> Game.move([5, 6, 7, 8])
      |> assert_guess([5, 6, 7, 8])
      |> assert_humanize("5 | 6 | 7 | 8 : \n4 | 3 | 2 | 1 : wwww")
      |> Game.move([9, 4, 2, 7])
      |> assert_guess([9, 4, 2, 7])
      |> assert_humanize("9 | 4 | 2 | 7 : ww\n5 | 6 | 7 | 8 : \n4 | 3 | 2 | 1 : wwww")
      |> Game.move([1, 2, 3, 4])
      |> assert_guess([1, 2, 3, 4])
      |> assert_humanize("YOU WIN")
    end

    test "You lose after 10 incorrect answers" do
      initial_game = Game.new([1, 2, 3, 4])

      Stream.repeatedly(fn -> [1, 1, 1, 1] end)
      |> Enum.take(10)
      |> Enum.reduce(initial_game, &Game.move(&2, &1))
      |> assert_humanize("YOU LOSE")
    end
  end

  describe "Construct" do
    test "New creates a game structure" do
      answer = [1, 2, 3, 4]

      assert %Game{answer: ^answer, move_history: []} = Game.new(answer)
    end
  end

  describe "Reduce" do
    setup [:create_game]

    test "Move adds move to head of list" do
      move = [1, 2, 3, 4]
      move2 = [2, 3, 4, 5]

      %Game{move_history: history} =
        Game.new()
        |> Game.move(move)
        |> Game.move(move2)

      assert history == [move2, move]
    end

    test "Game history never exceeds the default limit", %{game: known_game} do
      %Game{move_history: move_history} =
        1..40
        |> Enum.reduce(known_game, fn _, acc ->
          Game.move(acc, [2, 2, 2, 2])
        end)

      assert 10 = length(move_history)
    end
  end

  describe "Convert" do
    setup [:create_game]

    test "Humanize returns Lose Status", %{game: known_game} do
      game =
        known_game
        |> Enum.reduce(1..10, fn _, acc ->
          Game.move(acc, [2, 2, 2, 2])
        end)

      assert "YOU LOSE" = Game.humanize(game)
    end

    test "Humanize returns Win Status", %{game: known_game} do
      assert "YOU WIN" =
               known_game
               |> Game.move([1, 1, 1, 1])
               |> Game.humanize()
    end
  end
end
