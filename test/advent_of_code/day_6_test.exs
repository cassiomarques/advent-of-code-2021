defmodule AdventOfCode.Day6BruteForceTest do
  use ExUnit.Case, async: true

  @path "test/support/day_6_sample"

  test "correctly calculates the number of lanternfish after x days" do
    assert AdventOfCode.Day6BruteForce.run(@path, _days = 18) == 26
    assert AdventOfCode.Day6BruteForce.run(@path, _days = 80) == 5934
  end
end

defmodule AdventOfCode.Day6FastTest do
  use ExUnit.Case, async: true

  @path "test/support/day_6_sample"

  test "correctly calculates the number of lanternfish after x days" do
    assert AdventOfCode.Day6Fast.run(@path, _days = 18) == 26
    assert AdventOfCode.Day6Fast.run(@path, _days = 80) == 5934
  end
end
