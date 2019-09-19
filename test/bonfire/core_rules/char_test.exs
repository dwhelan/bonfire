defmodule CHARTest do
  use Test, async: true

  import CHAR
  doctest CHAR

  test_codec(CHAR, [0x01..0x7F])
end
