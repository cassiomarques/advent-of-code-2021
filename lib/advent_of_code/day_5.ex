# Map based implementation
defmodule AdventOfCode.Day5 do
  def run(path) do
    lines = extract_lines(path)
    board = %{}

    board
    |> mark_lines_on_board(lines)
    |> count_overlapping_lines()
  end

  defp extract_lines(path) do
    path
    |> File.read!()
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(fn line ->
      [start_point, end_point] = String.split(line, " -> ")
      {point_from_string(start_point), point_from_string(end_point)}
    end)
  end

  defp point_from_string(string_coords) do
    string_coords
    |> String.split(",")
    |> Enum.map(fn n ->
      Integer.parse(n) |> elem(0)
    end)
  end

  defp mark_lines_on_board(board, lines) do
    lines
    |> Enum.reduce(board, fn line, current_board ->
      mark_line_on_board(line, current_board)
    end)
  end

  # 17604
  defp mark_line_on_board({[x1, y1], [x2, y2]}, board) do
    cond do
      # vertical line
      x1 == x2 ->
        y1..y2
        |> Enum.reduce(board, fn y, new_board ->
          new_count = Map.get(new_board, {x1, y}, 0) + 1
          Map.put(new_board, {x1, y}, new_count)
        end)

      # horizontal line
      y1 == y2 ->
        x1..x2
        |> Enum.reduce(board, fn x, new_board ->
          new_count = Map.get(new_board, {x, y1}, 0) + 1
          Map.put(new_board, {x, y1}, new_count)
        end)

      # diagonal line at +45º
      x1 < x2 && y1 < y2 ->
        0..(x2 - x1)
        |> Enum.reduce(board, fn counter, new_board ->
          point_key = {x1 + counter, y1 + counter}
          new_count = Map.get(new_board, point_key, 0) + 1
          Map.put(new_board, point_key, new_count)
        end)

      # diagonal at -45º
      x1 < x2 && y1 > y2 ->
        0..(x2 - x1)
        |> Enum.reduce(board, fn counter, new_board ->
          point_key = {x1 + counter, y1 - counter}
          new_count = Map.get(new_board, point_key, 0) + 1
          Map.put(new_board, point_key, new_count)
        end)

      # diagonal at +135º
      x1 > x2 && y1 < y2 ->
        mark_line_on_board({[x2, y2], [x1, y1]}, board)

      # diagonal line at +225º
      x1 > x2 && y1 > y2 ->
        mark_line_on_board({[x2, y2], [x1, y1]}, board)
    end
  end

  defp count_overlapping_lines(board) do
    board
    |> Map.values()
    |> Enum.count(&(&1 > 1))
  end
end
