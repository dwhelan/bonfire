defmodule Alphabetic.Right do
  import Guards
  import ListProcessor.Right

  def move_one({[value | _], _} = input) when is_alpha(value) do
    ListProcessor.Right.move_one(input)
  end

  def move_one(_) do
    nil
  end
end

defmodule ListProcessor.RightTest do
  use Test, async: true

  import Guards
  import ListProcessor.Right
  doctest ListProcessor.Right

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

  test "move_to_list/3 with a count" do
    assert move_to_list({'', '_'}, -1, Alphabetic) == nil

    assert move_to_list({'', '_'}, 0, Alphabetic) == {'', '_'}
    assert move_to_list({'a', '_'}, 0, Alphabetic) == {'a', '_'}

    assert move_to_list({'', '_'}, 1, Alphabetic) == nil
    assert move_to_list({'*', '_'}, 1, Alphabetic) == nil
    assert move_to_list({'a', '_'}, 1, Alphabetic) == {'', ['a', ?_]}
    assert move_to_list({'ab', '_'}, 1, Alphabetic) == {'b', ['a', ?_]}

    assert move_to_list({'a', '_'}, 2, Alphabetic) == nil
    assert move_to_list({'a*', '_'}, 2, Alphabetic) == nil
    assert move_to_list({'ab', '_'}, 2, Alphabetic) == {'', ['ba', ?_]}
    assert move_to_list({'abc', '_'}, 2, Alphabetic) == {'c', ['ba', ?_]}
    assert move_to_list({'ab*', '_'}, 2, Alphabetic) == {'*', ['ba', ?_]}
  end

  test "move_to_list/3 with a range" do
    assert move_to_list({'a', '_'}, -1..2, Alphabetic) == nil

    assert move_to_list({'', '_'}, 1..2, Alphabetic) == nil
    assert move_to_list({'*', '_'}, 1..2, Alphabetic) == nil
    assert move_to_list({'a', '_'}, 1..2, Alphabetic) == {'', ['a', ?_]}
    assert move_to_list({'a*', '_'}, 1..2, Alphabetic) == {'*', ['a', ?_]}
    assert move_to_list({'ab', '_'}, 1..2, Alphabetic) == {'', ['ba', ?_]}
    assert move_to_list({'abc', '_'}, 1..2, Alphabetic) == {'c', ['ba', ?_]}
    assert move_to_list({'ab*', '_'}, 1..2, Alphabetic) == {'*', ['ba', ?_]}

    assert move_to_list({'', '_'}, 1..-1, Alphabetic) == nil
    assert move_to_list({'*', '_'}, 1..-1, Alphabetic) == nil
    assert move_to_list({'a', '_'}, 1..-1, Alphabetic) == {'', ['a', ?_]}
    assert move_to_list({'a*', '_'}, 1..-1, Alphabetic) == {'*', ['a', ?_]}
    assert move_to_list({'ab', '_'}, 1..-1, Alphabetic) == {'', ['ba', ?_]}
    assert move_to_list({'abc', '_'}, 1..-1, Alphabetic) == {'', ['cba', ?_]}
    assert move_to_list({'ab*', '_'}, 1..-1, Alphabetic) == {'*', ['ba', ?_]}
  end
end
