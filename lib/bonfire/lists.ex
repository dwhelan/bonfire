defmodule Lists do
  @moduledoc """
  Functions for manipulating lists.
  """

  def move_right({[], _}) do
    nil
  end

  def move_right({[value | left], right}) do
    {left, [value | right]}
  end

  def wrap_right({_, []}) do
    nil
  end

  def wrap_right({left, [value | right]}) do
    {left, [[value] | right]}
  end

  def insert_right({left, [value, values | right]}) do
    {left, [[value | values] | right]}
  end
end
