defmodule Text do
  @moduledoc """
  A zipper for literal text strings.

  ```
  ABNF permits the specification of literal text strings directly,
  enclosed in quotation marks.  Hence:

    command     =  "command string"

  Literal text strings are interpreted as a concatenated set of
  printable characters.

  NOTE:

      ABNF strings are case insensitive and the character set for these
      strings is US-ASCII.
  ```

  ## Examples

      iex> Unzip.apply {'', '"'}
      {'"', ''}

      iex> Unzip.apply {'', '_"'}
      nil

      iex> Zip.apply {'"', ''}
      {'', '"'}
  """

  use Zipper

  defzipper(?")
end
