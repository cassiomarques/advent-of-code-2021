defmodule AdventOfCode.Day12Test do
  use ExUnit.Case, async: true

  @path_a "test/support/day_12_a_sample"
  @path_b "test/support/day_12_b_sample"

  test "finds all the valid paths through the caves with sample file A" do
    assert AdventOfCode.Day12.run1(@path_a) == 10
  end

  test "finds all the valid paths through the caves with sample file B" do
    assert AdventOfCode.Day12.run1(@path_b) == 19
  end

  test "finds all the valid paths through the caves with sample file A when a single small cave can be visited twice" do
    assert AdventOfCode.Day12.run2(@path_a) == 36
  end

  test "finds all the valid paths through the caves with sample file B when a single small cave can be visited twice" do
    assert AdventOfCode.Day12.run2(@path_b) == 103
  end
end
