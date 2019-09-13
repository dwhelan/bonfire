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

  defdecode1(&is_alpha/1)

  defencode do
    def apply({[value | _], _} = input) when is_alpha(value) do
      shift_right(input)
    end
  end
end
