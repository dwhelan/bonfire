defmodule HEXDIGITTest do
  use Test, async: true
  import HEXDIGIT

  doctest HEXDIGIT

  test_codec(HEXDIGIT, [?0..?9, ?A..?F])
end
