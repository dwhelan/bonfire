defmodule Guards do
  @moduledoc """
  Guards for ABNF data.
  """

  @doc """
  Determine if a character is in the range `0..255`.
  
  ## Examples
  
      iex> is_octet 0
      true

      iex> is_octet 256
      false
  """
  defguard is_octet(char) when char >= 0 and char <= 255

  @doc """
  Determine if a character is alphabetic.

  ## Examples

      iex> is_alpha ?a
      true

      iex> is_alpha ?A
      true

      iex> is_alpha 0
      false
  """
  defguard is_alpha(char) when (char >= ?a and char <= ?z) or (char >= ?A and char <= ?Z)

  defguard is_digit(char) when char >= ?0 and char <= ?9

  # From RFC 5234 8.1 Core Fields
  # (ALPHA / DIGIT / "-")
  defguard is_rulename_char(char) when is_alpha(char) or is_digit(char) or char === ?-
end
