defmodule VCHARTest do
  use Test, async: true

  import VCHAR
  doctest VCHAR

  test_zipper(VCHAR, [0x21..0x7E])
end
