defmodule Digit do
  @moduledoc """
  A codec for a single `DIGIT` character.

  ```
  DIGIT =  %x30-39 ; 0-9
  ```

  ## Examples

      iex> decode '123'
      {'1', '23'}

      iex> decode {'', '123'}
      {'1', '23'}

      iex> decode {'1', '23'}
      {'12', '3'}

      iex> decode {'12', '3'}
      {'123', ''}

      iex> encode '123'
      {'23', '1'}

      iex> encode {'123', ''}
      {'23', '1'}

      iex> encode {'23', '1'}
      {'3', '12'}

      iex> encode {'3', '12'}
      {'', '123'}
  """
  use Codec

  defcodec1(&is_digit/1)
end
