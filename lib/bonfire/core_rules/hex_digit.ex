defmodule HEXDIGIT do
  @moduledoc """
  A codec for a `HEXDIGIT`.

  ```
  HEXDIG =  DIGIT / "A" / "B" / "C" / "D" / "E" / "F"
  ```

  ## Examples

      iex> merge '0'
      {'0', ''}

      iex> merge 'F'
      {'F', ''}

      iex> split '0'
      {'', '0'}

      iex> split 'F'
      {'', 'F'}

  """
  use Codec

  defcodec(&is_hex_digit/1)
end
