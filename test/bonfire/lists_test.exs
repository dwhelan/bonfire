defmodule ListsTest do
  use Test, async: true

  import Lists
  doctest Lists

  test "move_right/1" do
    assert move_right({'a', '_'}) == {'', 'a_'}
    assert move_right({'ab', '_'}) == {'b', 'a_'}
    assert move_right({'', ''}) == nil
  end

  test "wrap_right/1" do
    assert wrap_right({'_', 'a'}) == {'_', ['a']}
    assert wrap_right({'_', 'abc'}) == {'_', ['a', ?b, ?c]}
    assert wrap_right({'_', ''}) == nil
  end
end
