defmodule ALPHA do
  @moduledoc """
  A codec for an `ALPHA`.

  ```
  ALPHA = %x41-5A / %x61-7A ; A-Z / a-z
  ```

  ## Examples

      iex> decode 'abc'
      {'a', 'bc'}

      iex> encode 'abc'
      {'bc', 'a'}
  """
  use Codec

  defcodec_1_char(&is_alpha/1)
end
