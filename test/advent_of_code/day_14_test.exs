defmodule AdventOfCode.Day14Test do
  use ExUnit.Case, async: true

  @path_1 "test/support/day_14_sample"
  @path_2 "inputs/day-14.txt"

  test "calculates difference between most and least common elements in the polymer after 10 steps" do
    assert AdventOfCode.Day14BruteForce.run(@path_1, 10) == 1588
    assert AdventOfCode.Day14BruteForce.run(@path_2, 10) == 3342
  end

  test "calculates difference between most and least common elements in the polymer after 40 steps" do
    assert AdventOfCode.Day14Fast.run(@path_1, 10) == 1588
    assert AdventOfCode.Day14Fast.run(@path_2, 10) == 3342
    assert AdventOfCode.Day14Fast.run(@path_1, 40) == 2_188_189_693_529
    assert AdventOfCode.Day14Fast.run(@path_2, 40) == 3_776_553_567_525
  end
end
