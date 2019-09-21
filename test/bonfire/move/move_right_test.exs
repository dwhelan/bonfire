defmodule Alphabetic.MoveRight do
  import Guards

  def move_one({[char | _], _} = input) when is_alpha(char) do
    ListProcessor.MoveRight.move_one(input)
  end

  def move_one(_) do
    nil
  end
end

defmodule ListProcessor.RightTest do
  use Test, async: true

  import Guards
  import ListProcessor.MoveRight
  doctest ListProcessor.MoveRight

  test "move_one/1" do
    assert move_one({'a', '_'}) == {'', 'a_'}
    assert move_one({'ab', '_'}) == {'b', 'a_'}
    assert move_one({'', ''}) == nil
  end

  test "move_one/2" do
    assert move_one({'a', '_'}, Alphabetic) == {'', 'a_'}
    assert move_one({'*', '_'}, Alphabetic) == nil
    assert move_one({'', '_'}, Alphabetic) == nil

    assert move_one({'a', '_'}, &is_alpha/1) == {'', 'a_'}
    assert move_one({'*', '_'}, &is_alpha/1) == nil
    assert move_one({'', '_'}, &is_alpha/1) == nil
  end

  test "move_many/3 with a count" do
    assert move_many({'', '_'}, -1, Alphabetic) == nil

    assert move_many({'', '_'}, 0, Alphabetic) == {'', '_'}
    assert move_many({'a', '_'}, 0, Alphabetic) == {'a', '_'}

    assert move_many({'', '_'}, 1, Alphabetic) == nil
    assert move_many({'*', '_'}, 1, Alphabetic) == nil
    assert move_many({'a', '_'}, 1, Alphabetic) == {'', ['a', ?_]}
    assert move_many({'ab', '_'}, 1, Alphabetic) == {'b', ['a', ?_]}

    assert move_many({'a', '_'}, 2, Alphabetic) == nil
    assert move_many({'a*', '_'}, 2, Alphabetic) == nil
    assert move_many({'ab', '_'}, 2, Alphabetic) == {'', ['ba', ?_]}
    assert move_many({'abc', '_'}, 2, Alphabetic) == {'c', ['ba', ?_]}
    assert move_many({'ab*', '_'}, 2, Alphabetic) == {'*', ['ba', ?_]}
  end

  test "move_many/3 with a range" do
    assert move_many({'a', '_'}, -1..2, Alphabetic) == nil

    assert move_many({'', '_'}, 1..2, Alphabetic) == nil
    assert move_many({'*', '_'}, 1..2, Alphabetic) == nil
    assert move_many({'a', '_'}, 1..2, Alphabetic) == {'', ['a', ?_]}
    assert move_many({'a*', '_'}, 1..2, Alphabetic) == {'*', ['a', ?_]}
    assert move_many({'ab', '_'}, 1..2, Alphabetic) == {'', ['ba', ?_]}
    assert move_many({'abc', '_'}, 1..2, Alphabetic) == {'c', ['ba', ?_]}
    assert move_many({'ab*', '_'}, 1..2, Alphabetic) == {'*', ['ba', ?_]}

    assert move_many({'', '_'}, 1..-1, Alphabetic) == nil
    assert move_many({'*', '_'}, 1..-1, Alphabetic) == nil
    assert move_many({'a', '_'}, 1..-1, Alphabetic) == {'', ['a', ?_]}
    assert move_many({'a*', '_'}, 1..-1, Alphabetic) == {'*', ['a', ?_]}
    assert move_many({'ab', '_'}, 1..-1, Alphabetic) == {'', ['ba', ?_]}
    assert move_many({'abc', '_'}, 1..-1, Alphabetic) == {'', ['cba', ?_]}
    assert move_many({'ab*', '_'}, 1..-1, Alphabetic) == {'*', ['ba', ?_]}
  end
end
