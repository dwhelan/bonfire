defmodule ALPHATest do
  use Test, async: true

  import ALPHA
  doctest ALPHA

  test_zipper(ALPHA, [?A..?Z, ?a..?z])
end
