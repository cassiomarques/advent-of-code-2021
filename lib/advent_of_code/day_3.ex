defmodule AdventOfCode.Day3 do
  alias AdventOfCode.Utils

  def power_consumption(path) do
    path
    |> lines_from_file()
    |> calculate_gamma_and_epsilon()
    |> Utils.convert_to_decimal()
    |> (fn {epsilon, gamma} -> epsilon * gamma end).()
  end

  def life_support_rating(path) do
    report = path |> lines_from_file()

    oxygen_generator_rate =
      calculate_oxygen_generator_rate(report)
      |> Utils.convert_to_decimal()

    co2_scrubbing_rate =
      calculate_co2_scrubbing_rate(report)
      |> Utils.convert_to_decimal()

    oxygen_generator_rate * co2_scrubbing_rate
  end

  defp lines_from_file(input_path) do
    File.read!(input_path)
    |> String.split("\n", trim: true)
  end

  # Each element in the report is a string representing a binary number
  defp calculate_gamma_and_epsilon(report) when is_list(report) do
    report
    |> binary_length_range()
    |> Enum.reduce({"", ""}, fn index, {gamma, epsilon} ->
      {most_frequent, least_frequent} = most_and_least_frequent_for_index(report, index)

      {gamma <> most_frequent, epsilon <> least_frequent}
    end)
  end

  def calculate_oxygen_generator_rate(report) do
    binary_length_range(report)
    |> Enum.reduce_while(report, fn index, new_report ->
      {most_frequent, _least_frequent} = most_and_least_frequent_for_index(new_report, index)

      new_report =
        Enum.filter(new_report, fn number -> String.at(number, index) == most_frequent end)

      if length(new_report) == 1 do
        {:halt, Enum.at(new_report, 0)}
      else
        {:cont, new_report}
      end
    end)
  end

  def calculate_co2_scrubbing_rate(report) do
    binary_length_range(report)
    |> Enum.reduce_while(report, fn index, new_report ->
      {_most_frequent, least_frequent} = most_and_least_frequent_for_index(new_report, index)

      new_report =
        Enum.filter(new_report, fn number -> String.at(number, index) == least_frequent end)

      if length(new_report) == 1 do
        {:halt, Enum.at(new_report, 0)}
      else
        {:cont, new_report}
      end
    end)
  end

  defp most_and_least_frequent_for_index(report, index) do
    {zeros_count, ones_count} =
      Enum.reduce(report, {0, 0}, fn binary_number, {zeros, ones} ->
        if String.at(binary_number, index) == "0" do
          {zeros + 1, ones}
        else
          {zeros, ones + 1}
        end
      end)

    cond do
      zeros_count > ones_count -> {"0", "1"}
      ones_count > zeros_count -> {"1", "0"}
      true -> {"1", "0"}
    end
  end

  defp binary_length_range(report) do
    number_of_digits = hd(report) |> String.length()
    0..(number_of_digits - 1)
  end
end
