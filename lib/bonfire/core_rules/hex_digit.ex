defmodule HEXDIGIT do
  @moduledoc """
  A codec for a `HEXDIGIT`.

  ```
  HEXDIG =  DIGIT / "A" / "B" / "C" / "D" / "E" / "F"
  ```

  ## Examples

      iex> decode '0'
      {'0', ''}

      iex> decode '9'
      {'9', ''}

      iex> encode '0'
      {'', '0'}

      iex> encode '9'
      {'', '9'}

  """
  use Codec

  defcodec1(&is_digit/1)
end
