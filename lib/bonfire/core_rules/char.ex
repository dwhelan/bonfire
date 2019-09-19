defmodule CHAR do
  @moduledoc """
  A codec for a `CHAR`.

  ```
  CHAR = %x01-7F
        ; any 7-bit US-ASCII character,
        ;  excluding NUL

  ```

  ## Examples

      iex> merge 'abc'
      {'a', 'bc'}

      iex> split 'abc'
      {'bc', 'a'}
  """
  use Codec

  defcodec(&is_char/1)
end
