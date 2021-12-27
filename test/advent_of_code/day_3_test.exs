defmodule AdventOfCode.Day2Test do
  use ExUnit.Case, async: true

  @path "test/support/day_3_sample"

  test "correctly calculates the submarine's power consumption" do
    assert AdventOfCode.Day3.power_consumption(@path) == 198
  end

  test "correctly calculates the submarines's life support rating" do
    assert AdventOfCode.Day3.life_support_rating(@path) == 230
  end
end
