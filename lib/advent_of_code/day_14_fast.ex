defmodule AdventOfCode.Day14Fast do
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

    count(template, rules, steps)
    |> elem(0)
    |> calculate_difference_between_most_and_least_frequent()
  end

  defp count(template, rules, steps) do
    pairs_dict =
      template
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(%{}, fn pair, new_dict ->
        Map.update(new_dict, pair, 1, fn count -> count + 1 end)
      end)

    letters_dict =
      template
      |> Enum.reduce(%{}, fn c, d ->
        Map.update(d, c, 1, fn count -> count + 1 end)
      end)

    1..steps
    |> Enum.reduce({letters_dict, pairs_dict}, fn _step_number,
                                                  {_new_letters_dict, _new_pairs_dict} = dicts ->
      count_with_dicts(dicts, rules)
    end)
  end

  defp count_with_dicts({_letters_dict, pairs_dict} = dicts, rules) do
    pairs_dict
    |> Enum.reduce(dicts, fn {[a, b] = pair, count}, {new_letters_dict, new_pairs_dict} ->
      new_char = rules[a <> b]

      new_letters_dict =
        Map.update(new_letters_dict, new_char, count, fn curr_value -> curr_value + count end)

      new_pairs_dict =
        new_pairs_dict
        |> Map.update(pair, 0, fn curr_value -> curr_value - count end)
        |> Map.update([a, new_char], count, fn curr_value -> curr_value + count end)
        |> Map.update([new_char, b], count, fn curr_value -> curr_value + count end)

      {new_letters_dict, new_pairs_dict}
    end)
  end

  defp calculate_difference_between_most_and_least_frequent(letter_counts) do
    most_frequent = Map.values(letter_counts) |> Enum.max()
    least_frequent = Map.values(letter_counts) |> Enum.min()

    most_frequent - least_frequent
  end
end
