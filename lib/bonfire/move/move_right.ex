defmodule ListProcessor.Right do
  @moduledoc """
  Functions for moving elements from a left list to a right list.
  """
  require ListProcessor

  ListProcessor.many()

  @doc """
  ListProcessor one item from the left list to the right.

  The head item from the left list will be removed and will become the head item in the right list.

  A `nil` will be returned if the left list is empty.

  ## Examples

      iex> move_one {'abc', '...'}
      {'bc', 'a...'}

      iex> move_one {'', ''}
      nil
  """
  @spec move_one(ListProcessor.t()) :: ListProcessor.t()
  def move_one({[], _} = _input) do
    nil
  end

  def move_one({[value | left], right}) do
    {left, [value | right]}
  end

  @spec move_one(ListProcessor.t(), ListProcessor.mover()) :: ListProcessor.t()
  def move_one({[], _}, _) do
    nil
  end

  def move_one({[value | _], _} = input, predicate) when is_function(predicate, 1) do
    case predicate.(value) do
      true -> move_one(input)
      false -> nil
    end
  end

  def move_one(input, mover) do
    Module.concat(mover, Right).move_one(input)
  end

  @doc """
  Reverses the right list.

  ## Examples

      iex> reverse {'...', '123'}
      {'...', '321'}
  """
  @spec reverse(ListProcessor.t()) :: ListProcessor.t()
  def reverse({left, right}) do
    {left, Enum.reverse(right)}
  end

  defp wrap({_, []}) do
    nil
  end

  defp wrap({left, [value | right]}) do
    {left, [[value] | right]}
  end

  defp join({_, []}) do
    nil
  end

  defp join({left, [value, values | right]}) do
    {left, [[value | values] | right]}
  end
end
