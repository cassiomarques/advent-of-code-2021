defmodule AdventOfCode.Day5Test do
  use ExUnit.Case, async: true

  @path "test/support/day_5_sample"

  test "correctly calculates the number of points where at least 2 lines overlap" do
    assert AdventOfCode.Day5.run(@path) == 12
  end
end
