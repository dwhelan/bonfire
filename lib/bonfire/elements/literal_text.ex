defmodule LiteralText do
  @moduledoc """
  A zipper for literal text strings.

  Matches any printable ASCII character. That is, any character in the decimal range of [33..126].

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
