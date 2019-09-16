defmodule HexVal do
  @moduledoc """
  A codec for a `hex-val`.

  ```
  hex-val = "x" 1*HEXDIG [ 1*("." 1*HEXDIG) / ("-" 1*HEXDIG) ]
  ```

  ## Examples

      iex> decode 'a'
      {'a', ''}
  """
  use Zipper

  defcodec(&is_alpha/1)
end
