defmodule Guards do
  @moduledoc """
  Guards for ABNF data.

  These guards are intended to be used for encoding and decoding characters and are based on
  definitions in RFC 5234 8.1 Core Fields.

  """

  @doc """
  Determine if a character is an `ALPHA`.

  ## Examples

      iex> is_alpha ?a
      true

      iex> is_alpha ?Z
      true

      iex> is_alpha ?0
      false
  """
  defguard is_alpha(char) when (char >= ?a and char <= ?z) or (char >= ?A and char <= ?Z)

  @doc """
  Determine if a character is a `BIT`.

  ## Examples

      iex> is_bit 0
      true

      iex> is_bit 1
      true

      iex> is_bit ?a
      false
  """
  defguard is_bit(char) when char == 0 or char == 1

  @doc """
  Determine if a character is a `CHAR`.

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
  defguard is_char(char) when 1 <= char and char <= 127

  @doc """
  Determine if a character is a `HEXDIGIT`.

  ## Examples

      iex> is_hex_digit ?0
      true

      iex> is_hex_digit ?9
      true

      iex> is_hex_digit ?A
      true

      iex> is_hex_digit ?G
      false
  """
  defguard is_hex_digit(char) when (?0 <= char and char <= ?9) or (?A <= char and char <= ?F)

  @doc """
  Determine if a character is a `DIGIT`.

  ## Examples

      iex> is_digit ?0
      true

      iex> is_digit ?9
      true

      iex> is_digit ?a
      false
  """
  defguard is_digit(char) when char >= ?0 and char <= ?9

  @doc """
  Determine if a character is an `Octet`.

  ```
  OCTET = %x00-FF ; 8 bits of data
  ```

  ## Examples

      iex> is_octet 0
      true

      iex> is_octet 255
      true

      iex> is_octet 256
      false
  """
  defguard is_octet(char) when char >= 0 and char <= 255

  @doc """
  Determine if a character is valid for a rulename.

  Note that the first character in a rulename must be alphabetic. This guard
  is for subsequent characters.

  ```
  (ALPHA / DIGIT / "-")
  ```

  ## Examples

      iex> is_digit ?0
      true

      iex> is_digit ?9
      true

      iex> is_digit ?a
      false
  """
  defguard is_rulename_char(char) when is_alpha(char) or is_digit(char) or char === ?-
end
