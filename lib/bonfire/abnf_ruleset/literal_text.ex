defmodule LiteralText do
  @moduledoc """
  A codec for literal text strings.

  Matches any printable ASCII character. That is, any character in the decimal range of [33..126].

  ## Examples

      iex> LiteralText.Decode.apply {'', '""'}
      {'""', ''}

      iex> LiteralText.Decode.apply {'', '_"'}
      nil

      iex> LiteralText.Encode.apply {'""', ''}
      {'', '""'}
  """

  use Codec

  defmodule Decode do
    @moduledoc false

    @spec apply({list(char), nonempty_list(char)}) :: {nonempty_list(char), list(char)} | nil
    def apply({dest, [?" | rest]}) do
      {'""', ''}
    end

    def apply({dest, [char | rest]}) do
      nil
    end

    def apply2({dest, [char | rest]}) do
    end
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
