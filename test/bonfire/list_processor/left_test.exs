defmodule Alphabetic.Left do
  import Guards
  import ListProcessor.Left

  def move_one({[value | _], _} = input) when is_alpha(value) do
    ListProcessor.Left.move_one(input)
  end

  def move_one(_) do
    nil
  end
end

defmodule ListProcessor.LeftTest do
  use Test, async: true

  import Guards
  import ListProcessor.Left
  doctest ListProcessor.Left

  test "move_one/1" do
    assert move_one({ '_','a'}) == { 'a_',''}
    assert move_one({ '_','ab'}) == { 'a_','b'}
    assert move_one({ '',''}) == nil
  end

  test "move_one/2" do
    assert move_one({ '_','a'}, Alphabetic) == { 'a_',''}
    assert move_one({ '_','*'}, Alphabetic) == nil
    assert move_one({ '_',''}, Alphabetic) == nil

    assert move_one({ '_','a'}, &is_alpha/1) == { 'a_',''}
    assert move_one({ '_','*'}, &is_alpha/1) == nil
    assert move_one({ '_',''}, &is_alpha/1) == nil
  end

  test "move_to_list/3 with a count" do
    assert move_to_list({ '_',''}, -1, Alphabetic) == nil

    assert move_to_list({ '_',''}, 0, Alphabetic) == { '_',''}
    assert move_to_list({ '_','a'}, 0, Alphabetic) == { '_','a'}

    assert move_to_list({ '_',''}, 1, Alphabetic) == nil
    assert move_to_list({'*', '_'}, 1, Alphabetic) == nil
#    assert move_to_list({ '_','a'}, 1, Alphabetic) == {['a', ?_], ''}
#    assert move_to_list({'ab', '_'}, 1, Alphabetic) == {'b', ['a', ?_]}

    assert move_to_list({'a', '_'}, 2, Alphabetic) == nil
    assert move_to_list({'a*', '_'}, 2, Alphabetic) == nil
#    assert move_to_list({'ab', '_'}, 2, Alphabetic) == {'', ['ba', ?_]}
#    assert move_to_list({'abc', '_'}, 2, Alphabetic) == {'c', ['ba', ?_]}
#    assert move_to_list({'ab*', '_'}, 2, Alphabetic) == {'*', ['ba', ?_]}
  end

  test "move_to_list/3 with a range" do
    assert move_to_list({'a', '_'}, -1..2, Alphabetic) == nil

    assert move_to_list({'', '_'}, 1..2, Alphabetic) == nil
    assert move_to_list({'*', '_'}, 1..2, Alphabetic) == nil
#    assert move_to_list({'a', '_'}, 1..2, Alphabetic) == {'', ['a', ?_]}
#    assert move_to_list({'a*', '_'}, 1..2, Alphabetic) == {'*', ['a', ?_]}
#    assert move_to_list({'ab', '_'}, 1..2, Alphabetic) == {'', ['ba', ?_]}
#    assert move_to_list({'abc', '_'}, 1..2, Alphabetic) == {'c', ['ba', ?_]}
#    assert move_to_list({'ab*', '_'}, 1..2, Alphabetic) == {'*', ['ba', ?_]}

    assert move_to_list({'', '_'}, 1..-1, Alphabetic) == nil
    assert move_to_list({'*', '_'}, 1..-1, Alphabetic) == nil
#    assert move_to_list({'a', '_'}, 1..-1, Alphabetic) == {'', ['a', ?_]}
#    assert move_to_list({'a*', '_'}, 1..-1, Alphabetic) == {'*', ['a', ?_]}
#    assert move_to_list({'ab', '_'}, 1..-1, Alphabetic) == {'', ['ba', ?_]}
#    assert move_to_list({'abc', '_'}, 1..-1, Alphabetic) == {'', ['cba', ?_]}
#    assert move_to_list({'ab*', '_'}, 1..-1, Alphabetic) == {'*', ['ba', ?_]}
  end
end
