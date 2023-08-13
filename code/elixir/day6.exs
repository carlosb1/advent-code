defmodule Day6 do
  def run(arg, window_size) do
    content =
      File.read!(arg)
      |> String.trim("\n")
      |> String.split("", trim: true)

    content
    |> Enum.with_index()
    |> Enum.filter(fn {val, i} ->
      init = i - window_size

      if init >= 0 do
        sliced = content |> Enum.slice(init, window_size)
        sliced |> length == sliced |> Enum.uniq() |> length
      else
        false
      end
    end)
    |> List.first()
    |> IO.inspect()
  end
end

[arg | _] = System.argv()
Day6.run(arg, 14)
