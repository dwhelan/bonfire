defmodule HEXDIGIT do
  @moduledoc """
  A codec for a `HEXDIGIT`.

  ```
  HEXDIG =  DIGIT / "A" / "B" / "C" / "D" / "E" / "F"
  ```

  ## Examples

      iex> decode '0'
      {'0', ''}

      iex> decode 'F'
      {'F', ''}

      iex> encode '0'
      {'', '0'}

      iex> encode 'F'
      {'', 'F'}

  """
  use Codec

  defcodec(&is_hex_digit/1)
end
