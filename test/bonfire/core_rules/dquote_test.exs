defmodule DQUOTETest do
  use Test, async: true

  import DQUOTE
  doctest DQUOTE

  test_codec(DQUOTE, [0x22])
end
