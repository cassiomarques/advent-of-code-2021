defmodule AdventOfCode.Day7Test do
  use ExUnit.Case, async: true

  @path "test/support/day_7_sample"

  test "calculates the minimum amount of fuel needed to align all crabs" do
    assert AdventOfCode.Day7.run(@path) == 168
  end
end
