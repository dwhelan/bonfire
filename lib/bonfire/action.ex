defmodule Action do
  @moduledoc """
  Functions to apply actions.
  """
  @doc """
  Invokes an action.
  
  ## Examples
  
      iex> Action.apply {Alpha, Decode}, {'', 'abc'}
      {'a', 'bc'}

      iex> Action.apply {Alpha, Encode}, {'abc', ''}
      {'bc', 'a'}
  """
  def apply({element, verb}, arg) do
    Module.concat([element, verb]).apply(arg)
  end
end
