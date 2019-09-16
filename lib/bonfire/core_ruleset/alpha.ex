defmodule ALPHA do
  @moduledoc """
  A codec for an `ALPHA`.

  ```
  ALPHA = %x41-5A / %x61-7A ; A-Z / a-z
  ```

  ## Examples

      iex> unzip 'abc'
      {'a', 'bc'}

      iex> zip 'abc'
      {'bc', 'a'}
  """
  use Zipper

  defcodec(&is_alpha/1)
end
