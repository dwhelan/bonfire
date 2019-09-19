defmodule ALPHA do
  @moduledoc """
  A codec for an `ALPHA`.

  ```
  ALPHA = %x41-5A / %x61-7A ; A-Z / a-z
  ```

  ## Examples

      iex> split 'abc'
      {'bc', 'a'}

      iex> split {'abc', 'xyz'}
      {'bc', 'xyza'}

      iex> split {'bc', 'xyza'}
      {'c', 'xyzab'}

      iex> split {'c', 'xyzab'}
      {'', 'xyzabc'}

      iex> merge 'abc'
      {'c', 'ab'}

      iex> merge {'', 'xyzabc'}
      {'c', 'xyzab'}

      iex> merge {'c', 'xyzab'}
      {'bc', 'xyza'}

      iex> merge {'bc', 'xyza'}
      {'abc', 'xyz'}

  """
  use Codec

  defcodec(&is_alpha/1)
end
