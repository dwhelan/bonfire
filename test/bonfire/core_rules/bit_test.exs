defmodule BITTest do
  use Test, async: true

  import BIT
  doctest BIT

  test_zipper(BIT, [0, 1])
end
