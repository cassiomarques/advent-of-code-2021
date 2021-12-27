defmodule AdventOfCode.Day9 do
  alias AdventOfCode.Utils

  def run(path) do
    heightmap =
      path
      |> File.read!()
      |> String.trim("\n")
      |> String.split("\n")
      |> Enum.map(fn row ->
        String.split(row, "")
        |> Enum.reject(fn c -> c == "" end)
        |> Enum.map(&(Integer.parse(&1) |> elem(0)))
      end)

    low_points =
      heightmap
      |> find_low_points()

    heightmap
    |> find_3_biggest_basins(low_points)
    |> multiply_basin_sizes()
  end

  # A basin is an area made of locations that all flow
  # down towards a low point, meaning that the locations
  # at the border have a greater height than its neighbouring
  # locations in the direction of the lower point
  #
  # To find the basin we need to start moving outwards
  # from a low point in all four directions until the next
  # position is greater than the current.
  defp find_3_biggest_basins(heightmap, low_points) do
    find_basins(heightmap, low_points)
    |> Enum.sort(fn x, y -> Enum.count(x) > Enum.count(y) end)
    |> Enum.take(3)
  end

  defp find_basins(heightmap, low_points, basins \\ [])
  defp find_basins(_heightmap, [], basins), do: basins

  defp find_basins(heightmap, [low_point | low_points], basins) do
    basin = [low_point | find_basin_for(heightmap, low_point)]

    find_basins(heightmap, low_points, [basin | basins])
  end

  defp find_basin_for(heightmap, {location, i, j}, direction \\ :none, basin \\ []) do
    up = {:up, point_at(heightmap, i - 1, j)}
    right = {:right, point_at(heightmap, i, j + 1)}
    down = {:down, point_at(heightmap, i + 1, j)}
    left = {:left, point_at(heightmap, i, j - 1)}

    directions_to_follow =
      case direction do
        :up -> [up, right, left]
        :right -> [up, right, down]
        :down -> [down, left, right]
        :left -> [up, left, down]
        :none -> [up, right, down, left]
      end

    directions_to_follow
    |> Enum.reject(fn {_new_direction, point} -> is_nil(point) end)
    |> Enum.reduce(basin, fn {new_direction, point}, new_basin ->
      if elem(point, 0) > location && elem(point, 0) < 9 do
        [point | new_basin] ++ find_basin_for(heightmap, point, new_direction, [])
      else
        new_basin
      end
    end)
    |> Enum.uniq()
  end

  defp point_at(_heightmap, i, j) when i < 0 or j < 0, do: nil

  defp point_at(heightmap, i, j) do
    row = Enum.at(heightmap, i)

    if row do
      location = Enum.at(row, j)
      if location, do: {location, i, j}, else: nil
    else
      nil
    end
  end

  defp multiply_basin_sizes(basins) do
    Enum.reduce(basins, 1, fn b, total -> total * Enum.count(b) end)
  end

  defp find_low_points(heightmap) do
    heightmap
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, row_index}, low_points_lists ->
      low_points_in_row =
        row
        |> Enum.with_index()
        |> Enum.reduce([], fn {location, column_index}, low_points ->
          if low_point?(location, heightmap, row_index, column_index) do
            [{location, row_index, column_index} | low_points]
          else
            low_points
          end
        end)

      [low_points_in_row | low_points_lists]
    end)
    |> List.flatten()
  end

  defp low_point?(location, heightmap, row_index, column_index) do
    # 10 is used when location is on an edge or corner and some of the adjacent points don't actually exist
    location < up_location(heightmap, row_index, column_index) &&
      location < right_location(heightmap, row_index, column_index) &&
      location < down_location(heightmap, row_index, column_index) &&
      location < left_location(heightmap, row_index, column_index)
  end

  defp up_location(heightmap, row_index, column_index) do
    Utils.at(heightmap, row_index - 1, column_index) || 10
  end

  defp right_location(heightmap, row_index, column_index) do
    Utils.at(heightmap, row_index, column_index + 1) || 10
  end

  defp down_location(heightmap, row_index, column_index) do
    Utils.at(heightmap, row_index + 1, column_index) || 10
  end

  def left_location(heightmap, row_index, column_index) do
    Utils.at(heightmap, row_index, column_index - 1) || 10
  end
end
