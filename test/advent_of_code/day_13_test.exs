defmodule AdventOfCode.Day13Test do
  use ExUnit.Case, async: true

  @path "test/support/day_13_sample"

  test "finds the number of points after the first fold" do
    assert AdventOfCode.Day13.run_first_fold(@path) == 17
  end
end
