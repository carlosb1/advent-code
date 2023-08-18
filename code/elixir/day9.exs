defmodule Position do
  defstruct y: 0, x: 0
end

defmodule PositionState do
  defstruct current_position: %Position{},
            list_positions: [%Position{}]
end

defmodule Day9 do
  def run(arg) do
    result =
      File.read!(arg)
      |> String.trim("\n")
      |> String.split("\n", trim: true)
      |> Enum.map(fn movement ->
        [direction, step] = movement |> String.split(" ")
        {step, _} = step |> Integer.parse()
        {direction, step}
      end)
      |> Enum.reduce(%PositionState{}, fn input, acc ->
        IO.inspect(input, label: :input)
        # IO.inspect(acc, label: :acc)

        current_position = acc.current_position

        # Checking head position
        {new_current_position, tail_steps} =
          case input do
            {"U", steps} ->
              tail_steps =
                1..(steps - 1)
                |> Enum.map(fn step -> %{current_position | y: current_position.y + step} end)

              {%{current_position | y: current_position.y + steps}, tail_steps}

            {"D", steps} ->
              tail_steps =
                1..(steps - 1)
                |> Enum.map(fn step -> %{current_position | y: current_position.y - step} end)

              {%{current_position | y: current_position.y - steps}, tail_steps}

            {"L", steps} ->
              tail_steps =
                1..(steps - 1)
                |> Enum.map(fn step -> %{current_position | x: current_position.x - step} end)

              {%{current_position | x: current_position.x - steps}, tail_steps}

            {"R", steps} ->
              tail_steps =
                1..(steps - 1)
                |> Enum.map(fn step -> %{current_position | x: current_position.x + step} end)

              {%{current_position | x: current_position.x + steps}, tail_steps}
          end

        # IO.inspect(tail_steps, label: :tail_step)

        acc = %{
          acc
          | current_position: new_current_position,
            list_positions: acc.list_positions ++ tail_steps
        }

        acc
      end)
      |> IO.inspect()

    result.list_positions
    |> Enum.uniq()
    |> IO.inspect()
    |> Enum.count()
    |> IO.inspect()
  end
end

[arg | _] = System.argv()
Day9.run(arg)
