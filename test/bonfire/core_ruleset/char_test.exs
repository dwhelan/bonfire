defmodule CHARTest do
  use Test, async: true

  import CHAR
  doctest CHAR

  test_codec(CHAR, [1..127])
end
