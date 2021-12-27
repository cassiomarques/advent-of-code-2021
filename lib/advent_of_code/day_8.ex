defmodule AdventOfCode.Day8 do
  def run(path) do
    path
    |> File.read!()
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(fn line ->
      [patterns, output] = String.split(line, " | ")

      {
        String.split(patterns, " "),
        String.split(output, " ")
      }
    end)
    |> Enum.map(&solve_output/1)
    |> Enum.sum()
  end

  # patterns are the input signal patterns (10 patterns, one per digit)
  # scrambled_output is the 4 digits output using the random patterns
  #
  #   0:      1:      2:      3:      4:
  #  aaaa    ....    aaaa    aaaa    ....
  # b    c  .    c  .    c  .    c  b    c
  # b    c  .    c  .    c  .    c  b    c
  #  ....    ....    dddd    dddd    dddd
  # e    f  .    f  e    .  .    f  .    f
  # e    f  .    f  e    .  .    f  .    f
  #  gggg    ....    gggg    gggg    ....
  #
  #   5:      6:      7:      8:      9:
  #  aaaa    aaaa    aaaa    aaaa    aaaa
  # b    .  b    .  .    c  b    c  b    c
  # b    .  b    .  .    c  b    c  b    c
  #  dddd    dddd    ....    dddd    dddd
  # .    f  e    f  .    f  e    f  .    f
  # .    f  e    f  .    f  e    f  .    f
  #  gggg    gggg    ....    gggg    gggg
  defp solve_output({patterns, scrambled_output}) do
    signals = %{
      1 => find_signal_for_1(patterns),
      4 => find_signal_for_4(patterns),
      7 => find_signal_for_7(patterns),
      8 => find_signal_for_8(patterns)
    }

    signals =
      signals
      |> find_signals_for_two_three_and_five(patterns)
      |> find_signals_for_zero_six_and_nine(patterns)
      |> Map.new(fn {key, val} -> {val, key} end)

    scrambled_output =
      scrambled_output
      |> Enum.map(&signal_to_set/1)

    scrambled_output
    |> Enum.map(fn output_signal ->
      Map.get(signals, output_signal) |> Integer.to_string()
    end)
    |> Enum.join()
    |> Integer.parse()
    |> elem(0)
  end

  defp find_signal_for_1(patterns) do
    find_signals_with_segments_count(patterns, 2) |> List.first()
  end

  defp find_signal_for_4(patterns) do
    find_signals_with_segments_count(patterns, 4) |> List.first()
  end

  defp find_signal_for_7(patterns) do
    find_signals_with_segments_count(patterns, 3) |> List.first()
  end

  defp find_signal_for_8(patterns) do
    find_signals_with_segments_count(patterns, 7) |> List.first()
  end

  defp find_signals_for_two_three_and_five(
         %{
           1 => signal_for_1,
           4 => signal_for_4
         } = signals,
         patterns
       ) do
    signals_5_segments = find_signals_with_segments_count(patterns, 5)

    {[signal_for_3], signals_for_2_and_5} =
      signals_5_segments
      |> Enum.split_with(fn item ->
        MapSet.intersection(item, signal_for_1) |> Enum.count() == 2
      end)

    {[signal_for_5], [signal_for_2]} =
      signals_for_2_and_5
      |> Enum.split_with(fn item ->
        MapSet.intersection(item, signal_for_4) |> Enum.count() == 3
      end)

    Map.merge(signals, %{
      2 => signal_for_2,
      3 => signal_for_3,
      5 => signal_for_5
    })
  end

  defp find_signals_for_zero_six_and_nine(
         %{
           1 => signal_for_1,
           4 => signal_for_4
         } = signals,
         patterns
       ) do
    signals_6_segments = find_signals_with_segments_count(patterns, 6)

    {[signal_for_9], signals_for_0_and_6} =
      signals_6_segments
      |> Enum.split_with(fn item ->
        MapSet.intersection(item, signal_for_4) |> Enum.count() == 4
      end)

    {[signal_for_0], [signal_for_6]} =
      signals_for_0_and_6
      |> Enum.split_with(fn item ->
        MapSet.intersection(item, signal_for_1) |> Enum.count() == 2
      end)

    Map.merge(signals, %{
      0 => signal_for_0,
      6 => signal_for_6,
      9 => signal_for_9
    })
  end

  defp signal_to_set(signal) do
    signal
    |> String.split("")
    |> Enum.reject(&(String.length(&1) == 0))
    |> MapSet.new()
  end

  defp find_signals_with_segments_count(patterns, count) do
    Enum.filter(patterns, fn p -> String.length(p) == count end)
    |> Enum.map(&signal_to_set/1)
  end
end
