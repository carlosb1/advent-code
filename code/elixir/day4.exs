defmodule Day4 do
  def is_range_a_in_range_b({init_r1, end_r1}, {init_r2, end_r2}) do
    init_r1 >= init_r2 and init_r1 <= end_r2 and end_r1 >= init_r2 and end_r1 <= end_r2
  end

  def is_range_a_in_range_b_in_some_range({init_r1, end_r1}, {init_r2, end_r2}) do
    (init_r1 >= init_r2 and init_r1 <= end_r2) or (end_r1 >= init_r2 and end_r1 <= end_r2)
  end

  def run(arg) do
    File.read!(arg)
    |> String.split("\n")
    |> Enum.filter(fn val -> val != "" end)
    |> Enum.map(fn elem ->
      [first_elf | [second_elf | _]] = elem |> String.split(",")
      [init_first_elf | [end_first_elf | _]] = first_elf |> String.split("-")
      [init_second_elf | [end_second_elf | _]] = second_elf |> String.split("-")
      {{init_first_elf, end_first_elf}, {init_second_elf, end_second_elf}}
    end)
    |> Enum.map(fn {{init_r1, end_r1}, {init_r2, end_r2}} ->
      {init_r1, _} = init_r1 |> Integer.parse()
      {end_r1, _} = end_r1 |> Integer.parse()
      {init_r2, _} = init_r2 |> Integer.parse()
      {end_r2, _} = end_r2 |> Integer.parse()
      {{init_r1, end_r1}, {init_r2, end_r2}}
    end)
    |> Enum.filter(fn {range1, range2} ->
      Day4.is_range_a_in_range_b_in_some_range(range1, range2) or
        Day4.is_range_a_in_range_b_in_some_range(range2, range1)
    end)
    |> Enum.count()
    |> IO.inspect(label: :total)
  end
end

[arg | _] = System.argv()
Day4.run(arg)
