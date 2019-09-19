defmodule CHAR do
  @moduledoc """
  A codec for a `CHAR`.

  ```
  CHAR = %x01-7F
        ; any 7-bit US-ASCII character,
        ;  excluding NUL

  ```

  ## Examples

      iex> split 'abc'
      {'bc', 'a'}

      iex> merge 'abc'
      {'c', 'ab'}
  """
  use Codec

  defcodec(&is_char/1)
end
