defmodule ALPHA do
  @moduledoc """
  A codec for an `ALPHA`.

  ```
  ALPHA = %x41-5A / %x61-7A ; A-Z / a-z
  ```

  ## Examples

      iex> unsplit 'abc'
      {'a', 'bc'}

      iex> split 'abc'
      {'bc', 'a'}
  """
  use Codec

  defcodec(&is_alpha/1)
end
