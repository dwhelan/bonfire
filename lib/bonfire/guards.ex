defmodule Guards do
  defguard is_octet(char) when char >= 0 and char <= 255

  defguard is_alpha(char) when (char >= ?a and char <= ?z) or (char >= ?A and char <= ?Z)

  defguard is_digit(char) when char >= ?0 and char <= ?9

  # From RFC 5234 8.1 Core Fields
  # (ALPHA / DIGIT / "-")
  defguard is_rulename_char(char) when is_alpha(char) or is_digit(char) or char === ?-
end
