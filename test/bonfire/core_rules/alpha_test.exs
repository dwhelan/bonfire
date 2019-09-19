defmodule ALPHATest do
  use Test, async: true

  import ALPHA
  doctest ALPHA

  test_codec(ALPHA, [?A..?Z, ?a..?z])
end
