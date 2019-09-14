defmodule BITTest do
  use Test, async: true

  import BIT
  doctest BIT

  test_codec(BIT, [0, 1])
end
