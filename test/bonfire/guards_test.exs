defmodule GuardsTest do
  use Test, async: true
  import Guards

  doctest Guards

  test_guard(:is_alpha, [?A..?Z, ?a..?z])
  test_guard(:is_bit, [0, 1])
  test_guard(:is_char, [1..127])
  test_guard(:is_digit, [?0..?9])
  test_guard(:is_hex_digit, [?0..?9, ?A..?F])
end
