defmodule DQUOTETest do
  use Test, async: true

  import DQUOTE
  doctest DQUOTE

  test_zipper(DQUOTE, [0x22])
end
