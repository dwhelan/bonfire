defmodule Codec do
  defmacro defcodec do
    quote do
      def decode(input) do
        unquote(__CALLER__.module).Decode.apply(input)
      end

      def encode(input) do
        unquote(__CALLER__.module).Encode.apply(input)
      end
    end
  end
end

defmodule Digit do
  @moduledoc """

  ## Examples

      iex> decode '123'
      {'1', '23'}

      iex> decode {'', '123'}
      {'1', '23'}

      iex> decode {'1', '23'}
      {'12', '3'}

      iex> decode {'12', '3'}
      {'123', ''}

      iex> decode {'123', ''}
      nil

      iex> decode :non_digit
      nil

      iex> encode '123'
      {'23', '1'}

      iex> encode {'123', ''}
      {'23', '1'}

      iex> encode {'23', '1'}
      {'3', '12'}

      iex> encode {'3', '12'}
      {'', '123'}

      iex> encode :non_digit
      nil
  """
  import Guards
  import Rule
  import Codec

  defcodec
  defdecode do
    def apply({_, [char | _]} = input) when is_digit(char) do
      shift_left(input)
    end
  end

  defencode do
    def apply({[value | _], _} = input) when is_digit(value) do
      shift_right(input)
    end
  end
end
