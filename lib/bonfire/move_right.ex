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

  def move_one({[value | _], _} = input, move) do
    Module.concat(move, Right).move_one(input)
  end

  def move_zero_or_more(input, mover) do
    input
    ~> move_one_or_more(mover)
    ~>> return(input)
  end

  def move_one_or_more(input, mover) do
    input
    ~> move_one(mover)
    ~> wrap()
    ~> _move_zero_or_more(mover)
  end

  defp _move_zero_or_more(input, mover) do
    input
    ~> move_one(mover)
    ~> join()
    ~> _move_zero_or_more(mover)
    ~>> return(input)
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
