defmodule Move.Right do
  @moduledoc """
  Functions for shifting elements from a left list to a right list.
  """
  import Pipes

  def move_one({[], _}) do
    nil
  end

  def move_one({[value | left], right}) do
    {left, [value | right]}
  end

  def move_one({[], _}, _) do
    nil
  end

  def move_one({[value | _], _} = input, predicate) when is_function(predicate, 1) do
    case predicate.(value) do
      true -> move_one(input)
      false -> nil
    end
  end

  def move_one({[value | _], _} = input, mover) do
    Module.concat(mover, Right).move_one(input)
  end

  def move(input, 0, _) do
    input
  end

  def move({[], _}, count, _) when is_integer(count) and count > 0 do
    nil
  end

  def move(input, count, mover) when is_integer(count) do
    input
    ~> move_first(mover)
    ~> _move(count - 1, mover)
  end

  def move(input, %Range{} = range, mover) do
    from..to = range

    input
    ~> move(from, mover)
    ~> move_zero_or_more(mover)
  end

  defp _move(input, 0, _) do
    input
  end

  defp _move(input, count, mover) when is_integer(count) do
    input
    ~> move_next(mover)
    ~> move(count - 1, mover)
  end

  def move_zero_or_more(input, mover) do
    input
    ~> move_one_or_more(mover)
    ~>> return(input)
  end

  def move_one_or_more(input, mover) do
    input
    ~> move_first(mover)
    ~> _move_zero_or_more(mover)
  end

  defp _move_zero_or_more(input, mover) do
    input
    ~> move_next(mover)
    ~> _move_zero_or_more(mover)
    ~>> return(input)
  end

  defp move_first(input, mover) do
    input
    ~> move_one(mover)
    ~> wrap()
  end

  defp move_next(input, mover) do
    input
    ~> move_one(mover)
    ~> join()
  end

  defp return(_, result) do
    result
  end

  def wrap({_, []}) do
    nil
  end

  def wrap({left, [value | right]}) do
    {left, [[value] | right]}
  end

  def join({_, []}) do
    nil
  end

  def join({left, [value, values | right]}) do
    {left, [[value | values] | right]}
  end

  def reverse({left, right}) do
    {left, Enum.reverse(right)}
  end
end
