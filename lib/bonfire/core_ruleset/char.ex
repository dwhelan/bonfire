defmodule CHAR do
  @moduledoc """
  A codec for a `CHAR`.

  ```
  CHAR = %x01-7F
        ; any 7-bit US-ASCII character,
        ;  excluding NUL

  ```

  ## Examples

      iex> unzip 'abc'
      {'a', 'bc'}

      iex> zip 'abc'
      {'bc', 'a'}
  """
  use Zipper

  defcodec(&is_char/1)
end
