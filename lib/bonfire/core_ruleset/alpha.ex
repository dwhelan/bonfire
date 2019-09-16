defmodule ALPHA do
  @moduledoc """
  A zipper for an `ALPHA`.

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

  defzipper(&is_alpha/1)
end
