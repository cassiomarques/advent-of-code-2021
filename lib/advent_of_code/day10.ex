defmodule AdventOfCode.Day10 do
  require Integer

  @opening ["{", "[", "(", "<"]

  def illegal_character_score(path) do
    path
    |> extract_lines()
    |> remove_incomplete_lines()
    |> Enum.map(&first_illegal_character/1)
    |> calculate_total_syntax_error_score()
  end

  def middle_score_for_incomplete_lines(path) do
    path
    |> extract_lines()
    |> filter_incomplete_lines()
    |> Enum.map(&find_completion_brackets/1)
    |> find_middle_score_for_incomplete_lines()
  end

  defp incomplete_line?(line, open \\ [])
  # If line is exhausted but we still have open chars in the stack, it's imcomplete
  defp incomplete_line?([], [_top_of_stack | _rest_of_stack] = _open_stack), do: true
  defp incomplete_line?([], []), do: false

  # I don't know an easier way to identify if the line is incomplete
  # so I'm just using an implemenation that's very similar to the one
  # that identifies illegal characters
  defp incomplete_line?([curr | rest], open_stack) do
    if Enum.member?(@opening, curr) do
      # Push into stack
      incomplete_line?(rest, [curr | open_stack])
    else
      [open | rest_of_stack] = open_stack
      match = matching_closing_bracket(open)

      if curr == match do
        # Pop from stack!
        incomplete_line?(rest, rest_of_stack)
      else
        # Don't even check the rest, just assume
        # it's imcomplete
        false
      end
    end
  end

  defp first_illegal_character(line, open_stack \\ [])

  defp first_illegal_character([curr | rest], open_stack) do
    if Enum.member?(@opening, curr) do
      # Push into stack
      first_illegal_character(rest, [curr | open_stack])
    else
      [open | rest_of_stack] = open_stack
      match = matching_closing_bracket(open)

      if curr == match do
        # Pop from stack!
        first_illegal_character(rest, rest_of_stack)
      else
        curr
      end
    end
  end

  defp find_completion_brackets(line, open_stack \\ [])

  defp find_completion_brackets([], open_stack) do
    open_stack
    |> Enum.map(&matching_closing_bracket/1)
  end

  defp find_completion_brackets([curr | rest], open_stack) do
    if Enum.member?(@opening, curr) do
      # Push into stack
      find_completion_brackets(rest, [curr | open_stack])
    else
      # We just trust that the closing bracket matches,
      # so we pop from the stack and recurse
      [_open | rest_of_stack] = open_stack
      find_completion_brackets(rest, rest_of_stack)
    end
  end

  defp find_middle_score_for_incomplete_lines(scores) do
    scores
    |> Enum.map(&calculate_score_for_closing_brackets/1)
    |> Enum.sort()
    |> (fn scores ->
          Enum.at(scores, div(length(scores), 2))
        end).()
  end

  defp calculate_score_for_closing_brackets(brackets) do
    scores = %{
      ")" => 1,
      "]" => 2,
      "}" => 3,
      ">" => 4
    }

    brackets
    |> Enum.reduce(0, fn bracket, total ->
      total * 5 + Map.get(scores, bracket)
    end)
  end

  defp remove_incomplete_lines(lines) do
    Enum.reject(lines, &incomplete_line?/1)
  end

  defp filter_incomplete_lines(lines) do
    Enum.filter(lines, &incomplete_line?/1)
  end

  defp calculate_total_syntax_error_score(illegal_characters) do
    scores = %{
      ")" => 3,
      "]" => 57,
      "}" => 1197,
      ">" => 25137
    }

    illegal_characters
    |> Enum.reduce(0, fn c, total -> total + Map.get(scores, c) end)
  end

  def matching_closing_bracket(open) do
    case open do
      "{" -> "}"
      "[" -> "]"
      "(" -> ")"
      "<" -> ">"
    end
  end

  defp extract_lines(path) do
    path
    |> File.read!()
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, "") |> Enum.reject(fn c -> c == "" end)
    end)
  end
end
