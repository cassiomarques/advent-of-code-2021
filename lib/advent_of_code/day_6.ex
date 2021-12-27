defmodule AdventOfCode.Day6BruteForce do
  def run(path, days) do
    path
    |> prepare_school()
    |> simulate(days)
    |> length()
  end

  defp prepare_school(path) do
    path
    |> File.read!()
    |> String.trim("\n")
    |> String.split(",")
    |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)
  end

  # Brute force solution
  defp simulate(school, days) do
    1..days
    |> Enum.reduce(school, fn _day, new_school ->
      new_school
      |> Enum.map(fn fish_timer ->
        if fish_timer == 0 do
          [6, 8]
        else
          fish_timer - 1
        end
      end)
      |> List.flatten()
    end)
  end
end

defmodule AdventOfCode.Day6Fast do
  def run(path, days) do
    path
    |> prepare_school()
    |> simulate(days)
    |> Map.values()
    |> Enum.sum()
  end

  defp prepare_school(path) do
    path
    |> File.read!()
    |> String.trim("\n")
    |> String.split(",")
    |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)
  end

  # Faster solution
  defp simulate(school, days) when is_list(school) do
    timer_counts =
      0..8
      |> Enum.reduce(%{}, fn timer, counts ->
        Map.put(counts, timer, Enum.count(school, fn x -> x == timer end))
      end)

    simulate(days, timer_counts)
  end

  defp simulate(0, timer_counts), do: timer_counts

  defp simulate(days, timer_counts) when is_integer(days) do
    timer_counts = %{
      0 => timer_counts[1],
      1 => timer_counts[2],
      2 => timer_counts[3],
      3 => timer_counts[4],
      4 => timer_counts[5],
      5 => timer_counts[6],
      6 => timer_counts[0] + timer_counts[7],
      7 => timer_counts[8],
      8 => timer_counts[0]
    }

    simulate(days - 1, timer_counts)
  end
end
