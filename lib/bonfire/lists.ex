defmodule Lists.Right do
  @moduledoc """
  Functions for shifting elements from left list to right list.
  """

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

  def move_one({[value | _], _} = input, lists) do
    Module.concat(lists, Right).move_one(input)
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
