defmodule CHARTest do
  use Test, async: true

  import CHAR
  doctest CHAR

  test_zipper(CHAR, [0x01..0x7F])
end
