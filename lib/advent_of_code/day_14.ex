defmodule AdventOfCode.Day14BruteForce do
  def run(path, steps) do
    [template, rules] =
      path
      |> File.read!()
      |> String.split("\n\n")

    template = template |> String.split("", trim: true)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn line, rules_map ->
        [from, to] = String.split(line, " -> ", trim: true)

        Map.put(rules_map, from, to)
      end)

    template
    |> find_sequence(rules, steps)
    |> calculate_frequencies()
    |> calculate_difference_between_most_and_least_frequent()
  end

  defp find_sequence(template, rules, steps) do
    1..steps
    |> Enum.reduce(template, fn _step_number, new_template ->
      Enum.chunk_every(new_template, 2, 1, :discard)
      |> insert_rules(rules)
    end)
  end

  defp insert_rules([[a, b]], rules) do
    new_char = rules[a <> b]
    [a, new_char, b]
  end

  defp insert_rules([[a, b] | remaining_pairs], rules) do
    new_char = rules[a <> b]
    [a | [new_char | insert_rules(remaining_pairs, rules)]]
  end

  defp calculate_frequencies(sequence) do
    sequence
    |> Enum.uniq()
    |> Enum.reduce(%{}, fn char, frequencies ->
      Map.put(frequencies, char, Enum.count(sequence, &(&1 == char)))
    end)
  end

  defp calculate_difference_between_most_and_least_frequent(frequencies) do
    frequencies
    |> Enum.into([])
    |> Enum.sort(fn {_c1, q1}, {_c2, q2} -> q1 < q2 end)
    |> (fn sorted ->
          {_least_frequent, q1} = List.first(sorted)
          {_most_frequent, q2} = List.last(sorted)
          q2 - q1
        end).()
  end
end
