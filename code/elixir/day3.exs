defmodule Day3 do
  def run(arg) do
    scores =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("", trim: true)

    File.read!(arg)
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.filter(fn val -> val != [""] end)
    |> Enum.map(fn [list1, list2, list3] ->
      seperated_1 = list1 |> String.split("", trim: true) |> Enum.uniq()
      seperated_2 = list2 |> String.split("", trim: true) |> Enum.uniq()
      seperated_3 = list3 |> String.split("", trim: true) |> Enum.uniq()

      not_repeated =
        seperated_1
        |> Enum.filter(fn val ->
          Enum.member?(seperated_2, val) and Enum.member?(seperated_3, val)
        end)

      not_repeated |> Enum.at(0)
    end)
    |> IO.inspect()
    |> Enum.map(fn char ->
      Enum.find_index(scores, &(&1 == char)) + 1
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

[arg | _] = System.argv()
Day3.run(arg)
