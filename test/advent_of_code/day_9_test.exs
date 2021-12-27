defmodule AdventOfCode.Day9Test do
  use ExUnit.Case, async: true

  @path "test/support/day_9_sample"

  test "correctly finds the 3 biggest basins and multiplies their sizes" do
    assert AdventOfCode.Day9.run(@path) == 1134
  end
end
