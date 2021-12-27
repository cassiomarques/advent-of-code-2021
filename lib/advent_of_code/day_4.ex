defmodule AdventOfCode.Day4 do
  def first_winning_score(input_path) do
    {numbers, boards} =
      input_path
      |> extract_numbers_and_boards()

    find_first_winning_board(numbers, boards)
    |> calculate_winning_score()
  end

  def last_winning_score(input_path) do
    {numbers, boards} =
      input_path
      |> extract_numbers_and_boards()

    find_last_winning_board(numbers, boards)
    |> calculate_winning_score()
  end

  def extract_numbers_and_boards(input_path) do
    [raw_numbers | raw_boards] =
      File.read!(input_path)
      |> String.split("\n\n")

    boards =
      raw_boards
      |> prepare_boards

    numbers =
      raw_numbers
      |> String.split(",")
      |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)

    {numbers, boards}
  end

  defp prepare_boards(raw_boards) do
    raw_boards
    |> Enum.map(&prepare_board/1)
  end

  defp prepare_board(raw_board) do
    raw_board
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> String.trim()
      |> String.split(~r/\s+/)
      |> Enum.map(fn item ->
        {number, _rest} = Integer.parse(item)

        {number, false}
      end)
    end)
  end

  defp find_first_winning_board([], _boards) do
    nil
  end

  defp find_first_winning_board([current_number | tail_numbers], boards) do
    boards = mark_number_in_boards(current_number, boards)

    winning_board = Enum.find(boards, &board_wins?/1)

    if winning_board do
      {winning_board, current_number}
    else
      find_first_winning_board(tail_numbers, boards)
    end
  end

  defp find_last_winning_board(numbers, boards) do
    find_last_winning_board(numbers, boards, [])
  end

  defp find_last_winning_board(_numbers, [], winning_boards) do
    List.last(winning_boards)
  end

  defp find_last_winning_board([current_number | tail_numbers], boards, winning_boards) do
    updated_boards = mark_number_in_boards(current_number, boards)

    {win, lose} = Enum.split_with(updated_boards, &board_wins?/1)
    win = Enum.map(win, fn b -> {b, current_number} end)

    find_last_winning_board(tail_numbers, lose, winning_boards ++ win)
  end

  def mark_number_in_boards(number, boards) do
    boards
    |> Enum.map(fn board ->
      mark_number_in_board(number, board)
    end)
  end

  defp mark_number_in_board(number, board) do
    board
    |> Enum.map(fn row ->
      Enum.map(row, fn
        {^number, _} -> {number, true}
        other -> other
      end)
    end)
  end

  defp board_wins?(board) do
    board_has_winning_row?(board) || board_has_winning_column?(board)
  end

  defp board_has_winning_row?(board) do
    Enum.any?(board, &all_in_list_marked?/1)
  end

  defp board_has_winning_column?(board) do
    0..4
    |> Enum.find(fn index ->
      Enum.map(board, fn row -> Enum.at(row, index) end)
      |> all_in_list_marked?()
    end)
  end

  defp all_in_list_marked?(list) do
    Enum.all?(list, fn {_, marked} -> marked end)
  end

  defp calculate_winning_score({board, number}) do
    unmarked_sum =
      Enum.reduce(board, 0, fn row, sum ->
        sum +
          Enum.reduce(row, 0, fn
            {number, false}, acc -> acc + number
            _other, acc -> acc
          end)
      end)

    number * unmarked_sum
  end
end
