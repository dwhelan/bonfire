defmodule Guards do
  @moduledoc """
  Guards for ABNF data.

  These guards are intended to be used for encoding and decoding characters and are based on
  definitions in RFC 5234 8.1 Core Fields.

  """

  @doc """
  Determine if a character is in the range `0..255`.
  
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
  Determine if a character is alphabetic.

  ```
  ALPHA = %x41-5A / %x61-7A ; A-Z / a-z
  ```

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
  Determine if a character is a digit.

  ```
  DIGIT =  %x30-39 ; 0-9
  ```
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
