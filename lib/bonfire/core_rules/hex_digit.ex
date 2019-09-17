defmodule HEXDIGIT do
  @moduledoc """
  A zipper for a `HEXDIGIT`.

  ```
  HEXDIG =  DIGIT / "A" / "B" / "C" / "D" / "E" / "F"
  ```

  ## Examples

      iex> unzip '0'
      {'0', ''}

      iex> unzip 'F'
      {'F', ''}

      iex> zip '0'
      {'', '0'}

      iex> zip 'F'
      {'', 'F'}

  """
  use Zipper

  defzipper(&is_hex_digit/1)
end
