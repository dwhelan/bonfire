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

      iex> Action.apply {ALPHA, Merge}, {'', 'abc'}
      {'a', 'bc'}

      iex> Action.apply {ALPHA, MoveRight}, {'abc', ''}
      {'bc', 'a'}
  """
  @type t :: {module, module}

  @spec apply(t, Bonfire.t()) :: Bonfire.t() | nil
  def apply({element, verb}, arg) do
    Module.concat([element, verb]).apply(arg)
  end
end
