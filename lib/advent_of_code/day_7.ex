defmodule AdventOfCode.Day7 do
  def run(path) do
    path
    |> extract_crabs
    |> calculate_minimum_fuel
  end

  defp extract_crabs(path) do
    path
    |> File.read!()
    |> String.trim("\n")
    |> String.split(",")
    |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)
  end

  defp calculate_minimum_fuel(crabs) do
    positions = Enum.min(crabs)..Enum.max(crabs) |> Enum.into([])
    minimum_fuel(crabs, positions)
  end

  defp minimum_fuel(positions, to_calculate, current_minimum_fuel \\ 100_000_000, memo \\ %{})
  defp minimum_fuel(_positions, [], current_minimum_fuel, _memo), do: current_minimum_fuel

  defp minimum_fuel(
         positions,
         [current_position | pending_calculation],
         current_minimum_fuel,
         memo
       ) do
    new_minimum_fuel =
      if memo[current_position] do
        memo[current_position]
      else
        positions
        |> Enum.reduce_while(0, fn p, fuel ->
          distance = abs(current_position - p)
          fuel_for_move = (:math.pow(distance, 2) + distance) / 2
          new_fuel = fuel + fuel_for_move

          if new_fuel >= current_minimum_fuel do
            {:halt, new_fuel}
          else
            {:cont, new_fuel}
          end
        end)
      end

    minimum_fuel(
      positions,
      pending_calculation,
      min(new_minimum_fuel, current_minimum_fuel),
      memo
    )
  end
end
