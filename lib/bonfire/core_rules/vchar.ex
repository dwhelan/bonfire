defmodule VCHAR do
  @moduledoc """
  A codec for a `VCHAR`.

  ```
  VCHAR = %x21-7E ; visible (printing) characters
  ```

  ## Examples

      iex> unsplit '0'
      {'0', ''}

      iex> unsplit 'F'
      {'F', ''}

      iex> split '0'
      {'', '0'}

      iex> split 'F'
      {'', 'F'}

  """
  use Codec

  defcodec(&is_vchar/1)
end
