defmodule Lists.RightTest do
  use Test, async: true

  import Lists.Right
  doctest Lists.Right

  test "move_right/1" do
    assert move_right({'a', '_'}) == {'', 'a_'}
    assert move_right({'ab', '_'}) == {'b', 'a_'}
    assert move_right({'', ''}) == nil
  end

  test "move_right/2" do
    assert move_right({'a', '_'}, &_true/1) == {'', 'a_'}
    assert move_right({'a', '_'}, &_false/1) == nil
    assert move_right({'', '_'}, &_true/1) == nil
  end

  test "wrap_right/1" do
    assert wrap_right({'_', 'a'}) == {'_', ['a']}
    assert wrap_right({'_', 'abc'}) == {'_', ['a', ?b, ?c]}
    assert wrap_right({'_', ''}) == nil
  end

  test "join_right/1" do
    assert join_right({'_', [?a, []]}) == {'_', ['a']}
    assert join_right({'_', [?a, 'b', ?c]}) == {'_', ['ab', ?c]}
    assert join_right({'_', 'abc'}) == {'_', [[?a | ?b], ?c]}
    assert join_right({'_', ''}) == nil
  end

  test "reverse_right/1" do
    assert reverse_right({'_', 'abc'}) == {'_', 'cba'}
    assert reverse_right({'_', ''}) == {'_', ''}
  end

  defp _true(_), do: true
  defp _false(_), do: false
end
