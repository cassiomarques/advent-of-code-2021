defmodule AdventOfCode.Day1 do
  def run(input_path) do
    measurements_from(input_path)
    |> to_windows()
    |> count_increases()
  end

  defp measurements_from(input_path) do
    lines_from_file(input_path) |> Enum.map(&Integer.parse/1) |> Enum.map(&elem(&1, 0))
  end

  def lines_from_file(input_path) do
    File.read!(input_path)
    |> String.split("\n", trim: true)
  end

  defp to_windows([first, second, third | rest]) do
    [first + second + third | to_windows([second, third] ++ rest)]
  end

  defp to_windows([_, _]), do: []

  defp count_increases(measurements) do
    measurements
    |> Enum.with_index()
    |> Enum.count(fn {m, index} ->
      next = Enum.at(measurements, index + 1)

      next && m < next
    end)
  end
end
