defmodule CharVal do
  @moduledoc """
  A codec for a `char-val`.

  ```
  char-val =  DQUOTE *(%x20-21 / %x23-7E) DQUOTE
                                ; quoted string of SP and VCHAR
                                ;  without DQUOTE

  ```

  ## Examples

      iex> Merge.apply {'', '"'}
      {'"', ''}

      iex> Merge.apply {'', '_"'}
      nil

      iex> Right.apply {'"', ''}
      {'', '"'}
  """

  use Codec

  defcodec(?")
end
