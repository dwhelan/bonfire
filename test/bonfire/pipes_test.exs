defmodule PipesTest do
  use Test, async: true

  import Pipes
  doctest Pipes

  test "~> operator" do
#    assert
#input |> zipper.zip() ~> zip_zero_or_more(zipper)
    map = %{a: 1}
    assert map ~> Map.get(:a) == 1
    assert nil ~> Map.get(:a) == nil

    assert [a: 1] |> Map.new() ~> Map.get(:a) == 1
    assert [] |> Map.new() ~> Map.get(:a) == nil
  end
end
