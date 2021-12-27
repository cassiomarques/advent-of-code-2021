defmodule AdventOfCode.Day4Test do
  use ExUnit.Case, async: true

  @path "test/support/day_4_sample"

  test "correctly calculates the score of the first winning board" do
    assert AdventOfCode.Day4.first_winning_score(@path) == 4512
  end

  test "correctly calculates the score of the last winning board" do
    assert AdventOfCode.Day4.last_winning_score(@path) == 1924
  end
end
