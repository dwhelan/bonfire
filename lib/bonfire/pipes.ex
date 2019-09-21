defmodule ListProcessor.Pipes do
  @moduledoc """
  Pipe operators for short-circuiting truthy or non-truthy values.
  """
  @doc """
  A pipe operator that short-circuits non-truthy values (`false` or `nil`).

  Short circuits `nil` inputs.

  ## Examples

      iex> :a ~> to_string
      "a"

      iex> false ~> to_string
      false

      iex> nil ~> to_string
      nil
  """
  defmacro lhs ~> rhs do
    quote do
      unless unquote(lhs) do
        # short circuit
        unquote(lhs)
      else
        unquote(Macro.pipe(lhs, rhs, 0))
      end
    end
  end

  @doc """
  A pipe operator that short-circuits truthy values (neither `false` nor `nil`).

  ## Examples

      iex> :a ~>> to_string
      :a

      iex> false ~>> to_string
      "false"

      iex> nil ~>> to_string
      ""
  """
  defmacro lhs ~>> rhs do
    quote do
      if unquote(lhs) do
        # short circuit
        unquote(lhs)
      else
        unquote(Macro.pipe(lhs, rhs, 0))
      end
    end
  end
end
