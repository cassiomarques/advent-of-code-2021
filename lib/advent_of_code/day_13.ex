defmodule AdventOfCode.Day13 do
  def run(path) do
    [points_section, folds_section] =
      path
      |> File.read!()
      |> String.split("\n\n")

    points =
      points_section
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [x, y] =
          line
          |> String.split(",", trim: true)

        {String.to_integer(x), String.to_integer(y)}
      end)

    folds =
      folds_section
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [direction, position] =
          Regex.run(~r/(?<direction>[xy])=(?<position>\d+)/, line, capture: :all_but_first)

        {direction, String.to_integer(position)}
      end)

    fold_paper(points, folds)
    |> print_points()
  end

  defp fold_paper(points, []), do: points |> Enum.uniq() |> print_points()

  defp fold_paper(points, [{"x", position} | remaining_folds]) do
    new_points =
      points
      |> Enum.map(fn point -> fold_left(point, position) end)

    min_x = new_points |> Enum.map(fn {x, _y} -> x end) |> Enum.min()
    new_points = Enum.map(new_points, fn {x, y} -> {x - min_x, y} end)

    fold_paper(new_points, remaining_folds)
  end

  defp fold_paper(points, [{"y", position} | remaining_folds]) do
    new_points =
      points
      |> Enum.map(fn point -> fold_up(point, position) end)

    fold_paper(new_points, remaining_folds)
  end

  defp fold_up({x, y}, fold_position) do
    if y > fold_position do
      {x, y + 2 * (fold_position - y)}
    else
      {x, y}
    end
  end

  def fold_left({x, y}, fold_position) do
    if x < fold_position do
      {x + 2 * (fold_position - x), y}
    else
      {x, y}
    end
  end

  defp print_points(points) do
    max_x = Enum.map(points, fn {x, _y} -> x end) |> Enum.max()
    max_y = Enum.map(points, fn {_x, y} -> y end) |> Enum.max()

    points_map =
      points
      |> Enum.reduce(%{}, fn p, m ->
        Map.put(m, p, true)
      end)

    0..max_y
    |> Enum.each(fn y ->
      # Going backwards here because the ascending order was printing the code "mirrored",
      # so this makes it easier to read...
      max_x..0
      |> Enum.each(fn x ->
        IO.write(if points_map[{x, y}], do: "#", else: ".")
      end)

      IO.puts("")
    end)
  end
end
