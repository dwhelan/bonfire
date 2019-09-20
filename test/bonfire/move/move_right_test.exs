defmodule Alpha.Right do
  # will move an alpha character to the right, nil otherwise

  import Guards

  def move_one({[char | _], _} = input) when is_alpha(char) do
    Move.Right.move_one(input)
  end

  def move_one(_) do
    nil
  end
end

defmodule Move.RightTest do
  use Test, async: true

  import Guards
  import Move.Right
  doctest Move.Right

  test "move_one/1" do
    assert move_one({'a', '_'}) == {'', 'a_'}
    assert move_one({'ab', '_'}) == {'b', 'a_'}
    assert move_one({'', ''}) == nil
  end

  test "move_one/2" do
    assert move_one({'a', '_'}, Alpha) == {'', 'a_'}
    assert move_one({'*', '_'}, Alpha) == nil
    assert move_one({'', '_'}, Alpha) == nil

    assert move_one({'a', '_'}, &is_alpha/1) == {'', 'a_'}
    assert move_one({'*', '_'}, &is_alpha/1) == nil
    assert move_one({'', '_'}, &is_alpha/1) == nil
  end

  test "move_many/3 with a count" do
    assert move_many({'', '_'}, -1, Alpha) == nil

    assert move_many({'', '_'}, 0, Alpha) == {'', '_'}
    assert move_many({'a', '_'}, 0, Alpha) == {'a', '_'}

    assert move_many({'', '_'}, 1, Alpha) == nil
    assert move_many({'*', '_'}, 1, Alpha) == nil
    assert move_many({'a', '_'}, 1, Alpha) == {'', ['a', ?_]}
    assert move_many({'ab', '_'}, 1, Alpha) == {'b', ['a', ?_]}

    assert move_many({'a', '_'}, 2, Alpha) == nil
    assert move_many({'a*', '_'}, 2, Alpha) == nil
    assert move_many({'ab', '_'}, 2, Alpha) == {'', ['ba', ?_]}
    assert move_many({'abc', '_'}, 2, Alpha) == {'c', ['ba', ?_]}
    assert move_many({'ab*', '_'}, 2, Alpha) == {'*', ['ba', ?_]}
  end

  test "move_many/3 with a range" do
    assert move_many({'a', '_'}, -1..2, Alpha) == nil

    assert move_many({'', '_'}, 1..2, Alpha) == nil
    assert move_many({'*', '_'}, 1..2, Alpha) == nil
    assert move_many({'a', '_'}, 1..2, Alpha) == {'', ['a', ?_]}
    assert move_many({'a*', '_'}, 1..2, Alpha) == {'*', ['a', ?_]}
    assert move_many({'ab', '_'}, 1..2, Alpha) == {'', ['ba', ?_]}
    assert move_many({'abc', '_'}, 1..2, Alpha) == {'c', ['ba', ?_]}
    assert move_many({'ab*', '_'}, 1..2, Alpha) == {'*', ['ba', ?_]}

    assert move_many({'', '_'}, 1..-1, Alpha) == nil
    assert move_many({'*', '_'}, 1..-1, Alpha) == nil
    assert move_many({'a', '_'}, 1..-1, Alpha) == {'', ['a', ?_]}
    assert move_many({'a*', '_'}, 1..-1, Alpha) == {'*', ['a', ?_]}
    assert move_many({'ab', '_'}, 1..-1, Alpha) == {'', ['ba', ?_]}
    assert move_many({'abc', '_'}, 1..-1, Alpha) == {'', ['cba', ?_]}
    assert move_many({'ab*', '_'}, 1..-1, Alpha) == {'*', ['ba', ?_]}
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
end
