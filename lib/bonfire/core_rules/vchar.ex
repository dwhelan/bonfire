defmodule VCHAR do
  @moduledoc """
  A zipper for a `VCHAR`.

  ```
  VCHAR = %x21-7E ; visible (printing) characters
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

  defzipper(&is_vchar/1)
end
