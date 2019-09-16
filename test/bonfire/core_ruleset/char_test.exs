defmodule CHARTest do
  use Test, async: true

  import CHAR
  doctest CHAR

  test_zipper(CHAR, [1..127])
end
