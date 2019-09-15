defmodule Operators do
  defmacro lhs ~> rhs do
    quote do
      case unquote(lhs) do
        nil -> unquote(lhs)
        _ -> unquote Macro.pipe(lhs, rhs, 0)
      end
    end
  end

  defmacro lhs ~>> rhs do
    quote do
      case unquote(lhs) do
        nil -> unquote Macro.pipe(lhs, rhs, 0)
        _ -> unquote(lhs)
      end
    end
  end

end

defmodule LiteralText do
  @moduledoc """
  A codec for literal text strings.

  Matches any printable ASCII character. That is, any character in the decimal range of [33..126].

  ## Examples

      iex> Decode.apply {'', '"'}
      {'"', ''}

      iex> Decode.apply {'', '_"'}
      nil

      iex> Encode.apply {'""', ''}
      {'', '""'}
  """

  use Codec

  defmodule Decode do
    import Operators

    decode_char ?", fn {dest, source} -> {dest, source} end
  end

  defmodule Encode do
    @spec apply({nonempty_list(char), list(char)}) :: {list(char), nonempty_list(char)} | nil
    def apply({[char | rest] = source, dest}) do
      {'', '""'}
      #      case unquote(predicate).(char) do
      #        true -> {rest, [char | dest]}
      #        false -> nil
      #      end
    end
  end
end
