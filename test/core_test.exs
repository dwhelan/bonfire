defmodule CoreTest do
  use ExUnit.Case, async: true

  import Core
  doctest Core

  test "name" do
    assert name('abc') == {%{element: :name, value: 'abc', code: nil, comments: nil}, []}
  end

  @tag :skip
  test "OCTET" do
    assert Core.decode("CR", [1]) == {:ok, {[1], ""}}
  end
end
