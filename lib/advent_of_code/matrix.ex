defmodule AdventOfCode.Matrix do
  def at(matrix, {i, j}), do: at(matrix, i, j)

  def at(matrix, i, j) do
    row = Enum.at(matrix, i)
    if row, do: Enum.at(row, j), else: nil
  end

  def update_at(matrix, {i, j}, function), do: update_at(matrix, i, j, function)

  def update_at(matrix, i, j, function) do
    matrix
    |> List.update_at(i, fn row ->
      row
      |> List.update_at(j, function)
    end)
  end
end
