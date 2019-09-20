defmodule Lists.RightTest do
  use Test, async: true

  import Lists.Right
  doctest Lists.Right

  test "move/1" do
    assert move({'a', '_'}) == {'', 'a_'}
    assert move({'ab', '_'}) == {'b', 'a_'}
    assert move({'', ''}) == nil
  end

  test "move/2" do
    assert move({'a', '_'}, &_true/1) == {'', 'a_'}
    assert move({'a', '_'}, &_false/1) == nil
    assert move({'', '_'}, &_true/1) == nil
  end

  test "wrap/1" do
    assert wrap({'_', 'a'}) == {'_', ['a']}
    assert wrap({'_', 'abc'}) == {'_', ['a', ?b, ?c]}
    assert wrap({'_', ''}) == nil
  end

  test "join/1" do
    assert join({'_', [?a, []]}) == {'_', ['a']}
    assert join({'_', [?a, 'b', ?c]}) == {'_', ['ab', ?c]}
    assert join({'_', 'abc'}) == {'_', [[?a | ?b], ?c]}
    assert join({'_', ''}) == nil
  end

  test "reverse/1" do
    assert reverse({'_', 'abc'}) == {'_', 'cba'}
    assert reverse({'_', ''}) == {'_', ''}
  end

  defp _true(_), do: true
  defp _false(_), do: false
end
