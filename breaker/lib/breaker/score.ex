defmodule Breaker.Score do
  # move: [1,2,3,4]
  # answer: [4,3,2,1]
  def new(move, answer) do
    hit = count_hit(move, answer)
    miss = count_miss(move, answer)
    near = count_near(move, hit, miss)

    %{
      hit: hit,
      near: near,
      miss: miss
    }
  end

  defp count_hit(move, answer) do
    move
    |> Enum.zip(answer)
    |> Enum.count(fn {x, y} -> x == y end)
  end

  defp count_near(move, hit, miss) do
    move
    |> Enum.count()
    |> Kernel.-(hit)
    |> Kernel.-(miss)
  end

  defp count_miss(move, answer) do
    answer
    |> Kernel.--(move)
    |> Enum.count()
  end

  # output: "rrw"
  def humanize(%{hit: hit, near: near, miss: _miss}) do
    result = List.duplicate("r", hit) ++ List.duplicate("w", near)
    Enum.join(result)
  end
end
