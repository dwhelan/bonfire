defmodule Operators do
  defmacro lhs ~> rhs do
    quote do
      case unquote(lhs) do
        nil -> unquote(lhs)
        _ -> unquote(Macro.pipe(lhs, rhs, 0))
      end
    end
  end

  defmacro lhs ~>> rhs do
    quote do
      case unquote(lhs) do
        nil -> unquote(Macro.pipe(lhs, rhs, 0))
        _ -> unquote(lhs)
      end
    end
  end
end

defmodule LiteralText do
  @moduledoc """
  A zipper for literal text strings.

  Matches any printable ASCII character. That is, any character in the decimal range of [33..126].

  ## Examples

      iex> Unzip.apply {'', '"'}
      {'"', ''}

      iex> Unzip.apply {'', '_"'}
      nil

      iex> Zip.apply {'"', ''}
      {'', '"'}
  """

  use Zipper

  defzipper(?")
end
