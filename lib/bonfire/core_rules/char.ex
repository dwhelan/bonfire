defmodule CHAR do
  @moduledoc """
  A codec for a single `CHAR`.

  ```
  CHAR = %x01-7F
        ; any 7-bit US-ASCII character,
        ;  excluding NUL

  ```

  ## Examples

      iex> decode 'abc'
      {'a', 'bc'}

      iex> encode 'abc'
      {'bc', 'a'}
  """
  use Codec

  defcodec1(&is_char/1)
end