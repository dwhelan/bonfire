defmodule DIGITTest do
  use Test, async: true

  import DIGIT
  doctest DIGIT

  test_zipper(DIGIT, [?0..?9])
end
