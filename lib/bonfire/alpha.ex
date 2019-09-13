defmodule Alpha do
  @moduledoc """

  ## Examples

      iex> decode 'abc'
      {'a', 'bc'}

      iex> decode :non_alpha
      nil

      iex> encode 'abc'
      {'bc', 'a'}
  """
  use Rule

  defcodec

  defdecode do
    def apply({_, [char | _]} = input) when is_alpha(char) do
      shift_left(input)
    end
  end

  defencode do
    def apply({[value | _], _} = input) when is_alpha(value) do
      shift_right(input)
    end
  end
end
