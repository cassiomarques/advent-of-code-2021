defmodule AdventOfCode.Day12 do
  @start_cave "start"
  @end_cave "end"

  def run1(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> extract_caves()
    |> search()
    |> Enum.count()
  end

  def run2(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> extract_caves()
    |> search_allowing_small_caves_to_be_visited_twice()
    |> Enum.count()
  end

  defp extract_caves(lines) do
    lines
    |> Enum.reduce(%{}, fn line, graph ->
      [a, b] =
        line
        |> String.split("-", trim: true)

      graph = add_cave_connection(graph, a, b)
      add_cave_connection(graph, b, a)
    end)
  end

  defp add_cave_connection(graph, a, b) do
    Map.update(graph, a, MapSet.new([b]), fn neighbours ->
      MapSet.put(neighbours, b)
    end)
  end

  defp search_allowing_small_caves_to_be_visited_twice(graph) do
    graph
    |> small_caves()
    |> Enum.reduce([], fn small_cave_allowed_twice, paths ->
      paths ++ search(graph, @start_cave, [@start_cave], small_cave_allowed_twice)
    end)
    |> Enum.uniq()
  end

  defp search(graph) do
    search(graph, @start_cave, [@start_cave])
  end

  defp search(graph, cave, current_path, small_cave_allowed_twice \\ nil) do
    (graph[cave] || [])
    |> Enum.reduce([], fn n, paths ->
      if n == @end_cave do
        [[n | current_path] | paths]
      else
        if can_keep_searching?(n, current_path, small_cave_allowed_twice) do
          paths ++ search(graph, n, [n | current_path], small_cave_allowed_twice)
        else
          paths
        end
      end
    end)
  end

  defp can_keep_searching?(cave, path, nil) do
    cave != @start_cave && cave != @end_cave &&
      (!small_cave?(cave) || !Enum.member?(path, cave))
  end

  defp can_keep_searching?(cave, path, small_cave_allowed_twice) do
    small_cave_checker = fn small_cave ->
      if small_cave == small_cave_allowed_twice do
        Enum.count(path, fn c -> small_cave == c end) < 2
      else
        !Enum.member?(path, small_cave)
      end
    end

    cave != @start_cave && cave != @end_cave &&
      (!small_cave?(cave) || small_cave_checker.(cave))
  end

  defp small_cave?(cave) do
    String.downcase(cave) == cave
  end

  defp small_caves(graph) do
    graph
    |> Map.keys()
    |> Enum.filter(fn cave -> small_cave?(cave) end)
    |> Enum.reject(fn cave -> cave == @start_cave || cave == @end_cave end)
  end
end
