defmodule DIGITTest do
  use Test, async: true

  import DIGIT
  doctest DIGIT

  test_codec(DIGIT, [?0..?9])
end
