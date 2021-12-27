defmodule AdventOfCode.Day2Test do
  use ExUnit.Case, async: true

  @path "test/support/day_2_sample"

  test "correctly calculates final position multiplication" do
    assert AdventOfCode.Day2.run(@path) == 900
  end
end
