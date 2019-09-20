defmodule A do
  defmodule Right do
    # will move an `?a` to the right, nil otherwise
    @behaviour :"Elixir.Right"

    def apply({[?a | _] = _, _} = input) do
      Lists.Right.move_one(input)
    end

    def apply(_) do
      nil
    end

    def move_one({[?a | _] = _, _} = input) do
      Lists.Right.move_one(input)
    end

    def move_one(_) do
      nil
    end
  end
end

defmodule Lists.RightTest do
  use Test, async: true

  import Lists.Right
  doctest Lists.Right

  test "move_one/1" do
    assert move_one({'a', '_'}) == {'', 'a_'}
    assert move_one({'ab', '_'}) == {'b', 'a_'}
    assert move_one({'', ''}) == nil
  end

  test "move_one/2 with a predicate" do
    assert move_one({'a', '_'}, &_true/1) == {'', 'a_'}
    assert move_one({'a', '_'}, &_false/1) == nil
    assert move_one({'', '_'}, &_true/1) == nil
  end

  test "move_one/2 with a Lists" do
    assert move_one({'a', '_'}, A) == {'', 'a_'}
    assert move_one({'b', '_'}, A) == nil
    assert move_one({'', '_'}, A) == nil
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
