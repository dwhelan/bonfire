defmodule GuardsTest do
  use Test, async: true
  import Guards

  doctest Guards

  test_predicate(&is_alpha/1, [?A..?Z, ?a..?z])
  test_predicate(&is_bit/1, [0, 1])
  test_predicate(&is_char/1, [1..127])
  test_predicate(&is_digit/1, [?0..?9])
  test_predicate(&is_hex_digit/1, [?0..?9, ?A..?F])
end
