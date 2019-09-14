defmodule HexVal do
  @moduledoc """
  A codec for a `hex-val`.

  ```
  hex-val =  "x" 1*HEXDIG [ 1*("." 1*HEXDIG) / ("-" 1*HEXDIG) ]
  ```

  ## Examples

      iex> decode 'abc'
      {'a', 'bc'}

      iex> encode 'abc'
      {'bc', 'a'}
  """
  use Codec

  defcodec1(&is_alpha/1)
end
