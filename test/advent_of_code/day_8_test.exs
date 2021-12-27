defmodule AdventOfCode.Day8Test do
  use ExUnit.Case, async: true

  @path "test/support/day_8_sample"

  test "correctly identifies the random segments" do
    assert AdventOfCode.Day8.run(@path) == 26
  end
end
