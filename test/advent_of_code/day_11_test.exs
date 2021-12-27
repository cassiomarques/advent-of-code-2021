defmodule AdventOfCode.Day11Test do
  use ExUnit.Case, async: true

  @path "test/support/day_11_sample"

  test "counts the number of flashes after 100 simulations" do
    assert AdventOfCode.Day11.run_100_steps_simulation(@path) == 1656
  end

  test "find the number of steps needed for all octopi to flash at the same time" do
    assert AdventOfCode.Day11.run_find_when_all_octopi_flash_at_the_same_time(@path) == 195
  end
end
