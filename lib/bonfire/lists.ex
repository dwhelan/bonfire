defmodule Lists.Right do
  @moduledoc """
  Functions for shifting elements from left list to right list.
  """

  def move_right({[], _}) do
    nil
  end

  def move_right({[value | left], right}) do
    {left, [value | right]}
  end

  def move_right({[], _}, _) do
    nil
  end

  def move_right({[value | _], _} = input, predicate) do
    case predicate.(value) do
      true -> move_right(input)
      false -> nil
    end
  end

  def wrap_right({_, []}) do
    nil
  end

  def wrap_right({left, [value | right]}) do
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
