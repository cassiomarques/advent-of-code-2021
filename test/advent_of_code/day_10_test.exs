defmodule AdventOfCode.Day10Test do
  use ExUnit.Case, async: true
  @path "test/support/day_10_sample"

  test "calculates the total syntax error score" do
    assert AdventOfCode.Day10.illegal_character_score(@path) == 26397
  end

  test "calculates the middle completion score for incomplete lines" do
    assert AdventOfCode.Day10.middle_score_for_incomplete_lines(@path) == 288_957
  end
end
