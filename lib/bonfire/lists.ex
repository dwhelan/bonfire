defmodule Lists do
  @moduledoc """
  Functions for manipulating lists.
  """

  def wrap_right({left, [value | right]}) do
    {left, [[value] | right]}
  end

  def insert_right({left, [value, values | right]}) do
    {left, [[value | values] | right]}
  end
end
