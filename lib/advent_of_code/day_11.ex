defmodule AdventOfCode.Day11 do
  alias AdventOfCode.Matrix

  @flashed :f

  def run_100_steps_simulation(path) do
    path
    |> create_grid()
    |> simulate(100)
  end

  def run_find_when_all_octopi_flash_at_the_same_time(path) do
    path
    |> create_grid()
    |> simulate_until_all_flash_at_the_same_time()
  end

  # You can model the energy levels and flashes of light in steps. During a single step, the following occurs:
  #
  # - First, the energy level of each octopus increases by 1.
  # - Then, any octopus with an energy level greater than 9 flashes. This increases the energy level of all adjacent octopuses by 1,
  #   including octopuses that are diagonally adjacent. If this causes an octopus to have an energy level greater than 9, it also flashes.
  #   This process continues as long as new octopuses keep having their energy level increased beyond 9. (An octopus can only flash at most once per step.)
  # - Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.
  #
  defp simulate(grid, number_of_steps) do
    {_step_grid, step_count} =
      1..number_of_steps
      |> Enum.reduce({grid, 0}, fn _step_index, {new_grid, new_count} ->
        queue = positions()
        new_grid = increase_energy(new_grid)

        step({new_grid, new_count}, queue)
        |> (fn {g, c} ->
              {reset_flashed_octopuses(g), c}
            end).()
      end)

    step_count
  end

  defp simulate_until_all_flash_at_the_same_time(grid, index \\ 1) do
    queue = positions()
    grid = increase_energy(grid)

    {new_grid, _} = step({grid, 0}, queue)

    if all_flashed?(new_grid) do
      index
    else
      new_grid
      |> reset_flashed_octopuses()
      |> simulate_until_all_flash_at_the_same_time(index + 1)
    end
  end

  defp step({grid, flash_count}, []), do: {grid, flash_count}

  defp step({grid, flash_count}, [current_octopus | rest]) do
    value = Matrix.at(grid, current_octopus)

    if value != @flashed && value > 9 do
      neighbours = neighbours_indexes(current_octopus)

      grid =
        neighbours
        |> Enum.reduce(grid, fn n, new_grid ->
          Matrix.update_at(new_grid, n, fn v ->
            if v != @flashed, do: v + 1, else: v
          end)
        end)
        |> Matrix.update_at(current_octopus, fn _ -> @flashed end)

      step({grid, flash_count + 1}, rest ++ neighbours)
    else
      step({grid, flash_count}, rest)
    end
  end

  defp reset_flashed_octopuses(grid) do
    positions()
    |> Enum.reduce(grid, fn octopus, new_grid ->
      Matrix.update_at(new_grid, octopus, fn v ->
        if v === @flashed, do: 0, else: v
      end)
    end)
  end

  defp all_flashed?(grid) do
    grid
    |> Enum.all?(fn row ->
      Enum.all?(row, fn octopus -> octopus == @flashed end)
    end)
  end

  def increase_neighbour_energy(grid, coords) do
    Matrix.update_at(grid, coords, &(&1 + 1))
  end

  defp positions do
    0..9
    |> Enum.map(fn i ->
      0..9
      |> Enum.map(fn j -> {i, j} end)
    end)
    |> List.flatten()
  end

  defp increase_energy(grid, increase \\ 1) do
    grid
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn energy ->
        energy + increase
      end)
    end)
  end

  defp neighbours_indexes({i, j}), do: neighbours_indexes(i, j)

  defp neighbours_indexes(i, j) do
    [
      {i - 1, j},
      {i + 1, j},
      {i, j - 1},
      {i, j + 1},
      {i - 1, j - 1},
      {i + 1, j + 1},
      {i - 1, j + 1},
      {i + 1, j - 1}
    ]
    |> Enum.reject(fn {ii, jj} ->
      ii < 0 || ii > 9 || jj < 0 || jj > 9
    end)
  end

  defp create_grid(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
