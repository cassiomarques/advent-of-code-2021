defmodule AdventOfCode.Day1Test do
  use ExUnit.Case, async: true

  @path "test/support/day_1_sample"

  test "correctly calculates measurement increases" do
    assert AdventOfCode.Day1.run(@path) == 7
  end
end
