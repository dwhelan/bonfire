defmodule HEXDIGITTest do
  use Test, async: true
  import HEXDIGIT

  doctest HEXDIGIT

  test_zipper(HEXDIGIT, [?0..?9, ?A..?F])
end
