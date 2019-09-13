defmodule Action do
  @moduledoc """
  Functions to apply actions.

  Actions are represented by a two element tuple of `{Element, Action}`.
  """
  @doc """
  Invokes an action.

  The action will be invoked by combining the module
  names in the `action` tuple and then calling the `apply`
  function in that module with `arg`.

  ## Examples

      iex> Action.apply {Alpha, Decode}, {'', 'abc'}
      {'a', 'bc'}

      iex> Action.apply {Alpha, Encode}, {'abc', ''}
      {'bc', 'a'}
  """
  @type t :: {module, module}
  def apply({element, verb}, arg) do
    Module.concat([element, verb]).apply(arg)
  end
end
