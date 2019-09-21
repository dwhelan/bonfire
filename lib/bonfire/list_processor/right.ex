defmodule ListProcessor.Right do
  @moduledoc """
  Functions for moving items from the left list to the right list: `left -> right`.
  """
  require ListProcessor

  ListProcessor.move_to_list()

  @doc """
  Move one item from the left list to the right.

  The head item from the left list will be removed and will become the head item in the right list.

  A `nil` will be returned if the left list is empty.

  ## Examples

      iex> move_one {'abc', '...'}
      {'bc', 'a...'}

      iex> move_one {'', ''}
      nil
  """
  @spec move_one(ListProcessor.t()) :: ListProcessor.result()
  def move_one({[], _} = _input) do
    nil
  end

  def move_one({[value | left], right}) do
    {left, [value | right]}
  end

  @doc """
  Move one item from the left list to the right if accepted by the processor.

  The head item from the left list will be removed and will become the head item in the right list.

  A `nil` will be returned if the left list is empty.

  ## Examples

      iex> move_one {'abc', '...'}
      {'bc', 'a...'}

      iex> move_one {'', ''}
      nil
  """
  @spec move_one(ListProcessor.t(), ListProcessor.processor()) :: ListProcessor.result()
  def move_one({[], _}, _) do
    nil
  end

  def move_one({[value | _], _} = input, processor) when is_function(processor, 1) do
    case processor.(value) do
      true -> move_one(input)
      false -> nil
    end
  end

  def move_one(input, processor) do
    Module.concat(processor, Right).move_one(input)
  end
end
