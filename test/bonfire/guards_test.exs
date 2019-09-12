defmodule GuardsTest do
  use Test, async: true

  import Guards
  doctest Guards

  test "is_alpha" do
    {valid, invalid} = build_test_charlist([?A..?Z, ?a..?z])
    Enum.each(valid, &assert(is_alpha(&1)))
    Enum.each(invalid, &refute(is_alpha(&1)))
  end
end
