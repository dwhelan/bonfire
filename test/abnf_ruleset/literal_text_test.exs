defmodule LiteralTextTest do
  use ExUnit.Case

  alias LiteralText

  doctest LiteralText

  test "module exists" do
    assert is_list(LiteralText.module_info())
  end
end
