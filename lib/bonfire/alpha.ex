defmodule Alpha do
  @moduledoc """

  ## Examples

      iex> decode 'abc'
      {'a', 'bc'}

      iex> encode 'abc'
      {'bc', 'a'}
  """
  use Codec

  defcodec1(&is_alpha/1)
end
