defmodule CHAR do
  @moduledoc """
  A zipper for a `CHAR`.

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
  use Codec

  defzipper(&is_char/1)
end
