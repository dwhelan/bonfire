defmodule HexVal do
  @moduledoc """
  A zipper for a `hex-val`.

  ```
  hex-val = "x" 1*HEXDIG [ 1*("." 1*HEXDIG) / ("-" 1*HEXDIG) ]
  ```

  ## Examples

      iex> unzip 'a'
      {'a', ''}
  """
  use Zipper

  defzipper(&is_alpha/1)
end
