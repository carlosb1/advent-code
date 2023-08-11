defmodule Day1 do
  def run(arg) do
    three_max_carries =
      File.read!(arg)
      |> String.split("\n\n")
      |> Enum.map(fn set_nums ->
        set_nums
        |> String.split("\n", trim: true)
        |> Enum.map(fn elem ->
          elem |> String.trim() |> String.to_integer()
        end)
        |> Enum.sum()
      end)
      |> Enum.sort()
      |> Enum.take(-3)

    three_max_carries |> IO.inspect(label: :three_max_carries)
    three_max_carries |> Enum.sum() |> IO.inspect(label: :sum_max)
  end
end

[arg1 | _] = System.argv()
Day1.run(arg1)
