defmodule Guards do
  @moduledoc """
  Guards for ABNF fields.

  These guards are based on definitions in RFC 5234 8.1 Core Fields.
  """

  @doc """
  Returns `true` if `term` is an ABNF `ALPHA` character; otherwise returns `false`.

  ## Examples

      iex> is_alpha ?a
      true

      iex> is_alpha ?0
      false
  """
  defguard is_alpha(term) when term in ?a..?z or term in ?A..?Z

  @doc """
  Returns `true` if `term` is an ABNF `BIT`; otherwise returns `false`.

  ## Examples

      iex> is_bit 0
      true

      iex> is_bit 1
      true

      iex> is_bit ?a
      false
  """
  defguard is_bit(term) when term in 0..1

  @doc """
  Returns `true` if `term` is a `byte`; otherwise returns `false`.

  ## Examples

      iex> is_byte 0
      true

      iex> is_byte 255
      true

      iex> is_byte 256
      false
  """
  defguard is_byte(term) when term in 0..255

  @doc """
  Returns `true` if `term` is an ABNF `CHAR`; otherwise returns `false`.

  ## Examples

      iex> is_char 1
      true

      iex> is_char 127
      true

      iex> is_char 0
      false

      iex> is_char 128
      false
  """
  defguard is_char(term) when term in 1..127

  @doc """
  Returns `true` if `term` is an ABNF `DIGIT`; otherwise returns `false`.

  ## Examples

      iex> is_digit ?0
      true

      iex> is_digit ?9
      true

      iex> is_digit ?a
      false
  """
  defguard is_digit(term) when term in ?0..?9

  @doc """
  Returns `true` if `term` is an ABNF `HEXDIGIT`; otherwise returns `false`.

  ## Examples

      iex> is_hex_digit ?0
      true

      iex> is_hex_digit ?9
      true

      iex> is_hex_digit ?A
      true

      iex> is_hex_digit ?F
      true

      iex> is_hex_digit ?x
      false
  """
  defguard is_hex_digit(term) when term in ?0..?9 or term in ?A..?F

  @doc """
  Returns `true` if `term` is an ABNF `OCTET`; otherwise returns `false`.

  ## Examples

      iex> is_octet 0
      true

      iex> is_octet 255
      true

      iex> is_octet 256
      false
  """
  defguard is_octet(term) when term in 0..255

  @doc """
  Returns `true` if `term` is an ABNF `VHAR`; otherwise returns `false`.

  ## Examples

      iex> is_vchar 1
      true

      iex> is_vchar 0x7E
      true

      iex> is_vchar 0
      false

      iex> is_vchar 0x7F
      false
  """
  defguard is_vchar(term) when term in 1..0x7E

  @doc """
  Determine if a character is valid for a rulename.

  Note that the first character in a rulename must be alphabetic. This guard
  is for subsequent characters.

  ```
  (ALPHA / DIGIT / "-")

  This should move to a Rulename module and made private
  ```

  ## Examples

      iex> is_digit ?0
      true

      iex> is_digit ?9
      true

      iex> is_digit ?a
      false
  """
  defguard is_rulename_char(term) when is_alpha(term) or is_digit(term) or term === ?-
end
