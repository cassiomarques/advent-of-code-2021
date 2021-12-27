defmodule AdventOfCode.Day2 do
  def run(input_path) do
    commands_from(input_path)
    |> position()
    |> multiply_position()
  end

  defp commands_from(input_path) do
    input_path
    |> lines_from_file()
    |> Enum.map(&split_line/1)
  end

  def lines_from_file(input_path) do
    File.read!(input_path)
    |> String.split("\n", trim: true)
  end

  defp split_line(line) do
    [direction, n] = String.split(line, " ")
    {direction, Integer.parse(n) |> elem(0)}
  end

  defp position([_head | _tail] = list) do
    position(list, {0, 0, 0})
  end

  defp position([], current), do: current

  defp position([head | tail], current) do
    new_position = calculate_new_position(head, current)

    position(tail, new_position)
  end

  defp calculate_new_position({direction, n}, {horizontal, depth, aim}) do
    case direction do
      "down" -> {horizontal, depth, aim + n}
      "up" -> {horizontal, depth, aim - n}
      "forward" -> {horizontal + n, depth + aim * n, aim}
      _ -> {horizontal, depth}
    end
  end

  defp multiply_position({horizontal, depth, _aim}) do
    horizontal * depth
  end
end
