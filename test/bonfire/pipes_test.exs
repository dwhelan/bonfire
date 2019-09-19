defmodule PipesTest do
  use Test, async: true

  import Pipes
  doctest Pipes

  test "~> operator" do
    map = %{a: 1}
    assert map ~> Map.get(:a) == 1
    assert nil ~> Map.get(:a) == nil

    assert [a: 1] |> Map.new() ~> Map.get(:a) == 1
    assert [] |> Map.new() ~> Map.get(:a) == nil
  end
end
