defmodule BonfireTest do
  use ExUnit.Case
  import Bonfire
  doctest Bonfire

  test "rule form " do
    defrule "a = b"
  end
end
