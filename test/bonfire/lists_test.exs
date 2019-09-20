defmodule ListsTest do
  use Test, async: true

  import Lists
  doctest Lists

  test "move_right/1" do
    assert move_right({'a', '_'}) == {'', 'a_'}
    assert move_right({'ab', '_'}) == {'b', 'a_'}

    assert move_right({'', ''}) == nil
    assert move_right({'', '_'}) == nil
  end
end
