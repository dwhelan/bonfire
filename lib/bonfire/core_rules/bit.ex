defmodule BIT do
  @moduledoc """
  A zipper for a `BIT`.

  This implementation conforms to [Errata 5110](https://www.rfc-editor.org/errata/eid5110)
  where a `0` or `1` rather than `?0` or `?1` is used.

  ```
  BIT = %b0 / %b1
  ```

  ## Examples

      iex> unzip [0]
      {[0], ''}

      iex> zip [0]
      {[], [0]}
  """
  use Zipper

  defzipper(&is_bit/1)
end