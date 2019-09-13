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

  defcodec1(&is_alpha/1)
end
