defmodule Position do
  defstruct y: 0, x: 0

  def distance(position, compare_position) do
    :math.sqrt(
      :math.pow(position.x - compare_position.x, 2) +
        :math.pow(position.y - compare_position.y, 2)
    )
  end
end

defmodule PositionState do
  defstruct current_position: %Position{},
            tail_position: %Position{},
            list_tail_position: [],
            list_positions: []
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
        {_, steps} = input

        step_position =
          case input do
            {"U", _} -> %Position{y: 1}
            {"D", _} -> %Position{y: -1}
            {"L", _} -> %Position{x: -1}
            {"R", _} -> %Position{x: 1}
          end

        acc =
          1..steps
          |> Enum.reduce(acc, fn reduce_one_movement, acc_state_one_movement ->
            current_position = acc_state_one_movement.current_position

            new_current_position = %{
              current_position
              | y: current_position.y + step_position.y,
                x: current_position.x + step_position.x
            }

            distance =
              acc_state_one_movement.tail_position |> Position.distance(new_current_position)

            {new_tail_position, added_list_position, added_tail_positions} =
              if distance >= 2.0 do
                # here another loop for all thew new queue to review all the tails
                # the removed value must be the current option
                # siz = acc_state_one_movement.list_tail_position |> Enum.count()
                ##  added_tail_positions =
                # if siz == 9 do
                #  added_position = acc_state_one_movement.list_tail_position |> Enum.at(8)

                #  new_tail_positions =
                #    acc_state_one_movement.list_tail_position
                #    |> List.delete_at(8)
                #    |> List.insert_at(0, current_position)

                #  {current_position, [added_position], new_tail_positions}
                # else
                #  new_tail_positions =
                #    acc_state_one_movement.list_tail_position
                #    |> List.insert_at(0, current_position)

                #  {current_position, [], new_tail_positions}
                # end

                ## TODO uncomment this for part 1 and not apply if result
                {current_position, [current_position], [current_position]}
              else
                {acc_state_one_movement.tail_position, [],
                 acc_state_one_movement.list_tail_position}
              end

            # IO.inspect(distance, label: :distance)

            # add condition

            acc_state_one_movement = %{
              acc_state_one_movement
              | list_positions: acc_state_one_movement.list_positions ++ added_list_position,
                tail_position: new_tail_position,
                list_tail_position: added_tail_positions,
                current_position: new_current_position
            }

            acc_state_one_movement
          end)

        acc
      end)

    result.list_positions
    |> Enum.uniq()
    |> Enum.count()
    |> IO.inspect()
  end
end

[arg | _] = System.argv()
Day9.run(arg)
