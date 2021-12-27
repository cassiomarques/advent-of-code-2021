defmodule AdventOfCode.Utils do
  def convert_to_decimal(binary_number_string) when is_binary(binary_number_string) do
    Integer.parse(binary_number_string, 2) |> elem(0)
  end

  def convert_to_decimal({first, second}) do
    {convert_to_decimal(first), convert_to_decimal(second)}
  end

  def at(matrix, i, j) do
    row = Enum.at(matrix, i)
    if row, do: Enum.at(row, j), else: nil
  end
end
