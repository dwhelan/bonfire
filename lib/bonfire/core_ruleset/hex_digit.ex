defmodule HEXDIGIT do
  @moduledoc """
  A codec for a `HEXDIGIT`.

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

  defcodec(&is_hex_digit/1)
end
